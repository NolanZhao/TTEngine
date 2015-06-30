#coding=utf8
__author__ = 'xj'

import time, paramiko, os, stat

def sftp_makedirs(sftp, dir):
    dir = dir.replace("\\", "/")
    items = dir.split("/")
    items = [ item for item in items if len(item) > 0]

    ownedIndex = 0
    for index in xrange(1, len(items) + 1):
        nowDir = "/" + "/".join(items[0:index])
        try:
            d = sftp.stat(nowDir)
            if  not stat.S_ISDIR(d.st_mode):
                ownedIndex = index
                break
        except:
            ownedIndex = index
            break

    for index in xrange(ownedIndex, len(items) + 1):
        nowDir = "/" + "/".join(items[0:index])
        print "make dir", nowDir
        sftp.mkdir(nowDir)

if __name__ == "__main__":
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect("192.168.1.164", username="root", password="123456")
    r1, r2, r3 = client.exec_command("pwd")
    for line in r2:
        print line

    sftp = paramiko.SFTPClient.from_transport(client.get_transport())

    sftp_makedirs(sftp, "/home/rzrk/server/update/_update/1/2/3")

    d = sftp.stat("/home/rzrk/server/update/")
    path = os.path.dirname(os.path.abspath(__file__)) + "\\PlatformTest.py"


    sftp.put(path, "/home/rzrk/server/update/_update/PlatformTest.py")

"""
    chanel = client.invoke_shell("linux")
    print chanel.recv(1024)
    time.sleep(1)
    chanel.send("cd /home/rzrk/server/bin/\n")
    print chanel.recv(1024)
    time.sleep(1)
    chanel.send("pwd")
    print chanel.recv(1024)
    print "end"
"""