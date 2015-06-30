#coding=utf8
from customer import ConfigGenerator

__author__ = 'xujun'
import datetime


class Machine(object):
    def __init__(self):
        self.name = ""  # 机器名称
        self.code = "" # 机器码
        self.customer = "" # 客户
        self.modules = []   # 机器用到的功能模块
        self.config = {}
        self.remark = ""
        self.os = "" # 操作系统
        self.updateTime = datetime.datetime.now()

class MachineDetail(Machine):
    def __init__(self):
        self.config = {} # 配置信息
        self.fileInfos = []  # 文件信息
        self.localFileInfo = [] # 本地文件信息
