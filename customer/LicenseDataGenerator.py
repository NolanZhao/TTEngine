#coding=utf8
__author__ = 'xujun'
from utils.MapHelper import genMap, mapMerge
import json
from types import BooleanType, StringTypes
# datas

class LicenseDataGenerator(object):
    def __init__(self, config, minfo):
        self.config = config
        self.minfo = minfo

    def gen(self):
        lines = []
        dMap = {}
        for key, value in self.config.iteritems():
            if  key.find("/") == -1:
                lines.append("%s=%s" % (key, value))
            else:
                m = genMap(key, value, "/")
                dMap = mapMerge(dMap, m)
        for key, value in dMap.iteritems():
            lines.append("%s=%s" % (key, json.dumps(value)))
        lines.append("minfo=%s" %self.minfo)
        str = ";".join(lines)
        return str
