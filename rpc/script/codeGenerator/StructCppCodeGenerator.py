#coding=utf8
__author__ = 'Administrator'
from RPCCodeGenerator import RPCCodeGenerator
from RPCTemplate import *
from LuaTemplate import *


def getXTTypeByItemType(itemType):
    if (itemType == "bool"):
        return "XT_DATA_TYPE_BOOL"
    elif (itemType == "int"):
        return "XT_DATA_TYPE_INT"
    elif (itemType.find("{{Namespace}}::E") == 0):
        return "XT_DATA_TYPE_ENUM"
    elif (itemType == "long long"):
        return "XT_DATA_TYPE_LONG"
    elif (itemType == "double"):
        return "XT_DATA_TYPE_DOUBLE"
    elif (itemType == "std::string"):
        return "XT_DATA_TYPE_STRING"
    elif (itemType.find("{{Namespace}}::") == 0 and itemType.find("{{Namespace}}::E") != 0):
        return "XT_DATA_TYPE_IDATA"
    elif (itemType == "std::vector< bool >"):
        return "XT_DATA_TYPE_VBOOL"
    elif (itemType == "std::vector< int >"):
        return "XT_DATA_TYPE_VINT"
    elif (itemType.find("{{Namespace}}::E") == 0):
        return "XT_DATA_TYPE_VENUM"
    elif (itemType == "std::vector< long long >"):
        return "XT_DATA_TYPE_VLONG"
    elif (itemType == "std::vector< double >"):
        return "XT_DATA_TYPE_VDOUBLE"
    elif (itemType == "std::vector< std::string >"):
        return "XT_DATA_TYPE_VSTRING"
    elif (itemType.find("std::vector< {{Namespace}}::") == 0 and itemType.find("std::vector< {{Namespace}}::E") != 0):
        return "XT_DATA_TYPE_VIDATA"
    return "XT_DATA_TYPE_IDATA"

# 产生lua绑定代码
class StructCppCodeGenerator(RPCCodeGenerator):

    def __init__(self, desc, typeManager):
        RPCCodeGenerator.__init__(self, desc, typeManager, u"server")

    def genCodes(self):
        ret = STRUCT_CPP_FILE_TEMPLATE_SERVICE_CPP
        ret = self.replace(ret, u"{{IncludeCodes}}", self._genCppIncludeCodes(0))
        ret = self.replace(ret, u"{{LuaHeaderCodes}}", self.genLuaHeaderCodes(0))
        ret = self.replace(ret, u"{{StructCodes}}", self.genStructCodes(0))
        ret = self.replace(ret, u"{{RegisterCodes}}", self.genRegisterCodes(0))
        ret = self.replace(ret, u"{{EnumRegisters}}", self.genEnumsRegistersCodes(0))
        ret = self.replace(ret, u"{{StructRegisters}}", self.genStructRegistersCodes(0))
        ret = self.replace(ret , u"{{IncludeCodes}}", self._genIncludeCodes(0))
        ret = self.replace(ret , u"{{EnumStructCodes}}", self.genEnumStructCodes(0))
        ret = self.replace(ret , u"{{ClassCodes}}", self._genClassCode(0))
        ret = self.replace(ret, u"{{ConstDefineCodes}}", self.genConsts(0))
        ret = self.replace(ret, u"{{EnumDeclears}}", self.genEnumDeclears(0))
        ret = self.replace(ret, u"{{StructDeclears}}", self.genStructDeclears(0))
        #ret = self.replace(ret, u"{{DATE}}", unicode(date.today()).replace(u"-", u"_"))
        ret = self.replace(ret, u"{{Namespace}}", self.desc.nameSpace)
        ret = self.replace(ret, u"{{ServiceName}}", self.desc.serviceName)
        ret = self.replace(ret, u"{{tag}}", self.tag)
        return ret

    def genCppCodes(self, offset):

        pass

    def genLuaHeaderCodes(self, offset):
        lines = []
        lines.append("#include <lua.hpp>")
        lines.append("#include <luabind/luabind.hpp>")
        lines.append("#include <luabind/object.hpp>")
        lines.append("#include <luabind/operator.hpp>")
        lines.append("#include <luabind/raw_policy.hpp>")
        lines.append("#include <idata/TypeManager.h>")
        lines.append("#include <Protocol/rpc_ExtraEnums.h>")
        return "\n".join(line for line in lines)

    def genRegisterCodes(self, offset):
        ret = u""
        lines = []
        for aenum in self.desc.enums:
            lines.append("regist_enum_%s();" % aenum.name)
        for astruct in self.desc.structs:
            if not (astruct.property.has_key("old")):
                lines.append("regist_struct_%s();" % astruct.name)
        ret = u"\n".join(lines)
        return ret

    def genEnumDeclears(self, offset):
        return u"\n".join(u"static void regist_enum_%s();" % aenum.name for aenum in self.desc.enums)

    def genStructDeclears(self, offset):
        return u"\n".join(u"static void regist_struct_%s();" % astruct.name for astruct in self.desc.structs if not (astruct.property.has_key("old")))

    def genEnumsRegistersCodes(self, offset):
        ret = u""
        lines = []
        for aenum in self.desc.enums:
            oneLines = []
            for item in aenum.items:
                line  = ONE_ENUM_ITEM_REGIST_TEMPLATE
                typeName = u"{{Namespace}}::%s" % aenum.name
                line = self.replace(line, u"{{EnumName}}", typeName)
                line = self.replace(line, u"{{ItemValue}}", item.name)
                line = self.replace(line, u"{{ItemName}}", item.chsname)
                oneLines.append(line)
            line = ONE_ENUM_REGIST_TEMPLATE
            line = self.replace(line, "{{EnumCodes}}", "\n".join(oneLines))
            line = self.replace(line, "{{EnumName}}", aenum.name)
            lines.append(line)
        ret = u"\n".join(line for line in lines)
        return ret

    def genStructRegistersCodes(self, offset):
        ret = u""
        lines = []
        for astruct in self.desc.structs:
            if not (astruct.property.has_key("old")):
                BaseInfoCodes = u""
                if len(astruct.baseType) > 0:
                    BaseInfoCodes = "%s t; desc.insert(t.getFieldDes().begin(), t.getFieldDes().end());" % astruct.baseType
                TypeName = astruct.name
                BaseTypeId = "-1"
                if len(astruct.baseType) > 0:
                    BaseTypeId = "XT_%s" % astruct.baseType
                flines = []
                for item in astruct.items:
                    fieldIdType = u"-1";
                    if item.type.typeName.endswith("Ptr"):
                        strType = item.type.typeName[0:-3]
                        items = strType.split(":")
                        strType = items[-1]
                        fieldIdType = "XT_%s" % strType
                    strProperty = u"".join(("(ttservice::" + pr + ", true)") for pr in item.propertys)
                    if len(strProperty) > 0 and len(item.propertys):
                        strProperty = u"boost::assign::map_list_of" + strProperty + " "
                    else:
                        strProperty = u"std::map<int, bool>()"
                    vecStr = u""
                    strFunc = u"";
                    if len(item.funcs) > 0:
                        print "item.funcsitem.funcsitem.funcs ",item.funcs
                        strFunc = u"boost::assign::map_list_of"
                        seq = 0
                        vecStr = u""
                        for funcStr in item.funcs:
                            funcStrVec = funcStr.split(",")
                            if(len(funcStrVec) > 1):
                                vecStr += "vector< vector<int> > v%d ;\n" %seq
                                for i in range(1, len(funcStrVec)):
                                    pa = funcStrVec[i]
                                    strPa = u""
                                    pas = pa.split("-")
                                    strPa = u"    v%d.push_back(boost::assign::list_of" % seq
                                    for j in xrange(len(pas) / 2):
                                        strPa += "(" + pas[j * 2] + "::ITEM_" + pas[j * 2 + 1] + ")"
                                    strPa += u");\n"
                                    vecStr += strPa
                                #vecStr += ";\n"
                                strFunc += "(\"" + funcStrVec[0] + "\",v%d)" %seq
                                seq += 1
                            elif len(funcStrVec) == 1:
                                strFunc += "(\"" + funcStrVec[0] + "\"," + "std::vector< vector<int> >())"
                    else:
                        strFunc = u""
                    if len(strFunc) == 0:
                        strFunc = u"map<string, vector< vector<int> > >()"
                    fline = u"desc.insert(make_pair({{TypeName}}::ITEM_%s, FieldDes({{TypeName}}::ITEM_%s, %s, \"%s\", %f, %s, %s, \"%s\", \"%s\", %s, %s, \"%s\", FieldParsePtr(new {{TypeName}}_%s()), (int)((char *)&self.%s - (char *)&self))));" \
                            % (item.name, item.name, getXTTypeByItemType(item.type.getTypeName()), item.chsname, item.precision, item.flag, fieldIdType, \
                               item.invisible, item.type, strProperty, strFunc, item.name, item.name, item.name)
                    if len(vecStr) > 0:
                        fline = "{\n\t" + vecStr + "\t" + fline + "\n}"
                    flines.append(fline)
                FieldInfos = u"\n".join(fline for fline in flines) + u"\n"

                line = ONE_STRUCT_REGIST_TEMPLATE
                line = self.replace(line, u"{{FieldInfos}}", FieldInfos)
                line = self.replace(line, u"{{BaseInfoCodes}}", BaseInfoCodes)
                line = self.replace(line, u"{{TypeName}}", TypeName)
                line = self.replace(line, u"{{BaseTypeId}}", BaseTypeId)
                lines.append(line)
        ret = u"\n".join(line for line in lines)
        return ret

    def genStructCodes(self, offset):
        lines = []
        for astruct in self.desc.structs :
            line = ""
            if astruct.property.has_key("old"):
                line = self.genOneOldStructCode(astruct)
            else:
                line = self.genOneStructCode(astruct)
            lines.append(line)
        return "\n".join(lines)

    def genOneOldStructCode(self, astruct):
        ret = STRUCT_BASE_TEMPLATE_CPP
        initCode = u",\n".join([ u"%s(%s)" % (item.name, u"utils::getDefaultValue<%s>()" % item.type.getTypeName() if len(item.default) == 0 else item.default)\
                                 for item in astruct.items if item.type.isNeedInit() or len(item.default) > 0 ])
        appendToBuilder = u"\n".join([u"utils::appendToBuilder(objBuilder, \"%s\", this->%s);" % (item.name, item.name)for item in astruct.items])
        parserBson = u"\n".join([u"utils::safeParseBson(obj, \"%s\", this->%s);" % (item.name, item.name) for item in astruct.items])
        if len(astruct.baseType) > 0:
            appendToBuilder = (("%s::appendElementsWithNoTypeId(objBuilder);\n") % astruct.baseType) + appendToBuilder
            parserBson = (("%s::bsonValueFromObj(obj);\n") % astruct.baseType) + parserBson
        if len(initCode) > 0 : initCode = u":" + initCode
        ret = self.replace(ret, u"{{TypeNameWithInherit}}", astruct.name)
        ret = self.replace(ret, u"{{InitCode}}", initCode)
        ret = self.replace(ret, u"{{AppendToBuilder}}", appendToBuilder)
        ret = self.replace(ret, u"{{ParserBson}}", parserBson)
        return ret

    def genOneStructCode(self, astruct):
        #noParseList = ["COrderInfo", "COrderDetail", "CDealDetail", "CPositionDetail", "CPositionStatics", "CFtOrderDetail", "CFtDealDetail", "CFtPositionDetail", "CAccountDetail", "CFtAccountDetail"]
        noParseList = []
        lines = []
        for item in astruct.items:
            line = u"%s %s;" % (item.type.getTypeName(), item.name)
            if len(item.comment) > 0 : line += u" //" + item.comment
            lines.append(line)
        strContent = u"\n".join(lines)

        initCode = u",\n".join([ u"%s(%s)" % (item.name, u"utils::getDefaultValue<%s>()" % item.type.getTypeName() if len(item.default) == 0 else item.default)\
                                 for item in astruct.items if item.type.isNeedInit() or len(item.default) > 0 ])
        if len(initCode) > 0 : initCode = u":" + initCode
        parserBson = u"\n".join([u"utils::safeParseBson(obj, \"%s\", this->%s);" % (item.name, item.name) for item in astruct.items])
        baseBsonFromValueCodes = ""
        appendId = ""
        appendId_v2 = ""
        appendToBuilder_new = ""
        if not (astruct.property.has_key("old")):
            appendId = '''utils::appendToBuilder(objBuilder, "_typeId", (int)XT_%s);''' % astruct.name
            appendId_v2 = '''utils::appendToBuilder(objBuilder, "_t", (int)XT_%s);''' % astruct.name
            appendToBuilder = u"\n".join([u"utils::appendToBuilder(objBuilder, \"%s\", this->%s);" % (item.name, item.name)for item in astruct.items])
            appendToBuilder_new = u"\n".join([u"utils::appendToBuilderV2(objBuilder, \"%d\", this->%s);" % (index, astruct.items[index].name)for index in xrange(len(astruct.items))])
        else:
            appendToBuilder = u"\n".join([u"utils::appendToBuilder(objBuilder, \"%s\", this->%s);" % (item.name, item.name)for item in astruct.items])
        if len(astruct.baseType) > 0:
            if (astruct.name in noParseList):
                appendToBuilder = (("%s::appendElementsWithNoTypeIdWithBson(objBuilder);\n") % astruct.baseType) + appendToBuilder
            else:
                appendToBuilder = (("%s::appendElementsWithNoTypeId(objBuilder);\n") % astruct.baseType) + appendToBuilder
                if not (astruct.property.has_key("old")):
                    appendToBuilder_new = ("%s::appendElementsWithNoTypeId_v2(objBuilder);\n") % astruct.baseType + "\n" + appendToBuilder_new
                else :
                    appendToBuilder_new = ("%s::appendElementsWithNoTypeId(objBuilder);\n") % astruct.baseType + "\n" + appendToBuilder_new
            parserBson = (("%s::bsonValueFromObj(obj);\n") % astruct.baseType) + parserBson
            baseBsonFromValueCodes = "%s::bsonValueFromObj_v2(objIter);" % astruct.baseType

        strStatics = u""
        strDescMap = u""
        strFunc = u""
        baseTypeEnum = u"-1"
        strStatics = u""
        strGenKey = u""
        strKeyParam = u""
        strToStream = u""
        strFieldParses = u""
        if not (astruct.property.has_key("old")):
            lines = []
            for item in astruct.items:
                line = u"({{TypeName}}::ITEM_%s, FieldDes({{TypeName}}::ITEM_%s, %s, \"%s\", %f, %s))" % (item.name, item.name, getXTTypeByItemType(item.type.getTypeName()), item.chsname, item.precision, item.flag)
                lines.append(line)
            tempStr = u"".join(lines)
            baseInfoCodes = u""
            if len(astruct.baseType) > 0:
                baseInfoCodes = "%s t; desc.insert(t.getFieldDes().begin(), t.getFieldDes().end());" % astruct.baseType
                baseTypeEnum = ("XT_%s" % astruct.baseType)
            strDescMap = STRUCT_DESCMAP_FUNC
            strDescMap = strDescMap.replace("{{TypeName}}", astruct.name)
            strDescMap = strDescMap.replace("{{FieldInfos}}", tempStr)
            strDescMap = strDescMap.replace("{{BaseInfoCodes}}", baseInfoCodes)
            strDescMap = strDescMap.replace("{{BaseTypeEnum}}", baseTypeEnum)
            strDescMap = strDescMap.replace("{{TypeEnum}}", "XT_%s" % astruct.name)

            strGetDescMap = STRUCT_GETDESCMAP_FUNC
            if astruct.name in noParseList:
                strGetDescMap = STRUCT_GETDESCMAP_FUNC_NO_PARSE
            strGetDescMap = strGetDescMap.replace("{{TypeName}}", astruct.name)
            strGetDescMap = strGetDescMap.replace("{{FieldInfos}}", tempStr)
            strGetDescMap = strGetDescMap.replace("{{BaseInfoCodes}}", baseInfoCodes)

            # 结构map代码
            genOffsetCodes = u"\n".join("ret[{{TypeName}}::ITEM_%s] = (int)((char *)&t.%s - (char *)&t);" % (item.name, item.name) for item in astruct.items)
            baseGetOffset = u""
            if len(astruct.baseType) > 0:
                baseGetOffset = "ret = %s::getOffset(id);" % astruct.baseType

            strGetDescMap = self.replace(strGetDescMap, u"{{GenOffsetCodes}}", genOffsetCodes)
            strGetDescMap = self.replace(strGetDescMap, u"{{BaseGetOffset}}", baseGetOffset)

            strFunc = strGetDescMap
            keys = []
            keyParams =[]
            for i in astruct.items:
                if (i.isKey):
                    keyParams.append([i.name, i.type.typeName.strip()])
                    if i.type.typeName.strip().find("Ptr") == len(i.type.typeName.strip()) - 3:
                        keys.append(i.name + "->toStream(os);")
                    elif getXTTypeByItemType(i.type.getTypeName()) == "XT_DATA_TYPE_IDATA":
	                    keys.append(i.name + ".toStream(os);")
                    else:
                        keys.append("os << %s;" % i.name)

            key = "\nos << KEY_SPLITTER ;".join(item for item in keys)
            strGenKey = key
            strKeyParam = ",".join("%s %s" % (item[1], item[0]) for item in keyParams)
            strToStream = strGenKey
            if astruct.baseType != '':
                if strToStream == '':
                    strToStream = "%s::toStream(os);" %(astruct.baseType.strip())
                else:
                    strToStream = "%s::toStream(os);"
            strStatics = u"\n".join(u"const int {{TypeName}}::ITEM_%s = %s * 100 + %d;" % (item.name, ("XT_%s"%astruct.name), item.num) for item in astruct.items )

#        propertyDesc = u""
#        if astruct.property.has_key("ptr"):
#            propertyDesc = u"typedef boost::shared_ptr<{{TypeName}}> {{TypeName}}Ptr;"

        ret = STRUCT_DECLEAR_TEMPLATE
#        ret = self.replace(ret, u"{{PropertyDesc}}", propertyDesc)
        if not (astruct.property.has_key("old")):
            baseType = "IData"
            if len(astruct.baseType) > 0 : baseType = astruct.baseType
            ret = self.replace(ret, u"{{TypeNameWithInherit}}", astruct.name + " : public " + baseType)
        else:
            ret = self.replace(ret, u"{{TypeNameWithInherit}}", astruct.name)

        ret = self.replace(ret, u"{{Func}}", strFunc)
        strFieldParses = u"\n".join( "FIELD_PARSER(%s, %s, %d);" % (astruct.name, astruct.items[nIndex].name, nIndex) for nIndex in xrange(len(astruct.items)))
        ret = self.replace(ret, u"{{TypeName}}", astruct.name)
        ret = self.replace(ret, u"{{Content}}", strContent)
        ret = self.replace(ret, u"{{Statics}}", strStatics)
        ret = self.replace(ret, u"{{InitCode}}", initCode)
        ret = self.replace(ret, u"{{TypeName}}", astruct.name)
        ret = self.replace(ret, u"{{AppendToBuilder}}", appendToBuilder)
        ret = self.replace(ret, u"{{ParserBson}}", parserBson)
        ret = self.replace(ret, u"{{AppendTypeId}}", appendId)
        ret = self.replace(ret, u"{{BaseTypeId}}", baseTypeEnum)
        ret = self.replace(ret, u"{{GenKey}}", strGenKey)
        ret = self.replace(ret, u"{{ToStream}}", strToStream)
        ret = self.replace(ret, u"{{KeyParam}}", strKeyParam)
        ret = self.replace(ret, u"{{FieldParses}}", strFieldParses)
        ret = self.replace(ret, u"{{BaseBsonFromValueCodes}}", baseBsonFromValueCodes)
        ret = self.replace(ret, u"{{AppendToBuilder_new}}", appendToBuilder_new)
        ret = self.replace(ret, u"{{BaseBsonFromValueCodes}}", baseBsonFromValueCodes)
        return ret
