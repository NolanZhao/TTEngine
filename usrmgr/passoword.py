# encoding=utf-8
import hashlib


def generate_password(password):
    _sha1 = hashlib.sha1()
    _sha1.update(password)
    return _sha1.hexdigest()


if __name__ == "__main__":
    print generate_password("123")