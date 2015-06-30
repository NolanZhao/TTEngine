#coding=utf8
__author__ = 'RZRK_ZX'

MYSQL_MASTER_CONFIG = """\
grant replication slave on *.* to'root'@'192.168.1.%' identified by 'mysql.rzrk';
flush privileges;
show master status;

change master to master_host={{IpAddr}},master_user='root',
master_password='mysql.rzrk',master_log_file='mysql-bin.000003',master_log_pos=476;
start slave;
show slave status\G
"""

MYSQL_SLAVE_CONFIG = """\
grant replication slave on *.* to'root'@'192.168.1.%' identified by 'mysql.rzrk';
flush privileges;
show master status;

change master to master_host={{IpAddr}},master_user='root',
master_password='mysql.rzrk',master_log_file='mysql-bin.000003',master_log_pos=476;
start slave;
show slave status\G
"""

