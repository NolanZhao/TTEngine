# coding=utf8
import sys

reload(sys)
sys.setdefaultencoding('utf-8')
__author__ = 'Administrator'
import re
import logging

try:
    from rpc.script.codeGenerator.RPCStruct import *
except:
    from rpc.script.codeGenerator.base.RPCStruct import *

import hashlib

logger = logging.getLogger('django')


class RPCParser:
    def parse(self, rawString):
        # 根据换行符分组
        lines = rawString.splitlines()
        # 去掉注释行
        rawString = u"\n".join([line for line in lines if not line.strip().startswith(u"#") and not line.strip().startswith(u"//")])

        # 解析
        desc = RPCDescript()
        desc.nameSpace = self.parseNameSpace(rawString)
        desc.serviceName = self.parseServiceName(rawString)
        desc.HppIncludes = self.parseIncludes('Includes', rawString)
        desc.CppIncludes = self.parseIncludes('CppIncludes', rawString)
        desc.serverIncludes = self.parseIncludes('ServerIncludes', rawString)
        desc.clientIncludes = self.parseIncludes('ClientIncludes', rawString)
        desc.enums = self.parseEnums(rawString)
        desc.structs = self.parseStructs(rawString)
        desc.functions = self.parseFunctions(rawString)
        desc.pushFunctions = self.parsePushFunctions(rawString)
        desc.subFunctions = self.parseSubFunctions(rawString)
        desc.consts = self.parseConsts(rawString)
        desc.packType = self.parsePackType(rawString)
        desc.isNewError = self.parseIsNewError(rawString)
        return desc

    def parseNameSpace(self, rawString):
        #print(u"parse namespace")
        mret = re.search(u"Namespace\s*=\s*(\w+)\s*", rawString, re.IGNORECASE)
        if mret != None:
            return mret.group(1)
        else:
            return u""

    def parseServiceName(self, rawString):
        #print(u"parse service name")
        mret = re.search(u"ServiceName\s*=\s*(\w+)\s*", rawString, re.IGNORECASE)
        if mret != None:
            return mret.group(1)
        else:
            return u""
            #raise Exception("parse service name error")

    def parsePackType(self, rawString):
        #print(u"parse namespace")
        mret = re.search(u"PackType\s*=\s*(\w+)\s*", rawString, re.IGNORECASE)
        if mret != None:
            return mret.group(1)
        else:
            return u"1"

    def parseIsNewError(self, rawString):
        #print(u"parse service name")
        mret = re.search(u"IsNewError\s*=\s*(\w+)\s*", rawString, re.IGNORECASE)
        if mret != None:
            return True
        else:
            return False
            #raise Exception("parse service name error")

    def parseConsts(self, rawString):
        #print(u"parse const defines")
        ret = []
        constList = re.findall(u"\w+\([^\)]+\)\s*:\s*[^;]+;", rawString, re.IGNORECASE)
        for line in constList:
            line = line.strip()
            mret = re.search(u"\s*(?P<name>\w+)\s*\((?P<type>[^\)]+)\s*\)\s*:\s*(?P<value>[^;]+);", line, re.IGNORECASE)
            if mret and mret.group(u"name") and mret.group(u"type") and mret.group(u"value"):
                aconst = ConstItem()
                aconst.name = mret.group(u"name").strip()
                aconst.type = mret.group(u"type").strip()
                aconst.value = mret.group(u"value").strip()
                m = re.search(u"//(.*)", line)
                if m: aconst.comment = m.group(1).strip()
                ret.append(aconst)
        return ret

    def parseIncludes(self, tag, rawString):
        #print(u"parse includes")
        ret = []
        reString = tag + u"\s*=\s*\(([^)]*)\)\s*"
        mret = re.search(reString, rawString, re.IGNORECASE)
        if mret != None:
            content = mret.group(1)
            ret = re.findall(u"\s*([^\s]+)", content)
            ret = [item.strip(",").strip() for item in ret if len(item.strip()) > 0]
        return ret

    def parseEnums(self, rawString):
        #print(u"parse enum")
        strEnums = re.findall(u"enum_\w+\s*:\s*\([^\)]+\)(?:\s*\{[^\}]+\}){0,1}", rawString, re.MULTILINE)
        enums = []
        for anEnum in strEnums:
            enum = Enum()
            m = re.match(u"enum_(?P<name>\w+)\s*:\s*\((?P<content>[^\)]+)\)\s*(\{(?P<property>[^\}]+)\}){0,1}", anEnum)
            enum.name = m.group(u"name")
            propertys = m.group(u"property")
            if propertys:
                propertys = propertys.strip().split(",")
                tmp = propertys
                propertys = []
                for i in tmp:
                    propertys.append(i.strip())
                    #print "parseEnums propertys: ",propertys
            else:
                propertys = []
            for property in propertys:
                enum.property[property] = 1
            strContents = re.findall(u"\w+\s*[^;]+.*", m.group(u"content"), re.MULTILINE)
            contents = []
            for x in strContents:
                item = EnumItem()
                m = re.search(u"//(.*)", x)
                if m: item.comment = m.group(1).strip()
                tmp = ""
                if x.find(u":") > 0:
                    tmp = re.match(u"(\w+(\s*\|[^;]*){0,1})\s*:\s*[^;]", x).group(1).strip()
                else:
                    tmp = re.match(u"(\w+(\s*\|[^;]*){0,1})", x).group(1).strip()
                if (tmp.find("|") >= 0):
                    item.name, item.chsname = tmp.split("|")
                else:
                    item.name = tmp.split("|")[0]
                    item.chsname = item.comment
                #if item.chsname:
                #    print "chs:", item.chsname,"  ",item.name
                m = re.search(u"[\w\s]*:\s*([^;]+);", x)
                if m:
                    item.value = m.group(1).strip()
                enum.items.append(item)
            enums.append(enum)
        return enums

    #根据输入的key，清洗出我需要的字符串
    def cleanStr(self, raw, key):
        searchStr = u"%s\s*=\s*(?P<ret>[^;:]+)" % (key)
        m = re.search(searchStr, raw)
        try:
            return m.group(u"ret").strip()
        except:
            return u""


    def _init_structs_id(self, structs):
        """
        生成structs_id
        :param structs:
        :return:
        """

        result = {}
        #指定ID
        owned_defines = []
        #未指定ID
        struct_defines = []

        for struct in structs:
            #指定ID
            if not struct.property.has_key("old") and struct.property.has_key("structId"):
                owned_defines.append([struct.name, int(struct.property["structId"])])
            #未指定ID
            elif not struct.property.has_key("old") and not struct.property.has_key("structId"):
                struct_defines.append(struct.name)
            else:
                print '例外情况![name=%s][property=%s]' % (struct.name, struct.property)

        #计算起始ID,为未指定ID的结构体赋值
        start_id = None
        if len(struct_defines) > 0:
            m = hashlib.md5()
            m.update(structs[0].name)
            md5 = m.hexdigest()
            start_id = int(md5[0:2], 16) * 100

        if start_id is not None:
            for item in struct_defines:
                start_id += 1
                if result.has_key(item):
                    print('初始化结构体ID发现名称[%s]重复!将覆盖原值[ID=%s]!' % (item, result[item]))
                result[item] = start_id

        #为指定ID的结构体赋值
        for item in owned_defines:
            name = item[0]
            value = item[1]
            if result.has_key(name):
                print('初始化结构体ID发现名称[%s]重复!将覆盖原值[ID=%s]!' % (name, result[name]))
            result[name] = value

        for struct in structs:
            if result.has_key(struct.name):
                struct.id = result[struct.name]
            else:
                print('初始化结构体ID列表未发现结构体[name=%s]!' % struct.name)
        return


    def parseStructs(self, rawString):
        strStructs = re.findall(u"\w+(?:\s*\|\s*[^:]+){0,1}\s*:\s*\([^\)]+\)(?:\s*\{[^\}]+\}){0,1}", rawString)
        structs = []

        for aStruct in strStructs:
            #print "parse struct %s" % repr(aStruct)
            m = re.search(u"(?P<name>\w+)(\s*\|\s*(?P<base>[^:]+)){0,1}\s*:\s*\((?P<content>[^\)]+)\)\s*(\{(?P<property>[^\}]+)\}){0,1}", aStruct)
            baseType = m.group(u"base")
            name = m.group(u"name").strip()
            strContents = m.group(u"content").strip()
            if name.startswith(u"enum"):
                continue
            struct = Struct()
            struct.name = name
            if baseType is not None:
                struct.baseType = baseType.strip()
            propertys = m.group(u"property")
            if propertys:
                propertys = propertys.strip().split(",")
                tmp = propertys
                propertys = []
                for i in tmp:
                    if i.find("=") >= 0:
                        d = i.strip()
                        kvItem = d.split("=")
                        if len(kvItem) == 2:
                            struct.property[kvItem[0].strip()] = kvItem[1].strip()
                    else:
                        struct.property[i.strip()] = 1
                        #print "propertys: ",propertys
            strItems = re.findall \
                (u"\w+\s*:[^;:]+(?:\s*\|\s*index\s*=\s*[^;\|]*\s*\
                \|\s*name\s*=\s*[^;\|]*\s*\|\s*isKey\s*=\s*[^;\|]*\s*\|\s*precision\s*=\s*[^;\|]*\s*\|\s*flag\s*=\
                \s*[^;\|]*\s*\|\s*invisible\s*=\s*[^;\|]*){0,1}(?:\s*\|\s*property\s*=\s*[^;\|]*){0,1}(?:\s*\|\s*func\s*=\s*[^;\|]*){0,1}.*",
                 strContents, re.MULTILINE)
            maxNum = 0
            hasTagKey = False
            for strItem in strItems:
                strItem = strItem.strip()
                item = StructItem()
                m = re.search(u"//(.*)", strItem)
                if m:
                    item.comment = m.group(1).strip()
                content = strItem[0:strItem.index(";")]
                itemList = content.split(":", 1)
                if len(itemList) >= 2:
                    item.name = itemList[0].strip()
                    if (not hasTagKey and item.name == "m_strTagKey"):
                        hasTagKey = True
                        continue
                    propertyList = itemList[1].split("|", 10)
                    str = ""
                    if (len(propertyList) >= 7):
                        str = propertyList[0].strip()
                        try:
                            item.num = int(self.cleanStr(propertyList[1], "index").strip())
                            maxNum = item.num
                        except:
                            maxNum += 1
                            item.num = maxNum
                        item.chsname = self.cleanStr(propertyList[2], "name").strip()
                        if len(item.chsname) == 0:
                            item.chsname = item.comment  #如果没有中文名，临时用备注代替
                        item.isKey = len(self.cleanStr(propertyList[3], "isKey").strip()) > 0
                        ts = self.cleanStr(propertyList[4], "precision").strip()
                        if len(ts) > 0:
                            item.precision = (float)(ts)
                        ts = self.cleanStr(propertyList[5], "flag").strip()
                        if len(ts) > 0:
                            item.flag = ts
                        item.invisible = (self.cleanStr(propertyList[6], "invisible").strip())
                        if (len(propertyList) >= 8):
                            strpropertys = (self.cleanStr(propertyList[7], "property").strip())
                            if len(strpropertys) > 0:
                                item.propertys = strpropertys.strip().strip("[]").split(",")
                        if (len(propertyList) >= 9):
                            strfuncs = (self.cleanStr(propertyList[8], "func").strip())
                            if len(strfuncs) > 0:
                                item.funcs = strfuncs.strip().strip("[]").split("\'")
                    else:
                        struct.property["old"] = 1
                        str = itemList[1].strip()
                    defaultPos = str.find(u"=")
                    if defaultPos > 0:
                        default = str[defaultPos + 1:]
                        item.default = default.strip()
                        str = str[0:defaultPos].strip()
                    item.type = str
                    struct.items.append(item)
                    #if not hasTagKey:
                    #   item = StructItem()
                    #   item.name = "m_strTagKey"
                    #   item.num = maxNum + 1
                    #   item.type = "std::string"
                    #   struct.items.append(item)
            structs.append(struct)

        #初始化结构体ID
        self._init_structs_id(structs)
        return structs


    def parseFunctions(self, rawString):
        strFuncs = re.findall(u"\s*\w+\([^\)]*\)\s*=>\s*\([^\)]*\)", rawString)
        funcs = []
        for aFunc in strFuncs:
            m = re.search(u"(?P<name>\w+)\s*\((?P<inParam>[^\)]*)\)\s*=>\s*\((?P<outParam>[^\)]*)\)", aFunc)
            if m:
                inParams = self.parseParams(m.group(u"inParam"))
                outParams = self.parseParams(m.group(u"outParam"))
                func = Function(m.group(u"name").strip(), inParams, outParams)
                funcs.append(func)
        return funcs

    def parsePushFunctions(self, rawString):
        strFuncs = re.findall(u"=>\s*\w+\([^\)]*\)\s*", rawString)
        funcs = []
        for aFunc in strFuncs:
            #print "parse push function %s" % repr(aFunc)
            m = re.search(u"=>\s*(?P<name>\w+)\s*\((?P<inParam>[^\)]*)\)\s*", aFunc)
            if m:
                inParams = self.parseParams(m.group(u"inParam"))
                outParams = []
                func = Function(m.group(u"name").strip(), inParams, outParams)
                funcs.append(func)
        return funcs

    def parseSubFunctions(self, rawString):
        strFuncs = re.findall(u"\s*\w+\([^\)]*\)\s*==>\s*\([^\)]*\)", rawString)
        funcs = []
        for aFunc in strFuncs:
            m = re.search(u"(?P<name>\w+)\s*\((?P<inParam>[^\)]*)\)\s*==>\s*\((?P<outParam>[^\)]*)\)", aFunc)
            if m:
                inParams = self.parseParams(m.group(u"inParam"))
                outParams = self.parseParams(m.group(u"outParam"))
                func = Function(m.group(u"name").strip(), inParams, outParams)
                funcs.append(func)
        return funcs

    def parseParams(self, rawString):
        rawStringCopy = rawString.replace(';', ',')
        words = rawStringCopy.split(u",")
        params = []
        preWord = []
        for word in words:
            word = word.strip()
            if len(word) == 0:
                continue
            elif word.endswith(u"}"):
                preWord.append(word)
                param = u""
                for x in preWord:
                    if len(param) == 0:
                        param += x
                    else:
                        param += (u",", x)
                param = param.rstrip(u",")
                params.append(param)
                preWord = []
            else:
                params.append(word)

        paramList = []
        for param in params:
            pos = param.find(u":")
            name = param[0:pos].strip()
            typeStr = param[pos + 1:].strip()
            paramList.append([name, typeStr])
        return paramList


if __name__ == "__main__":
    d = u"suc:{#s : {#s: {#i:#d}} },fe:#s"
    parser = RPCParser()
    #print parser.parseParams(d)