from pydantic import BaseModel

from utils.strings import to_lower_camel


class UserBase(BaseModel):
    full_name: str
    email: str
    role: str

    class Config:
        alias_generator = to_lower_camel
        orm_mode = True


class User(UserBase):
    id: int


class UserCreate(UserBase):
    pass
