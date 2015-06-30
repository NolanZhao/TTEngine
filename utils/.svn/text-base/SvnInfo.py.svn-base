#coding=utf8
__author__ = 'xujun'

import pysvn
import sys
import hashlib
import json
import os
import time
from utils.OsHelper import isThisWindows

class SvnInfo(object):
    def __init__(self, path):
        self.client = pysvn.Client()
        self.svnInfo = self._getSvnInfo(path)

    def getSvnInfo(self):
        return self.svnInfo

    def getRevisionNumber(self, path):
        info = self.client.info2(path, recurse=False)
        return info[0][1]['rev'].number

    def getRevisionPath(self, localPath):
        url = ""
        try:
            info = self.client.info2(localPath, recurse=False)
            url = info[0][1]['URL']
        except:
            pass
        return url


    def extract(self, path, str):
        externals = []
        lines = str.splitlines()
        for line in lines:
            items = line.split()
            external = path + "/" + items[1]
            externals.append(external)
        return externals

    def getExternal(self, dir):
        ret = []
        list = []
        try:
            externals = self.client.propget('svn:externals', dir, recurse=True)
            for key, value in externals.iteritems():
                ret.extend(self.extract(key, value))
        except:
            pass
        return ret

    def extract(self, path, str):
        externals = []
        lines = str.splitlines()
        for line in lines:
            items = line.split()
            external = path + "/" + items[1]
            externals.append(external)
        return externals

    def _getSvnInfo(self, path):
        ret = ""
        url = self.getRevisionPath(path)
        if len(url) > 0:
            try :
                ret = url + ":" + str(self.getRevisionNumber(path))
            except:
                ret = url + ":unknown"
        else:
            if isThisWindows():
                if path.find("_runtime/") != -1:
                    ret = self._getBinSvnInfo(path)
            else:
                if path.find("bin/realese") != -1:
                    ret = self._getBinSvnInfo(path)
        return ret

    def _getBinSvnInfo(self, path):
        path = path + "/../../../"
        print path
        path = os.path.abspath(path)
        externals = self.getExternal(path)
        externalInfos = []
        for external in externals:
            info = self.getRevisionPath(external) + ":" + str(self.getRevisionNumber(external))
            externalInfos.append(info)
        ret = json.dumps(externalInfos, indent=4)
        #return externalInfos
        return ret

def getSvnInfo(path):
    info = SvnInfo(path)
    return info.svnInfo

#print getSvnInfo("F:/server5/ttservice/trunk/libs/base")
#print getSvnInfo("F:/server5/ttservice/trunk/_runtime/Win32.Deploy_Release/persist.dll")
