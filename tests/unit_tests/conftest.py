import pytest

from database import SessionLocal


@pytest.fixture
def db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
