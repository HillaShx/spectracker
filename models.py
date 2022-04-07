from pydantic import BaseModel


class UserBase(BaseModel):
    id: int
    fullName: str
    email: str
    role: str


class User(UserBase):
    pass

    class Config:
        orm_mode = True
