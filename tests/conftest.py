from inspect import signature
from unittest.mock import MagicMock

import pytest
from makefun import with_signature


@pytest.fixture
def db():
    db = MagicMock()
    try:
        yield db
    finally:
        db.close()


@pytest.fixture
def function_mock(request):
    original_function, expected_output = request.param
    original_func_params = signature(original_function)

    @with_signature(original_func_params, func_name="func")
    def func(*args, **kwargs):
        return expected_output
    return func
