from typing import Optional, List

from sqlalchemy.orm import Session

import schemas


def get_user_by_id(db: Session, user_id: int) -> Optional[schemas.User]:
    return db.query(schemas.User).filter(schemas.User.id == user_id).first()


def get_users(db: Session, skip: int = 0, limit: int = 100) -> List[schemas.User]:
    return db.query(schemas.User).offset(skip).limit(limit).all()
