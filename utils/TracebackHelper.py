#coding=utf8
__author__ = 'xujun'
from StringIO import StringIO
from traceback import print_exc


def getTraceBack():
    f = StringIO()
    print_exc(file=f)
    return f.getvalue()
