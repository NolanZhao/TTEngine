#!/bin/bash
# author: zoubailiu@thinktrader.net
#

HOSTSTATUSFILE=/home/rzrk/keepalived/conf/host.status
CHECKLOGFILE=/home/rzrk/server/userdata/log/check.log
LOGDB='/usr/bin/python /home/rzrk/server/pyScripts/logdb.py'
HOSTNAME=`/bin/hostname`

#enable master_backup mode 1, else 0
master_backup={{isMasterBackup}}

DATETIME=`date "+%Y-%m-%d %T"`
if [ "$master_backup" != "1" ]
then
	#only one master
	echo "do nothing"
	echo "master" > $HOSTSTATUSFILE

else
	echo $1 > $HOSTSTATUSFILE
	case "$1" in
	   	master|backup|fault)
			SHOWMSG="host:$HOSTNAME enter [ $1 ] status"
			echo $1 > $HOSTSTATUSFILE
			echo $DATETIME $SHOWMSG 
                	echo $DATETIME $SHOWMSG  >> $CHECKLOGFILE
			$LOGDB "$DATETIME" 1 "$SHOWMSG"
			{{checkRedis}}
			;;
		*)
			echo "unknow param, " $1
			;;
	esac
fi
