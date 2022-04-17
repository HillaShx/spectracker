from typing import List

from fastapi import APIRouter, HTTPException
from fastapi import Depends
from sqlalchemy.orm import Session

import schemas
from routers import get_db
from services import users as user_service
from utils.exceptions import OperationFailed

router = APIRouter(
    prefix="/users",
    tags=["users"],
    dependencies=[],
    responses={404: {"description": "Not found"}},
)


@router.get("", response_model=List[schemas.User])
async def get_users(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    users = user_service.get_users(db, skip=skip, limit=limit)
    return users


@router.get("/{user_id}")
async def get_user(user_id: int, db: Session = Depends(get_db)):
    user = user_service.get_user_by_id(db, user_id)
    if user is None:
        raise HTTPException(404)
    return user


@router.post("")
async def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    user_service.create_user(db, user)
    # except OperationFailed:
    #     raise HTTPException(500)
