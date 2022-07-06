import pytest

import models
from schemas import User
from services.users import get_users, get_user_by_id, create_user
from tests.models import UserFactory
from utils.objects import object_comparison


@pytest.mark.parametrize("db_result", [UserFactory.batch(size=3), [UserFactory.build()]])
def test_get_users(db, db_result):
    db.query.return_value.offset.return_value.limit.return_value.all.return_value = db_result

    result = get_users(db)
    assert isinstance(result, list)
    assert isinstance(result[0], User)


@pytest.mark.parametrize("user_id, db_result", [(1, UserFactory.build()), (-1, None)])
def test_get_user_by_id(db, user_id, db_result):
    db.query.return_value.filter.return_value.first.return_value = db_result

    result = get_user_by_id(db, user_id)
    assert type(result) == type(db_result)


@pytest.mark.parametrize("user", [UserFactory.build()])
def test_create_user(db, user):
    create_user(db, user)
    user_model = models.User(**user.dict())
    user_for_db = db.add.call_args_list[0].args[0]
    assert object_comparison(user_model, user_for_db)
