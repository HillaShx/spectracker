from pydantic import BaseModel

from utils import to_lower_camel


class UserBase(BaseModel):
    id: int
    full_name: str
    email: str
    role: str


class User(UserBase):
    pass

    class Config:
        alias_generator = to_lower_camel
        orm_mode = True
