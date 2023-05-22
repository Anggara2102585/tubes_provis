from typing import List, Optional
from pydantic import BaseModel, Field
from datetime import datetime


class RiwayatTransaksiBase(BaseModel):
    id_dompet: int
    jenis_transaksi: int = Field(ge=1, le=6)
    nominal: float
    tanggal: datetime
    keterangan: Optional[str] = Field("-")

class RiwayatTransaksiCreate(RiwayatTransaksiBase):
    pass

class RiwayatTransaksi(RiwayatTransaksiBase):
    id_riwayat_transaksi: int

    class Config:
        orm_mode = True


class DompetBase(BaseModel):
    saldo: Optional[float] = 0.0

class DompetCreate(DompetBase):
    pass

class Dompet(DompetBase):
    id_dompet: int
    riwayat_transaksi: List[RiwayatTransaksi] = []

    class Config:
        orm_mode = True


class NotifikasiBase(BaseModel):
    judul_notifikasi: str
    isi_notifikasi: Optional[str] = Field("-")
    # waktu_tanggal: datetime
    is_terbaca: Optional[bool] = Field(False)

# class NotifikasiCreate(NotifikasiBase):
#     pass

# class Notifikasi(NotifikasiBase):
#     id_notifikasi: int
#     waktu_tanggal: datetime
#     # umkm: List[Umkm] = []
#     # pendana: List[Pendana] = []

#     class Config:
#         orm_mode = True


class UmkmNotifikasiCreate(NotifikasiBase):
    list_id_umkm: Optional[List[int]]

class UmkmNotifikasi(NotifikasiBase):
    id_umkm_notifikasi: int
    id_umkm: int
    waktu_tanggal: datetime
#     # umkm: List[Umkm] = []

    class Config:
        orm_mode = True


class PendanaNotifikasiCreate(NotifikasiBase):
    list_id_pendana: Optional[List[int]]

class PendanaNotifikasi(NotifikasiBase):
    id_pendana_notifikasi: int
    id_pendana: int
    waktu_tanggal: datetime
#     # pendana: List[Pendana] = []

    class Config:
        orm_mode = True


class UmkmBase(BaseModel):
    foto_profil: str
    nama_umkm: str
    jenis_usaha: str
    # rating: float
    alamat_usaha: str
    telp: str
    deskripsi_umkm: str
    # limit_pinjaman: float
    omzet: float # per tahun

class UmkmCreate(UmkmBase):
    pass

class Umkm(UmkmBase):
    id_umkm: int
    rating: float
    limit_pinjaman: float
    id_dompet: int
    dompet: Dompet
    # pendanaan: List['Pendanaan'] = []
    umkm_notifikasi: List[UmkmNotifikasi] = []

    class Config:
        orm_mode = True


class PendanaBase(BaseModel):
    foto_profil: str                                    # Encoding di frontend atau backend?
    nama_pendana: str
    # id_dompet: int

class PendanaCreate(PendanaBase):
    pass

class Pendana(PendanaBase):
    id_pendana: int
    id_dompet: int
    dompet: Dompet
    # pendanaan: List[Pendanaan] = []
    pendana_notifikasi: List[PendanaNotifikasi] = []

    class Config:
        orm_mode = True


class PendanaanBase(BaseModel):
    id_umkm: int
    # kode_pendanaan: str
    # pendanaan_ke: int
    # status_pendanaan: int
    total_pendanaan: float
    # dana_masuk: float = Field(0.0)
    imba_hasil: int = Field(ge=0, le=100)
    minimal_pendanaan: float
    dl_penggalangan: datetime                  #set sehingga input harus lebih dari hari ini
    dl_bagi_hasil: datetime                    #set sehingga input harus lebih dari hari ini
    deskripsi_pendanaan: str
    # tanggal_pengajuan: datetime                #set sehingga input harus lebih dari hari ini
    # tanggal_selesai: Optional[datetime]

class PendanaanCreate(PendanaanBase):
    pass

class Pendanaan(PendanaanBase):
    id_pendanaan: int
    kode_pendanaan: str
    pendanaan_ke: int
    status_pendanaan: int
    dana_masuk: float
    tanggal_pengajuan: datetime
    tanggal_selesai: Optional[datetime]
    umkm: Umkm
    pendana: List[Pendana] = []

    class Config:
        orm_mode = True


# class DompetRiwayatTransaksi(BaseModel):
#     id_dompet_riwayat_transaksi: int
#     id_riwayat_transaksi: int
#     id_dompet: int


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