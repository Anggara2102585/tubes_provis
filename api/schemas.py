from pydantic import BaseModel

class RegisterPendanaRequest(BaseModel):
    nama: str
    username: str
    password: str
    foto_ktp: str
    foto_selfie: str
