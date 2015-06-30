#cofing=utf8
__author__ = 'xujun'
from types import DictType, StringTypes

def genMap(key, value, splitChar):
    itemData = {}
    items = key.split(splitChar)
    for index in xrange(len(items)):
        strItem = items[len(items) - index - 1].strip()
        if index == 0:
            if isinstance(value, StringTypes):
                itemData[strItem] = value.strip()
            else:
                itemData[strItem] = value
        else:
            raw = itemData
            itemData = {}
            itemData[strItem] = raw
    return itemData


def mapMerge(m1, m2):
    for k,v in m2.iteritems():
        if isinstance(v, DictType):
            if isinstance(m2[k], DictType):
                if m1.has_key(k) :
                    if isinstance(m1[k], DictType):
                        m1[k] = mapMerge(m1[k], m2[k])
                    else:
                        m1[k] = m2[k]
                else :
                    m1[k] = m2[k]
            else :
                m1[k] = v
        else:
            m1[k] = v
    return m1

if __name__ == "__main__":
    m1 = genMap("real/XtService&app&hello", 123, "&")
    m2 = genMap("real/XtService&app&test", "abc", "&")
    m3 = genMap("trader&app&test", "abc", "&")
    m = mapMerge(m1, m2)
    m = mapMerge(m, m3)
    print m


