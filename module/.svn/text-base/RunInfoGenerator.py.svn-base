#coding=utf8
__author__ = 'xujun'
from utils.StringHelper import replaceStr
from TTEngine.constants import RUN_TYPE_TIMER, RUN_TYPE_MASTER_ALWAYS

RUN_PROCESS_SCRIPT = """\
source /etc/profile
#!/bin/sh
CURDIR=`pwd`
PIDPATH=/home/rzrk//server/userdata/pids/{{run_info_name}}.pid
pid=`cat $PIDPATH`
echo $pid
if test -n "$pid"
then
echo "pid is valid"
ps -p $pid
echo "$?"
if [ $? -gt 1 ];
then
echo "kill $pid"
kill $pid
fi
fi

ulimit -c unlimited
cd {{workingDir}}
export LC_ALL=C
nohup {{runParam}} > /dev/null 2>&1 &
echo "$!" > $PIDPATH
cd $CURDIR
"""

WIN_RUN_PROCESS_SCRIPT = """\
@echo off

c:\python27\python MasterRun.py {{run_info_name}} {{xtDir}}\home\\rzrk\old.txt {{xtDir}}\home\\rzrk\\new.txt {{workingDir}}

"""


CHECK_PROCESS_SCRIPT="""\
{{xtDir}}/server/monitor/checkProgram.sh  {{runInfo}}\
"""

DAEMON_RUN_SCRIPT = """\
#!/bin/bash
source /etc/profile
exec 2>&1
ulimit -c unlimited
cd {{workingDir}}
export LC_ALL=C
{{runParam}}

"""

DAILY_RESTART = """\
#!/bin/bash

# clear cache
echo 1 > /proc/sys/vm/drop_caches
sysctl -p

# mkdir
/bin/mkdir /home/rzrk/server/userdata
/bin/mkdir /home/rzrk/server/userdata/sfit
/bin/mkdir /home/rzrk/server/userdata/pids

# clear sfits
/home/rzrk/server/monitor/brokerMonitor.sh
/bin/rm -rf /home/rzrk/server/userdata/sfit/cache
/bin/rm -rf /home/rzrk/server/userdata/sfit/temp
/bin/rm -rf /home/rzrk/server/userdata/sfit/data
# clear pids
/bin/rm -rf /home/rzrk/server/userdata/pids/*

# core
echo "core_%e" > /proc/sys/kernel/core_pattern

if [ "$1" = "1" ]
then
/usr/bin/killall /usr/local/bin/lua haproxy XtBroker XtQueryFutureCTP {{Processes}}
else
/usr/bin/killall /usr/local/bin/lua python haproxy XtBroker XtQueryFutureCTP {{Processes}}
fi

"""

WIN_DAILY_RESTART = """\
@echo off
md {{xtDir}}\home\\rzrk\server\userdata\sfit
md {{xtDir}}\home\\rzrk\server\userdata\pids

del {{xtDir}}\home\\rzrk\server\userdata\sfit\cache
del {{xtDir}}\home\\rzrk\server\userdata\sfit\\temp
del {{xtDir}}\home\\rzrk\server\userdata\sfit\data

rmdir /s /q {{xtDir}}\home\\rzrk\server\userdata\pids

if "%1" EQU "1" (
c:\windows\system32\\taskkill /f /im haproxy* XtBroker* XtQuoter* XtService* XtRiskControl* XtTraderService* XtTask* /t)
else
c:\windows\system32\\taskkill /f /im lua* python* haproxy* XtBroker* XtQuoter* XtService* XtRiskControl* XtTraderService* XtTask* /t
"""


def getCrontable(runInfos, xtDir):
    strRuns = []
    for info in runInfos:
        if info.runType == RUN_TYPE_TIMER:
            runParam = info.runParam.strip()
            workingDir = info.workingDir.strip()
            str = ""
            if len(workingDir) > 0:
                runParam = "`cd %s; %s`" % (workingDir, runParam)
                str = info.timerParam + " %s" % runParam
            else:
                runParam = "`%s`" % runParam
                str = info.timerParam + " %s" % runParam
            if len(str) > 0:
                strRuns.append(str)
    ret = "\n".join(strRuns)
    ret = ret + "\n"
    ret = replaceStr(ret, {"xtDir":xtDir})
    return ret

def genCheckAll(runInfos, xtDir):
    ret = "\n".join([replaceStr(CHECK_PROCESS_SCRIPT, {"runInfo":info.run_info_name}) for info in runInfos if info.runType == RUN_TYPE_MASTER_ALWAYS])
    ret = replaceStr(ret, {"xtDir":xtDir})
    return ret


def genDailyRestart(runInfos):
    restarts = []
    for info in runInfos :
        if info.runType == RUN_TYPE_MASTER_ALWAYS:
            items = info.runParam.strip().split()
            if len(items) > 0:
                processName = items[0].split("/")[-1]
                if processName == "python" or processName == "lua":
                    continue
                restarts.append(processName)
    restarts = list(set(restarts))
    str = " ".join(restarts)
    ret = DAILY_RESTART
    ret = replaceStr(ret, {"Processes":str})
    return ret


def win_genDailyRestart(runInfos):
    restarts = []
    for info in runInfos :
        if info.runType == RUN_TYPE_MASTER_ALWAYS:
            items = info.runParam.strip().split()
            if len(items) > 0:
                processName = items[0].split("/")[-1]
                if processName == "python" or processName == "lua":
                    continue
                restarts.append(processName)
    restarts = list(set(restarts))
    str = " ".join(restarts)
    ret = WIN_DAILY_RESTART
    ret = replaceStr(ret, {"Processes":str})
    return ret

	
def win_genDailyRestart(runInfos):
    restarts = []
    for info in runInfos :
        if info.runType == RUN_TYPE_MASTER_ALWAYS:
            items = info.runParam.strip().split()
            if len(items) > 0:
                processName = items[0].split("/")[-1]
                if processName == "python" or processName == "lua":
                    continue
                restarts.append(processName)
    restarts = list(set(restarts))
    str = " ".join(restarts)
    ret = WIN_DAILY_RESTART
    ret = replaceStr(ret, {"Processes":str})
    return ret

