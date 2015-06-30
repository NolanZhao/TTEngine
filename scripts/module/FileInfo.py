#coding=utf8
__author__ = 'xujun'

# 文件信息
class FileInfo(object):
    FILE_TYPE_UNKNOWN = 0
    FILE_TYPE_COMPILE = 1
    FILE_TYPE_CONFIG = 2
    FILE_TYPE_SCRIPT = 3
    FILE_TYPE_LINK = 4

    def __init__(self, **entries):
        self.filePath = ""  # 文件路径(包含了文件名)
        self.rawPath = ""       # 原始路径
        self.mod = 644
        self.descript = ""      # 描述信息
        self.remark = ""        # 备注
        self.fileType = self.FILE_TYPE_UNKNOWN      # 文件类型
        self.__dict__.update(entries)

# 详细配置
class FileInfoDetail(FileInfo):
    def __init__(self, file):
        self.sha1 = ""
        self.createTime = ""
        self.modifyTime = ""
        self.size = 0
        self.svnVersion = ""
        if isinstance(file, FileInfo):
            self.__dict__.update(file.__dict__)
        else:
            self.__dict__.update(file)

    def toDict(self):
        return self.__dict__
