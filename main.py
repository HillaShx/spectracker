from typing import List

from dotenv import load_dotenv
from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session

import models
from database import SessionLocal
from services import user as user_service

load_dotenv()

app = FastAPI()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@app.get("/users", response_model=List[models.User])
def read_users(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    users = user_service.get_users(db, skip=skip, limit=limit)
    return users


# if __name__ == "__main__":
#     uvicorn.run("spectracker-api:asgi", host="127.0.0.1", port=8000, log_level="info", reload=True)

