# -*- coding:utf-8 -*-

import ConfigParser
import sys
import os
import MySQLdb
import _winreg
import xtCommon

sys.path.append('../../../_xtPlatform/script/python/')
import RCVersioner
print os.path.abspath('../../../_xtPlatform/script/python/')

# 数据库配置类
class DBConfig:
    # 初始化函数
    def __init__(self):
        self.db_host = 'localhost'
        self.db_port = 3306
        self.db_user = 'root'
        self.db_pass = ''
        self.db_name = ''

# 编译打包配置类
class Config:
    
    # 读取配置文件
    def loadConfig(self, config_file):
        self.conf_parser = ConfigParser.ConfigParser()
        self.conf_file = config_file
        print '解析配置文件：' + self.conf_file
        if os.path.isfile(self.conf_file):
            self.conf_parser.read(self.conf_file)
        else:
            raise Exception('配置文件' + self.conf_file + '不存在。')
    
    # 读取注册表
    def loadReg(self):
        key = _winreg.OpenKey(_winreg.HKEY_LOCAL_MACHINE, 'System\\CurrentControlSet\\Control\\Session Manager\\Environment', 0, _winreg.KEY_READ)
        self.qt_path = _winreg.QueryValueEx(key, 'QTDIR')[0]
        _winreg.CloseKey(key)

    # 解析配置
    def parseConfig(self):

        self.client_version = int(self.conf_parser.get('Product', 'client_version'))
        self.product_name_cn = self.conf_parser.get('Product', 'product_name_cn')
        print self.product_name_cn
        self.product_name_en = self.conf_parser.get('Product', 'product_name_en')
        self.region = self.conf_parser.get('Product', 'region')
        self.update_temp_file = self.conf_parser.get('Product', 'update_temp_file')
        # self.config_subdir = self.conf_parser.get('Product', 'config_subdir')

        conf_id = self.conf_parser.get('Version', 'id')
        conf_name = self.conf_parser.get('Version', 'name')
        db_conf = DBConfig()
        db_conf.db_host = self.conf_parser.get('MySQL', 'host')
        db_conf.db_port = int(self.conf_parser.get('MySQL', 'port'))
        db_conf.db_user = self.conf_parser.get('MySQL', 'user')
        db_conf.db_pass = self.conf_parser.get('MySQL', 'pass')
        db_conf.db_name = self.conf_parser.get('MySQL', 'db')
        self.rc_conf = RCVersioner.RCVersionConf()

        success, self.rc_conf.ver_major, self.rc_conf.ver_minor, self.rc_conf.ver_revision, self.rc_conf.ver_build = self.getVersion(conf_id, conf_name, db_conf)
        if not success :
            raise Exception('无法读取版本信息。')
            return

        self.rc_conf.exe_name = self.conf_parser.get('Product', 'xt_exe_name')

        self.version = '%d.%d.%d.%04d' % (self.rc_conf.ver_major, self.rc_conf.ver_minor, self.rc_conf.ver_revision, self.rc_conf.ver_build)
        print '当前版本号：' + self.version

        self.out_tag = self.conf_parser.get('Product', 'output_file_tag')
        self.output_dir = self.conf_parser.get('Path', 'output_dir')
        self.out_file = self.outputFile(self.version)
        self.out_file_full = '%s\\%s' % (self.output_dir, self.out_file)
        self.publish_dir = self.conf_parser.get('Path', 'publish_dir')
        self.pdb_dir = self.conf_parser.get('Path', 'pdb_dir')

        self.output_download_url = self.conf_parser.get('Path', 'output_download_url')
        self.publish_download_url = self.conf_parser.get('Path', 'publish_download_url')

        self.server_lib_dir = self.conf_parser.get('Path', 'server_lib_dir')

        self.nsi_script = self.conf_parser.get('NSIS', 'scriptname')

        self.success_dst_addr = self.conf_parser.get('Mail', 'success_dst_addr').split(',')
        self.fail_dst_addr = self.conf_parser.get('Mail', 'fail_dst_addr').split(',')
        self.publish_dst_addr = self.conf_parser.get('Mail', 'publish_dst_addr').split(',')

        print '配置文件解析完毕。'


    def getVersion(self, id, name, dbconfig):
        try:
            conn = MySQLdb.connect(host=dbconfig.db_host, user=dbconfig.db_user, passwd=dbconfig.db_pass, db=dbconfig.db_name, port=dbconfig.db_port)
            cur = conn.cursor()
            cur.execute('insert version(v_id, v_name) values(%s, "%s") on duplicate key update v_id_build = v_id_build + 1' % (id, name))
            cur.execute('select v_id_major, v_id_minor, v_id_revision, v_id_build from version where v_id = %s' % id)
            row = cur.fetchone()
            id_major = int(row[0])
            id_minor = int(row[1])
            id_revision = int(row[2])
            id_build = int(row[3])
            conn.commit()
            cur.close()
            conn.close()
            return True,id_major,id_minor,id_revision,id_build
        except:
            return False,0,0,0,0


    def outputFile(self, v):
        if (len(self.out_tag) > 0):
            return '%s_%s_%s.exe' % (self.product_name_en, self.out_tag, v)
        else:
            return '%s_%s.exe' % (self.product_name_en, v)

    
    # 小版本号加1
    def incVersion(self):
        self.ver_newbuild = self.rc_conf.ver_build + 1
        print u'新版本号 %d' % self.ver_newbuild
        self.conf_parser.set('Version', 'Build', self.ver_newbuild)
        with open(self.conf_file, 'wt') as configfile:
            self.conf_parser.write(configfile)
    

    # 更新SVN版本号
    def updateRevision(self, revision):
        self.svn_last_changed = revision
        self.conf_parser.set('SVN', 'LastChanged', self.svn_last_changed)
        with open(self.conf_file, 'wt') as configfile:
            self.conf_parser.write(configfile)

    
    # 初始化函数
    def __init__(self, config_file):
        self.loadConfig(config_file)
        self.loadReg()
        self.root_dir = os.path.abspath(__file__ + '..\..\..\..\..')
        print '代码根目录：' + self.root_dir