import pytest
from fastapi.testclient import TestClient

from main import app
from services.users import get_users, get_user_by_id
from tests.models import UserFactory

client = TestClient(app)


@pytest.mark.parametrize("function_mock", [(get_users, UserFactory.batch(3))], indirect=["function_mock"])
def test_get_users(monkeypatch, function_mock):
    monkeypatch.setattr("services.users.get_users", function_mock)
    response = client.get("/users")
    assert response.status_code == 200


@pytest.mark.parametrize("function_mock", [(get_user_by_id, UserFactory.build())], indirect=["function_mock"])
def test_get_user_success(monkeypatch, function_mock, existing_id):
    monkeypatch.setattr("services.users.get_user_by_id", function_mock)
    response = client.get(f"/users/{existing_id}")
    assert response.status_code == 200


@pytest.mark.parametrize("function_mock", [(get_user_by_id, None)], indirect=["function_mock"])
def test_get_user_fail(monkeypatch, function_mock, non_existing_id):
    monkeypatch.setattr("services.users.get_user_by_id", function_mock)
    response = client.get(f"/users/{non_existing_id}")
    assert response.status_code == 404
