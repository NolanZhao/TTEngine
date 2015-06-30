__author__ = 'rzrk001'
#encoding:utf-8
from net.RPCClient import RPCClient, request
if __name__ == "__main__":
    strPath = r'd:\Xtservice.dat'
    param = {
        "strPath": strPath
    }
    try:

        ret = request(u"192.168.1.150:5379", u"addDgbmFile", param )
    except Exception, ex:
        print ex
        ret = ""

    strDb = 'Xtservice'
    param = {
        "strDb": strDb
    }
    try:

        ret = request(u"192.168.1.150:5379", u"getAllKeys", param )
    except Exception, ex:
        print ex
        ret = ""
    strDb = 'Xtservice'
    key = 'key1'
    param = {
        "strDb": strDb ,
        "strKey" : key
    }
    try:

        ret = request(u"192.168.1.150:5379", u"readData", param )
    except Exception, ex:
        print ex
        ret = ""
    print ret
