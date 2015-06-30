__author__ = 'whs'
#coding=utf8
import time
import re
import os
import subprocess
import sys
import shutil
def checkstart(temp,path,new_path):
    file = open(path,'r')
    pids = file.read()
    print type(pids)
    print type(pids.strip().split())
    new_file = open(new_path,'r')
    new_pids = new_file.read()
    for pid in pids:
        if pid not in new_pids:
            cmd = 'start %s' %temp_path
            os.system(cmd)
    SearchPID(temp,path)


def SearchPID(temp,path):
    '''Find Proccess Name,Return PID'''
    f = open(path,'w')
    ProcMessage = os.popen('tasklist').readlines()
    rule = re.compile('\s\d+\s')
    print ('Proc Name status PID')
    for eachline in ProcMessage: # Get a list of running process message to match
        if eachline.find(temp)==0: # if 0 ,Find the process to be killed
            ret = re.search(rule,eachline) # Get the PID
            print (temp,' running ',ret.group(0))
            f.write(ret.group(0)) # Add {process name:PID} to the Table list
    f.close()
    f = open(path,'r')
    date = f.read()
    if len(date) == 0:
        f.close()
        cmd = 'start %s' %temp_path
        os.system(cmd)
        SearchPID(temp,path)
    else:
        f.close()
    checktag(temp,path,new_path)

def SearchPID_new(temp,path):
    '''Find Proccess Name,Return PID'''
    f = open(path,'w')
    ProcMessage = os.popen('tasklist').readlines()
    rule = re.compile('\s\d+\s')
    print ('Proc Name status PID')
    for eachline in ProcMessage: # Get a list of running process message to match
        if eachline.find(temp)==0: # if 0 ,Find the process to be killed
            ret = re.search(rule,eachline) # Get the PID
            print (temp,' running ',ret.group(0))
            f.write(ret.group(0)) # Add {process name:PID} to the Table list
    f.close()


def checktag(temp,path,new_path):
    time.sleep(5)
    SearchPID_new(temp,new_path)
    checkstart(temp,path,new_path)

if __name__ == "__main__":
    new_path = sys.argv[3]
    temp_path = sys.argv[4]
    SearchPID(sys.argv[1],sys.argv[2])
