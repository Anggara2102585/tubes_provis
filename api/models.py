from sqlalchemy import Boolean, Column, ForeignKey, Integer, String, Float, Text, Numeric, DateTime
from sqlalchemy.orm import relationship

from .database import Base


class Dompet(Base):
    __tablename__ = "dompet"

    id_dompet = Column(Integer, primary_key=True, index=True, autoincrement=True)
    saldo = Column(Numeric(precision=15, scale=2))

class Umkm(Base):
    __tablename__ = "umkm"

    id_umkm = Column(Integer, primary_key=True, index=True, autoincrement=True)
    foto_profil = Column(String, unique=True)
    nama_umkm = Column(String)
    jenis_usaha = Column(String)
    rating = Column(Float)
    alamat_usaha = Column(Text)
    telp = Column(String)
    deskripsi_umkm = Column(Text)
    limit_pinjaman = Column(Numeric(precision=15, scale=2))
    omzet = Column(Numeric(precision=15, scale=2))
    id_dompet = Column(Integer, ForeignKey("dompet.id_dompet"))

class Pendanaan(Base):
    __tablename__ = "pendanaan"

    id_pendanaan = Column(Integer, primary_key=True, index=True, autoincrement=True)
    id_umkm = Column(Integer, ForeignKey("umkm.id_umkm"))
    kode_pendanaan = Column(String)
    pendanaan_ke = Column(Integer)
    status_pendanaan = Column(Integer)
    total_pendanaan = Column(Numeric(precision=15,scale=2))
    dana_masuk = Column(Numeric(precision=15,scale=2))
    imba_hasil = Column(Integer) # dalam persen
    minimal_pendanaan = Column(Numeric(precision=15,scale=2))
    dl_penggalangan = Column(DateTime)
    dl_bagi_hasil = Column(DateTime)
    deskripsi_pendanaan = Column(Text)
    tanggal_pengajuan = Column(DateTime)
    tanggal_selesai = Column(DateTime)
    # skip id_ulasan_user

class RiwayatTransaksi(Base):
    __tablename__ = "riwayat_transaksi"

    id_riwayat_transaksi = Column(Integer, primary_key=True, index=True, autoincrement=True)
    jenis_transaksi = Column(String)
    nominal = Column(Numeric(precision=15,scale=2))
    tanggal = Column(DateTime)
    keterangan = Column(String)

class Notifikasi(Base):
    __tablename__ = "notifikasi"

    id_notifikasi = Column(Integer, primary_key=True, index=True, autoincrement=True)
    judul_notifikasi = Column(String)
    isi_notifikasi = Column(Text)
    waktu_tanggal = Column(DateTime)
    is_terbaca = Column(Boolean, default=False)

class Pendana(Base):
    __tablename__ = "pendana"

    id_pendana = Column(Integer, primary_key=True, index=True, autoincrement=True)
    foto_profil = Column(String, unique=True)
    nama_pendana = Column(String)
    id_dompet = Column(Integer, ForeignKey("dompet.id_dompet"))

# table many to many Umkm - Notifikasi
class UmkmNotifikasi(Base):
    __tablename__ = "umkm_notifikasi"

    id_umkm_notifikasi = Column(Integer, primary_key=True, index=True, autoincrement=True)
    id_umkm = Column(Integer, ForeignKey("umkm.id_umkm"))
    id_notifikasi = Column(Integer, ForeignKey("notifikasi.id_notifikasi"))

# table many to many Pendana - Notifikasi
class PendanaNotifikasi(Base):
    __tablename__ = "pendana_notifikasi"

    id_pendana_notifikasi = Column(Integer, primary_key=True, index=True, autoincrement=True)
    id_pendana = Column(Integer, ForeignKey("pendana.id_pendana"))
    id_notifikasi = Column(Integer, ForeignKey("notifikasi.id_notifikasi"))

# table many to many RiwayatTransaksi - Dompet
class DompetRiwayatTransaksi(Base):
    __tablename__ = "dompet_riwayat_transaksi"

    id_dompet_riwayat_transaksi = Column(Integer, primary_key=True, autoincrement=True)
    id_riwayat_transaksi = Column(Integer,ForeignKey("RiwayatTransaksi.id_riwayat_transaksi"))
    id_dompet = Column(Integer, ForeignKey("Dompet.id_dompet"))

# table many to many Pendanaan - Pendana
class PendanaanPendana(Base):
    __tablename__ = "pendanaan_pendana"
    
    id_pendanaan_pendana = Column(Integer, primary_key=True,autoincrement=True)
    id_pendana = Column(Integer, ForeignKey("pendana.id_pendana"))
    id_pendanaan = Column(Integer, ForeignKey("pendanaan.id_pendanaan"))