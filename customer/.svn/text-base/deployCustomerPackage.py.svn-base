__author__ = 'zhaoshuailong'
#encoding=utf-8

# ######################################################
# 功能：1.解压安装包；
#       2 利用paramiko将解压后的安装包分发到不同的机器上；
#       3.利用paramiko在不同的远程机器上进行部署
# 注意： 本脚本最终在 “讯投资产管理门户”上使用
# ######################################################

import tarfile
import os
import re
import datetime
import logging
import paramiko
import stat
import MySQLdb
from StringIO import StringIO

logger = logging.getLogger('django')


def sftp_makedirs(sftp, dir):
    dir = dir.replace("\\", "/")
    items = dir.split("/")
    items = [item for item in items if len(item) > 0]

    ownedIndex = 0
    for index in xrange(1, len(items) + 1):
        nowDir = "/" + "/".join(items[0:index])
        try:
            d = sftp.stat(nowDir)
            if not stat.S_ISDIR(d.st_mode):
                ownedIndex = index
                break
        except:
            ownedIndex = index
            break

    for index in xrange(ownedIndex, len(items) + 1):
        nowDir = "/" + "/".join(items[0:index])
        logger.info("make dir %s" % nowDir)
        try:
            sftp.mkdir(nowDir)
        except IOError:
            logger.info('%s already exists' % nowDir)

# 更新 server
def server_update(client, sftp, machine_info, script_stream, server_package_stream, package_name=''):

    update_root_path = machine_info['root_path'] + 'update/'
    server_package_path = update_root_path + package_name
    sftp_makedirs(sftp, update_root_path)

    try:
        sftp.putfo(script_stream, update_root_path + 'update.sh')
    except:
        return {'success': False, 'msg': '[%s] fail to copy \"update.sh\" from local to server dir: %s' % (machine_info['host'], update_root_path)}

    try:
        logger.info('begin to send data: %s begin' % server_package_path)
        sftp.putfo(server_package_stream, server_package_path)
        logger.info('begin to send data: %s end' % server_package_path)
    except:
        return {'success': False, 'msg': '[%s] fail to copy install package to remote server dir: \"%s\"' % (machine_info['host'], server_package_path)}

    client.exec_command('chmod +x ' + update_root_path + 'update.sh')
    cmd = 'cd %s; /bin/sh update.sh %s' % (update_root_path, package_name)
    logger.info('executing: %s begin' % cmd)
    stdin, stdout, stderr = client.exec_command(cmd)
    logger.info('executing: %s end' % cmd)
    error = stderr.read()
    if len(error) > 0:
        msg = '[%s]executing cmd %s failed, %s' % (machine_info['host'], cmd, error)
        logger.info(msg)
        return {'success': True, 'msg': "excueted success"}
    else:
        logger.info('successfully execute cmd: %s' % cmd)
        return {'success': True, 'msg': '[%s] update server successfully' % machine_info['host']}

# 更新 portal
def portal_update(client, sftp, machine_info, portal_package_stream, package_name=''):
    update_root_path = machine_info['root_path'] + '/webserver/'
    portal_package_path = update_root_path + package_name
    try:
        sftp.putfo(portal_package_stream, portal_package_path)
    except:
        msg = '[%s_update_portal] 拷贝portal安装包到服务器 失败: %s' % (machine_info['host'], portal_package_path)
        return {'success': False, 'msg': msg}
    cmd = 'cd %s; /bin/tar -zxvf %s -C /home/rzrk/webserver/webserver; killall python' % (update_root_path, package_name)
    logger.info('excute command: %s begin' % cmd)
    stdin, stdout, stderr = client.exec_command(cmd)
    logger.info('excute command: %s end' % cmd)
    out = stdout.readlines()
    err_list = stderr.readline()
    if len(err_list) > 0:
        msg = '[%s__portal] 解压 %s 失败' % (machine_info['host'], package_name)
        logger.info(msg)
        return {'success': False, 'msg': msg}
    else:
        msg = '[%s__portal] 解压 %s 成功' % (machine_info['host'], package_name)
        logger.info(msg)
        return {'success': True, 'msg': msg}


def fetch_customer_package_content(readTar, machine_dict):
    customer_package = dict()
    server_update_script_stream = StringIO()

    portal_upgrade_package_stream = StringIO()
    portal_upgrade_package_name = ''

    res_list = list()

    for tarinfo in readTar:
        if tarinfo.isreg():
            arr = tarinfo.name.split('__')
            if u'update.sh' == arr[0]:
                print u'fetching server upgrade script'
                name = tarinfo.name
                size = tarinfo.size
                content = tarinfo.tobuf(encoding='utf-8')
                server_update_script_stream.write(content)

            elif u'portal_upgarde_sql' == arr[0]:
                print u'fetching portal upgrade sql data'
                name = tarinfo.name
                size = tarinfo.size
                if size==0:
                    continue
                content = tarinfo.tobuf(encoding='utf-8')
                for host, machine in machine_dict:
                    client = paramiko.SSHClient()
                    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
                    client.connect(host, port=machine['port'], username=machine['username'], password=machine['password'])
                    sftp = paramiko.SFTPClient.from_transport(client.get_transport())
                    # 登陆mysql,准备数据库
                    print 'update mysql portal database'
                    db = MySQLdb.connect(host=host, user=machine['mysql_username'], passwd=machine['mysql_password'])
                    cursor = db.cursor()
                    sql = [
                        'drop database if exists ttmgrportal_old',
                        'drop database if exists ttmgrportal_new',
                        'create database ttmgrportal_old',
                        'create database ttmgrportal_new'
                    ]
                    for item_sql in content:
                        cursor.execute(item_sql)
                    db.close()
                    break

            elif u'portal_package' == arr[0]:
                print u'fetching portal update package'
                portal_upgrade_package_name = tarinfo.name
                size = tarinfo.size
                content = tarinfo.tobuf(encoding='utf-8')
                portal_upgrade_package_stream.write(content)

            elif u'machine_package' == arr[0]:
                print u'fetching machine update package'
                name = tarinfo.name
                host = arr[1]
                size = tarinfo.size
                content = tarinfo.tobuf(encoding='utf-8')
                server_update_package_stream = StringIO(content)
                try:
                    machine = machine_dict[host]
                    client = paramiko.SSHClient()
                    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
                    client.connect(host, port=machine['port'], username=machine['username'], password=machine['password'])
                    sftp = paramiko.SFTPClient.from_transport(client.get_transport())
                    res = server_update(client=client, sftp=sftp,machine_info=machine, script_stream=server_update_script_stream, server_package_stream=server_update_package_stream, package_name=name)
                    res_list.append(res)
                    res = portal_update(client=client, sftp=sftp, machine_info=machine, portal_package_stream=portal_upgrade_package_stream, package_name=portal_upgrade_package_name)
                    res_list.append(res)
                except Exception as e:
                    error = '[%s] cannot find the machine' % host
                    logger.error(error)
                    res = {'success': False, 'host': host, 'error': error}
                    res_list.append(res)
    return res_list

def uncompressAndDeploy(customer_package_file_path, machine_dict):
    readTar = tarfile.open(name=customer_package_file_path, mode='r:gz')
    res_list = fetch_customer_package_content(readTar=readTar, machine_dict=machine_dict)
    readTar.close()
    retValue = {'success': True, 'msg': ''}
    for res in res_list:
        if not res['success']:
            retValue['success'] = False
            retValue['msg'] = str(res_list)
    return retValue

if __name__ == '__main__':

    # 由客户提供这些信息： CustomerName, list of (host, port, username, password)
    machine_dict = dict()
    machine_dict['192.168.1.164'] = {'host':'192.169=8.1.164', 'username':'root', 'password':'123456', 'port':22, 'root_path': '/home/rzrk/', 'mysql_username': 'root', 'mysql_password': '123456'}
    src_tar_path = u'C:/Users/USER/Downloads/customer_package_164测试机_20140731.tar.gz'
    uncompressAndDeploy(src_tar_path, machine_dict)

    #content = fetch_customer_package_content(readTar=readTar, target_path=target_dir_path)



