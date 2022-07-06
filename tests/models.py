from pydantic_factories import ModelFactory

from schemas import User


class UserFactory(ModelFactory):
    __model__ = User
