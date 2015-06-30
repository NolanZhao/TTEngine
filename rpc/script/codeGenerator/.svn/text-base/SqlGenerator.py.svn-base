#coding=utf8
__author__ = 'LTDC'

from RPCCodeGenerator import RPCCodeGenerator
from RPCTemplate import *
from LuaTemplate import *

#CAccountIn

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
    elif (itemType.find("{{Namespace}}::") == 0):   # and itemType.find("{{Namespace}}::E") != 0):change
        return "XT_DATA_TYPE_IDATA"
    elif (itemType == "std::vector< bool >"):
        return "XT_DATA_TYPE_VBOOL"
    elif (itemType == "std::vector< int >"):
        return "XT_DATA_TYPE_VINT"
    elif (itemType.find("std::vector< {{Namespace}}::E") == 0):  # != -1 change
        return "XT_DATA_TYPE_VENUM"
    elif (itemType == "std::vector< long long >"):
        return "XT_DATA_TYPE_VLONG"
    elif (itemType == "std::vector< double >"):
        return "XT_DATA_TYPE_VDOUBLE"
    elif (itemType == "std::vector< std::string >"):
        return "XT_DATA_TYPE_VSTRING"
    elif (itemType.find("std::vector< {{Namespace}}::") == 0): # and itemType.find("std::vector< {{Namespace}}::E") != 0):change
        return "XT_DATA_TYPE_VIDATA"
    return "XT_DATA_TYPE_IDATA"

class SqlGenerator(RPCCodeGenerator):

    def __init__(self, desc, typeManager, tag = u"unknown"):
        #self.desc = desc
        #self.typeManager = typeManager
        #self.tag = tag
        RPCCodeGenerator.__init__(self, desc, typeManager, u"server")
        self.initeTable()

    def initeTable(self):
        self.useTable = []
        self.typeName = []
        self.useTable.append("COrderDetail")
        self.typeName.append("orders")
        self.useTable.append("CAccountDetail")
        self.typeName.append("accounts")
        self.useTable.append("CDealDetail")
        self.typeName.append("deal")
        self.useTable.append("CPositionDetail")
        self.typeName.append("position")
        self.useTable.append("CDealStatics")
        self.typeName.append("deals")
        self.useTable.append("CPositionStatics")
        self.typeName.append("positions")

    def genCodes(self):
        ret = FILE_MAIN_SQL
        self.initeUserData(0)
        ret = self.replace(ret, u"{{VALUE_INITE}}", self.genValueIniteCodes(0))
        ret = self.replace(ret, u"{{UPDATE_CODES}}", self.genAllUpdateCodes(0))
        return ret

    def genHeaderCodes(self, offset):
        ret = ""
        return ret
    def genValueIniteCodes(self, offset):
        self.valueName = []
        templateValue = u'vector<ttservice::{{TYPE_NAME}}> {{VALUE_NAME}};'
        templateClear = u'{{VALUE_NAME}}.clear();'
        templateLoad = u'utils::safeParseBson(bsobj.copy(), "{{TYPE_VALUE}}", {{VALUE_NAME}});'
        ret = ""
        valueClear = ""
        loadValue = ""
        for i in range(0, 6):
            #if i == 4 or i == 5 or i == 3:
            ret += templateValue.replace("{{TYPE_NAME}}", self.useTable[i]).\
                   replace("{{VALUE_NAME}}", "v" + self.useTable[i][1:]) + "\n"#类型定义
            #else:
            #    ret += templateValue.replace("{{TYPE_NAME}}", "CFt" + self.useTable[i][1:]).\
            #replace("{{VALUE_NAME}}", "v" + self.useTable[i][1:]) + "\n"#类型定义
            valueClear += templateClear.replace("{{VALUE_NAME}}", "v" + self.useTable[i][1:]) + "\n"
            loadValue += templateLoad.replace("{{TYPE_VALUE}}", self.typeName[i]).replace("{{VALUE_NAME}}", "v" + self.useTable[i][1:]) + "\n"
            self.valueName.append("v" + self.useTable[i][1:])
        return ret + valueClear + loadValue

    def initeUserData(self, offset):
        for astructs in self.desc.structs:
            if astructs.name == "CAccountInfo":
                self.CAccounttInfoPtr = astructs
            if astructs.name == "CXtOrderTag":
                self.COrderTag = astructs

    def genAllUpdateCodes(self, offset):
        templateOneTable = u'for(size_t j = 0;j < {{VALUE_NAME}}.size(); ++j){\n{{INITE_CODES}}\nif(update){\n{{UPDATE_CODES}}}\nelse{\n{{INSERT_CODES}}\n}\n'\
                           u'if(mysql_real_query(mysql, sql, strlen(sql)) ){\ncout<<"mysql_query error,"<<mysql_error(mysql)<<endl;\ncout<<sql<<endl;\n}\n}'
        templateDefA = u'ttservice::{{TYPE_NAME}}& {{VALUE_NAME}} = {{VVALUE_NAME}}[j];\n'
        templateDefB = u'string m_priKey_tag = {{VALUE_NAME}}.getKey();\n'
        templateDefC = u'string m_strTradingDay = {{VALUE_NAME}}.m_strTradingDay;\n'
        templateIF = u'if(m_strTradingDay.empty())\ncontinue;\n'
        templateSafe = u'utils::safeGbk2Utf8({{VALUE_NAME}}.m_accountInfo->m_strAccountName);\n'
        #templateSprintPos = u'sprintf(sql, "select m_strTagKey from {{TABLE_NAME}}  where m_strTagKey = \'%s\' and  m_strTradingDay = \'%s\' ", m_strTagKey.c_str(), m_strTradingDay.c_str());\n'
        templateSprint = u'sprintf(sql, "select m_priKey_tag from {{TABLE_NAME}}  where m_priKey_tag = \'%s\'", m_priKey_tag.c_str());\n'
        ret = ""
        #retU = ""
        #retI = ""
        index = 0
        #initeCodes = ""
        for astructs in self.desc.structs:
            flag = False
            #if astructs.name == "CAccountInfo":
            #    self.CAccounttInfoPtr = astructs
            for name in self.useTable:
                if astructs.name == name:
                    flag = True
                    break
            if flag:
                retU = self.genOneUpdateCodes(0, astructs)
                retI = self.genInsertOneCodes(0, astructs)
                retU += u"\n\n"
                retI += u"\n\n"
                #if index == 4 or index == 5 or index == 3:
                initeCodes = templateDefA.replace("{{TYPE_NAME}}", self.useTable[index]).replace("{{VALUE_NAME}}", "m_" + astructs.name + "Value").\
                replace("{{VVALUE_NAME}}", self.valueName[index])
                #else:
                #    initeCodes = templateDefA.replace("{{TYPE_NAME}}", "CFt" + self.useTable[index][1:]).replace("{{VALUE_NAME}}", astructs.name + "Value").\
                #replace("{{VVALUE_NAME}}", self.valueName[index])
                initeCodes += templateDefB.replace("{{VALUE_NAME}}", "m_" + astructs.name + "Value")
                if astructs.name == "CPositionDetail":
                    initeCodes += templateDefC.replace("{{VALUE_NAME}}", "m_" + astructs.name + "Value")
                    initeCodes += templateIF
                initeCodes += templateSafe.replace("{{VALUE_NAME}}", "m_" + astructs.name + "Value")
                #if astructs.name == "CPositionDetail":
                #    sprintTmp = templateSprintPos.replace("{{TABLE_NAME}}", astructs.name)
                #else:
                sprintTmp = templateSprint.replace("{{TABLE_NAME}}", astructs.name)
                initeCodes += IF_ELSE_FIXED.replace("{{SPRINT_SELECT}}", sprintTmp)
                ret += templateOneTable.replace("{{VALUE_NAME}}", self.valueName[index]).replace("{{UPDATE_CODES}}", retU).\
                       replace("{{INSERT_CODES}}", retI).replace("{{INITE_CODES}}", initeCodes) + "\n\n"
                index += 1
        return ret

    def genOneUpdateCodes(self, offset, structTable):
        #sprintf(sql, "UPDATE tableName set filed = %d, filed = '%s' where filed = %d and filed = '%s'", number, string);
        valueName = "m_" + structTable.name + "Value."
        ret = 'sprintf(sql, "UPDATE {{TABLE_NAME}} set {{SET_VALUE}}  \\\n\\\nwhere {{CONDITION_VALUE}}", \\\n\\\n{{TRUE_VALUE}},\\\n{{CONDITION_TRUE}});'
        ret = ret.replace("{{TABLE_NAME}}", structTable.name)
        templateSet = u'{{FILED_NAME}} = {{FILED_TYPE}}'
        setValue = ""
        trueValue = ""
        conditionValue = "m_priKey_tag = \'%s\'"
        conditionTure = valueName + "getKey().c_str(),\\\n"
        for item in structTable.items:
            if item.type.typeName == "std::vector< std::string >":
                continue
            if item.type.typeName.endswith("CAccountInfoPtr"):
                for itemSub in self.CAccounttInfoPtr.items:
                    if itemSub.type.typeName == "std::vector< std::string >":
                        continue
                    if itemSub.type.typeName == "double":
                        setValue += templateSet.replace("{{FILED_NAME}}", itemSub.name).replace("{{FILED_TYPE}}", "%lf") + ",\\\n"
                        trueValue += valueName + "m_accountInfo->" + itemSub.name + ",\\\n"
                    elif itemSub.type.typeName == "long":
                        setValue += templateSet.replace("{{FILED_NAME}}", itemSub.name).replace("{{FILED_TYPE}}", "%I64d") + ",\\\n"
                        trueValue += valueName + "m_accountInfo->" + itemSub.name + ",\\\n"
                    elif itemSub.type.typeName == "std::string":
                        setValue += templateSet.replace("{{FILED_NAME}}", itemSub.name).replace("{{FILED_TYPE}}", "\'%s\'") + ",\\\n"
                        trueValue += valueName + "m_accountInfo->" + itemSub.name + ".c_str(),\\\n"
                    else:
                        setValue += templateSet.replace("{{FILED_NAME}}", itemSub.name).replace("{{FILED_TYPE}}", "%d") + ",\\\n"
                        trueValue += valueName + "m_accountInfo->" + itemSub.name + ",\\\n"
            elif item.type.typeName.endswith("CXtOrderTagPtr"):
                for itemSub in self.COrderTag.items:
                    if itemSub.type.typeName == "std::vector< std::string >":
                        continue
                    if itemSub.type.typeName == "double":
                        setValue += templateSet.replace("{{FILED_NAME}}", itemSub.name).replace("{{FILED_TYPE}}", "%lf") + ",\\\n"
                        trueValue += valueName + "m_xtTag->" + itemSub.name + ",\\\n"
                    elif itemSub.type.typeName == "long":
                        setValue += templateSet.replace("{{FILED_NAME}}", itemSub.name).replace("{{FILED_TYPE}}", "%I64d") + ",\\\n"
                        trueValue += valueName + "m_xtTag->" + itemSub.name + ",\\\n"
                    elif itemSub.type.typeName == "std::string":
                        setValue += templateSet.replace("{{FILED_NAME}}", itemSub.name).replace("{{FILED_TYPE}}", "\'%s\'") + ",\\\n"
                        trueValue += valueName + "m_xtTag->" + itemSub.name + ".c_str(),\\\n"
                    else:
                        setValue += templateSet.replace("{{FILED_NAME}}", itemSub.name).replace("{{FILED_TYPE}}", "%d") + ",\\\n"
                        trueValue += valueName + "m_xtTag->" + itemSub.name + ",\\\n"
            else:
                if item.type.typeName == "double":
                    setValue += templateSet.replace("{{FILED_NAME}}", item.name).replace("{{FILED_TYPE}}", "%lf") + ",\\\n"
                    trueValue += valueName + item.name + ",\\\n"
                elif item.type.typeName == "long":
                    setValue += templateSet.replace("{{FILED_NAME}}", item.name).replace("{{FILED_TYPE}}", "%I64d") + ",\\\n"
                    trueValue += valueName + item.name + ",\\\n"
                elif item.type.typeName == "std::string":
                    setValue += templateSet.replace("{{FILED_NAME}}", item.name).replace("{{FILED_TYPE}}", "\'%s\'") + ",\\\n"
                    trueValue += valueName + item.name + ".c_str(),\\\n"
                else:
                    setValue += templateSet.replace("{{FILED_NAME}}", item.name).replace("{{FILED_TYPE}}", "%d") + ",\\\n"
                    trueValue += valueName + item.name + ",\\\n"
        ret = ret.replace("{{SET_VALUE}}", setValue[:-3]).replace("{{TRUE_VALUE}}", trueValue[:-3]).replace("{{CONDITION_VALUE}}", conditionValue).\
        replace("{{CONDITION_TRUE}}", conditionTure[:-3])
        return ret

    def genInsertOneCodes(self, offset, structTable):
        #sprintf(sql, "INSERT INTO tableName(FILEDA, FILEDB) VALUES(%d, '%s')", number, str)
        valueName = "m_" + structTable.name + "Value."
        ret = 'sprintf(sql, "INSERT INTO {{TABLE_NAME}}({{FILED_TABLE}}) \\\nVALUES({{VALUE_TYPE}})",\\\n {{TRUE_VALUE}});'
        ret = ret.replace("{{TABLE_NAME}}", structTable.name)
        filedStr = "m_priKey_tag,\\\n"
        valueStr = "\'%s\', "
        trueStr = valueName + "getKey().c_str()" + ",\\\n"
        for item in structTable.items:
            if item.type.typeName == "std::vector< std::string >":
                continue
            if item.type.typeName.endswith("CAccountInfoPtr"):
                firstLine = True
                for itemSub in self.CAccounttInfoPtr.items:
                    if itemSub.type.typeName == "std::vector< std::string >":
                        continue
                    filedStr += itemSub.name + u',\\\n'
                    if itemSub.type.typeName == "double":
                        valueStr += "%lf, "
                        trueStr += valueName + "m_accountInfo->" + itemSub.name + ",\\\n"
                    elif itemSub.type.typeName == "long":
                        valueStr += "%I64d, "
                        trueStr += valueName + "m_accountInfo->" + itemSub.name + ",\\\n"
                    elif itemSub.type.typeName == "std::string":
                        valueStr += "\'%s\', "
                        trueStr += valueName + "m_accountInfo->" + itemSub.name + ".c_str(),\\\n"
                    else:
                        valueStr += "%d, "
                        trueStr += valueName + "m_accountInfo->" + itemSub.name + ",\\\n"
            elif item.type.typeName.endswith("CXtOrderTagPtr"):
                firstLine = True
                for itemSub in self.COrderTag.items:
                    if itemSub.type.typeName == "std::vector< std::string >":
                        continue
                    filedStr += itemSub.name + u',\\\n'
                    if itemSub.type.typeName == "double":
                        valueStr += "%lf, "
                        trueStr += valueName + "m_xtTag->" + itemSub.name + ",\\\n"
                    elif itemSub.type.typeName == "long":
                        valueStr += "%I64d, "
                        trueStr += valueName + "m_xtTag->" + itemSub.name + ",\\\n"
                    elif itemSub.type.typeName == "std::string":
                        valueStr += "\'%s\', "
                        trueStr += valueName + "m_xtTag->" + itemSub.name + ".c_str(),\\\n"
                    else:
                        valueStr += "%d, "
                        trueStr += valueName + "m_xtTag->" + itemSub.name + ",\\\n"
            else:
                filedStr += item.name + u',\\\n'
                if item.type.typeName == "double":
                    valueStr += "%lf, "
                    trueStr += valueName + item.name + ",\\\n"
                elif item.type.typeName == "long":
                    valueStr += "%I64d, "
                    trueStr += valueName + item.name + ",\\\n"
                elif item.type.typeName == "std::string":
                    valueStr += "\'%s\', "
                    trueStr += valueName + item.name + ".c_str(),\\\n"
                else:
                    valueStr += "%d, "
                    trueStr += valueName + item.name + ",\\\n"
        ret = ret.replace("{{FILED_TABLE}}", filedStr[:-3]).replace("{{VALUE_TYPE}}", valueStr[:-2]).replace("{{TRUE_VALUE}}", trueStr[:-3])
        return ret