# -*- coding:utf-8 -*-

# 此脚本文件依赖win32平台。

import sys

sys.path.append('../../../_xtPlatform/script/python/')
import BuildModule
import Solution
import Timer

from threading import Thread

class SolutionThread(Thread):

    def __init__(self, product_name, name, version, dir, sln, projects, clean, build, configuration = 'Release'):
        Thread.__init__(self)
        self.__product_name = product_name
        self.__name = name
        self.__version = version
        self.__dir = dir
        self.__sln = sln
        self.__projects = projects
        self.__clean = clean
        self.__build = build
        self.__stop = False
        self.__build_timer = Timer.Timer(1, self.__name)
        self.__build_solution = Solution.Solution(self.__dir, self.__sln, self.__clean, configuration)

    def run(self):
        print (self.__product_name + ' ' + self.__version + ' 正在编译' + self.__name + '……')
        self.__build_timer.start()
        try:
            self.__build_solution.buildSolution(self.__build, self.__projects)
            self.__build_timer.stop()
        except:
            self.__build_timer.stop()

    def status(self):
        return self.__build_solution.status()

    def log(self):
        return self.__build_solution.build_log

    def stop(self):
        self.__build_solution.terminate()
        self.__build_timer.stop()

    def timer(self):
        return self.__build_timer

