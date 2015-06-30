# coding=utf8
__author__ = 'Administrator'

import re
from datetime import date
from RPCTemplate import *
import hashlib

TAB_SIZE = 4


class RPCCodeGenerator():
    def __init__(self, desc, typeManager, tag=u"unknown"):
        self.desc = desc
        self.typeManager = typeManager
        self.tag = tag

    # must be inherit
    def genOneFunctionCode(self, func):
        return ""

    def genOneFunctionCodeRealize(self, func):
        return ""

    # must be inherit
    def genOnePushFunctionCode(self, func):
        return ""

    def genOnePushFunctionCodeRealize(self, func):
        return ""

    # must be inherit
    def genOneSubFunctionCode(self, func):
        return ""

    def genOneSubFunctionCodeRealize(self, func):
        return ""

    # must be inherit
    def genClassCode(self, offset):
        return ""

    def genClassCodeRealize(self, offset):
        return ""

    # must be inherit
    def genIncludeCodes(self, offset):
        return ""

    def genCodes(self, typeID=1, baseName=""):
        #temp = u'#include "utils/BsonHelper.h"\n'
        temp = ""
        if typeID == 1:
            ret = FILE_TEMPLATE_SERVICE_HPP
        elif typeID == 0:
            ret = FILE_TEMPLATE_CLIENT_HPP
        elif typeID == 2:
            ret = FILE_TEMPLATE_STRUCT_HPP
            temp += u'#include "rpc_%s_Def.h"' % baseName

        ret = self.replace(ret, u"{{RegisterCodes}}", "")
        ret = self.replace(ret, u"{{IncludeFiles}}", temp)
        ret = self.replace(ret, u"{{IncludeCodes}}", self._genIncludeCodes(0))
        ret = self.replace(ret, u"{{EnumStructCodes}}", self.genEnumStructCodes(0))
        ret = self.replace(ret, u"{{ClassCodes}}", self._genClassCode(0))
        ret = self.replace(ret, u"{{ConstDefineCodes}}", self.genConsts(0))
        ret = self.replace(ret, u"{{DATE}}", unicode(date.today()).replace(u"-", u"_"))
        ret = self.replace(ret, u"{{Namespace}}", self.desc.nameSpace)
        ret = self.replace(ret, u"{{ServiceName}}", self.desc.serviceName)
        ret = self.replace(ret, u"{{tag}}", self.tag)
        return ret

    def genCodesRealize(self, typeID=1, hppOutputFile=""):
        #        temp = u'#include "utils/BsonHelper.h"\n'
        #        if isinstance(self.typeManager, QtTypeManger):
        #            temp = u'#include "base/common/BsonFunc.h"\n'
        #        ret = FILE_TEMPLATE_SERVICE_HPP
        ret = FILE_TEMPLATE_CPP
        ret = ret.replace(u"{{HPP_OUT_FILE}}", hppOutputFile)
        ret = self.replace(ret, u"{{IncludeCodes}}", self._genIncludeCodesRealize(0))
        ret = self.replace(ret, u"{{StructCodesService}}", self.genStructCodesService(0))
        ret = self.replace(ret, u"{{ClassCodes}}", self._genClassCodeRealize(0))
        ret = self.replace(ret, u"{{Namespace}}", self.desc.nameSpace)
        ret = self.replace(ret, u"{{ServiceName}}", self.desc.serviceName)
        return ret

    def genConsts(self, offset):
        ret = u""
        content = u"\n".join([self.genOneConst(aconst) for aconst in self.desc.consts])
        if len(content) > 0:
            ret = CONST_DEFINE_TEMPLATE
            ret = self.replace(ret, u"{{CostDefineContentCodes}}", content)
        return ret

    def genOneConst(self, aconst):
        ret = u"static const %s %s = %s;" % (aconst.type.getTypeName(), aconst.name, aconst.value)
        if len(aconst.comment) > 0:
            ret += u" // %s" % aconst.comment
        return ret

    def _genIncludeCodes(self, offset):
        str = u"\n".join([u"#include \"%s\"" % item.strip() for item in self.desc.HppIncludes])
        if len(str) > 0: str += u"\n"
        #str += self.genIncludeCodes(0)
        return str

    def _genIncludeCodesRealize(self, offset):
        str = u"\n".join([u"#include \"%s\"" % item.strip() for item in self.desc.CppIncludes])
        if len(str) > 0: str += u"\n"
        #str += self.genIncludeCodes(0)
        return str

    def _genCppIncludeCodes(self, offset):
        str = u"\n".join([u"#include \"%s\"" % item.strip() for item in self.desc.CppIncludes])
        if len(str) > 0: str += u"\n"
        #str += self.genIncludeCodes(0)s
        return str

    def _genClassCode(self, offset):
        ret = u""
        if len(self.desc.functions) > 0 or len(self.desc.pushFunctions):
            ret = CLASS_TEMPLATE
            ret = self.replace(ret, u"{{ClassCodes}}", self.genClassCode(offset))
        return ret

    def _genClassCodeRealize(self, offset):
        ret = u""
        if len(self.desc.functions) > 0 or len(self.desc.pushFunctions):
            ret = CLASS_TEMPLATE
            ret = self.replace(ret, u"{{ClassCodes}}", self.genClassCodeRealize(offset))
        return ret

    def genStructCodesService(self, offset):
        ret = u""
        if len(self.desc.structs) > 0:
            ret = ENUM_AND_STRUCT_TEMPLATE_CPP
            ret = self.replace(ret, u"{{StructCodes}}", self.genStructCodesRealize(offset))
            ret = self.replace(ret, u"{{StructIds}}", self._genStructIds(offset))
        return ret

    def genEnumStructCodes(self, offset):
        ret = u""
        if len(self.desc.enums) > 0 or len(self.desc.structs) > 0:
            RegisterCodes = u" "
            hasIData = False
            for astruct in self.desc.structs:
                if not (astruct.property.has_key("old")):
                    hasIData = True
                    break;
            if hasIData or len(self.desc.enums) > 0:
                RegisterCodes = u"int regist_{{ServiceName}}();"
            else:
                RegisterCodes = u""

            ret = ENUM_AND_STRUCT_TEMPLATE_HPP
            ret = self.replace(ret, u"{{RegisterCodes}}", RegisterCodes)
            ret = self.replace(ret, u"{{EnumCodes}}", self.genEnumCodes(offset))
            ret = self.replace(ret, u"{{StructCodes}}", self.genStructCodes(offset))
            ret = self.replace(ret, u"{{EnumBsonCodes}}", self.genEnumBsonCodes(offset))
            ret = self.replace(ret, u"{{EnumDefaultCodes}}", self.genEnumDefaultCodes(offset))
            ret = self.replace(ret, u"{{StructBsonCodes}}", self.genStructBsonCodes(offset))
            ret = self.replace(ret, u"{{StructIds}}", self._genStructIds(offset))
        return ret

    def genEnumCodes(self, offset):
        ret = u"\n".join(self.genOneEnumCodes(anenum) for anenum in self.desc.enums)
        return self.offsetLines(ret, offset)

    def genOneEnumCodes(self, anenum):
        lines = []
        for item in anenum.items:
            line = u""
            if len(item.value) == 0:
                line = item.name + u","
            else:
                line = item.name + u" = " + item.value + u", "
            if len(item.comment) > 0: line += u" //" + item.comment
            lines.append(line)
        strContent = u"\n".join(lines)

        ret = ENUM_TEMPLATE
        ret = self.replace(ret, u"{{TypeName}}", anenum.name)
        strContent = self.offsetLines(strContent, TAB_SIZE)
        ret = self.replace(ret, u"{{Content}}", strContent)
        return ret

    def genEnumBsonCodes(self, offset):
        ret = u"\n".join([self.genOneEnumBsonCodes(anenum) for anenum in self.desc.enums])
        return self.offsetLines(ret, offset)

    def genOneEnumBsonCodes(self, anenum):
        ret = ENUM_BSON_TEMPLATE
        ret = self.replace(ret, u"{{TypeName}}", anenum.name)
        return ret

    def genEnumDefaultCodes(self, offset):
        lines = []
        for anenum in self.desc.enums:
            line = "template <> inline {{Namespace}}::{{TypeName}} getDefaultValue(){return {{Namespace}}::{{Default}};};"
            line = line.replace("{{TypeName}}", anenum.name)
            line = line.replace("{{Default}}", anenum.getDefault())
            lines.append(line)
        ret = u"\n".join(lines)
        return self.offsetLines(ret, offset)

    def genStructCodes(self, offset):
        ret = u"\n".join([self.genOneStructCode(astruct) for astruct in self.desc.structs])
        return self.offsetLines(ret, offset)

    def genStructCodesRealize(self, offset):
        ret = u"\n".join([self.genOneStructCodeRealize(astruct) for astruct in self.desc.structs if astruct.property.has_key("old")])
        return self.offsetLines(ret, offset)

    def genOneStructCodeRealize(self, astruct):
        ret = STRUCT_BASE_TEMPLATE_CPP
        initCode = u",\n".join([u"%s(%s)" % (item.name, u"utils::getDefaultValue<%s>()" % item.type.getTypeName() if len(item.default) == 0 else item.default) \
                                for item in astruct.items if item.type.isNeedInit() or len(item.default) > 0])
        appendToBuilder = u"\n".join([u"utils::appendToBuilder(objBuilder, \"%s\", this->%s);" % (item.name, item.name) for item in astruct.items])
        parserBson = u"\n".join([u"utils::safeParseBson(obj, \"%s\", this->%s);" % (item.name, item.name) for item in astruct.items])
        if len(astruct.baseType) > 0:
            appendToBuilder = (("%s::appendElementsWithNoTypeId(objBuilder);\n") % astruct.baseType) + appendToBuilder
            parserBson = (("%s::bsonValueFromObj(obj);\n") % astruct.baseType) + parserBson
        if len(initCode) > 0: initCode = u":" + initCode
        ret = self.replace(ret, u"{{TypeNameWithInherit}}", astruct.name)
        ret = self.replace(ret, u"{{InitCode}}", initCode)
        ret = self.replace(ret, u"{{AppendToBuilder}}", appendToBuilder)
        ret = self.replace(ret, u"{{ParserBson}}", parserBson)
        return ret

    def genOneStructCode(self, astruct):
        lines = []
        for item in astruct.items:
            line = u"%s %s;" % (item.type.getTypeName(), item.name)
            if len(item.comment) > 0: line += u" //" + item.comment
            lines.append(line)
        strContent = u"\n".join(lines)

        initCode = u",\n".join([u"%s(%s)" % (item.name, u"utils::getDefaultValue<%s>()" % item.type.getTypeName() if len(item.default) == 0 else item.default) \
                                for item in astruct.items if item.type.isNeedInit() or len(item.default) > 0])
        if len(initCode) > 0: initCode = u":" + initCode
        appendToBuilder = u"\n".join([u"utils::appendToBuilder(objBuilder, \"%s\", this->%s);" % (item.name, item.name) for item in astruct.items])
        parserBson = u"\n".join([u"utils::safeParseBson(obj, \"%s\", this->%s);" % (item.name, item.name) for item in astruct.items])
        appendId = ""
        strFunc = u""
        strStatics = u""
        strKeyParam = u""
        if not (astruct.property.has_key("old")):
            # 头文件中新增加的方法放在CPP中实现, 此处只声明
            appendId = '''utils::appendToBuilder(objBuilder, "_typeId", (int)XT_%s);''' % astruct.name
            strFunc = STRUCT_GETDESCMAP_FUNC_DECLEAR
            strStatics = u"\n".join(u"static const int ITEM_%s;" % item.name for item in astruct.items)
            ownedTypes = self.getTypes(astruct)
            keyParams = []
            for i in astruct.items:
                if (i.isKey):
                    keyParams.append([i.name, i.type.typeName.strip()])
            strKeyParam = ",".join("%s %s" % (item[1], item[0]) for item in keyParams)

        if len(astruct.baseType) > 0:
            appendToBuilder = (("%s::appendElementsWithNoTypeId(objBuilder);\n") % astruct.baseType) + appendToBuilder
            parserBson = (("%s::bsonValueFromObj(obj);\n") % astruct.baseType) + parserBson
        propertyDesc = u""
        #        if astruct.property.has_key("ptr"):
        #            propertyDesc = u"typedef boost::shared_ptr<{{TypeName}}> {{TypeName}}Ptr;"

        ret = u""
        if not (astruct.property.has_key("old")):
            #noParseList = ["COrderInfo", "COrderDetail", "CDealDetail", "CPositionDetail", "CPositionStatics", "CFtOrderDetail", "CFtDealDetail", "CFtPositionDetail", "CAccountDetail", "CFtAccountDetail"]
            noParseList = []
            if astruct.name in noParseList:
                ret = STRUCT_IDATA_TEMPLATE_NO_PARSER
            else:
                ret = STRUCT_IDATA_TEMPLATE
        else:
            ret = STRUCT_BASE_TEMPLATE_HPP

        ret = self.replace(ret, u"{{PropertyDesc}}", propertyDesc)
        if not (astruct.property.has_key("old")):
            baseType = "IData"
            if len(astruct.baseType) > 0: baseType = astruct.baseType
            ret = self.replace(ret, u"{{TypeNameWithInherit}}", astruct.name + " : public " + baseType)
        else:
            ret = self.replace(ret, u"{{TypeNameWithInherit}}", astruct.name)

        strFieldParses = u"\n".join("FIELD_PARSER(%s, %s);" % (astruct.name, item.name) for item in astruct.items)
        ret = self.replace(ret, u"{{Func}}", strFunc)
        ret = self.replace(ret, u"{{TypeName}}", astruct.name)
        ret = self.replace(ret, u"{{StructName}}", astruct.name)
        ret = self.replace(ret, u"{{Content}}", strContent)
        ret = self.replace(ret, u"{{Statics}}", strStatics)
        ret = self.replace(ret, u"{{InitCode}}", initCode)
        ret = self.replace(ret, u"{{TypeName}}", astruct.name)
        ret = self.replace(ret, u"{{AppendToBuilder}}", appendToBuilder)
        ret = self.replace(ret, u"{{ParserBson}}", parserBson)
        ret = self.replace(ret, u"{{AppendTypeId}}", appendId)
        ret = self.replace(ret, u"{{KeyParam}}", strKeyParam)
        ret = self.replace(ret, u"{{FieldParses}}", strFieldParses)
        return ret

    def genStructBsonCodes(self, offset):
        ret = u"\n".join([self.genOneStructBsonCodes(astruct) for astruct in self.desc.structs])
        return self.offsetLines(ret, offset)

    def genOneStructBsonCodes(self, astruct):
        ret = STRUCT_BSON_TEMPLATE
        if not (astruct.property.has_key("old")):
            ret = "IDATA_BSON_BUILDER_DECLEAR({{Namespace}}::{{TypeName}});"
        ret = self.replace(ret, u"{{TypeName}}", astruct.name)
        return ret

    def genFunctionCodes(self, offset):
        ret = u"\n".join([self.genOneFunctionCode(func) for func in self.desc.functions])
        if self.desc.packType == "2":
            ret = ret.replace("appendToBuilder", "appendToBuilderV2");
        return self.offsetLines(ret, offset)

    def genFunctionCodesRealize(self, offset):
        ret = u"\n".join([self.genOneFunctionCodeRealize(func) for func in self.desc.functions])
        if self.desc.packType == "2":
            ret = ret.replace("appendToBuilder", "appendToBuilderV2");
        return self.offsetLines(ret, offset)

    def genFunctionCodesRealize(self, offset):
        ret = u"\n".join([self.genOneFunctionCodeRealize(func) for func in self.desc.functions])
        if self.desc.packType == "2":
            ret = ret.replace("appendToBuilder", "appendToBuilderV2");
        return self.offsetLines(ret, offset)

    def genPushFunctionCodes(self, offset):
        ret = u"\n".join([self.genOnePushFunctionCode(func) for func in self.desc.pushFunctions])
        if self.desc.packType == "2":
            ret = ret.replace("appendToBuilder", "appendToBuilderV2");
        return self.offsetLines(ret, offset)

    def genPushFunctionCodesRealize(self, offset):
        ret = u"\n".join([self.genOnePushFunctionCodeRealize(func) for func in self.desc.pushFunctions])
        if self.desc.packType == "2":
            ret = ret.replace("appendToBuilder", "appendToBuilderV2");
        return self.offsetLines(ret, offset)

    def genSubFunctionCodes(self, offset):
        ret = u"\n".join([self.genOneSubFunctionCode(func) for func in self.desc.subFunctions])
        if self.desc.packType == "2":
            ret = ret.replace("appendToBuilder", "appendToBuilderV2");
        return self.offsetLines(ret, offset)

    def genSubFunctionCodesRealize(self, offset):
        ret = u"\n".join([self.genOneSubFunctionCodeRealize(func) for func in self.desc.subFunctions])
        if self.desc.packType == "2":
            ret = ret.replace("appendToBuilder", "appendToBuilderV2");
        return self.offsetLines(ret, offset)

    def _genStructIds(self, offset):
        """
        生成StructId
        :param offset:
        :return:
        """
        owns = []
        for astruct in self.desc.structs:
            if not astruct.property.has_key("old") and astruct.property.has_key("structId"):
                owns.append("XT_%s = %s," % (astruct.name, astruct.property["structId"]))
        ownedDefines = "\n".join(owns)
        structDefines = u"\n".join(["XT_%s," % astruct.name for astruct in self.desc.structs if not astruct.property.has_key("old") and not astruct.property.has_key("structId")])
        #print "structDefines ", structDefines
        ret = u""
        if len(structDefines) > 0:
            m = hashlib.md5()
            m.update(self.desc.structs[0].name)
            md5 = m.hexdigest()
            startId = int(md5[0:2], 16)
            startCode = "XT_%d_START = %d * 100," % (startId, startId)
            ret = u"enum {\n%s\n%s\n%s\n};\n" % (startCode, structDefines, ownedDefines)
        return ret

    def replace(self, raw, old, new):
        oldLines = [line for line in raw.splitlines() if line.strip() == old]
        if len(new.splitlines()) <= 1:
            raw = raw.replace(old, new)
        else:
            for line in oldLines:
                offset = line.find(old)
                now = self.offsetLines(new, offset)
                raw = raw.replace(line, now)
        return raw

    def offsetLines(self, str, offset):
        lines = str.splitlines()
        ret = u"\n".join([u" " * offset + line for line in lines])
        return ret

    def getTypes(self, astruct):
        # 看类中有多少种数据结构, 然后填充之
        listTypeNames = {"bool": ["Bool", "false"], "int": ["Int", "0"], "std::string": ["String", "\"\""]}
        listTypeNames["r_int64"] = ["Long", "0"]
        listTypeNames["double"] = ["Double", "0.0"]
        listTypeNames["IDataPtr"] = ["IData", "IDataPtr()"]
        listTypeNames["std::vector<bool>"] = ["VBool", "vector<bool>()"]
        listTypeNames["std::vector<int>"] = ["VInt", "vector<int>()"]
        listTypeNames["std::vector<r_int64>"] = ["VLong", "vector<r_int64>()"]
        listTypeNames["std::vector<double>"] = ["VDouble", "vector<double>()"]
        listTypeNames["std::vector<string>"] = ["VString", "vector<string>()"]
        listTypeNames["std::vector<IDataPtr>"] = ["VIData", "vector<IDataPtr>()"]

        ownedTypes = {}

        for tn in listTypeNames.keys():
            cont = u""
            for i in astruct.items:
                if tn in ["IDataPtr"]:
                    if i.type.typeName.find("{{Namespace}}::C") == 0:
                        ownedTypes[tn] = listTypeNames[tn]
                elif tn in ["std::vector<IDataPtr>"]:
                    if i.type.typeName.find("std::vector< {{Namespace}}::C") == 0:
                        ownedTypes[tn] = listTypeNames[tn]
                else:
                    if i.type.typeName == tn:
                        ownedTypes[tn] = listTypeNames[tn]
        return ownedTypes
