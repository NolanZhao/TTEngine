#coding=utf8
__author__ = 'Administrator'

import os
import sys
import shutil
if __name__ == u"__main__":
    reload(sys)
    sys.setdefaultencoding( "utf-8" )
    print sys.argv
    input =  unicode(sys.argv[1])
    output = unicode(sys.argv[2])
    print input
    print output

    # 检查输入文件更新时间, 如果input更新早则生成, 否则不生成
    files = os.listdir(input)
    for file in files:
        if file.endswith(u".rpc"):
            inputFile = input + u"/" + file
            outputFile = output + u"/" + file
            inputTime = os.stat(inputFile).st_mtime
            outputTime = 0
            try :
                outputTime =  os.stat(outputFile).st_mtime
            except :
                pass
            if  inputTime >= outputTime or outputTime == 0:
                print(u"copy %s to %s" % (inputFile, outputFile))
                shutil.copy(inputFile, outputFile)
