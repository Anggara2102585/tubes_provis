from typing import List, Optional
from pydantic import BaseModel, Field
from datetime import datetime

#base = untuk jadi basis apa aja yang user masukan
#


class DompetBase(BaseModel):
    saldo: Optional[float] = 0.0


class DompetCreate(DompetBase):
    pass


class Dompet(DompetBase):
    id_dompet: int

    class Config:
        orm_mode = True


class UmkmBase(BaseModel):
    foto_profil: str
    nama_umkm: str
    jenis_usaha: str
    rating: float
    alamat_usaha: str
    telp: str
    deskripsi_umkm: str
    limit_pinjaman: float
    omzet: float


class UmkmCreate(UmkmBase):
    pass


class Umkm(UmkmBase):
    id_umkm: int
    dompet: Dompet
    pendanaan: List[Pendanaan] = []
    notifikasi: List[Notifikasi] = []

    class Config:
        orm_mode = True


class PendanaanBase(BaseModel):
    kode_pendanaan: str
    pendanaan_ke: int
    status_pendanaan: int
    total_pendanaan: float
    dana_masuk: float = Field(0.0)
    imba_hasil: int
    minimal_pendanaan: float
    dl_penggalangan: datetime.datetime                  #set sehingga input harus lebih dari hari ini
    dl_bagi_hasil: datetime.datetime                    #set sehingga input harus lebih dari hari ini
    deskripsi_pendanaan: str
    tanggal_pengajuan: datetime.datetime                #set sehingga input harus lebih dari hari ini
    # tanggal_selesai: Optional[datetime.datetime]


class PendanaanCreate(PendanaanBase):
    pass


class Pendanaan(PendanaanBase):
    id_pendanaan: int
    # kode_pendanaan: str
    # pendanaan_ke: int
    # status_pendanaan: int
    # dana_masuk: float
    # tanggal_pengajuan: datetime.datetime
    # tanggal_selesai: Optional[datetime.datetime]
    umkm: Umkm
    pendana: List[Pendana] = []

    class Config:
        orm_mode = True


class RiwayatTransaksiBase(BaseModel):
    id_dompet: int
    jenis_transaksi: str
    nominal: float
    tanggal: datetime.datetime
    keterangan: Optional[str] = Field("-")


class RiwayatTransaksiCreate(RiwayatTransaksiBase):
    pass


class RiwayatTransaksi(RiwayatTransaksiBase):
    id_riwayat_transaksi: int
    # dompet: Dompet

    class Config:
        orm_mode = True


class NotifikasiBase(BaseModel):
    judul_notifikasi: str
    isi_notifikasi: Optional[str] = Field("-")
    waktu_tanggal: datetime.datetime
    is_terbaca: Optional[bool] = Field(False)


class NotifikasiCreate(NotifikasiBase):
    pass


class Notifikasi(NotifikasiBase):
    id_notifikasi: int
    # umkm: List[Umkm] = []
    # pendana: List[Pendana] = []

    class Config:
        orm_mode = True


class PendanaBase(BaseModel):
    foto_profil: str
    nama_pendana: str
    id_dompet: int


class PendanaCreate(PendanaBase):
    pass


class Pendana(PendanaBase):
    id_pendana: int
    dompet: Dompet
    pendanaan: List[Pendanaan] = []
    notifikasi: List[Notifikasi] = []

    class Config:
        orm_mode = True


class UmkmNotifikasi(BaseModel):
    id_umkm_notifikasi: int
    id_umkm: int
    id_notifikasi: int


class PendanaNotifikasi(BaseModel):
    id_pendana_notifikasi: int
    id_pendana: int
    id_notifikasi: int


class DompetRiwayatTransaksi(BaseModel):
    id_dompet_riwayat_transaksi: int
    id_riwayat_transaksi: int
    id_dompet: int


class PendanaanPendana(BaseModel):
    id_pendanaan_pendana: int
    id_pendanaan: int
    id_pendana: int


# class UmkmCreateUpdate(BaseModel):
#     umkm: UmkmCreate
#     dompet: DompetCreate


# class PendanaCreateUpdate(BaseModel):
#     pendana: PendanaCreate
#     dompet: DompetCreate