from sqlalchemy import Column, Integer, String, Enum, Date, Table, ForeignKey
from sqlalchemy.orm import relationship, backref

from database import Base


# SQLAlchemy models
user_patient_relation = Table(
    'user_patient', Base.metadata,
    Column('userId', Integer, ForeignKey('users.id')),
    Column('patientId', Integer, ForeignKey('patients.id'))
)


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
    users = relationship(
        'User', secondary=user_patient_relation, backref=backref('patients', lazy='immediate')
    )
