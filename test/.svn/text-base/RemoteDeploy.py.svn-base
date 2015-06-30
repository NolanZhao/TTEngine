# encoding=utf-8
__author__ = 'zhaoshuailong'

import time, paramiko, os, stat
from bson import ObjectId
import tarfile
import zipfile
from utils.TarfileHelper import addfilefromstring, addfile
from StringIO import StringIO
import json
from utils.StringHelper import replaceStr
import time
import datetime
from customer.models import CustomerPackage, Machine, InstallPackage, PortalPackage, DeployRecord
# 问题： 安装包的地址还需要外界传过来，否则无法执行

def sftp_makedirs(sftp, dir):
    dir = dir.replace("\\", "/")
    items = dir.split("/")
    items = [item for item in items if len(item) > 0]

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
        try:
            sftp.mkdir(nowDir)
        except IOError:
            print nowDir, ' already exists'

def server_update(client, customer, machine, local_package_path, update_root_path='/home/rzrk/update/'):
    sftp = paramiko.SFTPClient.from_transport(client.get_transport())

    arr = local_package_path.split('/')
    package_name = arr[len(arr)-1]
    server_package_path = update_root_path + package_name
    sftp_makedirs(sftp, update_root_path)
    try:
        sftp.put('../deploy/update.sh', update_root_path + 'update.sh')
    except:
        return {'success': False, 'msg': '[%s_%s] fail to copy \"update.sh\" from local to server dir: %s' % (customer.name, machine.host, update_root_path)}
    try:
        sftp.put(local_package_path, server_package_path)
    except:
        return {'success': False, 'msg': '[%s_%s] fail to copy install package to remote server dir: \"%s\"' % (customer.name, machine.host, local_package_path, server_package_path)}

    client.exec_command('chmod +x ' + update_root_path + 'update.sh')

    cmd = 'cd %s; sh update.sh %s'%(update_root_path, package_name)
    print 'executing: ', cmd
    stdin, stdout, stderr = client.exec_command(cmd)
    if len(stderr.readlines()) > 0:
        msg = '[%s_%s]executing cmd %s fails' %(customer.name, machine.host, cmd)
        return {'success': False, 'msg': msg}
    else:
        print 'successfully execute cmd: %s' % cmd
    return {'success': True, 'msg': '[%s_%s] update server successfully' % (customer.name, machine.host)}

def portal_update(client, customer, machine, local_package_path, root_path='/home/rzrk/webserver/'):
    sftp = paramiko.SFTPClient.from_transport(client.get_transport())
    bak_mongodb_sh_path = '../deploy/MongoDbBackup.sh'
    try:
        sftp.put(bak_mongodb_sh_path, root_path + 'MongoDbBackup.sh')
    except:
        success = False
        msg = '[%s_%s_update_portal] fail to copy \"MongDbBackup.sh\" from local to remote server: %s' % (customer.name, machine.host, root_path)
        return {'success': False, 'msg': msg}
    # 备份数据库
    print 'back up mongodb database'
    client.exec_command('sh %sMongoDbBackup.sh' % root_path)
    print 'successfully back up'
    # 远程传输 portal 安装包
    arr = local_package_path.split('/')
    package_name = arr[len(arr)-1]
    server_package_path = root_path + package_name
    try:
        sftp.put(local_package_path, server_package_path)
        print '[%s_%s] 成功将portal安装包(%s)拷贝到远程机器' %(customer.name, machine.host, local_package_path)
    except:
        msg = '[%s_%s_update_portal] 拷贝portal安装包到服务器 失败: %s' % (customer.name, machine.host, server_package_path)
        return {'success': False, 'msg': msg}
    cmd = 'cd %s; tar -zxvf %s -C webserver' % (root_path, package_name)
    print 'command: %s' % cmd
    print '[%s_%s]解压 %s' %(customer.name, machine.host, package_name)
    stdin, stdout, stderr = client.exec_command(cmd)
    out = stdout.readlines()
    err_list = stderr.readline()
    if len(err_list)> 0:
        msg = '[%s_%s__portal] 解压 %s 失败' %(customer.name, machine.host, package_name)
        print msg
        return {'success': False, 'msg': msg}
    else:
        msg = '[%s_%s__portal] 解压 %s 成功' % (customer.name, machine.host, package_name)
        print msg
        return {'success': True, 'msg': msg}

def addCommonPackageInfo(lastPackage, package, writeTar):
    # 加入updateInfo.json和前一次的安装json
    lastInfos = {}
    lastInfos["fileInfos"] = {}
    lastInfos["xtDir"] = package.machine.xtDir
    if lastPackage is not None:
        for detail in lastPackage.files:
            lastInfos["fileInfos"][detail.filePath] = detail.toDict()
    jsonInfo = json.dumps(lastInfos, indent=4)
    jsonInfo = replaceStr(jsonInfo, {"xtDir": package.machine.xtDir})
    addfilefromstring(writeTar, "lastUpdate.json", jsonInfo)

    # updateInfo
    infos = {}
    infos["fileInfos"] = {}
    # 写入产生信息
    infos["xtDir"] = package.machine.xtDir
    infos["packageName"] = package.version
    infos["branches"] = package.branches
    for detail in package.files:
        infos["fileInfos"][detail.filePath] = detail.toDict()
    jsonInfo = json.dumps(infos, indent=4)
    jsonInfo = replaceStr(jsonInfo, {"xtDir": package.machine.xtDir})
    addfilefromstring(writeTar, "update.json", jsonInfo)

    localDir = os.path.dirname(os.path.abspath(__file__))
    files = ["update.sh", "Deploy.py", "README"]
    for file in files:
        path = localDir + "/../deploy/" + file
        addfile(writeTar, file, path)

def download_server_pcakge(package):
    if package is None:
        return {'success': False, 'msg': ''}

    lastPackage = None
    record = DeployRecord.objects(machine=package.machine).order_by("-start_time")
    if len(record) > 0:
        lastPackage = record[0].new_version

    stringIO = StringIO()
    writeTar = tarfile.open(fileobj=stringIO, mode="w:gz")
    addCommonPackageInfo(lastPackage, package, writeTar)

    lastFileMap = {}
    if lastPackage is not None:
        for file in lastPackage.files:
            lastFileMap[file.filePath] = file

    # 与前一个包比较
    for file in package.files:
        rawFile = lastFileMap.get(file.filePath, None)
        if rawFile is None or rawFile.sha1 != file.sha1 or rawFile.size != file.size:
            content = file.file.read()
            strIO = StringIO(content)
            info = tarfile.TarInfo(file.filePath)
            info.mode = file.info.mod
            info.size = len(content)
            info.mtime = time.time()
            writeTar.addfile(info, strIO)
            print 'add file %s' % file.filePath

    writeTar.close()
    content = stringIO.getvalue()
    tar_file_path="../media/temp/%s_%s_%s_update.tar.gz" % (package.customer.tag, package.machine.name, datetime.datetime.now().strftime("%Y%m%d"))
    try:
        fp = open(tar_file_path, 'wb')
        fp.write(content)
        fp.close()
        return {'success':True, 'msg': tar_file_path}
    except:
        return {'success': False, 'msg': '无法创建安装包' % tar_file_path}

def update_customer_packages(customerPack):
    res_list = list()

    # for machinePack in customerPack.machine_packages:
    #     machine = machinePack.machine
    #     res = download_server_pcakge(machinePack)
    #     if not res['success']:
    #         res_list.append({'success': False, 'msg': '[%s_%s]无法创建安装包'%(customerPack.customer.name, machine.host)})
    #         return res_list
    #     else:
    #         print '成功下载安装包到本地'
    #     local_package_path = res['msg']
    #     # 建立连接
    #     client = paramiko.SSHClient()
    #     client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    #     client.connect(machine.host, username=machine.username, password=machine.password)
    #
    #     res = server_update(client, customerPack, machinePack.machine, local_package_path)
    #     res_list.append(res)
    #     # 关闭 ssh 连接
    #     client.close()
    #     os.remove(local_package_path)

    # update portal
    portalPack = customerPack.portal_package
    content = portalPack.package.read()
    local_package_path ='../media/temp/portal_%s.tar.gz' % portalPack.svn_version
    try:
        fp = open(local_package_path, 'wb')
        fp.write(content)
        fp.close()
        print 'successfully download protal install package to ../media/temp/'
    except:
        print '下载portal包失败'
        return {'success': False, 'msg': '下载portal安装包失败'}
    for machine in customerPack.machines:
        # 建立连接
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        print 'machine info. host: %s, username: %s, password: %s' %(machine.host, machine.username, machine.password)
        client.connect(machine.host, username=machine.username, password=machine.password)
        res = portal_update(client, customerPack.customer, machine, local_package_path)
        res_list.append(res)
        if not res['success']:
            return res_list
        # 关闭 ssh 连接
        client.close()
    os.remove(local_package_path)
    return res_list
if __name__ == "__main__":
    update_root_path = '/home/rzrk/update/'
    customerPack = CustomerPackage.objects.get(pk=ObjectId("53cf7b8efa03212e28ce1a2c"))
    res_list = update_customer_packages(customerPack)
    print res_list