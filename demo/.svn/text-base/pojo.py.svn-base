#encoding=utf-8
__author__ = 'nerve'

import anydbm
import whichdb
import zlib


class KeyValueParam:
    """
    一条键值对数据
    """
    key = None
    value = None

    def __init__(self, key, value):
        self.key = key
        self.value = value

    def __str__(self):
        return 'key={key},value={value}'.format(key=self.key, value=self.value)


if __name__ == '__main__':
    path = 'D:/XtTradeData'
    print whichdb.whichdb(path)
    db = anydbm.open(path, 'c')
    pass