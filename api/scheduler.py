from apscheduler.schedulers.background import BackgroundScheduler
from datetime import datetime
from sqlalchemy.orm import Session

import models

def check_pendanaan_status(db: Session):
    pendanaans = db.query(models.Pendanaan).filter(models.Pendanaan.status_pendanaan.in_([1, 2])).all()

    current_datetime = datetime.now()

    for pendanaan in pendanaans:
        if pendanaan.dl_penggalangan_dana < current_datetime and pendanaan.status_pendanaan == 1:
            pendanaan.status_pendanaan = 5
            pendanaan.tanggal_selesai = current_datetime
        elif pendanaan.dl_penggalangan_dana < current_datetime and pendanaan.status_pendanaan == 2:
            pendanaan.status_pendanaan = 3
            pendanaan.tanggal_selesai = current_datetime

    db.commit()

def start_scheduler(db: Session):
    scheduler = BackgroundScheduler()
    scheduler.add_job(check_pendanaan_status, 'interval', minutes=1, args=(db,))
    scheduler.start()