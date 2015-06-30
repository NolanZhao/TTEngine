#coding=utf8
from subprocess import Popen, PIPE

__author__ = 'xujun'
import pymongo
import json
import os
import hashlib
import shutil
import tarfile
import scripts.module.RunInfo
from bson.objectid import ObjectId
from bson import Binary
from utils.SvnInfo import *
from scripts.module.FileInfo import *
from scripts.module.Module import *
from scripts.module.RunInfo import *
import re
from utils.Common import *
from utils.StringHelper import replaceStr
from platform import system
from utils.OsHelper import *
from StringIO import StringIO
from utils.TarfileHelper import addfile, addfilefromstring
from datetime import datetime
from pysvn import Client

DB_HOST = "192.168.1.187"
class Compile(object):
    def __init__(self, address):
        self.conn = pymongo.Connection(host=address)
        self.db = self.conn.ttengine
        self.svnClient = Client()

    def update(self, machine, branches):
        for path in branches:
            self.svnClient.update(path)

    # 更新编译
    def updateCompile(self, recordId, machine, userId, branches):
        #self.update(machine, branches)

        # 先默认是在本机编译
        userInfo = self.db.user.find_one({"_id": ObjectId(userId)})
        if userInfo is None:
            data = {
                "end_time" :datetime.now(),
                "status" : 2,
                "remark" : "用户信息为空"
            }
            self.updateRecord(recordId, data)
            return

        if len(branches) == 0:
            data = {
                "end_time" :datetime.now(),
                "status" : 2,
                "remark" : "未选择代码分支"
            }
            self.updateRecord(recordId, data)
            return

        rawDir = os.curdir
        userName = userInfo["username"]
        for path in branches:
            # 运行编译脚本
            print "change dir", path
            os.chdir(path)
            print "make clean", path
            p = Popen(["make", "clean", "user=%s" % userName], stdin=PIPE, stdout=PIPE, stderr=PIPE)
            p.wait()
            print "make clean completed", path
            if recordId is not None:
                print "make -j8 all", path, recordId
            p = Popen(["make", "-j8", "all", "user=%s" % userName], stdin=PIPE, stdout=PIPE, stderr=PIPE)
            outStr, errorStr = p.communicate()
            if len(errorStr) > 0:
                data = {}
                data["status"] = 2
                data["remark"] = errorStr
                self.updateRecord(recordId, data)
            print "compile completed: %s" % path
        os.chdir(rawDir)
        data = {}
        data["end_time"] = datetime.now()
        data["status"] = 3
        data["remark"] = "编译完成"
        self.updateRecord(recordId, data)

    def updateRecord(self, recordId, datas):
        pass
        #if recordId is not None:
        #    self.db.compiling_record.update({"_id": ObjectId(recordId)}, {"$set": datas})

    def getCustomer(self, customerId):
        customer = self.db.customer.find_one({"_id":ObjectId(customerId)})
        return customer

    def getUser(self, userId):
        user = self.db.user.find_one({"_id":ObjectId(userId)})
        return user

def doCompile(recordId, machineId, userId, dirMap):
    c = Compile(DB_HOST)
    branches = [v for k, v in dirMap.iteritems()]
    return c.updateCompile(recordId, machineId, userId, branches)

def testMongo():
    c = Compile(DB_HOST)
    id = "537b271398ea9b9f6e19f81f"
    d = {'status': 4, 'end_time': 'Tue May 20 17:57:50 2014'}
    e = c.db.compiling_log.find_one({"_id": ObjectId(id)})
    r = c.db.compiling_record.update({"_id": ObjectId(id)}, {"$set": d})
    print r


import gridfs
def testLargeData():
    c = Compile(DB_HOST)
    #packageId = c.db.update_package.save({"package":package})
    fs = gridfs.GridFS(c.db)
    f = open("E:/test/webserver.7z", "rb")
    #data = fs.put(f.read())
    ffile = fs.new_file(**{"content_type":"application/zip"})
    str = f.read()
    ffile.write(str)
    ffile.close()

    c.updatePackage(time.ctime(), "5374669d98ea9b7ffd727a2e", ffile._id, len(str), "")

if __name__ == "__main__":
    #compile("5378cb624aa59f01a61d2f4a", "5374cf71715e262d60cd9791", ["536b3459715e2620581ec065"], "536b3078715e262b18d78fd8", {"branch": "/home/sourcecode/deploy_20140516"})
    #testMongo()
    testLargeData()
    pass
