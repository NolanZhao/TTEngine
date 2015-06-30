#!/bin/bash
#
# author: zoubailiu@thinktrader.net
#
#check redis role

HOSTSTATUSFILE=/home/rzrk/keepalived/conf/host.status
CHECKLOGFILE=/home/rzrk/server/userdata/log/check.log
REDISCLI=/home/rzrk/redis/bin/redis-cli
LOGDB='/usr/bin/python /home/rzrk/server/pyScripts/logdb.py'
ANOTHERHOST={{otherHost}}

#check redis-server
HOSTNAME=`/bin/hostname`
curcount=`ps -C  redis-server --no-header | wc -l`
DATETIME=`date "+%Y-%m-%d %T"`
if [ "$curcount" -lt "1" ]
then
	SHOWMSG="host:$HOSTNAME [ redis-server ] may be down, start it"
	echo $DATETIME $SHOWMSG 
        echo $DATETIME $SHOWMSG  >> $CHECKLOGFILE
        $LOGDB "$DATETIME" 1 "$SHOWMSG"
	service redis start
fi

#check local redis role
REDISSTATUS=`$REDISCLI info | grep role | awk -F: '{print $2}'`
REDISSTATUS=`echo -n $REDISSTATUS`
hoststatus=`cat $HOSTSTATUSFILE`
if [ "$hoststatus" = "master" ]
then
        if [ "${REDISSTATUS:0:5}" = "slave" ]
        then
                SHOWMSG="host:$HOSTNAME status is $hoststatus, but [ redis-server ] role is slave, change role"
		echo $DATETIME $SHOWMSG 
                echo $DATETIME $SHOWMSG  >> $CHECKLOGFILE
                $LOGDB "$DATETIME" 1 "$SHOWMSG"
		$REDISCLI slaveof no one
        fi
elif [ "$hoststatus" = "backup" ]
then
        if [ "${REDISSTATUS:0:6}" = "master" ]
        then
                SHOWMSG="host:$HOSTNAME status is $hoststatus, but [ redis-server ] role is master, change role"
		echo $DATETIME $SHOWMSG 
                echo $DATETIME $SHOWMSG  >> $CHECKLOGFILE
                $LOGDB "$DATETIME" 1 "$SHOWMSG"
		$REDISCLI slaveof $ANOTHERHOST 6379
	fi
fi
