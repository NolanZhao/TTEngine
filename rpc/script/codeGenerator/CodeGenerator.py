#!/usr/bin/python
#coding=utf-8
__author__ = 'Administrator'
from StockClientCodeGenerator import *
from StockServerCodeGenerator import *
from base.RPCParser import *
from ServerCodeGenerator import *
from StdClientCodeGenerator import *
from StructCppCodeGenerator import *
from LuaCodeGenerator import *
import sys
import codecs as codecs
import os


def parseFileName(filePath):
    print filePath
    posA = filePath.rfind('\\')
    posB = filePath.rfind('/')
    if posA < posB:
        posA = posB
    return filePath[posA + 1:]


def parseFile(inputFile, typeManager):
    inputHandler = codecs.open(inputFile, 'r', 'utf-8')
    parser = RPCParser()
    data = inputHandler.read()
    desc = parser.parse(data)
    desc.genTypeInfos(typeManager)
    return desc


def saveFile(outputFile, str):
    print outputFile
    rawData = u""
    try:
        handler = codecs.open(outputFile, 'r', 'utf-8')
        rawData = handler.read().decode()
        rawData = rawData.lstrip(unicode(codecs.BOM_UTF8, "utf8"))
    except:
        pass

    if (rawData != str):
        outputHandler = codecs.open(outputFile, 'w', 'utf-8')
        outputHandler.write(codecs.BOM_UTF8)
        outputHandler.write(str)
        outputHandler.close()
        #os.chmod(outputFile, stat.S_IREAD)


def genClientCode(desc, typeManager, outputFile):
    generator = ClientCodeGenerator(desc, typeManager)
    codes = generator.genCodes()
    saveFile(outputFile, codes)


def genStdClientCode(inputFile, outputFile, isStock=False):
    typeManager = StdTypeManger()
    desc = parseFile(input, typeManager)
    generator = None
    if isStock:
        generator = StockClientCodeGenerator(desc, typeManager)
    else:
        generator = StdClientCodeGenerator(desc, typeManager)
    codesDefine = generator.genCodes()
    codesRealize = generator.genCodesRealize(parseFileName(outputFile))
    saveFile(outputFile, codesDefine)
    saveFile(outputFile.replace(u".h", u".cpp"), codesRealize)


def genHppCode(inputFile, outputFile, baseName="", isStock=False):
    typeManager = StdTypeManger()
    desc = parseFile(inputFile, typeManager)
    generator = None
    if isStock:
        generator = StockClientCodeGenerator(desc, typeManager)
    else:
        generator = StdClientCodeGenerator(desc, typeManager)
    codesDefine = generator.genCodesHpp(baseName)
    saveFile(outputFile, codesDefine)


def genServerCode(desc, typeManager, outputFile, isStock=False):
    generator = None
    if isStock:
        generator = StockServerCodeGenerator(desc, typeManager)
    else:
        generator = ServerCodeGenerator(desc, typeManager)
    codesDefline = generator.genCodes()
    codesRealize = generator.genCodesRealize(parseFileName(outputFile))
    saveFile(outputFile, codesDefline)
    saveFile(outputFile.replace(u".h", u".cpp"), codesRealize)


def genStdServerCode(inputFile, outputFile, isStock=False):
    typeManager = StdTypeManger()
    desc = parseFile(input, typeManager)
    genServerCode(desc, typeManager, outputFile, isStock)


def genCppCode(inputFile, outputFile, isStock=False):
    typeManager = StdTypeManger()
    desc = parseFile(input, typeManager)
    generator = StructCppCodeGenerator(desc, typeManager)
    codes = generator.genCodes()
    saveFile(outputFile, codes)


def genLuaHCode(inputFile, outputFile):
    typeManager = StdTypeManger()
    desc = parseFile(input, typeManager)
    generator = LuaHCodeGenerator(desc, typeManager)
    codes = generator.genCodes()
    saveFile(outputFile, codes)


def genLuaCppCode(inputFile, outputFile):
    typeManager = StdTypeManger()
    desc = parseFile(input, typeManager)
    generator = LuaCppCodeGenerator(desc, typeManager)
    codes = generator.genCodes()
    saveFile(outputFile, codes)


def genStructDefCode(inputFile, outputFile):
    typeManager = StdTypeManger()
    desc = parseFile(inputFile, typeManager)
    generator = LuaCppCodeGenerator(desc, typeManager)
    codes = generator.genStructDefCodes()
    saveFile(outputFile, codes)


def genCodes(tag, input, output):
    #if  inputTime >= outputTime or outputTime == 0:
    print tag, input, output
    if True:
        if typeName == u"STDCLIENT":
            genStdClientCode(input, output)
        elif typeName == u"STDSERVER":
            genStdServerCode(input, output)
        elif typeName == u"STDSTOCKCLIENT":
            genStdClientCode(input, output, True)
        elif typeName == u"STDSTOCKSERVER":
            genStdServerCode(input, output, True)
        elif typeName == u"STRUCT":
            baseName = os.path.basename(input)[0:-4]
            hOutput = output + "/" + "rpc_%s.h" % baseName;
            genHppCode(input, hOutput, baseName)
            cppOutput = output + "/" + "rpc_%s.cpp" % baseName;
            genCppCode(input, cppOutput, True)
            luaHOutput = output + "/" + "rpc_%s_lua.h" % baseName;
            genLuaHCode(input, luaHOutput)
            luaCppOutput = output + "/" + "rpc_%s_lua.cpp" % baseName;
            genLuaCppCode(input, luaCppOutput)
            structDefHOutput = output + "/" + "rpc_%s_Def.h" % baseName
            genStructDefCode(input, structDefHOutput)
    else:
        print "no change"


if __name__ == "__main__":
    reload(sys)
    sys.setdefaultencoding("utf-8")

    # typeName = sys.argv[1].upper()
    # input = sys.argv[2]
    # output = sys.argv[3]
    # print sys.argv
    # genCodes(typeName, input, output)

    #    typeName = u"STDSERVER"
    #    input =  u"Trader.rpc"
    #    output = u"Trader.h"
    #    #print sys.argv
    #    genCodes(typeName, input, output)

    #测试解析RPC文件

    typeManager = StdTypeManger()
    desc = parseFile('D:/workspace_py/TTEngine/rpc/protocols/traderbase/Structs.rpc', typeManager)
    print 'here it is'