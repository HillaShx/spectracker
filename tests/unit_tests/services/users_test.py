from schemas import User
from services.users import get_users
from utils.collections import is_empty


def test_get_users(db):
    result = get_users(db)
    assert isinstance(result, list)
    if not is_empty(result):
        assert isinstance(result[0], User)
