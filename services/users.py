from sqlalchemy.orm import Session

import schemas


def get_user(db: Session, user_id: int):
    return db.query(schemas.User).filter(schemas.User.id == user_id).first()


def get_users(db: Session, skip: int = 0, limit: int = 100):
    return db.query(schemas.User).offset(skip).limit(limit).all()
