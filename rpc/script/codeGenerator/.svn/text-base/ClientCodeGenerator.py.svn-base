#coding=utf8
__author__ = 'Administrator'
from RPCCodeGenerator import RPCCodeGenerator
from ClientTemplate import *

class ClientCodeGenerator(RPCCodeGenerator):
    def __init__(self, desc, typeManager):
        RPCCodeGenerator.__init__(self, desc, typeManager, u"client")
        
    def _genClientIncludeCodes(self, offset):
        str = u"\n".join([u"#include \"%s\"" % item.strip() for item in self.desc.clientIncludes ])
        return str
        
    def genCodes(self):
        ret = RPCCodeGenerator.genCodes(self, 0)
        ret = self.replace(ret , u"{{ClientIncludeCodes}}", self._genClientIncludeCodes(0))
        ret = self.replace(ret , u"{{ServerIncludeCodes}}", "")
        return ret

    def genCodesHpp(self, baseName = ""):
        ret = RPCCodeGenerator.genCodes(self, 2, baseName)
        ret = self.replace(ret , u"{{ClientIncludeCodes}}", self._genClientIncludeCodes(0))
        ret = self.replace(ret , u"{{ServerIncludeCodes}}", "")
        return ret

    def genCodesRealize(self, hppOutputFile):
        ret = RPCCodeGenerator.genCodesRealize(self, hppOutputFile = hppOutputFile)
        #ret = self.replace(ret , u"{{ClientIncludeCodes}}", self._genClientIncludeCodes(0))
        ret = self.replace(ret , u"{{ServerIncludeCodes}}", "")
        return ret

    def genClassCode(self, offset):
        notifyCodes = u"\n".join([NOTIFY_CODE_TEMPLATE.replace(u"{{PushFunction}}", func.name) for func in self.desc.pushFunctions] )
        ret = self.replace(CLIENT_CLASS_TEMPLATE_HPP, u"{{FunctionContent}}", self.genFunctionCodes(offset))
        ret = self.replace(ret, u"{{PushFunctionContent}}", self.genPushFunctionCodes(offset))
        ret = self.replace(ret, u"{{SubFunctionContent}}", self.genSubFunctionCodes(offset))
        ret = self.replace(ret, u"{{NotifyCodes}}", notifyCodes)
        return ret

    def genOneFunctionCode(self, func):
        ret = u""
        ret += self.genSyncCode(func)
        ret += u"\n"
        ret += self.genAsyncCode(func)
        ret += u"\n"
        return ret

    def genOneFunctionCodeRealize(self, func):
        ret = u""
        ret += self.genSyncCodeRealize(func)
        ret += u"\n\n"
        ret += self.genAsyncCodeRealize(func)
        ret += u"\n\n"
        return ret

    def genSyncCode(self, func):
        # 避免参数重复
        inParams = []
        for inParam in func.inParam:
            find = False
            for outParam in func.outParam:
                if inParam[0] == outParam[0]:
                    find = True
                    break
            if not find:
                inParams.append(inParam)

        inParamStr = u", ".join([u"%s %s" % (x[1].paramString(), x[0]) for x in inParams])
        if len(inParamStr) > 0 : inParamStr += u", "
        outParamStr = u", ".join([u"%s& %s" % (x[1].getTypeName(), x[0]) for x in func.outParam])
        if len(outParamStr) > 0 : outParamStr += u", "
        ret = CLIENT_SYNC_CODE_TEMPLATE_HPP
        if self.desc.isNewError:
            ret = CLIENT_SYNC_CODE_TEMPLATE_V2_HPP
        ret = ret.replace(u"{{FuncName}}", func.name)
        ret = self.replace(ret, u"{{InParam}}", inParamStr)
        ret = self.replace(ret, u"{{OutParam}}", outParamStr)
        return ret

    def genSyncCodeRealize(self, func):
        # 避免参数重复
        inParams = []
        for inParam in func.inParam:
            find = False
            for outParam in func.outParam:
                if inParam[0] == outParam[0]:
                    find = True
                    break
            if not find:
                inParams.append(inParam)

        inParamStr = u", ".join([u"%s %s" % (x[1].paramString(), x[0]) for x in inParams])
        if len(inParamStr) > 0 : inParamStr += u", "
        outParamStr = u", ".join([u"%s& %s" % (x[1].getTypeName(), x[0]) for x in func.outParam])
        if len(outParamStr) > 0 : outParamStr += u", "
        #genBson = u"\n".join([ u"%s.appendElements(_builder);" % (param[0]) for param in func.inParam ] )
        genBson = u"\n".join([ u"utils::appendToBuilder(_builder, \"%s\", %s);" % (param[0], param[0]) for param in func.inParam ] )
        parseBson = u"\n".join([ u"utils::safeParseBson(_response, \"%s\", %s);" % (param[0], param[0]) for param in func.outParam ] )
        ret = CLIENT_SYNC_CODE_TEMPLATE_CPP
        if self.desc.isNewError:
            ret = CLIENT_SYNC_CODE_TEMPLATE_V2_CPP
        ret = ret.replace(u"{{FuncName}}", func.name)
        ret = self.replace(ret, u"{{InParam}}", inParamStr)
        ret = self.replace(ret, u"{{OutParam}}", outParamStr)
        ret = self.replace(ret, u"{{GenBson}}", genBson)
        ret = self.replace(ret, u"{{ParseBson}}", parseBson)
        return ret

    def genAsyncCode(self, func):
        outTypes = u", ".join([param[1].paramString() for param in func.outParam])
        if len(outTypes) > 0 : outTypes += u", "
        outParamDeclear = u"\n".join([param[1].declearVariantString(param[0]) for param in func.outParam])
        outParamName = u", ".join([u"%s" % (param[0]) for param in func.outParam])
        if len(outParamName) > 0 : outParamName += u", "
        inParamStr = u", ".join([u"%s %s" % (x[1].paramString(), x[0]) for x in func.inParam])
        if len(inParamStr) > 0 : inParamStr += u", "
        #genBson = u"\n".join([ u"%s.appendElements(_builder);" % (param[0]) for param in func.inParam ] )
        genBson = u"\n".join([ u"utils::appendToBuilder(_builder, \"%s\", %s);" % (param[0], param[0]) for param in func.inParam ] )
        parseBson = u"\n".join([ u"utils::safeParseBson(_response, \"%s\", %s);" % (param[0], param[0]) for param in func.outParam ] )

        ret = CLIENT_ASYNC_CODE_TEMPLATE_HPP
        if self.desc.isNewError:
            ret = CLIENT_ASYNC_CODE_TEMPLATE_V2_HPP
        ret = ret.replace(u"{{FuncName}}", func.name)
        errorCode = u'_error = bson::bob().append("error", "字段解析错误").obj();'
        ret = self.replace(ret, u"{{Param}}", inParamStr)
        ret = self.replace(ret, u"{{OutTypes}}", outTypes)
        ret = self.replace(ret, u"{{GenBson}}", genBson)
        ret = self.replace(ret, u"{{ParseBson}}", parseBson)
        ret = self.replace(ret, u"{{OutParamDeclear}}", outParamDeclear)
        ret = self.replace(ret, u"{{OutParamName}}", outParamName)
        ret = self.replace(ret, u"{{MakeError}}", errorCode)
        return ret

    def genAsyncCodeRealize(self, func):
        outTypes = u", ".join([param[1].paramString() for param in func.outParam])
        if len(outTypes) > 0 : outTypes += u", "
        outParamDeclear = u"\n".join([param[1].declearVariantString(param[0]) for param in func.outParam])
        outParamName = u", ".join([u"%s" % (param[0]) for param in func.outParam])
        if len(outParamName) > 0 : outParamName += u", "
        inParamStr = u", ".join([u"%s %s" % (x[1].paramString(), x[0]) for x in func.inParam])
        if len(inParamStr) > 0 : inParamStr += u", "
        #genBson = u"\n".join([ u"%s.appendElements(_builder);" % (param[0]) for param in func.inParam ] )
        genBson = u"\n".join([ u"utils::appendToBuilder(_builder, \"%s\", %s);" % (param[0], param[0]) for param in func.inParam ] )
        parseBson = u"\n".join([ u"utils::safeParseBson(_response, \"%s\", %s);" % (param[0], param[0]) for param in func.outParam ] )

        ret = CLIENT_ASYNC_CODE_TEMPLATE_CPP
        if self.desc.isNewError:
            ret = CLIENT_ASYNC_CODE_TEMPLATE_V2_CPP
        ret = ret.replace(u"{{FuncName}}", func.name)
        errorCode = u'_error = bson::bob().append("error", "字段解析错误").obj();'
        ret = self.replace(ret, u"{{Param}}", inParamStr)
        ret = self.replace(ret, u"{{OutTypes}}", outTypes)
        ret = self.replace(ret, u"{{GenBson}}", genBson)
        ret = self.replace(ret, u"{{ParseBson}}", parseBson)
        ret = self.replace(ret, u"{{OutParamDeclear}}", outParamDeclear)
        ret = self.replace(ret, u"{{OutParamName}}", outParamName)
        ret = self.replace(ret, u"{{MakeError}}", errorCode)
        return ret

    def genOnePushFunctionCode(self, func):
        paramDeclear = u"\n".join([param[1].declearVariantString(param[0]) for param in func.inParam])
        paramNames = u", ".join([u"%s" % param[0] for param in func.inParam])
        params = u", ".join([u"%s %s" % (param[1].paramString(), param[0]) for param in func.inParam])
        parseBson = u"\n".join([ u"utils::safeParseBson(_responsei,\"%s\", %s);" % (param[0], param[0]) for param in func.inParam ] )

        ret = CLIENT_PUSH_CODE_TEMPLATE_HPP.replace(u"{{FuncName}}", func.name)
        ret = self.replace(ret, u"{{ParamDeclear}}", paramDeclear)
        ret = self.replace(ret, u"{{ParseBson}}", parseBson)
        ret = self.replace(ret, u"{{ParamNames}}", paramNames)
        ret = self.replace(ret, u"{{Params}}", params)
        return ret

    def genOneSubFunctionCode(self, func):
	    outTypes = u", ".join([param[1].getTypeName() for param in func.outParam])
	    if len(outTypes) > 0 : outTypes += u", "
	    genBson = u"\n".join([ u"%s.appendElements(_builder);" % (param[0]) for param in func.inParam ] )
	    inParamStr = u", ".join([u"%s %s" % (x[1].paramString(), x[0]) for x in func.inParam])
	    if len(inParamStr) > 0 : inParamStr += u", "
	    outParamDeclear = u"\n".join([param[1].declearVariantString(param[0]) for param in func.outParam])
	    outParamName = u", ".join([u"%s" % (param[0]) for param in func.outParam])
	    if len(outParamName) > 0 : outParamName = outParamName + u","
	    parseBson = u"\n".join([ u"utils::safeParseBson(_response, \"%s\", %s);" % (param[0], param[0]) for param in func.outParam ] )

	    ret = CLIENT_SUBSCRIBE_TEMPLATE_HPP
	    ret = self.replace(ret, u"{{FuncName}}", func.name)
	    ret = self.replace(ret, u"{{Param}}", inParamStr)
	    ret = self.replace(ret, u"{{OutTypes}}", outTypes)
	    ret = self.replace(ret, u"{{GenBson}}", genBson)
	    ret = self.replace(ret, u"{{OutParamDeclear}}", outParamDeclear)
	    ret = self.replace(ret, u"{{OutParamName}}", outParamName)
	    ret = self.replace(ret, u"{{ParseBson}}", parseBson)
	    return ret

    def genIncludeCodes(self, offset):
        return self.offsetLines(CLIENT_INCLUDE_TEMPLATE, offset)