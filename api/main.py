import copy
from datetime import datetime, timedelta
from decimal import Decimal
from fastapi import FastAPI, Depends, HTTPException, UploadFile, File
from sqlalchemy import func, exc
from sqlalchemy.orm import Session, joinedload
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse
from passlib.context import CryptContext

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


# Create a password context for password hashing and verification
password_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

#upload image
@app.post("/uploadimage")
# pip install python-multipart
# buat terlebih dulu direktori /data_file untuk menyimpan file
def upload(file: UploadFile = File(...)):
    try:
        print("mulai upload")
        print(file.filename)
        contents = file.file.read()
        with open("./data_file/"+file.filename, 'wb') as f:
            f.write(contents)
    except Exception:
        return {"message": "Error upload file"}
    finally:
        file.file.close()

    return {"message": f"Upload berhasil: {file.filename}"}

# ambil image berdasarkan nama file
@app.get("/getimage/{nama_file}")
async def getImage(nama_file:str):
    return FileResponse("./data_file/"+nama_file)

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

    # Hash the new password
    hashed_password = password_context.hash(pendana_request.password)

    # Create a new Akun for the pendana
    new_akun = models.Akun(
        username = pendana_request.username,
        password = hashed_password,
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

    # Hash the new password
    hashed_password = password_context.hash(umkm_request.password)

    # Create a new Akun for the umkm
    new_akun = models.Akun(
        username = umkm_request.username,
        password = hashed_password,
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
    # Check if the username
    akun = db.query(models.Akun).filter(models.Akun.username == login_request.username).first()
    if not akun:
        raise HTTPException(status_code=401, detail="Username atau password salah")

    # Verify the password
    if not password_context.verify(login_request.password, akun.password):
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

@app.post("/pendana/beranda", response_model=schemas.ResponseBerandaPendana) # Using post because we are not just fetching data but also performing calculations and aggregations based on the provided data.
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
    umkm_records = db.query(models.Umkm.nama_umkm, (models.PendanaanPendana.jumlah_danai + models.PendanaanPendana.jumlah_danai * models.Pendanaan.imba_hasil / 100).label('sisa_pokok')).\
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

@app.post("/notifikasi", response_model=schemas.ResponseListNotifikasi)
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

@app.post("/saldo", response_model=schemas.Saldo)
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
    
    response = schemas.Saldo(saldo=dompet.saldo)

    return response

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

@app.get("/marketplace", response_model=schemas.ResponseListMarketplace)
def get_pendanaan_marketplace(db: Session = Depends(get_db)):
    # Retrieve the available pendanaan from the database
    pendanaan = db.query(models.Pendanaan). \
        options(joinedload(models.Pendanaan.umkm)). \
        filter(models.Pendanaan.status_pendanaan == 1). \
        all()

    # Prepare the response data
    marketplace_data = []
    for item in pendanaan:
        persen_progres = (item.dana_masuk / item.total_pendanaan) * 100

        pendanaan_data = schemas.CardMarketplace(
            nama_umkm=item.umkm.nama_umkm,
            jenis_usaha=item.umkm.jenis_usaha,
            kode_pendanaan=item.kode_pendanaan,
            total_pendanaan=item.total_pendanaan,
            dana_masuk=item.dana_masuk,
            imba_hasil=item.imba_hasil,
            dl_penggalangan_dana=item.dl_penggalangan_dana,
            persen_progres=persen_progres
        )
        marketplace_data.append(pendanaan_data)

    response = schemas.ResponseListMarketplace(pendanaan=marketplace_data)
    return response

""" DETAIL MARKETPLACE pakai DETAIL PENDANAAN """

@app.post("/mendanai", response_model=schemas.ResponseMendanai)
def mendanai_pendanaan(request: schemas.Mendanai, db: Session = Depends(get_db)):
    # Retrieve the pendana from pendana table using id_akun
    pendana = (
        db.query(models.Pendana)
        .filter(models.Pendana.id_akun == request.id_akun)
        .first()
    )
    if not pendana:
        raise HTTPException(status_code=404, detail="Pendana not found")

    # Retrieve the pendanaan data
    pendanaan = (
        db.query(models.Pendanaan)
        .filter(models.Pendanaan.id_pendanaan == request.id_pendanaan)
        .first()
    )
    if not pendanaan:
        raise HTTPException(status_code=404, detail="Pendanaan not found")

    # Check if the nominal is valid
    minimal_pendanaan = pendanaan.minimal_pendanaan
    remaining_amount = pendanaan.total_pendanaan - pendanaan.dana_masuk

    if request.nominal < minimal_pendanaan:
        raise HTTPException(status_code=400, detail="Nominal is less than minimal_pendanaan")
    
    # if request.nominal > remaining_amount:
    #     raise HTTPException(status_code=400, detail="Nominal exceeds the remaining amount")

    # Retrieve the saldo from dompet table
    dompet = (
        db.query(models.Dompet)
        .filter(models.Dompet.id_dompet == pendana.id_dompet)
        .first()
    )

    if not dompet:
        raise HTTPException(status_code=404, detail="Dompet not found")

    saldo = dompet.saldo

    if request.nominal > saldo:
        raise HTTPException(status_code=400, detail="Insufficient saldo in dompet")

    # Calculate the actual nominal
    if remaining_amount < minimal_pendanaan:
        actual_nominal = remaining_amount
    else:
        actual_nominal = request.nominal

    if actual_nominal > remaining_amount:
        actual_nominal = remaining_amount

    # Start the transaction
    try:
        # Reduce saldo in dompet
        dompet.saldo -= actual_nominal

        # Add dana_masuk to pendanaan
        pendanaan.dana_masuk += actual_nominal

        # Create pendanaan_pendana entry
        pendanaan_pendana = models.PendanaanPendana(
            id_pendana=pendana.id_pendana,
            id_pendanaan=request.id_pendanaan,
            jumlah_danai=actual_nominal,
            tanggal_danai=datetime.now()
        )
        db.add(pendanaan_pendana)

        # Create riwayat_transaksi entry
        riwayat_transaksi = models.RiwayatTransaksi(
            id_dompet=dompet.id_dompet,
            jenis_transaksi=5,
            nominal=actual_nominal,
            tanggal=datetime.now(),
            keterangan="-"
        )
        db.add(riwayat_transaksi)

        db.commit()
        db.refresh(dompet)

        # Prepare the response data
        response_data = schemas.ResponseMendanai(
            id_pendanaan_pendana=pendanaan_pendana.id_pendanaan_pendana,
            id_dompet=riwayat_transaksi.id_dompet,
            saldo_dompet=dompet.saldo
        )

        return response_data
    
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail="Failed to mendanai pendanaan")


@app.post("/portofolio", response_model=schemas.ResponseListPortofolio)
def get_portofolio(portofolio_request: schemas.ListPortofolio, db: Session = Depends(get_db)):
    # Retrieve the corresponding pendana based on id_akun
    pendana = db.query(models.Pendana).filter(models.Pendana.id_akun == portofolio_request.id_akun).first()
    if not pendana:
        raise HTTPException(status_code=404, detail="Pendana not found")
    id_pendana = pendana.id_pendana

    # Retrieve the portfolio data from the database
    pendanaan = db.query(models.PendanaanPendana).\
        join(models.Pendanaan, models.PendanaanPendana.id_pendanaan == models.Pendanaan.id_pendanaan).\
        join(models.Umkm, models.Pendanaan.id_umkm == models.Umkm.id_umkm).\
        filter(models.PendanaanPendana.id_pendana == id_pendana).\
        all()

    # Prepare the response data
    portofolio_data = []
    for item in pendanaan:
        portofolio_item = schemas.CardPortofolio(
            nama_umkm=item.umkm.nama_umkm,
            kode_pendanaan=item.pendanaan.kode_pendanaan,
            status_pendanaan=item.pendanaan.status_pendanaan,
            jumlah_danai=item.jumlah_danai,
            tanggal_danai=item.tanggal_danai
        )
        portofolio_data.append(portofolio_item)

    response = schemas.ResponseListPortofolio(pendanaan=portofolio_data)
    return response

@app.post("/detail_pendanaan", response_model=schemas.ResponseDetailPendanaan)
def get_detail_pendanaan(detail_pendanaan_request: schemas.DetailPendanaan, db: Session = Depends(get_db)):
    # Retrieve the corresponding pendana based on id_akun
    pendana = db.query(models.Pendana).filter(models.Pendana.id_akun == detail_pendanaan_request.id_akun).first()
    if not pendana:
        raise HTTPException(status_code=404, detail="Pendana not found")
    id_pendana = pendana.id_pendana

    # Retrieve the portfolio data from the database
    pendanaanPendana = db.query(models.PendanaanPendana).\
        join(models.Pendanaan, models.PendanaanPendana.id_pendanaan == models.Pendanaan.id_pendanaan).\
        join(models.Umkm, models.Pendanaan.id_umkm == models.Umkm.id_umkm).\
        filter(models.PendanaanPendana.id_pendana == id_pendana).\
        filter(models.PendanaanPendana.id_pendanaan == detail_pendanaan_request.id_pendanaan).\
        first()
    if not pendanaanPendana:
        raise HTTPException(status_code=404, detail="Pendanaan not found")

    # Prepare the response data
    response = schemas.ResponseDetailPendanaan(
        nama_pemilik=pendanaanPendana.umkm.nama_pemilik,
        nama_umkm=pendanaanPendana.umkm.nama_umkm,
        jenis_usaha=pendanaanPendana.umkm.jenis_usaha,
        telp=pendanaanPendana.umkm.telp,
        deskripsi_umkm=pendanaanPendana.umkm.deskripsi_umkm,
        
        kode_pendanaan=pendanaanPendana.pendanaan.kode_pendanaan,
        pendanaan_ke=pendanaanPendana.pendanaan.pendanaan_ke,
        status_pendanaan=pendanaanPendana.pendanaan.status_pendanaan,
        total_pendanaan=pendanaanPendana.pendanaan.total_pendanaan,
        dana_masuk=pendanaanPendana.pendanaan.dana_masuk,
        persen_progres=pendanaanPendana.pendanaan.persen_progres,
        imba_hasil=pendanaanPendana.pendanaan.imba_hasil,
        minimal_pendanaan=pendanaanPendana.pendanaan.minimal_pendanaan,
        dl_pendanaan_dana=pendanaanPendana.pendanaan.dl_pendanaan_dana,
        dl_bagi_hasil=pendanaanPendana.pendanaan.dl_bagi_hasil,
        deskripsi_pengajuan=pendanaanPendana.pendanaan.deskripsi_pengajuan,
        tanggal_pengajuan=pendanaanPendana.pendanaan.tanggal_pengajuan,
        tanggal_selesai=pendanaanPendana.pendanaan.tanggal_selesai,
        
        jumlah_danai=pendanaanPendana.jumlah_danai,
        tanggal_danai=pendanaanPendana.tanggal_danai
    )
    if response.tanggal_selesai:
        response.is_telat = pendanaanPendana.pendanaan.tanggal_selesai > pendanaanPendana.pendanaan.dl_bagi_hasil
    response.bunga = pendanaanPendana.pendanaan.total_pendanaan * pendanaanPendana.pendanaan.imba_hasil/100
    response.total_bagi_hasil =  pendanaanPendana.pendanaan.total_pendanaan + response.bunga

    return response

@app.post("/profil_pendana", response_model=schemas.ResponseProfilPendana)
def get_profil_pendana(profil_pendana_request: schemas.ProfilPendana, db: Session = Depends(get_db)):
    # Retrieve the corresponding pendana based on id_akun
    pendana = db.query(models.Pendana).filter(models.Pendana.id_akun == profil_pendana_request.id_akun).first()
    if not pendana:
        raise HTTPException(status_code=404, detail="Pendana not found")

    # Prepare the response data
    response = schemas.ResponseProfilPendana(
        foto_profil=pendana.foto_profil,
        nama_pendana=pendana.nama_pendana,
        email=pendana.email,
        telp=pendana.telp,
        alamat=pendana.alamat,
        username=pendana.akun.username,
        password=pendana.akun.password
    )

    return response

@app.put("/edit_profil_pendana", response_model=schemas.ResponseProfilPendana)
def edit_profil_pendana(edit_profil_request: schemas.EditProfilPendana, db: Session = Depends(get_db)):
    # Retrieve the corresponding pendana based on id_akun
    pendana = db.query(models.Pendana).filter(models.Pendana.id_akun == edit_profil_request.id_akun).first()
    if not pendana:
        raise HTTPException(status_code=404, detail="Pendana not found")

    # Update the profile data
    if edit_profil_request.foto_profil is not None:
        pendana.foto_profil = edit_profil_request.foto_profil
    if edit_profil_request.nama_pendana is not None:
        pendana.nama_pendana = edit_profil_request.nama_pendana
    if edit_profil_request.email is not None:
        pendana.email = edit_profil_request.email
    if edit_profil_request.telp is not None:
        pendana.telp = edit_profil_request.telp
    if edit_profil_request.alamat is not None:
        pendana.alamat = edit_profil_request.alamat
    if edit_profil_request.username is not None:
        # Check if the new username is unique
        if db.query(models.Akun).filter(models.Akun.username == edit_profil_request.username).first():
            raise HTTPException(status_code=400, detail="Username already exists")
        pendana.akun.username = edit_profil_request.username
    if edit_profil_request.password is not None:
        # Hash the new password
        hashed_password = password_context.hash(edit_profil_request.password)
        pendana.akun.password = hashed_password

    try:
        db.commit()
        db.refresh(pendana)
    except exc.SQLAlchemyError:
        db.rollback()
        raise HTTPException(status_code=500, detail="Failed to update profile")

    # Prepare the response data
    response = schemas.ResponseProfilPendana(
        foto_profil=pendana.foto_profil,
        nama_pendana=pendana.nama_pendana,
        email=pendana.email,
        telp=pendana.telp,
        alamat=pendana.alamat,
        username=pendana.akun.username,
        password=pendana.akun.password
    )

    return response

""" 
UMKM
"""

""" BERANDA UMKM """

@app.post("/usahaku", response_model=schemas.ResponseUsahaku)
def get_usahaku(usahaku_request: schemas.Usahaku, db: Session = Depends(get_db)):
    # Retrieve the corresponding UMKM based on id_akun
    umkm = db.query(models.Umkm).filter(models.Umkm.id_akun == usahaku_request.id_akun).first()
    if not umkm:
        raise HTTPException(status_code=404, detail="UMKM not found")

    # Retrieve total_pinjaman
    total_pinjaman = db.query(func.sum(models.Pendanaan.total_pendanaan)).filter(models.Pendanaan.id_umkm == umkm.id_umkm).scalar() or 0

    # Retrieve total_pengeluaran
    total_pengeluaran = db.query(func.sum(models.Pendanaan.total_pendanaan + models.Pendanaan.total_pendanaan * models.Pendanaan.imba_hasil / 100)).filter(models.Pendanaan.id_umkm == umkm.id_umkm).scalar() or 0

    # Retrieve the list of pendanaan
    pendanaan_list = []
    pendanaan_rows = db.query(models.Pendanaan).filter(models.Pendanaan.id_umkm == umkm.id_umkm).all()
    for pendanaan in pendanaan_rows:
        # Calculate persen_progres for each pendanaan
        persen_progres = int(pendanaan.dana_masuk / pendanaan.total_pendanaan * 100) if pendanaan.dana_masuk != 0 else 0

        # Calculate total_bayar for each pendanaan
        total_bayar = pendanaan.total_pendanaan + pendanaan.total_pendanaan * pendanaan.imba_hasil / 100

        pendanaan_data = schemas.PendanaanUsahaku(
            kode_pendanaan=pendanaan.kode_pendanaan,
            deskripsi_pendanaan=pendanaan.deskripsi_pendanaan,
            status_pendanaan=pendanaan.status_pendanaan,
            dana_masuk=pendanaan.dana_masuk,
            dl_penggalangan_dana=pendanaan.dl_penggalangan_dana,
            tanggal_pengajuan=pendanaan.tanggal_pengajuan,
            tanggal_selesai=pendanaan.tanggal_selesai,
            total_bayar=total_bayar,
            persen_progres=persen_progres
        )
        pendanaan_list.append(pendanaan_data)

    # Prepare the response data
    response = schemas.ResponseUsahaku(
        nama_umkm=umkm.nama_umkm,
        jenis_usaha=umkm.jenis_usaha,
        limit_pinjaman=umkm.limit_pinjaman,
        total_pinjaman=total_pinjaman,
        total_pengeluaran=total_pengeluaran,
        pendanaan=pendanaan_list
    )

    return response

@app.post("/lihat_pendana", response_model=schemas.ResponseLihatPendana)
def lihat_pendana(lihat_pendana_request: schemas.LihatPendana, db: Session = Depends(get_db)):
    # Retrieve the corresponding pendanaan based on id_pendanaan
    pendanaan = db.query(models.Pendanaan).filter(models.Pendanaan.id_pendanaan == lihat_pendana_request.id_pendanaan).first()
    if not pendanaan:
        raise HTTPException(status_code=404, detail="Pendanaan not found")

    # Retrieve the list of pendana
    pendana_list = []
    pendana_rows = db.query(models.PendanaanPendana).filter(models.PendanaanPendana.id_pendanaan == pendanaan.id_pendanaan).all()
    for pendana_row in pendana_rows:
        # Retrieve nama_pendana from pendana table
        pendana = db.query(models.Pendana).filter(models.Pendana.id_pendana == pendana_row.id_pendana).first()
        if not pendana:
            raise HTTPException(status_code=500, detail="Failed to retrieve pendana")

        pendana_data = schemas.DataPendana(
            nama_pendana=pendana.nama_pendana,
            jumlah_danai=pendana_row.jumlah_danai,
            tanggal_danai=pendana_row.tanggal_danai
        )
        pendana_list.append(pendana_data)

    # Prepare the response data
    response = schemas.ResponseLihatPendana(
        pendana=pendana_list
    )

    return response

""" cek apakah total_pendanaan kurang dari maksimum peminjaman """
@app.post("/mengajukan_pendanaan", response_model=schemas.ResponseMengajukanPendanaan)
def mengajukan_pendanaan(mengajukan_pendanaan_request: schemas.MengajukanPendanaan, db: Session = Depends(get_db)):
    # Retrieve the corresponding UMKM based on id_akun
    umkm = db.query(models.Umkm).filter(models.Umkm.id_akun == mengajukan_pendanaan_request.id_akun).first()
    if not umkm:
        raise HTTPException(status_code=404, detail="UMKM not found")

    # Calculate the pendanaan_ke
    pendanaan_ke = db.query(func.count(models.Pendanaan.id_pendanaan)).filter(models.Pendanaan.id_umkm == umkm.id_umkm).scalar() or 0
    pendanaan_ke += 1

    # Generate the kode_pendanaan
    kode_pendanaan = f"{umkm.nama_umkm}-{pendanaan_ke}"

    # Prepare the pendanaan data
    pendanaan_data = models.Pendanaan(
        id_umkm=umkm.id_umkm,
        pendanaan_ke=pendanaan_ke,
        kode_pendanaan=kode_pendanaan,
        status_pendanaan=1,
        total_pendanaan=mengajukan_pendanaan_request.total_pendanaan,
        dana_masuk=0,
        imba_hasil=mengajukan_pendanaan_request.imba_hasil,
        minimal_pendanaan=mengajukan_pendanaan_request.minimal_pendanaan,
        dl_penggalangan_dana=datetime.now() + timedelta(days=mengajukan_pendanaan_request.dl_penggalangan_dana),
        dl_bagi_hasil=datetime.now() + timedelta(days=mengajukan_pendanaan_request.dl_penggalangan_dana+30),
        deskripsi_pendanaan=mengajukan_pendanaan_request.deskripsi_pendanaan,
        tanggal_pengajuan=datetime.now(),
        tanggal_selesai=None
    )

    # Save the pendanaan to the database
    db.add(pendanaan_data)
    db.commit()
    db.refresh(pendanaan_data)

    # Prepare the response data
    response = schemas.ResponseMengajukanPendanaan(
        id_pendanaan=pendanaan_data.id_pendanaan,
        id_umkm=pendanaan_data.id_umkm,
        pendanaan_ke=pendanaan_data.pendanaan_ke,
        kode_pendanaan=pendanaan_data.kode_pendanaan,
        status_pendanaan=pendanaan_data.status_pendanaan,
        total_pendanaan=pendanaan_data.total_pendanaan,
        dana_masuk=pendanaan_data.dana_masuk,
        imba_hasil=pendanaan_data.imba_hasil,
        minimal_pendanaan=pendanaan_data.minimal_pendanaan,
        dl_penggalangan_dana=pendanaan_data.dl_penggalangan_dana,
        dl_bagi_hasil=pendanaan_data.dl_bagi_hasil,
        deskripsi_pendanaan=pendanaan_data.deskripsi_pendanaan,
        tanggal_pengajuan=pendanaan_data.tanggal_pengajuan,
        tanggal_selesai=pendanaan_data.tanggal_selesai
    )

    return response

@app.post("/melunasi")
def melunasi_pendanaan(
    request: schemas.MelunasiRequest,
    db: Session = Depends(get_db)
):
    # Retrieve the umkm from umkm table using id_akun
    umkm = (
        db.query(models.Umkm)
        .filter(models.Umkm.id_akun == request.id_akun)
        .first()
    )

    if not umkm:
        raise HTTPException(status_code=404, detail="UMKM not found")

    # Retrieve the pendanaan data
    pendanaan = (
        db.query(models.Pendanaan)
        .filter(models.Pendanaan.id_pendanaan == request.id_pendanaan)
        .first()
    )

    if not pendanaan:
        raise HTTPException(status_code=404, detail="Pendanaan not found")

    # Check if the pendanaan is eligible for melunasi
    if pendanaan.status_pendanaan not in [2, 3]:
        raise HTTPException(status_code=400, detail="Invalid status_pendanaan for melunasi")

    # Retrieve the dompet data for the umkm
    dompet_umkm = (
        db.query(models.Dompet)
        .filter(models.Dompet.id_umkm == umkm.id_umkm)
        .first()
    )

    if not dompet_umkm:
        raise HTTPException(status_code=404, detail="Dompet for UMKM not found")

    # Calculate the tagihan
    tagihan = pendanaan.total_pendanaan + (pendanaan.total_pendanaan * pendanaan.imba_hasil / 100)

    if dompet_umkm.saldo < tagihan:
        raise HTTPException(status_code=400, detail="Insufficient saldo in dompet for melunasi")

    # Start the transaction
    try:
        # Reduce saldo from umkm's dompet
        dompet_umkm.saldo -= tagihan

        # Set status_pendanaan to 4
        pendanaan.status_pendanaan = 4

        # Retrieve pendanaan_pendana data
        pendanaan_pendana = (
            db.query(models.PendanaanPendana)
            .filter(models.PendanaanPendana.id_pendanaan == request.id_pendanaan)
            .all()
        )

        # Process each pendanaan_pendana
        for pp in pendanaan_pendana:
            # Retrieve the pendana data
            pendana = (
                db.query(models.Pendana)
                .filter(models.Pendana.id_pendana == pp.id_pendana)
                .first()
            )

            if not pendana:
                raise HTTPException(status_code=404, detail="Pendana not found")

            # Retrieve the dompet data for the pendana
            dompet_pendana = (
                db.query(models.Dompet)
                .filter(models.Dompet.id_dompet == pendana.id_dompet)
                .first()
            )

            if not dompet_pendana:
                raise HTTPException(status_code=404, detail="Dompet for Pendana not found")

            # Calculate the keuntungan_pendana
            keuntungan_pendana = pp.jumlah_danai + (pp.jumlah_danai * pendanaan.imba_hasil / 100)

            # Create riwayat_transaksi entry for pendana
            riwayat_transaksi_pendana = models.RiwayatTransaksi(
                id_dompet=dompet_pendana.id_dompet,
                jenis_transaksi=5,
                nominal=keuntungan_pendana,
                tanggal=datetime.now(),
                keterangan="bagi hasil diterima"
            )
            db.add(riwayat_transaksi_pendana)

            # Add keuntungan_pendana to pendana's saldo
            pendana.saldo += keuntungan_pendana

        # Create riwayat_transaksi entry for umkm
        riwayat_transaksi_umkm = models.RiwayatTransaksi(
            id_dompet=dompet_umkm.id_dompet,
            jenis_transaksi=5,
            nominal=tagihan,
            tanggal=datetime.now(),
            keterangan="bagi hasil dibayarkan"
        )
        db.add(riwayat_transaksi_umkm)

        db.commit()
        db.refresh(dompet_umkm)

        return {"message": "Pendanaan berhasil dilunasi."}

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail="Internal server error")

@app.post("/profil_umkm", response_model=schemas.ResponseProfilUMKM)
def get_profil_umkm(profil_umkm_request: schemas.ProfilUMKM, db: Session = Depends(get_db)):
    # Retrieve the profile data from the database based on the given `id_akun`
    profil_umkm = db.query(models.Umkm). \
        filter(models.Umkm.id_akun == profil_umkm_request.id_akun). \
        first()

    if not profil_umkm:
        raise HTTPException(status_code=404, detail="UMKM not found")

    # Prepare the response data
    response = schemas.ResponseProfilUMKM(
        nama_pemilik=profil_umkm.nama_pemilik,
        email=profil_umkm.email,
        telp=profil_umkm.telp,
        alamat_usaha=profil_umkm.alamat_usaha,
        username=profil_umkm.akun.username,
        nama_umkm=profil_umkm.nama_umkm,
        omzet=profil_umkm.omzet,
        deskripsi_umkm=profil_umkm.deskripsi_umkm,
        jenis_usaha=profil_umkm.jenis_usaha
    )

    return response

@app.put("/edit_profil_umkm", response_model=schemas.ResponseProfilUMKM)
def edit_profil_umkm(edit_umkm_request: schemas.EditProfilUMKM, db: Session = Depends(get_db)):
    # Retrieve the UMKM profile data from the database based on the given `id_akun`
    profil_umkm = db.query(models.Umkm). \
        filter(models.Umkm.id_akun == edit_umkm_request.id_akun). \
        first()

    if not profil_umkm:
        raise HTTPException(status_code=404, detail="UMKM not found")

    # Update the profile data based on the request body
    if edit_umkm_request.nama_pemilik is not None:
        profil_umkm.nama_pemilik = edit_umkm_request.nama_pemilik
    if edit_umkm_request.email is not None:
        profil_umkm.email = edit_umkm_request.email
    if edit_umkm_request.telp is not None:
        profil_umkm.telp = edit_umkm_request.telp
    if edit_umkm_request.alamat_usaha is not None:
        profil_umkm.alamat_usaha = edit_umkm_request.alamat_usaha
    if edit_umkm_request.username is not None:
        profil_umkm.akun.username = edit_umkm_request.username
    if edit_umkm_request.nama_umkm is not None:
        profil_umkm.nama_umkm = edit_umkm_request.nama_umkm
    if edit_umkm_request.omzet is not None:
        profil_umkm.omzet = edit_umkm_request.omzet
    if edit_umkm_request.deskripsi_umkm is not None:
        profil_umkm.deskripsi_umkm = edit_umkm_request.deskripsi_umkm
    if edit_umkm_request.jenis_usaha is not None:
        profil_umkm.jenis_usaha = edit_umkm_request.jenis_usaha

    # Save the changes to the database
    db.commit()

    # Prepare the response data
    response = schemas.ResponseProfilUMKM(
        nama_pemilik=profil_umkm.nama_pemilik,
        email=profil_umkm.email,
        telp=profil_umkm.telp,
        alamat_usaha=profil_umkm.alamat_usaha,
        username=profil_umkm.akun.username,
        nama_umkm=profil_umkm.nama_umkm,
        omzet=profil_umkm.omzet,
        deskripsi_umkm=profil_umkm.deskripsi_umkm,
        jenis_usaha=profil_umkm.jenis_usaha
    )

    return response