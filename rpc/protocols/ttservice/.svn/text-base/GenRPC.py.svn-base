#coding=utf8
__author__ = 'Administrator'

import os
import subprocess

DEFAULT_FORMAT = ["STDCLIENT", "CPP"]
FILE_COMPLE_FORMAT = {
    "ClientTrader" : ["STDSERVER", "CPP"],
    "WebService" : ["STDSERVER", "CPP"],
    "TradingMonitorService" : ["STDSERVER", "CPP"]
}

def getGenFormat(inputName):
    inputName = inputName.strip()
    if inputName.endswith(u".rpc"):
        inputName = file[0:len(file)-4]
    ret = FILE_COMPLE_FORMAT.get(inputName, DEFAULT_FORMAT)
    return ret

if __name__ == "__main__":
    inputDir = os.getcwd()
    rawDir = "."
    inputDir = rawDir
    print inputDir
    pyPath = ""
    protocolDir = ""
    # 遍历目录结构, 找到最近的CodeGenerator.py和最近的Protocol目录
    while len(pyPath) == 0 or len(protocolDir) == 0:
        for root, dirs, files in os.walk(inputDir):
            for file in files :
                if file == "CodeGenerator.py" :
                    pyPath = os.path.join(root, file)
            for dir in dirs:
                if dir == "Protocol" :
                    protocolDir = os.path.join(root, dir)
        splits = os.path.split(inputDir)
        if splits[0] == inputDir :
            break
        else :
            inputDir = splits[0]

    print pyPath
    print protocolDir
    inputPath = ""
    for root, dirs, files in os.walk(rawDir):
        for file in files:
            print file
            if file.endswith(u".rpc"):
                file = file.strip()
                inputName = file[0:len(file)-4]
                inputPath = os.path.join(root, file)
                formats = getGenFormat(inputName)
                if formats[0] != None :
                    outputPath = os.path.join(protocolDir, "rpc_" + inputName + ".h")
                    subprocess.call(["python.exe", pyPath, formats[0], inputPath, outputPath],shell=True)
                if formats[1] != None :
                    outputPath = os.path.join(protocolDir, "rpc_" + inputName + ".cpp")
                    subprocess.call(["python.exe", pyPath, "CPP", inputPath, outputPath],shell=True)
