#coding=utf8
__author__ = 'xujun'
from os import name
from types import IntType

OS_TYPE_LINUX = 1
OS_TYPE_WINDOWNS = 2
OS_TYPES= {
    OS_TYPE_LINUX: 'LINUX',
    OS_TYPE_WINDOWNS: 'WINDOWS'
}

# 测试本机是否是windows
def isThisWindows():
    strOs = name
    if strOs.startswith("nt"):
        return True
    else:
        return False

# 测试目标机是否是windows
def isWindows(os):
    if isinstance(os, IntType):
        if os == OS_TYPE_LINUX:
            return False
        else:
            return True
    else:
        strOs = os.lower()
        if strOs.startswith("win"):
            return True
        else:
            return False
