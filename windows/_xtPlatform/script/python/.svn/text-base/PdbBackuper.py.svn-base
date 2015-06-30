# -*- coding:utf-8 -*-

import Util
import sys
import os
import shutil

class PdbBackuper:

    def __doBackupDir(self, src_dir):
        # 创建输入路径
        dst_dir = self.__pdb_dir + '\\' + self.__version
        util = Util.Util()
        if not os.path.isdir(dst_dir):
            util.makeDir(dst_dir)
        # 复制文件
        for parent, dirnames, filenames in os.walk(src_dir):
            for f in filenames:
                if f.lower().endswith('.pdb') or f.lower().endswith('.map'):
                    src_file = src_dir + '\\' + f
                    dst_file = dst_dir + '\\' + f
                    shutil.copy(src_file, dst_file)
    
    # 备份pdb
    def backupPdb(self):
        for src_dir in self.__src_dir_list:
            print 'Backup pdb : ' + src_dir
            self.__doBackupDir(src_dir)
    
    # 构造函数
    def __init__(self, version, src_dir_list, pdb_dir):
        self.__version = version
        self.__pdb_dir = pdb_dir
        self.__src_dir_list = src_dir_list
        
