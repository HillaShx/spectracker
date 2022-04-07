from sqlalchemy import Column, Integer, String, Enum

from .database import Base


class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    fullName = Column(String, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    role = Column(Enum("admin", "case_manager", "therapist", "parent"), default="therapist")

