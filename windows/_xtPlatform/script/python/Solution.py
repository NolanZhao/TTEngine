# -*- coding:utf-8 -*-

# 此脚本文件依赖win32平台。

import sys
import os
import time
import subprocess


SOLUTION_STATUS_READY = 0
SOLUTION_STATUS_RUNNING = 1
SOLUTION_STATUS_FINISHED = 2
SOLUTION_STATUS_ERROR = 3

# 项目编译类
class Solution:
    
    # 先Clean
    def __cleanSolution(self):
        cmd_line = 'devenv ' + self.__sln_fullpath + ' /Clean ' + '\"' + self.__configuration + '|' + self.__platform + '\"'
        print '\n--------------------\n清理' + self.__sln_file + '\n--------------------\n'
        print cmd_line
        if 0 != os.system(cmd_line):
            raise Exception('Clean solution失败。')

    # 再重新编译
    def __rebuildSolution(self, projects):
        for proj_name in projects:
            if os.path.isfile(self.build_log):
                os.remove(self.build_log)
            cmd_line = 'devenv ' + self.__sln_fullpath + ' /Build ' + '\"' + self.__configuration + '|' + self.__platform + '\"'
            if 0 != len(proj_name):
                #print 'proj_name:　', proj_name
                cmd_line = cmd_line + ' /Project ' + proj_name
            cmd_line = cmd_line + ' /Out ' + self.build_log
            print '\n--------------------\n编译' + self.__sln_file + '\n--------------------\n'
            print cmd_line
            self.__p = subprocess.Popen(cmd_line, shell = True)
            self.wait()
            if 0 != self.__p.returncode:
                self.__status = SOLUTION_STATUS_ERROR
                raise Exception('编译' + self.__sln_file + '失败。')
        if not SOLUTION_STATUS_ERROR == self.__status:
            self.__status = SOLUTION_STATUS_FINISHED
    
    # 编译项目
    def buildSolution(self, build, projects):
        if build:
            self.__status = SOLUTION_STATUS_RUNNING
            self.__rebuildSolution(projects)
        else:
            self.__status = SOLUTION_STATUS_FINISHED

    # 等待编译结束
    def wait(self):
        return self.__p.wait()

    # 终止编译
    def terminate(self):
        cmd = 'taskkill /f /t /pid ' + str(self.__p.pid)
        os.system(cmd)

    # 状态
    def status(self):
        return self.__status

    # 初始化函数
    def __init__(self, root_path, sln_file, clean, configuration = 'Release', platform='win32'):
        self.__sln_file = sln_file
        self.__sln_fullpath = root_path + '\\' + sln_file
        self.__ret = -1
        self.__status = SOLUTION_STATUS_READY
        self.__configuration = configuration
        self.__platform = platform
        self.build_log = self.__sln_fullpath + '.build_log.' + configuration + '.' + platform + '.txt'

        if clean:
            self.__cleanSolution()
        
