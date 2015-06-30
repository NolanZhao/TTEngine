#coding=utf8
__author__ = 'xj'
from StringIO import StringIO
from tarfile import TarInfo
from time import time
from utils.PathHelper import getTempDir
import os

def addfilefromstring(tar, name, theString):
    savePath = getTempDir() + os.path.basename(name)
    f = open(savePath, "w")
    f.write(theString)
    f.close()
    addfile(tar, name, savePath)
    """
    d = theString
    content = StringIO(d)
    theFileInfo = TarInfo(name=name)
    theFileInfo.mtime = int(time())
    theFileInfo.size = len(d)
    tar.addfile(theFileInfo, fileobj=content)
    """

def addfile(tar, name, path):
    tar.add(path, name)

if __name__ == "__main__":
    import tarfile
    f = open("test.tar.gz", "wb")
    tar = tarfile.open(fileobj=f, mode="w:gz")
    tar.add("/home/rzrk/server/bin/XtService", "XtService")
    #addfile(tar, "server/bin/XtService", "/home/rzrk/server/bin/XtService")
    #addfile(tar, "server/bin/XtTraderService", "/home/rzrk/server/bin/XtTraderService")
    #addfile(tar, "server/bin/XtRiskControl", "/home/rzrk/server/bin/XtRiskControl")
    tar.close()
    f.close()
    
    f = open("test.tar.gz", "rb")
    tar = tarfile.open(fileobj=f, mode="r:gz")
    tar.extractall()
    tar.close()
