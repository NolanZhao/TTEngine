#coding=utf8
__author__ = 'xujun'

import time

class Module(object):
    def __init__(self, **entries):
        self.name = ""  # 模块名称
        self.version = "" # 版本
        self.createTime = "" # 创建时间
        self.files = [] # 文件， 此处包含的是FileInfo
        self.runInfos = [] # 运行信息, 此处包含的是RunInfo
        self.__dict__.update(entries)

    def getRunInfos(self):
        return self.runInfos

class ModuleDetail(Module):
    def __init__(self, **entries):
        self.customer = ""  # 客户
        self.machine = ""   # 机器
        self.fileDetails = [] # 文件详情
        self.updateTime = time.now() # 更新时间

        self.__dict__.update(entries)

    def getFileInfos(self):
        return self.fileDetails