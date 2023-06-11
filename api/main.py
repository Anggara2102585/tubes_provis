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
        username=pendana_request.username,
        password=pendana_request.password,
        foto_ktp=pendana_request.foto_ktp,
        foto_selfie=pendana_request.foto_selfie
    )
    db.add(new_akun)
    db.commit()
    db.refresh(new_akun)

    # Create a new Pendana
    new_pendana = models.Pendana(
        foto_profil='default_profile_pic.png',
        nama_pendana=pendana_request.nama,
        id_dompet=new_dompet.id_dompet,
        id_akun=new_akun.id_akun,
        alamat='',
        telp='',
        email=''
    )
    db.add(new_pendana)
    db.commit()
    db.refresh(new_pendana)

    # Return a success response or any other desired response
    return {"message": "Registrasi pendana berhasil"}
