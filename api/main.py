from decimal import Decimal
from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session

import schemas, models
from database import SessionLocal, engine

models.Base.metadata.create_all(bind=engine)

app = FastAPI()

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
        jenis_user = 2
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