from pydantic_factories import ModelFactory

from schemas import User, UserCreate


class UserCreateFactory(ModelFactory):
    __model__ = UserCreate


class UserFactory(ModelFactory):
    __model__ = User
