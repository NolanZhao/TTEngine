#coding=utf8
__author__ = 'xj'
from deploy.MachineConfig import configs
import paramiko, time, os, datetime, stat

def mkdirs(sftp, dir):
    dir = dir.replace("\\", "/")
    items = dir.split("/")
    items = [ item for item in items if len(item) > 0]

    ownedIndex = 0
    for index in xrange(1, len(items) + 1):
        nowDir = "/" + "/".join(items[0:index])
        try:
            d = sftp.stat(nowDir)
            if  not stat.S_ISDIR(d.st_mode):
                ownedIndex = index
                break
        except:
            ownedIndex = index
            break

    for index in xrange(ownedIndex, len(items) + 1):
        nowDir = "/" + "/".join(items[0:index])
        print "make dir", nowDir
        sftp.mkdir(nowDir)

def putDir(sftp, rawDir, remoteDir):
    for root, dirs, files in os.walk(rawDir):
        item = {}
        rootRel = os.path.relpath(root, rawDir)
        mkdirs(sftp, remoteDir + "/" + rootRel)
        for f in files:
            path = os.path.join(root, f)
            pathRel = os.path.relpath(path, rawDir)
            dstPath = remoteDir + "/" + pathRel
            print "send file %s to remote %s" % (path, dstPath)
            sftp.put(path, dstPath)

def execute(chanel, cmd):
    time.sleep(1)
    chanel.send("%s\n" % cmd)
    while chanel.recv_ready():
        print chanel.recv(1024)

def deploy(config, updateMysql):
    # 调用shell执行
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(config["host"], port = config["port"], username=config["user"], password=config["password"])
    sftp = paramiko.SFTPClient.from_transport(client.get_transport())

    # 删除/home/rzrk/update/_update目录
    client.exec_command("rm -rf /home/rzrk/update/_update")

    # 上传目录
    putDir(config["host"], "/home/rzrk/update/_update")

    # 上传辅助文件
    files = ["Deploy.py", "README", "update.sh"]
    for file in files:
        dstPath = "/home/rzrk/update/_update/%s" % file
        print "send file %s to remote %s" % (file, dstPath)
        sftp.put(file, dstPath)

    # 上传portal
    pass

    # 上传mysql更新文件

    # 将升级文件打包
    print "pack update files"
    chanel = client.invoke_shell("linux")
    execute(chanel, "cd /home/rzrk/server/upate")
    strTime = datetime.datetime.now().strftime("%Y%m%d_%H%H%S")
    execute(chanel, "tar -czvf %s.tag.gz _update" % strTime)

    # 备份文件
    execute(chanel, "cd /home/rzrk/server/upate/_update")
    print "back up files"
    execute(chanel, "/usr/bin/python Deploy.py 0 .")
    print "check local is changed"
    execute(chanel, "/usr/bin/python Deploy.py 1 lastUpdate.json changed.json")
    if sftp.lstat("changed.json"):
        execute(chanel, "/usr/bin/python Deploy.py 4 changed.json modify.tar.gz")
        print "file has changed, please submit to xt manager"
        sftp.get("modify.tag.gz", "report/%s/modify.tag.gz" % config["host"])
        sftp.get("changed.json", "report/%s/changed.json" % config["host"])

    # 更新数据库
    if updateMysql:
        pass

    # 升级
    print "start update"
    print "copy files"
    execute(chanel, "/usr/bin/python Deploy.py 2 .")
    print "change crontab"
    execute(chanel, "crontab crontab")
    print "ldconfig"
    execute(chanel, "ldconfig")
    print "restart"
    execute(chanel, "/home/rzrk/server/monitor/dailyRestart.sh")

    # 升级完检查
    execute(chanel, "cd /home/rzrk/update/_update")
    print "update check"
    execute(chanel, "/usr/bin/python Deploy.py 1 update.json check.json")
    if sftp.lstat("check.json"):
        print "update file exception, please submit to xt manager"
        sftp.get("check.json", "report/%s/changed.json" % config["host"])

def main(configs):
    updateSql = True
    for config in configs:
        print "################################"
        print "deploy machine : ", config["host"]
        deploy(config, updateSql)
        if updateSql:
            updateSql = False

    # 打包report目录



if __name__ == "__main__":
    main(configs)
