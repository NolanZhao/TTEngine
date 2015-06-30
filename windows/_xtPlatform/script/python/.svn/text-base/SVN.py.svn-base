# -*- coding:utf-8 -*-

# 此脚本文件依赖win32平台。

import sys
import os


# svn类
class SVN:
   
    # 获取当前SVN版本号
    def __getRevision(self):
        tmp_info_file = 'tmp_svn_info.txt'
        cmd_line = 'svn info \"' + self.__root_path + '\" > ' + tmp_info_file
        r = ''
        if 0 != os.system(cmd_line):
            raise Exception('获取当前svn版本号遇到问题。')
        f = open(tmp_info_file)
        try:
            all_lines = f.readlines()
            for line in all_lines:
                segs = line.split(': ')
                if segs[0] == 'Last Changed Rev':
                    r = segs[1]
        except:
            raise Exception('读取svn版本号错误。')
        finally:
            f.close()
            if len(r) <= 0:
                raise Exception('未能读取到svn版本号')
            return r
    
    # 初始化函数
    def __init__(self, root_path, name):
        self.__root_path = root_path
        self.__name = name
        self.to_revision = 1
    
    # 获取日志结束版本
    def getToRevision(self):
        self.to_revision = int(self.__getRevision())
    
    # 更新svn
    def update(self):
        cmd_line = 'svn update \"' + self.__root_path + '\" --accept mine-full'
        print '\n--------------------'
        print '更新 ' + self.__name + ' SVN。'
        print cmd_line
        print '--------------------\n'
        if 0 != os.system(cmd_line):
            raise Exception('更新svn遇到问题。')

    # 还原
    def revert(self):
        cmd_line = 'svn revert \"' + self.__root_path + '\"'
        if 0 != os.system(cmd_line):
            raise Exception('还原' + self.__root_path + '遇到问题')

    # 获取svn更新日志
    def getLog(self, from_revision):
        tmp_log_file = 'tmp_svn_log.txt'
        all_text = ''
        if from_revision <= self.to_revision:
            cmd_line = 'svn log \"' + self.__root_path + '\" -r ' + str(self.to_revision) + ':' + str(from_revision) + ' > ' + tmp_log_file
            print cmd_line
            if 0 != os.system(cmd_line):
                raise Exception('获取svn日志遇到问题。')
            f = open(tmp_log_file)
            try:
                all_lines = f.readlines()
                for line in all_lines:
                    all_text = all_text + line + '<br/>'
            except:
                raise Exception('读取svn日志错误。')
            finally:
                f.close()
                return all_text
        return all_text

