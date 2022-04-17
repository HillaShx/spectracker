from models import User
from services.users import get_users, get_user_by_id


def test_get_users(db):
    result = get_users(db)
    assert isinstance(result, list)
    assert isinstance(result[0], User)


def test_get_user_full(db, existing_id):
    result = get_user_by_id(db, existing_id)
    assert isinstance(result, User)


def test_get_user_empty(db, non_existing_id):
    result = get_user_by_id(db, non_existing_id)
    assert result is None
