#coding=utf8
__author__ = 'xujun'

from mongoengine import *

db_name = 'matrix_test'
db_host = "192.168.146.135"
db_port = 27017
db_user = "zhaoxu"
db_password = "123456"

def mongo_connect():
    connect(db_name, host=db_host, port=db_port, username=db_user, password=db_password)

mongo_connect()