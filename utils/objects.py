def object_comparison(object1, object2) -> bool:
    if type(object1) != type(object2):
        return False
    object_attributes = [attr for attr in dir(object1) if not attr.startswith("_")]
    for attribute in object_attributes:
        attribute1 = object1.__getattribute__(attribute)
        attribute2 = object2.__getattribute__(attribute)
        if attribute1 != attribute2:
            return False
    return True
