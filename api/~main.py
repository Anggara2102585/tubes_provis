"""
TODO:
- kirim uang ke saldo UMKM ketika status pendanaan berubah ke 3
"""
from datetime import datetime
from decimal import Decimal
from typing import List
from fastapi import Depends, FastAPI, HTTPException
from sqlalchemy.orm import Session, joinedload

import models, schemas
from database import SessionLocal, engine
from scheduler import start_scheduler

models.Base.metadata.create_all(bind=engine)

app = FastAPI()


# Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Scheduler
# This function will be called when the application starts
@app.on_event("startup")
async def startup_event():
    db = SessionLocal()
    start_scheduler(db)


# Dompet - Create (POST)
@app.post("/dompet/", response_model=schemas.Dompet)
def create_dompet(dompet: schemas.DompetCreate, db: Session = Depends(get_db)):
    db_dompet = models.Dompet(**dompet.dict())

    db.add(db_dompet)
    db.commit()
    db.refresh(db_dompet)
    return db_dompet

# Dompet - Read (GET)
@app.get("/dompet/", response_model=List[schemas.Dompet])
def get_all_dompet(db: Session = Depends(get_db)):
    dompet = db.query(models.Dompet).all()
    return dompet

# Dompet - Delete
@app.delete("/dompet/{dompet_id}")
def delete_dompet(dompet_id: int, db: Session = Depends(get_db)):
    db_dompet = db.query(models.Dompet).filter(models.Dompet.id_dompet == dompet_id).first()
    if not db_dompet:
        raise HTTPException(status_code=404, detail="Dompet not found")
    db.delete(db_dompet)
    db.commit()
    return {"message": "Dompet deleted successfully"}

# RiwayatTransaksi - Create (POST)
@app.post("/riwayat_transaksi/", response_model=schemas.RiwayatTransaksi)
def create_riwayat_transaksi(riwayat_transaksi: schemas.RiwayatTransaksiCreate, db: Session = Depends(get_db)):
    db_riwayat_transaksi = models.RiwayatTransaksi(**riwayat_transaksi.dict())
    db_riwayat_transaksi.tanggal = datetime.now()

    db.add(db_riwayat_transaksi)
    db.commit()
    db.refresh(db_riwayat_transaksi)
    return db_riwayat_transaksi

@app.post("/riwayat_transaksi/cascade", response_model=schemas.RiwayatTransaksi)
def create_riwayat_transaksi_cascade(riwayat_transaksi: schemas.RiwayatTransaksiCreate, db: Session = Depends(get_db)):
    db_riwayat_transaksi = models.RiwayatTransaksi(**riwayat_transaksi.dict())
    db_riwayat_transaksi.tanggal = datetime.now()

    if riwayat_transaksi.jenis_transaksi in [1, 2, 3]:
        # Add the nominal amount to the Dompet's saldo
        db_dompet = (
            db.query(models.Dompet)
            .options(joinedload(models.Dompet.riwayat_transaksi)) # The purpose of using joinedload is to eagerly load the associated relationship, so you can access and modify its attributes without triggering additional database queries.
            .filter(models.Dompet.id_dompet == riwayat_transaksi.id_dompet)
            .first()
        )
        if not db_dompet:
            raise HTTPException(status_code=404, detail="Dompet not found")

        db_dompet.saldo += riwayat_transaksi.nominal

    elif riwayat_transaksi.jenis_transaksi in [4, 5, 6]:
        # Reduce the nominal amount from the Dompet's saldo
        db_dompet = (
            db.query(models.Dompet)
            .options(joinedload(models.Dompet.riwayat_transaksi))
            .filter(models.Dompet.id_dompet == riwayat_transaksi.id_dompet)
            .first()
        )
        if not db_dompet:
            raise HTTPException(status_code=404, detail="Dompet not found")

        if db_dompet.saldo < riwayat_transaksi.nominal:
            raise HTTPException(status_code=400, detail="Insufficient saldo")

        db_dompet.saldo -= riwayat_transaksi.nominal

    db.add(db_riwayat_transaksi)
    db.commit()
    db.refresh(db_riwayat_transaksi)
    return db_riwayat_transaksi

# RiwayatTransaksi - Read (GET)
@app.get("/riwayat_transaksi/", response_model=List[schemas.RiwayatTransaksi])
def get_all_riwayat_transaksi(db: Session = Depends(get_db)):
    db_riwayat_transaksi = db.query(models.RiwayatTransaksi).all()
    return db_riwayat_transaksi


# UMKM - Create (POST)
@app.post("/umkm", response_model=schemas.Umkm)
def create_umkm(umkm: schemas.UmkmCreate, db: Session = Depends(get_db)):
    # Create a new Dompet
    db_dompet = models.Dompet()
    db.add(db_dompet)
    db.commit()
    db.refresh(db_dompet)
    
    db_umkm = models.Umkm(**umkm.dict())  # Create a new Umkm instance with the provided data
    db_umkm.id_dompet = db_dompet.id_dompet
    db_umkm.rating = 0.0
    db_umkm.limit_pinjaman = db_umkm.omzet*(Decimal(8)/Decimal(10)) / 12 # 80% omzet tahunan / 12 [bulan]

    db.add(db_umkm)  # Add the Umkm instance to the database session
    db.commit()  # Commit the changes to the database to persist the new Umkm record
    db.refresh(db_umkm)  # Refresh the Umkm instance to fetch the updated data from the database
    return db_umkm

# UMKM - Read (GET)
@app.get("/umkm/{umkm_id}", response_model=schemas.Umkm)
def read_umkm(umkm_id: int, db: Session = Depends(get_db)):
    db_umkm = db.query(models.Umkm).filter(models.Umkm.id_umkm == umkm_id).first()
    if not db_umkm:
        raise HTTPException(status_code=404, detail="UMKM not found")
    return db_umkm

@app.get("/umkm/", response_model=List[schemas.Umkm])
def get_all_umkm(db: Session = Depends(get_db)):
    umkms = db.query(models.Umkm).all()
    return umkms

# UMKM - Update (PUT)
@app.put("/umkm/{umkm_id}", response_model=schemas.Umkm)
def update_umkm(umkm_id: int, umkm: schemas.UmkmUpdate, db: Session = Depends(get_db)):
    db_umkm = db.query(models.Umkm).filter(models.Umkm.id_umkm == umkm_id).first()
    if not db_umkm:
        raise HTTPException(status_code=404, detail="UMKM not found")
    for field, value in umkm.dict().items():
        setattr(db_umkm, field, value)
    db.commit()
    db.refresh(db_umkm)
    return db_umkm

# UMKM - Partial Update (PATCH)
@app.patch("/umkm/{umkm_id}", response_model=schemas.Umkm)
def partial_update_umkm(umkm_id: int, umkm: schemas.Umkm, db: Session = Depends(get_db)):
    db_umkm = db.query(models.Umkm).filter(models.Umkm.id_umkm == umkm_id).first()
    if not db_umkm:
        raise HTTPException(status_code=404, detail="UMKM not found")
    for field, value in umkm.dict(exclude_unset=True).items():
        setattr(db_umkm, field, value)
    db.commit()
    db.refresh(db_umkm)
    return db_umkm

# UMKM - Delete
@app.delete("/umkm/{umkm_id}")
def delete_umkm(umkm_id: int, db: Session = Depends(get_db)):
    db_umkm = db.query(models.Umkm).filter(models.Umkm.id_umkm == umkm_id).first()
    if not db_umkm:
        raise HTTPException(status_code=404, detail="UMKM not found")
    db.delete(db_umkm)
    db.commit()
    return {"message": "UMKM deleted successfully"}


# Pendana - Create (POST)
@app.post("/pendana/", response_model=schemas.Pendana)
def create_pendana(pendana: schemas.PendanaCreate, db: Session = Depends(get_db)):
    # Create a new Dompet
    db_dompet = models.Dompet()
    db.add(db_dompet)
    db.commit()
    db.refresh(db_dompet)
    
    db_pendana = models.Pendana(**pendana.dict())
    db_pendana.id_dompet = db_dompet.id_dompet

    db.add(db_pendana)
    db.commit()
    db.refresh(db_pendana)
    return db_pendana

# Pendana - Read (GET)
@app.get("/pendana/{pendana_id}", response_model=schemas.Pendana)
def read_pendana(pendana_id: int, db: Session = Depends(get_db)):
    db_pendana = db.query(models.Pendana).filter(models.Pendana.id_pendana == pendana_id).first()
    if not db_pendana:
        raise HTTPException(status_code=404, detail="Pendana not found")
    return db_pendana

@app.get("/pendana/", response_model=List[schemas.Pendana])
def get_all_pendana(db: Session = Depends(get_db)):
    pendana = db.query(models.Pendana).all()
    return pendana

# Pendana - Update (PUT)
@app.put("/pendana/{pendana_id}", response_model=schemas.Pendana)
def update_pendana(pendana_id: int, pendana: schemas.Pendana, db: Session = Depends(get_db)):
    db_pendana = db.query(models.Pendana).filter(models.Pendana.id_pendana == pendana_id).first()
    if not db_pendana:
        raise HTTPException(status_code=404, detail="Pendana not found")
    for field, value in pendana.dict().items():
        setattr(db_pendana, field, value)
    db.commit()
    db.refresh(db_pendana)
    return db_pendana

# Pendana - Partial Update (PATCH)
@app.patch("/pendana/{pendana_id}", response_model=schemas.Pendana)
def partial_update_pendana(pendana_id: int, pendana: schemas.Pendana, db: Session = Depends(get_db)):
    db_pendana = db.query(models.Pendana).filter(models.Pendana.id_pendana == pendana_id).first()
    if not db_pendana:
        raise HTTPException(status_code=404, detail="Pendana not found")
    for field, value in pendana.dict(exclude_unset=True).items():
        setattr(db_pendana, field, value)
    db.commit()
    db.refresh(db_pendana)
    return db_pendana

# Pendana - Delete
@app.delete("/pendana/{pendana_id}")
def delete_pendana(pendana_id: int, db: Session = Depends(get_db)):
    db_pendana = db.query(models.Pendana).filter(models.Pendana.id_pendana == pendana_id).first()
    if not db_pendana:
        raise HTTPException(status_code=404, detail="Pendana not found")
    db.delete(db_pendana)
    db.commit()
    return {"message": "Pendana deleted successfully"}


# Pendanaan - Create (POST)
@app.post("/pendanaan/", response_model=schemas.Pendanaan)
def create_pendanaan(pendanaan: schemas.PendanaanCreate, db: Session = Depends(get_db)):
    # Get the last pendanaan_ke for the corresponding UMKM
    last_pendanaan = (
        db.query(models.Pendanaan)
        .filter(models.Pendanaan.id_umkm == pendanaan.id_umkm)
        .order_by(models.Pendanaan.pendanaan_ke.desc())
        .first()
    )
    if last_pendanaan:
        pendanaan_ke = last_pendanaan.pendanaan_ke + 1
    else:
        pendanaan_ke = 1
    
    # Generate kode_pendanaan by concatenating the name of the UMKM with pendanaan_ke
    umkm = db.query(models.Umkm).filter(models.Umkm.id_umkm == pendanaan.id_umkm).first()
    kode_pendanaan = f"{umkm.nama_umkm}_{pendanaan_ke}"
    
    db_pendanaan = models.Pendanaan(**pendanaan.dict())
    db_pendanaan.pendanaan_ke = pendanaan_ke
    db_pendanaan.kode_pendanaan = kode_pendanaan
    db_pendanaan.status_pendanaan = 1
    db_pendanaan.dana_masuk = 0.0
    db_pendanaan.tanggal_pengajuan = datetime.now()
    db_pendanaan.tanggal_selesai = None

    db.add(db_pendanaan)
    db.commit()
    db.refresh(db_pendanaan)
    return db_pendanaan

# Pendanaan - Read (GET)
@app.get("/pendanaan/{pendanaan_id}", response_model=schemas.Pendanaan)
def read_pendanaan(pendanaan_id: int, db: Session = Depends(get_db)):
    db_pendanaan = db.query(models.Pendanaan).filter(models.Pendanaan.id_pendanaan == pendanaan_id).first()
    if not db_pendanaan:
        raise HTTPException(status_code=404, detail="Pendanaan not found")
    return db_pendanaan

@app.get("/pendanaan/", response_model=List[schemas.Pendanaan])
def get_all_pendanaan(db: Session = Depends(get_db)):
    pendanaan = db.query(models.Pendanaan).all()
    return pendanaan

# Pendanaan - Update (PUT)
@app.put("/pendanaan/{pendanaan_id}", response_model=schemas.Pendanaan)
def update_pendanaan(pendanaan_id: int, pendanaan: schemas.Pendanaan, db: Session = Depends(get_db)):
    db_pendanaan = db.query(models.Pendanaan).filter(models.Pendanaan.id_pendanaan == pendanaan_id).first()
    if not db_pendanaan:
        raise HTTPException(status_code=404, detail="Pendanaan not found")
    # Update the pendanaan instance with the provided data
    for field, value in pendanaan.dict().items():
        setattr(db_pendanaan, field, value)
    # Check if status_pendanaan is changed to 4 or 5
    if pendanaan.status_pendanaan in [4, 5] and db_pendanaan.tanggal_selesai is None:
        db_pendanaan.tanggal_selesai = datetime.now()
    # Check if dana_masuk is equal to total_pendanaan
    if db_pendanaan.dana_masuk == db_pendanaan.total_pendanaan and db_pendanaan.status_pendanaan == 1:
        db_pendanaan.status_pendanaan = 2
    
    db.commit()
    db.refresh(db_pendanaan)
    return db_pendanaan

# Pendanaan - Partial Update (PATCH)
@app.patch("/pendanaan/{pendanaan_id}", response_model=schemas.Pendanaan)
def partial_update_pendanaan(pendanaan_id: int, pendanaan: schemas.Pendanaan, db: Session = Depends(get_db)):
    db_pendanaan = db.query(models.Pendanaan).filter(models.Pendanaan.id_pendanaan == pendanaan_id).first()
    if not db_pendanaan:
        raise HTTPException(status_code=404, detail="Pendanaan not found")
    # Update the pendanaan instance with the provided data
    for field, value in pendanaan.dict(exclude_unset=True).items():
        setattr(db_pendanaan, field, value)
    # Check if status_pendanaan is changed to 4 or 5
    if pendanaan.status_pendanaan in [4, 5] and db_pendanaan.tanggal_selesai is None:
        db_pendanaan.tanggal_selesai = datetime.now()
    # Check if dana_masuk is equal to total_pendanaan
    if db_pendanaan.dana_masuk == db_pendanaan.total_pendanaan and db_pendanaan.status_pendanaan == 1:
        db_pendanaan.status_pendanaan = 2
    
    db.commit()
    db.refresh(db_pendanaan)
    return db_pendanaan

# Pendanaan - Delete
@app.delete("/pendanaan/{pendanaan_id}")
def delete_pendanaan(pendanaan_id: int, db: Session = Depends(get_db)):
    db_pendanaan = db.query(models.Pendanaan).filter(models.Pendanaan.id_pendanaan == pendanaan_id).first()
    if not db_pendanaan:
        raise HTTPException(status_code=404, detail="Pendanaan not found")
    db.delete(db_pendanaan)
    db.commit()
    return {"message": "Pendanaan deleted successfully"}


# UmkmNotifikasi - Create (POST)
@app.post("/umkm_notifikasi/", response_model=schemas.UmkmNotifikasi)
def create_umkm_notifikasi(
    notifikasi: schemas.UmkmNotifikasiCreate,
    db: Session = Depends(get_db)
):
    target_users = notifikasi.list_id_umkm
    notifications = []

    # Create notification for all UMKM
    if target_users == None:
        umkm_users = db.query(models.Umkm).all()
        for umkm_user in umkm_users:
            db_notifikasi = models.UmkmNotifikasi(**notifikasi.dict(exclude='list_id_umkm'))
            db_notifikasi.id_umkm = umkm_user.id_umkm
            db_notifikasi.waktu_tanggal = datetime.now()

            db.add(db_notifikasi)
            db.commit()
            db.refresh(db_notifikasi)
            notifications.append(db_notifikasi)
        
        return notifications

    # Set notification for specific UMKM
    elif target_users != None:
        for id_umkm in target_users:
            db_notifikasi = models.UmkmNotifikasi(**notifikasi.dict(exclude='list_id_umkm'))
            db_notifikasi.id_umkm = id_umkm
            db_notifikasi.waktu_tanggal = datetime.now()

            db.add(db_notifikasi)
            db.commit()
            db.refresh(db_notifikasi)
            notifications.append(db_notifikasi)
            
        return notifications

    # else:
    #     raise HTTPException(
    #         status_code=400, detail="Invalid target_users parameter."
    #     )
    
# UmkmNotifikasi - Read (GET)
@app.get("/umkm_notifikasi/{id_umkm}", response_model=List[schemas.UmkmNotifikasi])
def read_umkm_notifikasi(id_umkm: int, db: Session = Depends(get_db)):
    db_umkm_notifikasi = db.query(models.UmkmNotifikasi).filter(models.UmkmNotifikasi.id_umkm == id_umkm).all()
    return db_umkm_notifikasi

@app.get("/umkm_notifikasi/", response_model=List[schemas.UmkmNotifikasi])
def get_all_umkm_notifikasi(db: Session = Depends(get_db)):
    notifikasi = db.query(models.UmkmNotifikasi).all()
    return notifikasi

# Notifikasi - Update (PUT)
@app.put("/umkm_notifikasi/{id_umkm}", response_model=schemas.UmkmNotifikasi)
def update_umkm_notifikasi(id_umkm: int, db: Session = Depends(get_db)):
    db_umkm_notifikasi = db.query(models.UmkmNotifikasi).filter(models.UmkmNotifikasi.id_umkm == id_umkm).all()
    for notification in db_umkm_notifikasi:
        notification.is_terbaca = True
    
    db.commit()
    db.refresh(db_umkm_notifikasi)  # Refresh the objects with updated values
    
    return db_umkm_notifikasi
# @app.put("/umkm_notifikasi/{notifikasi_id}", response_model=schemas.Notifikasi)
# def update_notifikasi(notifikasi_id: int, notifikasi: schemas.NotifikasiUpdate, db: Session = Depends(get_db)):
#     db_notifikasi = db.query(models.Notifikasi).filter(models.Notifikasi.id_notifikasi == notifikasi_id).first()
#     if not db_notifikasi:
#         raise HTTPException(status_code=404, detail="Notification not found")
#     for field, value in notifikasi.dict().items():
#         setattr(db_notifikasi, field, value)
#     db.commit()
#     db.refresh(db_notifikasi)
#     return db_notifikasi

# UmkmNotifikasi - Delete
@app.delete("/umkm_notifikasi/{id_notifikasi}")
def delete_umkm_notifikasi(id_notifikasi: int, db: Session = Depends(get_db)):
    db_notifikasi = db.query(models.UmkmNotifikasi).filter(models.UmkmNotifikasi.id_umkm_notifikasi == id_notifikasi).first()
    if not db_notifikasi:
        raise HTTPException(status_code=404, detail="Notification not found")
    db.delete(db_notifikasi)
    db.commit()
    return {"message": "Notification deleted successfully"}


# PendanaNotifikasi - Create (POST)
@app.post("/pendana_notifikasi/", response_model=schemas.PendanaNotifikasi)
def create_pendana_notifikasi(notifikasi: schemas.PendanaNotifikasiCreate, db: Session = Depends(get_db)):
    target_users = notifikasi.list_id_pendana
    notifications = []

    # Create notification for all Pendana
    if target_users == None:
        pendana_users = db.query(models.Pendana).all()
        for pendana_user in pendana_users:
            db_notifikasi = models.PendanaNotifikasi(**notifikasi.dict(exclude='list_id_pendana'))
            db_notifikasi.id_pendana = pendana_user.id_pendana
            db_notifikasi.waktu_tanggal = datetime.now()

            db.add(db_notifikasi)
            db.commit()
            db.refresh(db_notifikasi)
            notifications.append(db_notifikasi)
        
        return notifications

    # Set notification for specific Pendana
    elif target_users != None:
        for id_pendana in target_users:
            db_notifikasi = models.PendanaNotifikasi(**notifikasi.dict(exclude='list_id_pendana'))
            db_notifikasi.id_pendana = id_pendana
            db_notifikasi.waktu_tanggal = datetime.now()

            db.add(db_notifikasi)
            db.commit()
            db.refresh(db_notifikasi)
            notifications.append(db_notifikasi)
            
        return notifications
    
# PendanaNotifikasi - Read (GET)
@app.get("/pendana_notifikasi/{id_pendana}", response_model=List[schemas.PendanaNotifikasi])
def read_pendana_notifikasi(id_pendana: int, db: Session = Depends(get_db)):
    db_pendana_notifikasi = db.query(models.PendanaNotifikasi).filter(models.PendanaNotifikasi.id_pendana == id_pendana).all()
    return db_pendana_notifikasi

@app.get("/pendana_notifikasi/", response_model=List[schemas.PendanaNotifikasi])
def get_all_pendana_notifikasi(db: Session = Depends(get_db)):
    notifikasi = db.query(models.PendanaNotifikasi).all()
    return notifikasi

# Notifikasi - Update (PUT)
@app.put("/pendana_notifikasi/{id_pendana}", response_model=schemas.PendanaNotifikasi)
def update_pendana_notifikasi(id_pendana: int, db: Session = Depends(get_db)):
    db_pendana_notifikasi = db.query(models.PendanaNotifikasi).filter(models.PendanaNotifikasi.id_pendana == id_pendana).all()
    for notification in db_pendana_notifikasi:
        notification.is_terbaca = True
    
    db.commit()
    db.refresh(db_pendana_notifikasi)  # Refresh the objects with updated values
    
    return db_pendana_notifikasi

# PendanaNotifikasi - Delete
@app.delete("/pendana_notifikasi/{id_notifikasi}")
def delete_pendana_notifikasi(id_notifikasi: int, db: Session = Depends(get_db)):
    db_notifikasi = db.query(models.PendanaNotifikasi).filter(models.PendanaNotifikasi.id_pendana_notifikasi == id_notifikasi).first()
    if not db_notifikasi:
        raise HTTPException(status_code=404, detail="Notification not found")
    db.delete(db_notifikasi)
    db.commit()
    return {"message": "Notification deleted successfully"}