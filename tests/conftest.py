import pytest

from tests import TestingSessionLocal


@pytest.fixture
def db():
    db = TestingSessionLocal()
    try:
        yield db
    finally:
        db.close()


@pytest.fixture
def existing_id():
    return 1


@pytest.fixture
def non_existing_id():
    return 738974
