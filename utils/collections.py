from typing import Union


def is_empty(c: Union[list, dict, tuple]) -> bool:
    return len(c) == 0
