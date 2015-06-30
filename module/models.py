# encoding=utf-8
from mongoengine import *
from TTEngine.constants import *
from TTEngine.constants import FILE_TYPE_DICT
from utils.StringHelper import replaceStr
from module.RunInfoGenerator import RUN_PROCESS_SCRIPT, DAEMON_RUN_SCRIPT,WIN_RUN_PROCESS_SCRIPT
from utils.PathHelper import getMonitorDir
from TTEngine.mongoSettings import mongo_connect
from utils.OsHelper import isWindows, isThisWindows, OS_TYPE_LINUX, OS_TYPE_WINDOWNS

mongo_connect()


class RunInfo(Document):
    run_info_name = StringField(max_length=90, required=True, verbose_name="运行名称", help_text="")
    workingDir = StringField(max_length=90, required=True, verbose_name="运行目录", help_text="")
    runParam = StringField(max_length=200, required=True, verbose_name="运行参数", help_text="")
    runTypeDict = {
        RUN_TYPE_NONE: '不运行',
        RUN_TYPE_SETUP: '安装时运行',
        RUN_TYPE_MASTER_ALWAYS: '主机运行',
        RUN_TYPE_TIMER: '定时运行',
        RUN_TYPE_ALL_ALWAYS: '一直运行'
    }
    runType = IntField(required=True, verbose_name="运行类型", help_text="")
    timerParam = StringField(max_length=90, required=True, verbose_name="定时器参数", help_text="")

    def getRunScript(self, os, dir):
        path = None
        script = None
        if self.runType == RUN_TYPE_MASTER_ALWAYS:
            if not isWindows(os):
                path = getMonitorDir(os) + "run_" + self.run_info_name.strip() + ".sh"
                script = replaceStr(RUN_PROCESS_SCRIPT, {"run_info_name": self.run_info_name, "workingDir": self.workingDir, "runParam": self.runParam})
                script = replaceStr(script, {"xtDir": dir})
            else:
                path = getMonitorDir(os) + "run_win" + self.run_info_name.strip() + ".bat"
                script = replaceStr(WIN_RUN_PROCESS_SCRIPT, {"run_info_name": self.run_info_name, "workingDir": self.workingDir})
                script = replaceStr(script, {"xtDir": dir})
        elif self.runType == RUN_TYPE_ALL_ALWAYS:
            if not isWindows(os):
                path = "/service/%s/run" % self.run_info_name.strip()
                script = replaceStr(DAEMON_RUN_SCRIPT, {"run_info_name": self.run_info_name, "workingDir": self.workingDir, "runParam": self.runParam})
                script = replaceStr(script, {"xtDir": dir})
            else:
                path = "/service/%s.bat/run" % self.run_info_name.strip()
                script = replaceStr(WIN_RUN_PROCESS_SCRIPT, {"run_info_name": self.run_info_name, "workingDir": self.workingDir})
                script = replaceStr(script, {"xtDir": dir})
        return path, script


class FileInfo(Document):
    @staticmethod
    def get_file_type_dict():
        return FILE_TYPE_DICT

    @staticmethod
    def get_file_type_name(value):
        if value is not None and FileInfo.get_file_type_dict().has_key(value):
            return FileInfo.get_file_type_dict()[value]
        return None

    filePath = StringField(max_length=256, required=True, verbose_name="文件路径(包含了文件名)", help_text="")
    rawPath = StringField(max_length=300, required=True, verbose_name="原始路径", help_text="")
    mod = IntField(required=True, verbose_name="linux系统权限", help_text="")
    fileType = IntField(required=True, verbose_name="文件类型", help_text="")
    descript = StringField(max_length=90, required=True, verbose_name="描述信息", help_text="")
    remark = StringField(max_length=90, required=True, verbose_name="备注", help_text="")
    createTime = DateTimeField(required=True, verbose_name="创建时间", help_text="")
    updateTime = DateTimeField(required=True, verbose_name="更新时间", help_text="")


# 详细配置
class FileInfoDetail(Document):
    filePath = StringField(max_length=256, required=True, verbose_name="文件路径(包含了文件名)", help_text="")
    info = ReferenceField(FileInfo, verbose_name="文件简介")
    sha1 = StringField(verbose_name="文件sha1", help_text="")
    size = IntField(required=True, verbose_name="文件大小", help_text="")
    svnVersion = StringField(verbose_name="svn信息", help_text="")
    file = FileField(required=False, verbose_name="文件", help_text="")
    createTime = DateTimeField(required=True, verbose_name="创建时间", help_text="")
    updateTime = DateTimeField(required=True, verbose_name="更新时间", help_text="")

    def toDict(self):
        ret = {
            "path": self.filePath,
            "sha1": self.sha1,
            "size": self.size
        }
        try:
            ret["mod"] = self.info.mod
        except:
            pass
        return ret


class Module(Document):
    name = StringField(max_length=60, required=True, verbose_name="模块名称", help_text="")
    version = StringField(max_length=30, required=True, verbose_name="版本号", help_text="")
    createTime = DateTimeField(required=True, verbose_name="创建时间", help_text="")
    head = StringField(max_length=30, required=True, verbose_name="负责人", help_text="", default="未知")
    files = ListField(ReferenceField(FileInfo))
    runInfos = ListField(ReferenceField(RunInfo))
    remark = StringField(max_length=900, verbose_name="备注", help_text="")
    group = StringField(max_length=900, verbose_name="所属分组", help_text="")

    def delete(self, **write_concern):
        from customer.models import Customer, Machine
        # 删除客户对应模块信息
        Customer.objects(modules__contains=self).update(pull__modules=self)

        # 删除机器对应模块信息
        Machine.objects(modules__contains=self).update(pull__modules=self)

        # 调用父类删除方法
        super(Module, self).delete()

class Group(Document):
    name = StringField(max_length=60, required=True, verbose_name="模块组名称", help_text="")
    createTime = DateTimeField(required=True, verbose_name="创建时间", help_text="")
    modules = ListField(ReferenceField(Module))
