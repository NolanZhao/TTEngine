#coding=utf8
__author__ = 'xujun'
from utils.StringHelper import replaceStr

class RunInfo(object):
    # 不运行
    RUN_TYPE_NONE = 0
    # 安装时运行
    RUN_TYPE_SETUP = 1
    # 一直运行
    RUN_TYPE_ALWAYS = 2
    # 定时运行
    RUN_TYPE_TIMER = 3

    def __init__(self, **entries):
        self.runName = ""       # 名称
        self.workingDir = ""     # 运行目录
        self.runParam = ""      # 运行参数
        self.runType = self.RUN_TYPE_SETUP # 运行类型
        self.timerParam = ""    # 定时器参数
        self.__dict__.update(entries)

    def getMonitor(runInfos):
        pass

    def toDict(self):
        return self.__dict__

    def isAlwaysRun(self):
        return self.runType == self.RUN_TYPE_ALWAYS

    def genAlwaysScript(self, dir):
        ret = replaceStr(self.RUN_PROCESS_SCRIPT, self.__dict__)
        ret = replaceStr(ret, {"xtDir":dir})
        return ret

    def genAlwaysCheck(self, dir):
        ret = replaceStr(self.RUN_PROCESS_ALWAYS_CHECK, self.__dict__)
        ret = replaceStr(ret, {"xtDir":dir})
        return ret

def getCrontable(runInfos, xtDir):
    strRuns = []
    for info in runInfos:
        if info.runType == RunInfo.RUN_TYPE_TIMER:
            runParam = info.runParam.strip()
            runParam = "`%s`" % runParam
            str = info.timerParam + " " + runParam
            if len(str) > 0:
                strRuns.append(str)
    ret = "\n".join(strRuns)
    ret = ret + "\n"
    ret = replaceStr(ret, {"xtDir":xtDir})
    return ret


if __name__ == "__main__":
    d = {u'runParam': u'./XtService ../config/config.lua',
         u'runType': 2,
         u'timerParam': u'',
         u'workingDir': u'{{xtDir}}/server/bin'
    }
    info = RunInfo(**d)
    print info