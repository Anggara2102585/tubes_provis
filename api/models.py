from sqlalchemy import Boolean, Column, ForeignKey, Integer, String, Float, Text, Numeric, DateTime
from sqlalchemy.orm import relationship

from database import Base


class Dompet(Base):
    __tablename__ = "dompet"

    id_dompet = Column(Integer, primary_key=True, index=True, autoincrement=True)
    saldo = Column(Numeric(precision=15, scale=2))

    umkm = relationship("Umkm", uselist=False, back_populates="dompet")
    pendana = relationship("Pendana", uselist=False, back_populates="dompet")
    riwayat_transaksi = relationship("RiwayatTransaksi", back_populates="dompet", cascade="all, delete-orphan")

class Akun(Base):
    __tablename__ = "akun"

    id_akun = Column(Integer, primary_key=True, index=True, autoincrement=True)
    username = Column(String, unique=True)
    password = Column(String)
    foto_ktp = Column(String)
    foto_selfie = Column(String)
    jenis_user = Column(Integer)

    umkm = relationship("Umkm", uselist=False, back_populates="akun")
    pendana = relationship("Pendana", uselist=False, back_populates="akun")

class Umkm(Base):
    __tablename__ = "umkm"

    id_umkm = Column(Integer, primary_key=True, index=True, autoincrement=True)
    foto_profil = Column(String)
    nama_umkm = Column(String)
    jenis_usaha = Column(String)
    rating = Column(Float)
    alamat_usaha = Column(Text)
    telp = Column(String)
    deskripsi_umkm = Column(Text)
    limit_pinjaman = Column(Numeric(precision=15, scale=2))
    omzet = Column(Numeric(precision=15, scale=2))  # per tahun
    id_dompet = Column(Integer, ForeignKey("dompet.id_dompet"))
    id_akun = Column(Integer, ForeignKey("akun.id_akun"))
    email = Column(String)
    nama_pemilik = Column(String)

    dompet = relationship("Dompet", back_populates="umkm", cascade="all")
    akun = relationship("Akun", back_populates="umkm", cascade="all")
    pendanaan = relationship("Pendanaan", back_populates="umkm")
    umkm_notifikasi = relationship("UmkmNotifikasi", back_populates="umkm", cascade="all")

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

    umkm = relationship("Umkm", back_populates="pendanaan")
    pendana = relationship("Pendana", secondary="pendanaan_pendana", back_populates="pendanaan")

class RiwayatTransaksi(Base):
    __tablename__ = "riwayat_transaksi"

    id_riwayat_transaksi = Column(Integer, primary_key=True, index=True, autoincrement=True)
    id_dompet = Column(Integer, ForeignKey("dompet.id_dompet"))
    jenis_transaksi = Column(String)
    nominal = Column(Numeric(precision=15,scale=2))
    tanggal = Column(DateTime)
    keterangan = Column(String)

    dompet = relationship("Dompet", back_populates="riwayat_transaksi", cascade="all")

# class Notifikasi(Base):
#     __tablename__ = "notifikasi"

#     id_notifikasi = Column(Integer, primary_key=True, index=True, autoincrement=True)
#     judul_notifikasi = Column(String)
#     isi_notifikasi = Column(Text)
#     waktu_tanggal = Column(DateTime)
#     is_terbaca = Column(Boolean, default=False)

#     umkm = relationship("Umkm", secondary="umkm_notifikasi", back_populates="notifikasi")
#     pendana = relationship("Pendana", secondary="pendana_notifikasi", back_populates="notifikasi")

class Pendana(Base):
    __tablename__ = "pendana"

    id_pendana = Column(Integer, primary_key=True, index=True, autoincrement=True)
    foto_profil = Column(String, unique=True)
    nama_pendana = Column(String)
    id_dompet = Column(Integer, ForeignKey("dompet.id_dompet"))
    id_akun = Column(Integer, ForeignKey("akun.id_akun"))
    alamat = Column(String)
    telp = Column(String)
    email = Column(String)

    dompet = relationship("Dompet", back_populates="pendana", cascade="all")
    akun = relationship("Akun", back_populates="pendana", cascade="all")
    pendanaan = relationship("Pendanaan", secondary="pendanaan_pendana", back_populates="pendana")
    pendana_notifikasi = relationship("PendanaNotifikasi", back_populates="pendana", cascade="all")

# table one to many Umkm - Notifikasi
class UmkmNotifikasi(Base):
    __tablename__ = "umkm_notifikasi"

    id_umkm_notifikasi = Column(Integer, primary_key=True, index=True, autoincrement=True)
    id_umkm = Column(Integer, ForeignKey("umkm.id_umkm"))
    # id_notifikasi = Column(Integer, ForeignKey("notifikasi.id_notifikasi"))
    judul_notifikasi = Column(String)
    isi_notifikasi = Column(Text)
    waktu_tanggal = Column(DateTime)
    is_terbaca = Column(Boolean, default=False)

    umkm = relationship("Umkm", back_populates="umkm_notifikasi")

# table one to many Pendana - Notifikasi
class PendanaNotifikasi(Base):
    __tablename__ = "pendana_notifikasi"

    id_pendana_notifikasi = Column(Integer, primary_key=True, index=True, autoincrement=True)
    id_pendana = Column(Integer, ForeignKey("pendana.id_pendana"))
    # id_notifikasi = Column(Integer, ForeignKey("notifikasi.id_notifikasi"))
    judul_notifikasi = Column(String)
    isi_notifikasi = Column(Text)
    waktu_tanggal = Column(DateTime)
    is_terbaca = Column(Boolean, default=False)

    pendana = relationship("Pendana", back_populates="pendana_notifikasi")
    

# # table many to many RiwayatTransaksi - Dompet
# class DompetRiwayatTransaksi(Base):
#     __tablename__ = "dompet_riwayat_transaksi"

#     id_dompet_riwayat_transaksi = Column(Integer, primary_key=True, autoincrement=True)
#     id_riwayat_transaksi = Column(Integer,ForeignKey("RiwayatTransaksi.id_riwayat_transaksi"))
#     id_dompet = Column(Integer, ForeignKey("Dompet.id_dompet"))

# table many to many Pendanaan - Pendana
class PendanaanPendana(Base):
    __tablename__ = "pendanaan_pendana"
    
    id_pendanaan_pendana = Column(Integer, primary_key=True,autoincrement=True)
    id_pendanaan = Column(Integer, ForeignKey("pendanaan.id_pendanaan"))
    id_pendana = Column(Integer, ForeignKey("pendana.id_pendana"))
    jumlah_danai = Column(Numeric(precision=15,scale=2))
    tanggal_danai = Column(DateTime)
    
    # pendanaan = relationship("Pendanaan", back_populates="pendanaan_pendana")
    # pendana = relationship("Pendana", back_populates="pendanaan_pendana")

# pendanaan_pendana = Table(
#     "pendanaan_pendana",
#     Base.metadata,
#     Column("id_pendanaan", Integer, ForeignKey("pendanaan.id_pendanaan"), primary_key=True),
#     Column("id_pendana", Integer, ForeignKey("pendana.id_pendana"), primary_key=True)
# )