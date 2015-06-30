__author__ = 'rzrk001'
# encoding=utf-8
import os,shutil,sys,subprocess,tarfile,time
from os.path import isdir
def a():
    #先判断update文件夹存在与否，若存在则继续，若不存在，则新建
    #判断update下是否有_update文件夹，若存在则先删除，在新建，不存在直接新建
    #将下载的安装包解压放入_update文件夹下
    #运行update.sh脚本、(先备份，再执行)
    #在检验那些程序有没有启动
    #还应该修改keepalived
    if not os.path.exists("C:\\home\\rzrk\\update"):
        os.makedirs("C:\\home\\rzrk\\update")
    if os.path.exists("C:\\home\\rzrk\\update\\_update"):
        os.rmdir("C:\\home\\rzrk\\update\\_update")
    os.makedirs("C:\\home\\rzrk\\update\\_update")
    copy_folders("C:\\Users\\rzrk001\\Downloads\\247_192.168.1.247_20140904_install","C:\\update\\_update")
    #备份update.sh
    copy_file("C:\\update\\_update\\update.sh","C:\\home\\rzrk\\backup")

    print '-------------------------------'
#拷贝文件夹
def copy_folders(source,target_dir):
    if isdir(source) != True:
        print 'Error: source is not a directory'
        exit()
    filelist = os.listdir(source)
    print(filelist)
    for name in filelist :
        srcFilename = source + '\\' + name
        srcFilename = '"' + srcFilename + '"'
        desFilename = target_dir + '\\' + name
        desFilename = '"' + desFilename + '"'
        print
        copy_command = "copy %s %s" % (srcFilename, desFilename)
        print copy_command
        if os.system(copy_command) == 0:
            print 'Successful backup to copy from', srcFilename, 'to' ,desFilename
        else:
            print 'Fail to copy', srcFilename, 'to', desFilename
        print 'total copy', k, 'files'
    # for file in os.listdir(dir):
    #     if  os.path.splitext(file)[1]=='.gz':
    #         print '%s' % file
    #         os.path.isfile(file)
    #         tar = tarfile.open("file","r:")
    #         names = tar.getnames()
    #         for name in names:
    #             tar.extract(name,path="C:\\update")
    #         tar.close()

#拷贝文件
def copy_file(source,target_dir):
    shutil.copy(source,  target_dir)


if __name__ == "__main__":
    print '123'
    a()