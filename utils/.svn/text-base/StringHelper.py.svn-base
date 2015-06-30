#coding=utf8
__author__ = 'xujun'
from re import sub


def replaceStr(raw, paramMap):
    ret = raw
    for key, value in paramMap.iteritems():
        strReg = "{{\s*%s+\s*}}" % key
        ret = sub(strReg, value, ret)
    return ret


if __name__ == "__main__":
    d = {"xtDir": "/homr/rzrk"}
    print replaceStr("", d)