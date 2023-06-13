import copy
from datetime import datetime
from decimal import Decimal
from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy import func
from sqlalchemy.orm import Session
from fastapi.middleware.cors import CORSMiddleware

import schemas, models
from database import SessionLocal, engine

models.Base.metadata.create_all(bind=engine)

app = FastAPI()

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Update this list with appropriate origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

""" 
LOGIN & REGISTER
"""

@app.post("/register/pendana")
def register_pendana(pendana_request: schemas.RegisterPendanaRequest, db: Session = Depends(get_db)):
    # Check if the username already exists
    existing_username = db.query(models.Akun).filter(models.Akun.username == pendana_request.username).first()
    if existing_username:
        raise HTTPException(status_code=400, detail="Username sudah digunakan")

    # Create a new Dompet for the pendana
    new_dompet = models.Dompet(saldo=0)
    db.add(new_dompet)
    db.commit()
    db.refresh(new_dompet)

    # Create a new Akun for the pendana
    new_akun = models.Akun(
        username = pendana_request.username,
        password = pendana_request.password,
        foto_ktp = pendana_request.foto_ktp,
        foto_selfie = pendana_request.foto_selfie,
        jenis_user = 2
    )
    db.add(new_akun)
    db.commit()
    db.refresh(new_akun)

    # Create a new Pendana
    new_pendana = models.Pendana(
        foto_profil = 'default_profile_pic.png',
        nama_pendana = pendana_request.nama,
        id_dompet = new_dompet.id_dompet,
        id_akun = new_akun.id_akun,
        alamat = '',
        telp = '',
        email = ''
    )
    db.add(new_pendana)
    db.commit()
    db.refresh(new_pendana)

    # Return a success response or any other desired response
    return {"message": "Registrasi pendana berhasil"}

@app.post("/register/umkm")
def register_umkm(umkm_request: schemas.RegisterUMKMRequest, db: Session = Depends(get_db)):
    # Check if the username already exists
    existing_username = db.query(models.Akun).filter(models.Akun.username == umkm_request.username).first()
    if existing_username:
        raise HTTPException(status_code=400, detail="Username sudah digunakan")

    # Create a new Dompet for the umkm
    new_dompet = models.Dompet(saldo=0)
    db.add(new_dompet)
    db.commit()
    db.refresh(new_dompet)

    # Create a new Akun for the umkm
    new_akun = models.Akun(
        username = umkm_request.username,
        password = umkm_request.password,
        foto_ktp = umkm_request.foto_ktp,
        foto_selfie = umkm_request.foto_selfie,
        jenis_user = 1
    )
    db.add(new_akun)
    db.commit()
    db.refresh(new_akun)

    # Create a new Umkm
    new_umkm = models.Umkm(
        foto_profil = 'default_profile_pic.png',
        nama_pemilik = umkm_request.nama,
        nama_umkm = umkm_request.nama_umkm,
        jenis_usaha = umkm_request.jenis_usaha,
        alamat_usaha = umkm_request.alamat_usaha,
        telp = umkm_request.telp,
        deskripsi_umkm = umkm_request.deskripsi_umkm,
        omzet = umkm_request.omzet,
        limit_pinjaman = umkm_request.omzet*(Decimal('0.8')) / 12, # 80% omzet tahunan / 12 [bulan]
        id_dompet = new_dompet.id_dompet,
        id_akun = new_akun.id_akun,
        email = ''
    )
    db.add(new_umkm)
    db.commit()
    db.refresh(new_umkm)

    # Return a success response or any other desired response
    return {"message": "Registrasi UMKM berhasil"}

@app.post("/login")
def login(login_request: schemas.Login, db: Session = Depends(get_db)):
    # Check if the username and password match an existing account
    akun = db.query(models.Akun).filter(models.Akun.username == login_request.username, models.Akun.password == login_request.password).first()
    if not akun:
        raise HTTPException(status_code=401, detail="Username atau password salah")

    # Return the id_akun and jenis_user in the response
    response = {
        "id_akun": akun.id_akun,
        "jenis_user": akun.jenis_user
    }
    return response

""" 
Pendana
"""

@app.post("/pendana/beranda") # Using post because we are not just fetching data but also performing calculations and aggregations based on the provided data.
def get_pendana_homepage(pendana_request: schemas.BerandaPendana, db: Session = Depends(get_db)):
    # Retrieve the Pendana data
    pendana = db.query(models.Pendana).filter(models.Pendana.id_akun == pendana_request.id_akun).first()
    if not pendana:
        raise HTTPException(status_code=404, detail="Pendana not found")

    # Retrieve the saldo from the Dompet table
    saldo = db.query(models.Dompet.saldo).filter(models.Dompet.id_dompet == pendana.id_dompet).scalar()

    # Calculate total_pendanaan
    total_pendanaan = db.query(func.sum(models.PendanaanPendana.jumlah_danai)).\
        join(models.Pendanaan).\
        filter(models.PendanaanPendana.id_pendana == pendana.id_pendana).\
        filter(models.Pendanaan.status_pendanaan != 5).\
        scalar()
    if total_pendanaan is None:
        total_pendanaan = 0

    # Calculate total_bagi_hasil
    total_bagi_hasil = db.query(func.sum(models.RiwayatTransaksi.nominal)).\
        filter(models.Dompet.id_dompet == pendana.id_dompet).\
        filter(models.RiwayatTransaksi.jenis_transaksi == 2).\
        scalar()
    if total_bagi_hasil is None:
        total_bagi_hasil = 0

    # Retrieve the UMKM data
    umkm_records = db.query(models.Umkm.nama_umkm, (models.PendanaanPendana.jumlah_danai + models.PendanaanPendana.jumlah_danai * models.Pendanaan.imba_hasil).label('sisa_pokok')).\
        join(models.Pendanaan, models.PendanaanPendana.id_pendanaan == models.Pendanaan.id_pendanaan).\
        filter(models.PendanaanPendana.id_pendana == pendana.id_pendana).\
        filter(models.Pendanaan.status_pendanaan.in_([1, 2, 3])).\
        all()

    # Calculate jumlah_didanai_aktif
    jumlah_didanai_aktif = len(umkm_records)

    # Prepare the UMKM data
    umkm_data = [schemas.ListUMKMBerandaPendana(nama_umkm=umkm.nama_umkm, sisa_pokok=umkm.sisa_pokok) for umkm in umkm_records]

    # Construct the response
    response = schemas.ResponseBerandaPendana(
        nama_pendana=pendana.nama_pendana,
        saldo=saldo,
        total_pendanaan=total_pendanaan,
        total_bagi_hasil=total_bagi_hasil,
        jumlah_didanai_aktif=jumlah_didanai_aktif,
        umkm=umkm_data
    )

    return response

@app.post("/notifikasi")
def get_and_read_notifications(notifikasi_request: schemas.ListNotifikasi, db: Session = Depends(get_db)):
    # Process based on the user type
    if notifikasi_request.jenis_user == 1:
        # Retrieve notifications for UMKM
        notification_records = db.query(models.UmkmNotifikasi).filter(models.UmkmNotifikasi.id_umkm == notifikasi_request.id_akun).all()
        # Get a copy (by value) of the notification records
        notification_records_copy = copy.deepcopy(notification_records)
        # Set all notifications as read
        db.query(models.UmkmNotifikasi).\
            filter(models.UmkmNotifikasi.id_umkm == notifikasi_request.id_akun).\
            update({models.UmkmNotifikasi.is_terbaca: True})
        db.commit()
    elif notifikasi_request.jenis_user == 2:
        # Retrieve notifications for Pendana
        notification_records = db.query(models.PendanaNotifikasi).filter(models.PendanaNotifikasi.id_pendana == notifikasi_request.id_akun).all()
        # Get a copy (by value) of the notification records
        notification_records_copy = copy.deepcopy(notification_records)
        # Set all notifications as read
        db.query(models.PendanaNotifikasi).\
            filter(models.PendanaNotifikasi.id_pendana == notifikasi_request.id_akun).\
            update({models.PendanaNotifikasi.is_terbaca: True})
        db.commit()
    else:
        raise HTTPException(status_code=400, detail="Invalid jenis_user")

    # Prepare response
    notifications = []
    for notification in notification_records_copy:
        notification_data = schemas.Notifikasi(
            judul_notifikasi=notification.judul_notifikasi,
            is_terbaca=notification.is_terbaca,
            waktu_tanggal=notification.waktu_tanggal,
            isi_notifikasi=notification.isi_notifikasi
        )
        notifications.append(notification_data)

    return notifications

@app.post("/topup")
def process_topup(topup_request: schemas.TopUp, db: Session = Depends(get_db)):
    # Retrieve the corresponding user based on jenis_user
    if topup_request.jenis_user == 1:
        user = db.query(models.Umkm).filter(models.Umkm.id_akun == topup_request.id_akun).first()
        if not user:
            raise HTTPException(status_code=404, detail="User not found")
        id_dompet = user.id_dompet
        model_notification = models.UmkmNotifikasi
    elif topup_request.jenis_user == 2:
        user = db.query(models.Pendana).filter(models.Pendana.id_akun == topup_request.id_akun).first()
        if not user:
            raise HTTPException(status_code=404, detail="User not found")
        id_dompet = user.id_dompet
        model_notification = models.PendanaNotifikasi
    else:
        raise HTTPException(status_code=400, detail="Invalid jenis_user")

    # Increase saldo in the dompet table
    db.query(models.Dompet).\
        filter(models.Dompet.id_dompet == id_dompet).\
        update({models.Dompet.saldo: models.Dompet.saldo + topup_request.nominal})
    db.commit()

    # Create a new notification
    new_notification = model_notification(
        # id_pendana=topup_request.id_akun if topup_request.jenis_user == 2 else None,
        # id_umkm=topup_request.id_akun if topup_request.jenis_user == 1 else None,
        judul_notifikasi="TopUp Berhasil!",
        is_terbaca=False,
        waktu_tanggal=datetime.now(),
        isi_notifikasi=f"TopUp sebesar Rp.{topup_request.nominal} berhasil."
    )
    if topup_request.jenis_user == 1:
        new_notification.id_umkm=topup_request.id_akun
    elif topup_request.jenis_user == 2:
        new_notification.id_pendana=topup_request.id_akun
    db.add(new_notification)
    db.commit()

    return {"message": "Topup berhasil"}

@app.post("/saldo")
def get_saldo(get_saldo_request: schemas.GetSaldo, db: Session = Depends(get_db)):
    # Retrieve the corresponding user based on jenis_user
    if get_saldo_request.jenis_user == 1:
        user = db.query(models.Umkm).filter(models.Umkm.id_akun == get_saldo_request.id_akun).first()
        if not user:
            raise HTTPException(status_code=404, detail="User not found")
        id_dompet = user.id_dompet
    elif get_saldo_request.jenis_user == 2:
        user = db.query(models.Pendana).filter(models.Pendana.id_akun == get_saldo_request.id_akun).first()
        if not user:
            raise HTTPException(status_code=404, detail="User not found")
        id_dompet = user.id_dompet
    else:
        raise HTTPException(status_code=400, detail="Invalid jenis_user")

    # Retrieve the saldo from the dompet table
    dompet = db.query(models.Dompet).get(id_dompet)
    if not dompet:
        raise HTTPException(status_code=404, detail="Dompet not found")

    return {"saldo": dompet.saldo}

@app.post("/tarik-dana")
def process_withdraw(withdraw_request: schemas.TarikDana, db: Session = Depends(get_db)):
    # Retrieve the corresponding user based on jenis_user
    if withdraw_request.jenis_user == 1:
        user = db.query(models.Umkm).filter(models.Umkm.id_akun == withdraw_request.id_akun).first()
        if not user:
            raise HTTPException(status_code=404, detail="User not found")
        id_dompet = user.id_dompet
        model_notification = models.UmkmNotifikasi
    elif withdraw_request.jenis_user == 2:
        user = db.query(models.Pendana).filter(models.Pendana.id_akun == withdraw_request.id_akun).first()
        if not user:
            raise HTTPException(status_code=404, detail="User not found")
        id_dompet = user.id_dompet
        model_notification = models.PendanaNotifikasi
    else:
        raise HTTPException(status_code=400, detail="Invalid jenis_user")

    # Retrieve the saldo from the dompet table
    dompet = db.query(models.Dompet).get(id_dompet)
    if not dompet:
        raise HTTPException(status_code=404, detail="Dompet not found")

    # Check if there is enough saldo for withdrawal
    if dompet.saldo < withdraw_request.nominal:
        raise HTTPException(status_code=400, detail="Insufficient saldo for withdrawal")

    # Update the saldo in the dompet table
    db.query(models.Dompet).\
        filter(models.Dompet.id_dompet == id_dompet).\
        update({models.Dompet.saldo: models.Dompet.saldo - withdraw_request.nominal})
    db.commit()

    # Create a new notification
    new_notification = model_notification(
        judul_notifikasi="Tarik Dana Berhasil!",
        is_terbaca=False,
        waktu_tanggal=datetime.now(),
        isi_notifikasi=f"Penarikan dana sebesar Rp.{withdraw_request.nominal} berhasil."
    )
    if withdraw_request.jenis_user == 1:
        new_notification.id_umkm=withdraw_request.id_akun
    elif withdraw_request.jenis_user == 2:
        new_notification.id_pendana=withdraw_request.id_akun
    db.add(new_notification)
    db.commit()

    return {"message": "Penarikan dana berhasil"}
