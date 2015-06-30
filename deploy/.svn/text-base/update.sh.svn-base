#/bin/bash
MYPATH=`pwd`
echo $MYPATH
update()
{
	echo "mkdirs ignore all errors"
	/bin/mkdir /home/rzrk/backup
	/bin/mkdir /home/rzrk/db_bak
	/bin/mkdir /home/rzrk/db_bak/bak
	/bin.mkdir /home/rzrk/server/userdata
	/bin/mkdir /home/rzrk/server/userdata/pids
	/bin/rm -rf /home/rzrk/server/bin/core*
	/usr/bin/python Deploy.py 2 .
	crontab /home/rzrk/crontab
	ldconfig
	/home/rzrk/server/monitor/dailyRestart.sh
	cd $MYPATH
	echo "check update info"
	/usr/bin/python Deploy.py 1 update.json check.json
	if test -f check.json; then
		echo "check error, please read check.json!"
		echo 'cat check.json'
	fi
	UPSQLFILE="/home/rzrk/server/monitor/updateSQL.sh"
	if [ -f "$UPSQLFILE" ]; then
       chmod +x $UPSQLFILE
       /home/rzrk/server/monitor/updateSQL.sh
    fi

}

if [ "$1" = "0" ]
then
	echo "back up"
	/usr/bin/python Deploy.py 0 .
	echo "check local is changed"
	/usr/bin/python Deploy.py 1 lastUpdate.json changed.json
	if test -f changed.json; then
		/usr/bin/python Deploy.py 4 changed.json modify.tar.gz
		echo "file has changed, please submit to xt manager"
	else
		update
	fi
elif [ "$1" = "1" ]
then
	echo "direct"
	update
else
	rm -rf _update
	mkdir _update
	tar -xzvf $1 -C _update
	cd _update
	chmod +x update.sh
	./update.sh 0
	rm update.sh
	cp ../update.sh update.sh
	./update.sh 1
fi