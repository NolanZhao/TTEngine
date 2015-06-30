#coding=utf-8
__author__ = 'Administrator'


def joinStr(str1, str2, splitStr = u", "):
    ret = u"" + str1
    if len(str2) > 0:
        if len(ret) > 0:
            ret += splitStr
        ret += str2
    return ret

def offsetLines(str, offset):
    lines = str.splitlines()
    ret = u"\n".join([ u" " * offset + line for line in lines])
    return ret

def replace(raw, old, new):
    oldLines = [line for line in raw.splitlines() if line.strip() == old ]
    if len(new.splitlines()) <= 1 :
        raw = raw.replace(old, new)
    else:
        for line in oldLines:
            offset = line.find(old)
            now = offsetLines(new, offset)
            raw = raw.replace(line, now)
    return raw