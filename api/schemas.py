from datetime import datetime
from decimal import Decimal
from typing import List, Optional
from pydantic import BaseModel, Field

""" AUTHHENTICATION """

# return: message [berhasil|gagal]
class BaseRegister(BaseModel):
    nama: str
    username: str
    password: str
    foto_ktp: str
    foto_selfie: str
class RegisterPendanaRequest(BaseRegister):
    pass
class RegisterUMKMRequest(BaseRegister):
    nama_umkm: str
    jenis_usaha: str
    deskripsi_umkm: str
    telp: str
    alamat_usaha: str
    omzet: Decimal

""" 
return:
kalau gagal: message
"""
class Login(BaseModel):
    username: str
    password: str
class ResponseLoginSuccess(BaseModel):
    id_akun: int
    jenis_user: int = Field(ge=1, le=2) # 1 = UMKM


""" PENDANA """

# Beranda
# Beranda Pendana
class ListUMKMBerandaPendana(BaseModel):
    nama_umkm: str
    sisa_pokok: Decimal # total_danai + total_danai*imba_hasil
class BerandaPendana(BaseModel): # Request
    id_akun: int
class ResponseBerandaPendana(BaseModel): # Response
    nama_pendana: str
    saldo: Decimal
    total_pendanaan: Decimal # total jumlah_danai - (total pendanaan gagal yang dia danai)
    total_bagi_hasil: Decimal # total riwayat_transaksi jenis 2
    jumlah_didanai_aktif: int
    umkm: List[ListUMKMBerandaPendana]

# Notifikasi
class ListNotifikasi(BaseModel): # Request
    id_akun: int
    jenis_user: int = Field(ge=1, le=2) # 1 = UMKM | 2 = pendana
class Notifikasi(BaseModel):
    judul_notifikasi: str
    is_terbaca: bool
    waktu_tanggal: datetime
    isi_notifikasi: str
class ResponseListNotifikasi(BaseModel): # Response
    notifikasi: List[Notifikasi]

# Top Up (nambah saldo + notifikasi)
"""
return: message (pasti berhasil)
notif:
- judul: Top Up berhasil atau gagal ... (pasti berhasil)
- isi_notifikasi: nunggu Khana
"""
class TopUp(BaseModel): # Request
    nominal: Decimal
    id_akun: int
    jenis_user: int = Field(ge=1, le=2) # 1 = UMKM | 2 = pendana

# Tarik Dana
""" return:
saldo
"""
class GetSaldo(BaseModel): # Request
    id_akun: int
    jenis_user: int = Field(ge=1, le=2) # 1 = UMKM | 2 = pendana
class Saldo(BaseModel): # Response
    saldo: Decimal
"""
(ngurangin saldo + notifikasi)
return: message [gagal/berhasil]
notif:
- judul: Tarik Dana Berhasil / Gagal (bisa gagal kalau saldo tidak mencukupi)
- isi_notifikasi: "Dana sebesar Rp.$nominal berhasil ditarik dari dompet!"
"""
class TarikDana(BaseModel):
    nominal: Decimal
    id_akun: int
    jenis_user: int = Field(ge=1, le=2) # 1 = UMKM | 2 = pendana

# Marketplace

# Minta list Pendanaan
# - ngasih yang statusnya 1
# - urut berdasarkan yang dl_penggalangan_dana paling awal (gak jadi)
""" 
return: list Pendanaan
"""
class ListMarketplace(BaseModel): # Request
    pass
    # list view bisa search n filter
    
    # nama_umkm: Optional[str] # kalau isi berarti pake filter
    # jenis_umkm: Optional[str]
class CardMarketplace(BaseModel): # Response
    nama_umkm: str
    jenis_usaha: str
    kode_pendanaan: str
    total_pendanaan: Decimal
    dana_masuk: Decimal
    persen_progres: int = Field(ge=0, le=100)
    imba_hasil: int = Field(ge=0, le=100)
    dl_penggalangan_dana: datetime
class ResponseListMarketplace(BaseModel):
    pendanaan: List[CardMarketplace]
# Mendanai
class Mendanai(BaseModel): # Request
    id_akun: int
    nominal: Decimal
    id_pendanaan: int
class ResponseMendanai(BaseModel): # Response
    id_pendanaan_pendana: int
    id_dompet: int
    saldo_dompet: Decimal

# Portofolio

# List Portofolio
""" 
Tiap card:
- nama_umkm
- kode_pendanaan
- jumlah_danai
- tanggal_danai
- status (belum selsai = status (1,2,3))
"""
class ListPortofolio(BaseModel): # Request
    id_akun: int
class CardPortofolio(BaseModel):
    nama_umkm: str
    kode_pendanaan: str
    status_pendanaan: int
    jumlah_danai: int
    tanggal_danai: datetime
class ResponseListPortofolio(BaseModel): # Response
    pendanaan: List[CardPortofolio]
# Detail Portofolio / Detail Pendanaan
class DetailPendanaan(BaseModel): # Request
    id_pendanaan: int
    id_akun: int
    jenis_user: int
class ResponseDetailPendanaan(BaseModel): # Response
    nama_pemilik: str
    nama_umkm: str
    jenis_usaha: str
    telp: str
    deskripsi_umkm: str
    kode_pendanaan: str
    pendanaan_ke: int
    status_pendanaan: int
    total_pendanaan: Decimal
    dana_masuk: Decimal
    persen_progres: int
    imba_hasil: int
    minimal_pendanaan: Decimal
    dl_pendanaan_dana: datetime
    dl_bagi_hasil: datetime
    deskripsi_pengajuan: str
    tanggal_pengajuan: datetime
    tanggal_selesai: Optional[datetime] = None
    is_telat: Optional[bool] = None
    bunga: Optional[float] = None
    total_bagi_hasil: Optional[float] = None
    jumlah_danai: Decimal
    tanggal_danai: datetime
# Profil
class ProfilPendana(BaseModel): # Request
    id_akun: int
class ResponseProfilPendana(BaseModel): # Response
    foto_profil: str
    nama_pendana: str
    email: str
    telp: str
    alamat: str
    username: str
    password: str
"""
return:
message (jika error)
schema ResponseProfilPendana (jika berhasil)
"""
class EditProfilPendana(BaseModel): # Request
    id_akun: int
    foto_profil: Optional[str] = None
    nama_pendana: Optional[str] = None
    email: Optional[str] = None
    telp: Optional[str] = None
    alamat: Optional[str] = None
    username: Optional[str] = None
    password: Optional[str] = None

""" UMKM """

# Beranda

# Usahaku
class Usahaku(BaseModel): # Request
    id_akun: int
class PendanaanUsahaku(BaseModel):
    kode_pendanaan: str
    deskripsi_pendanaan: str
    status_pendanaan: str
    dana_masuk: float
    dl_penggalangan_dana: str
    tanggal_pengajuan: datetime
    tanggal_selesai: Optional[datetime] = None # (kalau null berati blm selesai)
    total_bayar: float # (total_pendanaan + total_pendanaan * imba_hasil)
    persen_progres: int
class ResponseUsahaku(BaseModel): # Response
    nama_umkm: str
    jenis_usaha: str
    limit_pinjaman: float
    total_pinjaman: float
    total_pengeluaran: float
    pendanaan: List[PendanaanUsahaku]
# Lihat Pendana
class LihatPendana(BaseModel): # Request
    id_pendanaan: int
class DataPendana(BaseModel):
    nama_pendana: str
    jumlah_danai: Decimal
    tanggal_danai: datetime
class ResponseLihatPendana(BaseModel): # Response
    pendana: List[DataPendana]
# Mengajukan pendanaan
# return: text
class MengajukanPendanaan(BaseModel): # Request=============================================butuh notif
    id_akun: int
    deskripsi_pendanaan: str
    imba_hasil: int
    minimal_pendanaan: Decimal
    dl_penggalangan_dana: int # x hari dari sekarang
    # dl_bagi_hasil 1 bulan dari dl_penggalangan_dana
    total_pendanaan: Decimal # backend cek apakah lebih dari limit_pinjaman
class ResponseMengajukanPendanaan(BaseModel): # Response
    id_pendanaan: int
    id_umkm: int
    pendanaan_ke: int
    kode_pendanaan: str
    status_pendanaan: int
    total_pendanaan: Decimal
    dana_masuk: Decimal
    imba_hasil: int
    minimal_pendanaan: Decimal
    dl_penggalangan_dana: datetime
    dl_bagi_hasil: datetime
    deskripsi_pendanaan: str
    tanggal_pengajuan: datetime
    tanggal_selesai: Optional[datetime] = None
    
# Bayar Tagihan
class MelunasiRequest(BaseModel): # Request
    id_akun: int
    id_pendanaan: int
# class MelunasiData(BaseModel):
#     saldo_dompet: float
# class ResponseMelunasi(BaseModel): # Response
#     data: MelunasiData

# Profil
class ProfilUMKM(BaseModel): # Request
    id_akun: int
class ResponseProfilUMKM(BaseModel): # Response
    nama_pemilik: str
    email: str
    telp: str
    alamat_usaha: str
    username: str
    nama_umkm: str
    omzet: Decimal
    deskripsi_umkm: str
    jenis_usaha: str
"""
return:
message (jika error)
schema ResponseProfilUMKM (jika berhasil)
"""
class EditProfilUMKM(BaseModel): # Request
    id_akun: int
    nama_pemilik: Optional[str] = None
    email: Optional[str] = None
    telp: Optional[str] = None
    alamat_usaha: Optional[str] = None
    username: Optional[str] = None
    nama_umkm: Optional[str] = None
    omzet: Optional[Decimal] = None
    deskripsi_umkm: Optional[str] = None
    jenis_usaha: Optional[str] = None