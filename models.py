from sqlalchemy import Column, Integer, String, Enum, Date

from database import Base


# SQLAlchemy models
class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    full_name = Column(String, name="fullName", nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    role = Column(Enum("admin", "case_manager", "therapist", "parent"), default="therapist")
    created_at = Column(Date, name="createdAt")
    updated_at = Column(Date, name="updatedAt")


class Patient(Base):
    __tablename__ = "patients"
    id = Column(Integer, primary_key=True, index=True)
    full_name = Column(String, name="fullName", nullable=False)
    birth_date = Column(Date, name="birthDate")
    created_at = Column(Date, name="createdAt")
    updated_at = Column(Date, name="updatedAt")
