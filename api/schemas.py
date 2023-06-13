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
class GetSaldo(BaseModel):
    id_akun: int
    jenis_user: int = Field(ge=1, le=2) # 1 = UMKM | 2 = pendana
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

# Minta list UMKM
# - ngasih yang statusnya 1
# - urut berdasarkan yang dl_penggalangan_dana paling awal
""" 
return: list UMKM
tiap UMKM:
- nama_umkm
- jenis_umkm
- kode_pendanaan
- total_pendanaan
- dana_masuk
- persen_progres
- imba_hasil
- dl_penggalangan_dana
"""
class ListMarketplace(BaseModel): # Request
    nama_umkm: Optional[str] # kalau isi berarti pake filter
    # jenis_umkm: Optional[str]

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
class ListPortofolio(BaseModel):
    # id_pendana: int
    id_akun: int
    jenis_user: int = Field(ge=1, le=2) # 1 = UMKM | 2 = pendana
# Detail Portofolio / Detail Pendanaan
""" 
return:
- nama_pemilik
- nama_umkm
- jenis_usaha
- telp
- deskripsi_umkm

- kode_pendanaan
- pendanaan_ke
- status_pendanaan
- total_pendanaan
- dana_masuk
- persen_progres
- imba_hasil
- minimal_pendanaan
- dl_penggalangan_dana
- dl_bagi_hasil
- deskripsi_pendanaan
- tanggal_pengajuan
- tanggal_selesai

- is_telat (true/false/null) (tanggal_selesai > dl_bagi_hasil)
- bunga (total_pendanaan * imba_hasil)
- total_bagi_hasil (total_pendanaan + total_pendanaan * imba_hasil)
- durasi_pendanaan ()

- jumlah_danai
- tanggal_danai #tanggal pendanaan yang terakhir
"""
class DetailPendanaan(BaseModel):
    id_pendanaan: int
    # id_pendana: int # yang ngeklik siapa
    id_akun: int
    jenis_user: int = Field(ge=1, le=2) # 1 = UMKM | 2 = pendana
# Profil
"""
return:
message
"""
class EditProfilPendana(BaseModel):
    foto_profil: str
    nama_pendana: str
    email: str
    telp: str
    alamat: str
    username: str
    password: str

""" UMKM """

# Beranda

# Usahaku
""" 
return:
- nama_umkm
- jenis_umkm
- total_pinjaman
- total_pengeluaran
- limit_pinjaman
- pendanaan: [
{
 - kode_pendanaan
 - tanggal_pengajuan
 - deskripsi_pendanaan
 - status_pendanaan
 - total_bayar (total_pendanaan + total_pendanaan * imba_hasil)
 - persen_progres
 - dana_masuk
 - dl_penggalangan_dana
 - tanggal_pengajuan
 - tanggal_selesai (kalau null berati blm selesai)
},
{},
{}
]
"""
class Usahaku(BaseModel):
    id_umkm: int
# Lihat Pendana
""" 
return:
[
    {
        nama_pendana
        jumlah_danai
        tanggal_danai
    },
    {}
]
"""
class ListPendana(BaseModel):
    id_pendanaan: int
# Bayar Tagihan

# Profil
