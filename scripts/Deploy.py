#coding=utf8
__author__ = 'xujun'
import sys
import os
import hashlib
import shutil
import re
from json import load, dumps
import sys

# 注意： 未处理crontab

# 升级检查， 主要检查本地配置或者监控是否修改
def updateCheck(updateFile):
    if not os.path.exists(updateFile):
        print "update file is not exists"
    f = open(updateFile, "r")
    jsonData = load(f)
    f.close()

    delFiles = []
    modifyFiles = []
    fileInfos = jsonData["fileInfos"]
    for path, info in fileInfos.iteritems():
        rawPath = path
        if not path.startswith("/"):
            path = jsonData["xtDir"] + path
        print "path", path
        if os.path.exists(path):
            fStat = os.stat(path)
            sha1 = hashlib.sha1(open(path).read()).hexdigest()
            if sha1 != info["sha1"] or fStat.st_size != info["size"]:
                modifyFiles.append(info)
                jsonData["fileInfos"][rawPath]["sha1"] = sha1
                jsonData["fileInfos"][rawPath]["size"] = fStat.st_size
                print "is not equal", path
        else:
            delFiles.append(info)
            jsonData["fileInfos"][rawPath]["sha1"] = ""
            jsonData["fileInfos"][rawPath]["size"] = 0
            print "not exists", path

    if len(modifyFiles) > 0 or len(delFiles) > 0:
        strJson = dumps({"delFiles":delFiles, "modifies":modifyFiles}, indent=4)
        f = open("check.json", "w")
        f.write(strJson)
        f.close()

        strJson = dumps(jsonData, indent=4)
        f = open("local.json", "w")
        f.write(strJson)
        f.close()
    else:
        print "local files not changed"

# 更新机器
# updatePackagePath : 升级包地址
# updateInfoPath ： 升级信息地址
def updateMachine(updatePackageDir):
    updateInfoPath = updatePackageDir + "/" + "update.json"
    # 安装包更新
    f = open(updateInfoPath, "r")
    jsonData = load(f)
    updateMap = jsonData["fileInfos"]

    # 拷贝文件并修改文件mode
    xtDir = jsonData["xtDir"]
    for root, dirs, files in os.walk(updatePackageDir):
        for file in files:
            print(file)
            path = os.path.join(root, file)
            relPath = os.path.relpath(path, updatePackageDir)
            # 处理crontab
            if relPath == "crontab":
                # 外部shell脚本负责写crontab
                continue

            # 处理普通文件
            xtPath = xtDir + "/" + relPath
            info = updateMap.get(relPath, None)
            if info is not None:
                if not os.path.exists(os.path.dirname(xtPath)):
                    os.makedirs(os.path.dirname(xtPath))
                shutil.copy(path, xtPath)
                if info is not None:
                    os.chmod(xtPath, info["mod"])
            else:
                rootPath = "/" + relPath
                info = updateMap.get(rootPath, None)
                if info is not None:
                    if not os.path.exists(os.path.dirname(rootPath)):
                        os.makedirs(os.path.dirname(rootPath))
                    shutil.copy(path, rootPath)
                    if info is not None:
                        os.chmod(rootPath, info["mod"])

if __name__ == "__main__":
    print "params:", sys.argv
    type = sys.argv[1]
    if type == "0":
        dir = sys.argv[2] + "/update.json"
        updateCheck(dir)
        pass
    else:
        dir = sys.argv[2]
        updateMachine(dir)
    
