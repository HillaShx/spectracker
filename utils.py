def to_lower_camel(s):
    camel_version = ''.join(word.capitalize() for word in s.split('_'))
    return camel_version[0].lower() + camel_version[1:]
