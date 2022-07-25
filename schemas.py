from datetime import datetime

from pydantic import BaseModel

from utils.strings import to_lower_camel


# pydantic models
class UserBase(BaseModel):
    full_name: str
    email: str
    role: str = "therapist"

    class Config:
        alias_generator = to_lower_camel
        allow_population_by_field_name = True
        use_enum_values = True
        orm_mode = True


class User(UserBase):
    id: int


class UserCreate(UserBase):
    created_at = datetime.now()
    updated_at = datetime.now()


class PatientBase(BaseModel):
    full_name: str
    birth_date: str

    class Config:
        alias_generator = to_lower_camel
        allow_population_by_field_name = True
        orm_mode = True


class Patient(PatientBase):
    id: int
