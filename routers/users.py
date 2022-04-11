from typing import List

from fastapi import APIRouter
from fastapi import Depends
from sqlalchemy.orm import Session

import models
from routers import get_db
from services import users as user_service

router = APIRouter(
    prefix="/users",
    tags=["users"],
    dependencies=[],
    responses={404: {"description": "Not found"}},
)


@router.get("", response_model=List[models.User])
def get_users(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    users = user_service.get_users(db, skip=skip, limit=limit)
    return users
