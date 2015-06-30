#!/bin/bash
#2014-07-24
#author: zhaoxu
#version 2.0

DATE=$(date +%Y%m%d)
#Mysql Database Backup
#mysqldump -uroot -pmysql.rzrk ttmgrportal > /home/rzrk/backup/ttmgrportal$DATE.sql
#mysqldump –-no-data -uroot -pmysql.rzrk ttmgrportal > /home/rzrk/backup/ttmgrportal$DATE.sql
#mysqldump -–add-drop-table -uroot -pmysql.rzrk ttmgrportal> /home/rzrk/backup/ttmgrportal$DATE.sql
mysqldump -uroot -pmysql.rzrk ttmgrportal | gzip > /home/rzrk/backup/ttmgrportal$DATE.sql.gz

#MongoDB Backup
#mkdir -p /home/rzrk/data/dump
/home/rzrk/mongodb/bin/mongodump -d ttengine -o /home/rzrk/data/dump
tar -zcvf /home/rzrk/data/dump/ttengine$DATE.tar.gz /home/rzrk/data/dump/ttengine
rm -rf /home/rzrk/data/dump/ttengine