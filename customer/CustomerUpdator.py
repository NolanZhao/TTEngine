#coding=utf8
__author__ = 'xujun'
import sys
import json
import os
import hashlib
import shutil
import tarfile
import scripts.module.RunInfo
import hashlib
from utils.SvnInfo import *
from scripts.module.FileInfo import FileInfoDetail
from scripts.module.RunInfo import RunInfo
import re
from utils.Common import *
from platform import system
from utils.OsHelper import *
from datetime import datetime
from utils.PathHelper import getConfigDir

"""
升级步骤如下：如现在是20140515日
1： 从服务器下载升级包
2： 在客户机器上执行一下操作
rm -rf /home/rzrk/update/20140515
mkdir /home/rzrk/update/20140515
包程序包放在/home/rzrk/update/20140515目录下
3： 执行CustomerUpdator的updateCheck, 检查本地配置是否发生修改
4： 如果发生修改， 把修改的部分告知迅投总部人员， 总部人员按配置文件入库， 然后重新产生本地配置包给部署人员，
    如果没更新， 执行5
5： 更新客户机程序
6： 像迅投后台登记更新信息
"""

class CustomerUpdator(object):
    def __init__(self, updatePackageDir, updateInfoPath):
        self.updatePackageDir = updatePackageDir
        self.updateInfoPath = updateInfoPath

    # 升级检查， 主要检查本地配置或者监控是否修改
    def updateCheck(self):
        pass

    # 更新机器
    # updatePackagePath : 升级包地址
    # updateInfoPath ： 升级信息地址
    def updateMachine(self):
        # 安装包更新
        packagePath = self.updatePackageDir + "/" + PACKAGE_FILE_NAME
        os.chdir(self.updatePackageDir)
        tar = tarfile.open(packagePath)
        tar.extractall()
        tar.close()
        f = open(self.updateInfoPath, "r")
        updateInfo = json.load(f)
        for info in updateInfo["fileInfos"]:
            infoObj = FileInfoDetail(info)
            path = dir + "/" + infoObj.filePath
            if os.path.exists(path):
                shutil.move(path, infoObj.filePath)
                os.chmod(infoObj.filePath, infoObj.mod)

        if isThisWindows():
            configDir = getConfigDir("windows")
        else:
            configDir = getConfigDir("linux")

        # 客户本地配置更新
        customerPath = self.updatePackageDir + "/" + LOCAL_CUSTOMER_CONFIG_FILE_NAME
        if os.path.exists(customerPath):
            tar = tarfile.open(customerPath)
            tar.extractall("customer/")
            tar.close()
            dirList = os.listdir("customer/")
            for dir in dirList:
                shutil.move(dir, configDir)

        # 机器本地配置更新
        customerPath = self.updatePackageDir + "/" + LOCAL_MACHINE_CONFIG_FILE_NAME
        if os.path.exists(customerPath):
            tar = tarfile.open(customerPath)
            tar.extractall("machine/")
            tar.close()
            dirList = os.listdir("machine/")
            for dir in dirList:
                shutil.move(dir, configDir)

        # 删除本地无效的配置
        localFiles = []
        dirStart = self.updatePackageDir + "/customer/"
        for root, dirs, files in os.walk("customer/"):
            for file in files:
                path = os.path.join(root, file)
                localFiles.append(os.path.relpath(path, dirStart))
        dirStart = self.updatePackageDir + "/machine/"
        for root, dirs, files in os.walk("machine/"):
            for file in files:
                path = os.path.join(root, file)
                localFiles.append(os.path.relpath(path, dirStart))

        for root, dirs, files in os.walk(configDir):
            for file in files:
                if file.find("local") != -1:
                    path = os.path.join(root, file)
                    relPath =  os.path.relpath(path, configDir)
                    if not localFiles.contains(relPath):
                        shutil.rmtree(path)

        if not isThisWindows():
            # 取得运行信息
            runInfos = []
            for info in updateInfo["runInfos"]:
                infoObj = RunInfo(info)
                runInfos.append(infoObj)

            # 修改crontab
            strCrontab = RunInfo.getCrontable(runInfos)

            # 修改运行脚本
            if not os.path.exists("./runInfos"):
                os.makedirs("./runInfos")
            for info in runInfos:
                if info.isAlwaysRun():
                    runScript = info.genMarsterAlwaysScript()
                    if len(runScript) > 0:
                        path = "./runInfos/" + info.runName + ".sh"
                        f = open(path, "w")
                        f.write(runScript)
                        f.close()
                        shutil.move(path, RUN_PROCESS_SCRIPT_INFO_DIR + info.runName)

            # 修改监控脚本
            runNames = []
            for info in runInfos:
                if info.isAlwaysRun():
                    runNames.append(info.genAlwaysCheck)
            str = "\n".join(runNames)
            path = "checkAll.sh"
            f = open("checkAll.sh", "w")
            f.write(str)
            f.close()
            shutil.move(path, CHECK_ALL_PATH)

        # 保存版本信息, 先读取已有的版本信息， 然后再综合新文件信息
        shutil.copy(self.updateInfoPath, dir + "../xt_version.json")

    def genUpdateInfoFile(self, fileInfos, runInfos, savePath):
        f = open(savePath, "w")
        strJson = self.genUpdateInfoJson(fileInfos, runInfos)
        f.write(strJson)
        f.close()

    def genUpdateInfoJson(self, fileInfos, localInfos, runInfos):
        files = []
        for file in fileInfos:
            d = file.toDict()
            del d["updateTime"]
            del d["_id"]
            files.append(d)

        localfiles = []
        for file in localInfos:
            d = file.toDict()
            del d["updateTime"]
            del d["_id"]
            localfiles.append(d)
        runs = []
        for run in runInfos:
            d = run.toDict()
            del d["_id"]
            runs.append(d)
        updateInfo = {"fileInfos" : files, "localInfos":localfiles, "runInfos":runs}
        return json.dumps(updateInfo, indent=4)

def main():
    date = datetime.now().date()
    dir = "/home/rzrk/update/" + date + "/"
    updator = CustomerUpdator(dir, dir + "update.json")
    updator.updateCheck()
    updator.updateMachine()
    #updator.genUpdateInfoFile()

if __name__ == "__main__":
    main()