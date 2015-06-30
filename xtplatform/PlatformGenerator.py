#coding=utf8
__author__ = 'xujun'

import pymongo
from types import IntType, StringTypes
from xtplatform.medels import Platform

def getPlatformByType(platforms, type, tag):
    lines = []
    for x in platforms:
        platformId =  x[0]
        platformType = x[1]
        platformObjs = Platform.objects(m_nId=platformId, m_nType =platformType)
        platform = None
        if len(platformObjs) > 0:
            platform = platformObjs[0]
        if platform is None:
            continue
        if platformType != type:
            continue
        items = []
        for k, v in platform.getData().iteritems():
            if isinstance(v, StringTypes):
                items.append(u'%s="%s"' % (k, v))
            elif isinstance(v, IntType):
                items.append(u'%s=%s' % (k, v))
        lines.append(u"    {%s}" % ",".join(items))
    str = u",\n".join(lines)
    ret = u"%s = {\n%s\n}" % (tag, str)
    return ret

def getPlatformIds(modules):
    platforms = []
    for x in modules:
        name = x.name
        if not name.startswith("BrokerModule_"):
            continue
        splited = name.split("_")
        if len(splited) != 4:
            continue
        platformType = int(splited[1])
        platformId =  int(splited[2])
        platforms.append([platformId, platformType])
    return platforms

def getPlatformStr(platformIds):
    platformType = {
        1: "g_future_platforms",
        2: "g_stock_platforms",
        3: "g_credit_platforms",
    }
    lines = []
    for k, v in platformType.iteritems():
        lines.append(getPlatformByType(platformIds, k, v))
    return "\n\n".join(lines)

def genPlatform(modules):
    platformIds = getPlatformIds(modules)
    return getPlatformStr(platformIds)

if __name__ == "__main__":
    mongoAddress = "192.168.1.187"
    conn = pymongo.Connection(host=mongoAddress)
    db = conn.ttengine
    collection = db.platform
    platformIds = [
        [20001, 1],
        [21001, 1],
        [11001, 2],
        [10001, 2],
    ]
    print getPlatformStr(collection, platformIds)
