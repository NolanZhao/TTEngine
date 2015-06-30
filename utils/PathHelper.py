#coding=utf8
__author__ = 'xj'
from utils.OsHelper import isWindows
import os

def getConfigDir(os):
        return "server/config/"

def getMonitorDir(os):
    return "server/monitor/"

def getLocalDir(os):
    return "server/config_local/"

def getLicensePath(os, xtDir):
    if isWindows(os):
        return "bin/license.data"
    else:
        return "server/bin/license.data"

def getTempDir():
    dir = "../temp/"
    if not os.path.exists(dir):
        os.makedirs(dir)
    return dir

def getTarPath(rawPath):
    if rawPath.find(":") != -1:
        return rawPath.replace(":", "")
    else:
        if rawPath.startswith("/"):
            return rawPath[1:]
        else:
            return rawPath

def getRealPathFromTar(rawPath, os):
    if isWindows(os):
        if len(rawPath) > 2:
            if rawPath[1] == "/" :
                return rawPath[0] + ":" + rawPath[1:]
            else:
                return rawPath
        else:
            return rawPath
    else:
        if rawPath.startswith("/"):
            return rawPath
        else:
            return "/" + rawPath


