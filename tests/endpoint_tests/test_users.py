import json

import pytest
from fastapi.testclient import TestClient

from main import app
from services.users import get_users, get_user_by_id, create_user
from tests import EXISTING_ID, NON_EXISTING_ID
from tests.models import UserFactory, UserCreateFactory

client = TestClient(app)


@pytest.mark.parametrize("function_mock", [(get_users, UserFactory.batch(3))], indirect=["function_mock"])
def test_get_users(monkeypatch, function_mock):
    monkeypatch.setattr("services.users.get_users", function_mock)
    response = client.get("/users")
    assert response.status_code == 200


@pytest.mark.parametrize("function_mock, user_id, expected_code", [
    ((get_user_by_id, UserFactory.build()), EXISTING_ID, 200),
    ((get_user_by_id, None), NON_EXISTING_ID, 404),
], indirect=["function_mock"])
def test_get_user(monkeypatch, function_mock, user_id, expected_code):
    monkeypatch.setattr("services.users.get_user_by_id", function_mock)
    response = client.get(f"/users/{user_id}")
    assert response.status_code == expected_code


@pytest.mark.parametrize("function_mock, user_id, expected_code", [
    ((get_user_by_id, UserFactory.build()), EXISTING_ID, 200),
    ((get_user_by_id, None), NON_EXISTING_ID, 404),
], indirect=["function_mock"])
def test_get_user_patients(monkeypatch, function_mock, user_id, expected_code):
    monkeypatch.setattr("services.users.get_user_by_id", function_mock)
    response = client.get(f"/users/{user_id}/patients")
    assert response.status_code == expected_code


@pytest.mark.parametrize("function_mock, user, expected_code", [
    ((create_user, None), UserCreateFactory.build(), 200),
    ((create_user, None), None, 422),
], indirect=["function_mock"])
def test_create_user(monkeypatch, function_mock, user, expected_code):
    monkeypatch.setattr("services.users.create_user", function_mock)
    user_data = user.dict(by_alias=True) if user is not None else user
    response = client.post("/users", data=json.dumps(user_data))
    assert response.status_code == expected_code
