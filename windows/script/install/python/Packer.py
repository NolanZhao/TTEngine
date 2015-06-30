# -*- coding:utf-8 -*-
import sys
import os
import shutil
import subprocess

sys.path.append('../../../_xtPlatform/script/python/')
print os.path.abspath('../../../_xtPlatform/script/python/')
import Util

# 打包类
class Packer:
    def __binPath(self):
        return self.__conf.root_dir + '\\_runtime\\bin.pack\\' + self.__configuration

    def __confPath(self):
        return self.__conf.root_dir + '\\_runtime\\config.pack\\' + self.__configuration

    # 将文件复制到打包目录
    def __copyFiles(self):
        print '复制文件到指定目录。'
        util = Util.Util()

        ##################################################
        # 1. bin文件
        ##################################################

        bin_path = self.__binPath()
        client_bin_path = self.__conf.root_dir + '\\_runtime\\' + self.__configuration

        # crt dll
        util.copyFile(client_bin_path, bin_path, 'msvcm90.dll')
        util.copyFile(client_bin_path, bin_path, 'msvcp90.dll')
        util.copyFile(client_bin_path, bin_path, 'msvcr90.dll')
        util.copyFile(client_bin_path, bin_path, 'Microsoft.VC90.CRT.manifest')

        # Qt DLL
        qt_bin_path = self.__conf.qt_path + '\\bin'
        util.copyFile(qt_bin_path, bin_path, 'QtCore4.dll')
        util.copyFile(qt_bin_path, bin_path, 'QtGui4.dll')
        util.copyFile(qt_bin_path, bin_path, 'QtXml4.dll')
        util.copyFile(qt_bin_path, bin_path, 'QtWebKit4.dll')
        util.copyFile(qt_bin_path, bin_path, 'QtNetwork4.dll')

        # 其它bin文件
        util.copyFile(self.__conf.server_lib_dir + '\\runtime', bin_path, 'libeay32.dll')
        util.copyFile(self.__conf.server_lib_dir + '\\runtime', bin_path, 'ssleay32.dll')
        util.copyFile(self.__conf.server_lib_dir + '\\runtime', bin_path, 'arcom.dll')
        util.copyFile(self.__conf.server_lib_dir + '\\runtime\\release', bin_path, 'log4cxx.dll')
        util.copyFile(self.__conf.server_lib_dir + '\\runtime\\release', bin_path, 'lua51.dll')
        util.copyFile(self.__conf.server_lib_dir + '\\runtime\\release', bin_path, 'core.dll')
        util.copyFile(self.__conf.server_lib_dir + '\\runtime\\release', bin_path, 'zookeeper.dll')

        util.copyFile(self.__conf.server_lib_dir + '\\hsfutures\\runtime', bin_path, 'HsFutuSDK.dll')
        util.copyFile(self.__conf.server_lib_dir + '\\hsfutures\\runtime', bin_path, 't2sdk.dll')
        util.copyFile(self.__conf.server_lib_dir + '\\thost\\win32', bin_path, 'thosttraderapi.dll')
        util.copyFile(self.__conf.server_lib_dir + '\\thost\\win32', bin_path, 'thostmduserapi.dll')

        if 1 == self.__conf.client_version:
            util.copyFile(self.__conf.server_lib_dir + '\\runtime', bin_path, 'libmySQL.dll')

        ##################################################
        # 2. 资源文件
        ##################################################

        # 资源文件
        resource_dst_dir = self.__conf.root_dir + '\\_runtime\\resource'
        resource_src_dir = self.__conf.root_dir + '\\_xtPlatform\\_runtime\\resource';
        util.copyDirR(resource_src_dir, resource_dst_dir)

    # 运行NSIS生成安装包
    def __makeNSIS(self):
        print '\n生成安装文件。'
        nsi_script_path = self.__conf.root_dir + '\\script\\install\\'
        client_version_arg = ''
        if 1 == self.__conf.client_version:
            client_version_arg = '/DSERVER_BINS '
        print "current dir: ", os.path.abspath('.')
        nsi_installer =  nsi_script_path + self.__conf.nsi_script
        nsi_installer = os.path.normpath(os.path.abspath(nsi_installer))
        # print "installer: ", nsi_installer
        # print "client_version_arg: ", client_version_arg
        # print "config: ", self.__configuration
        # print 'conf_product_name_cn: ', self.__conf.product_name_cn
        # print 'conf_product_name_en: ', self.__conf.product_name_en
        # print 'conf_version: ', self.__conf.version
        # print 'conf_out-file: ', self.__conf.out_file
        # print 'nsis file: ', nsi_installer

        cmd_line = u'cd ' + nsi_script_path + u'&& echo %cd% && makensis '
        cmd_line += u' /DBIN_SUBDIR=\"' + self.__configuration
        cmd_line += u'\" /DPRODUCT_NAME_CN=\"' + self.__conf.product_name_cn.decode('gbk')
        cmd_line += u'\" /DPRODUCT_NAME_EN=\"' + self.__conf.product_name_en
        cmd_line += u'\" /DPRODUCT_VERSION=\"' + self.__conf.version
        cmd_line += u'\" /DORIGINAL_FILENAME=\"' + self.__conf.out_file
        cmd_line += u'\" /DOUTFILE=\"' + self.__conf.out_file_full + '\" '
        cmd_line += u'\"' + nsi_installer + '\"'

        if 0 != os.system(cmd_line.encode('gbk')):
            raise Exception("make install package failed")

        # 安装包也进行数字签名
        print '对安装文件进行数字签名'
        os.system(self.__sign_cmd_line + '"' + self.__conf.out_file_full + '"')

        # 初始化bin文件目录

    def iniBinDir(self):
        util = Util.Util()
        bin_path = self.__binPath()
        if not os.path.isdir(bin_path):
            os.mkdir(bin_path)
        util.clearDir(bin_path)
        conf_path = os.path.normpath(self.__confPath())
        if not os.path.isdir(conf_path):
            os.mkdir(conf_path)
        util.clearDir(conf_path)
        return bin_path, conf_path

    # 打包 
    def packInstaller(self):
        self.__copyFiles()
        self.__makeNSIS()
        return self.__conf.out_file_full

    # 初始化函数
    def __init__(self, conf, configuration):
        self.__conf = conf
        self.__configuration = 'Win32.' + configuration
        self.__sign_cmd_line = self.__conf.root_dir + '\\script\\install\\\sign\\signtool.exe sign /f "' + self.__conf.root_dir + '\\script\\install\\\sign\\mycert.pfx" /p "rzrk.verisign" /t "http://timestamp.verisign.com/scripts/timstamp.dll" '