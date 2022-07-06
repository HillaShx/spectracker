import re


def to_lower_camel(s) -> str:
    camel_version = ''.join(word.capitalize() for word in s.split('_'))
    return camel_version[0].lower() + camel_version[1:]


def to_snake(s: str) -> str:
    return re.sub('([A-Z]+)', r'_\1', s).lower()
