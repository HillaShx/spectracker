from fastapi.testclient import TestClient
from main import app

client = TestClient(app)


# def test_get_users():
#     response = client.get("/users")
#     assert response.status_code == 200
# TODO: fix code


def test_get_user_success(existing_id):
    response = client.get(f"/users/{existing_id}")
    assert response.status_code == 200


def test_get_user_fail(non_existing_id):
    response = client.get(f"/user/{non_existing_id}")
    assert response.status_code == 404
