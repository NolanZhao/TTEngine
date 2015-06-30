#coding=utf8
__author__ = 'xujun'
import re, sys, json, datetime, shutil, hashlib, os, MySQLdb, tarfile, time
from json import load, dumps

# 注意： 未处理crontab

# 升级检查， 主要检查本地配置或者监控是否修改
def updateCheck(updatePackagePath, checkPath):
    updateFile = updatePackagePath
    if not os.path.exists(updateFile):
        print "update file is not exists"
    f = open(updateFile, "r")
    jsonData = load(f)
    f.close()

    delFiles = []
    modifyFiles = []
    fileInfos = jsonData["fileInfos"]
    for path, info in fileInfos.iteritems():
        baseName = os.path.basename(path)
        if baseName == "crontab":
            continue
        if baseName == "update.sh":
            continue
        if baseName == "Deploy.py":
            continue

        rawPath = path
        if not path.startswith("/"):
            path = jsonData["xtDir"] + path
#print "path", path
        if os.path.exists(path):
            fStat = os.stat(path)
            sha1 = hashlib.sha1(open(path).read()).hexdigest()
            if sha1 != info["sha1"]:
                info["path"] = path
                modifyFiles.append(info)
                jsonData["fileInfos"][rawPath]["sha1"] = sha1
                jsonData["fileInfos"][rawPath]["size"] = fStat.st_size
                print "is not equal", path
        else:
            info["path"] = path
            delFiles.append(info)
            jsonData["fileInfos"][rawPath]["sha1"] = ""
            jsonData["fileInfos"][rawPath]["size"] = 0
            print "not exists", path
    if len(modifyFiles) > 0 or len(delFiles) > 0:
        strJson = dumps({"delFiles":delFiles, "modifies":modifyFiles, "xtDir":jsonData["xtDir"]}, indent=4)
        f = open(checkPath, "w")
        f.write(strJson)
        f.close()
    else:
        print "local files not changed"

def writePlatform(dir):
    sys.path.append("/home/rzrk/server/pyScripts/")
    from pyenv import getMysqlConfig
    # 写入平台信息到数据库
    os.chdir(dir)
    strPlatforms = os.popen("lua config.lua g_allPlatforms").read()
    platforms = json.loads(strPlatforms)

    conn = MySQLdb.connect(**getMysqlConfig())
    cursor = conn.cursor()
    sqlTemplate = "insert into tradeplatform_platform(abbrname, logo, name, id, types, creditable) values ('%s', '%s', '%s', %s, %s, %s) on duplicate key update creditable=%s;"
    for platform in platforms:
        isCreditable = 0
        for findPlatform in platforms:
            if findPlatform["m_nId"] == platform["m_nId"] and findPlatform["m_nType"] == 3:
                isCreditable = 1
        datas = (platform["m_strAbbrName"], platform["m_strLogo"], platform["m_strName"], platform["m_nId"], platform["m_nType"], isCreditable, isCreditable)
        sql = sqlTemplate % datas
        #print "excute ", sql
        cursor.execute(sql)
    conn.commit()
    cursor.close()
    conn.close()
    print "completed"

# 更新机器
# updatePackagePath : 升级包地址
# updateInfoPath ： 升级信息地址
def updateMachine(updatePackageDir):
    updateInfoPath = updatePackageDir + "/" + "update.json"
    # 安装包更新
    f = open(updateInfoPath, "r")
    jsonData = load(f)
    updateMap = jsonData["fileInfos"]
    xtDir = jsonData["xtDir"]

    # 创建监控目录
    pidDir = xtDir + "/server/userdata/pids/"
    if not os.path.exists(pidDir):
        os.makedirs(pidDir)

    logDir = xtDir + "/server/userdata/log/"
    if not os.path.exists(logDir):
        os.makedirs(logDir)

    for path, value in updateMap.iteritems():
        xtPath = path
        relPath = path
        if path.startswith("/") :
            xtPath = path
            relPath = path[1:]
        else:
            xtPath = xtDir + "/" + path
            relPath = path
        if os.path.exists(relPath):
            # 处理普通文件
            if not os.path.exists(os.path.dirname(xtPath)):
                os.makedirs(os.path.dirname(xtPath))
            shutil.move(relPath, xtPath)
            os.popen("chmod %d %s" % (value["mod"], xtPath))
    writePlatform(xtDir + "/server/config")

def tarLocal(infoPath, tarPath):
    f = open(tarPath, "w")
    writeTar = tarfile.open(fileobj=f, mode="w:gz")
    infos = json.loads(open(infoPath, "r").read())
    xtDir = infos["xtDir"]
    for file in infos["modifies"]:
        path = file["path"]
        relPath = os.path.relpath(path, xtDir)
        writeTar.add(path, relPath)
        print relPath
    writeTar.close()
    f.close()

def copyFiles(sourceDir, targetDir, ignoreStart):
    for f in os.listdir(sourceDir):
        sourceF = os.path.normpath(os.path.join(sourceDir, f))
        targetF = os.path.normpath(os.path.join(targetDir, f))
        if os.path.isfile(sourceF):
            if len(ignoreStart) > 0 and os.path.basename(sourceF).startswith(ignoreStart):
                continue
            if not os.path.exists(targetDir):
                os.makedirs(targetDir)
            print "copy file from", sourceF, "to", targetF
            shutil.copy2(sourceF, targetF)
        if os.path.isdir(sourceF):
            copyFiles(sourceF, targetF, ignoreStart)

def backup(updatePackageDir):
    updateInfoPath = updatePackageDir + "/" + "update.json"
    f = open(updateInfoPath, "r")
    jsonData = load(f)
    xtDir = jsonData["xtDir"]
    copyDirs = ["/server/bin/", "/server/monitor/", "/server/pyScripts/", "/server/luaScripts/", "/server/config/"]

    date = datetime.date.today().strftime("%Y%m%d")
    destDir = xtDir + "/backup/" + date + "/"

    maxIndex = -1
    for x in os.listdir(xtDir + "/backup/"):
        if x.startswith(destDir):
            tag = x[len(destDir) :]
            if len(tag) > 0 :
                tag = tag[1:]
                if int(tag) > maxIndex:
                    maxIndex = int(tag)
            else:
                maxIndex = 0
    if maxIndex >= 0:
        destDir = xtDir + "/backup/" + date + "_" + str(maxIndex + 1) + "/"

    print destDir
    if not os.path.exists(destDir):
        os.makedirs(destDir)
    for x in copyDirs:
        copyFiles(xtDir + "/" + x, destDir + x, "")

    # crontab
    f = open(destDir + "crontab", "w")
    f.write(os.popen("crontab -l").read())
    f.close()

    # keepalived
    shutil.copy2(xtDir + "/keepalived/conf/keepalived.conf", destDir + "keepalived.conf")

HELPER = """
# 备份
python Deploy.py 0 .

# 校验（看本地文件与update.json中记录的是否有异常， 结果存放在check.json中）
python Deploy.py 1 update.json

# 更新
python Deploy.py 2 .

# 写平台信息
python Deploy.py 3 .
"""

if __name__ == "__main__":
    print "params:", sys.argv
    if len(sys.argv) < 2:
        print HELPER
    else:
        type = sys.argv[1]
        if type == "0":
            backup(sys.argv[2])
        elif type == "1":
            rawPath = sys.argv[2]
            checkPath =  sys.argv[3]
            updateCheck(rawPath, checkPath)
            pass
        elif type == "2":
            dir = sys.argv[2]
            updateMachine(dir)
        elif type == "3":
            dir = sys.argv[2]
            writePlatform(dir)
        elif type == "4":
            checkPath = sys.argv[2]
            tarPath = sys.argv[3]
            tarLocal(checkPath, tarPath)
        else:
            print HELPER




