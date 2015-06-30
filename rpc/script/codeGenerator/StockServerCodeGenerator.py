
#coding=utf8
__author__ = 'Administrator'
from ServerCodeGenerator import ServerCodeGenerator
from ServerTemplate import *
from tools.StringHelper import *

class StockServerCodeGenerator(ServerCodeGenerator):
    def genOneFunctionCode(self, func):
        ret = SERVER_FUNCTION_TEMPLATE_HPP
        # 避免重复
        funcName = func.name
        sendOutParam = u",".join([param[1].inParamString(param[0]) for param in func.outParam ])
        if len(sendOutParam) > 0 : sendOutParam += u","
        ret = self.replace(ret, u"{{FuncName}}", funcName)
        ret = self.replace(ret, u"{{SendOutParam}}", sendOutParam)
        return ret

    def genOneFunctionCode(self, func):
        ret = SERVER_FUNCTION_TEMPLATE_CPP
        # 避免重复
        funcName = func.name
        inParamDeclear = u"\n".join([param[1].declearVariantString(param[0]) for param in func.inParam])
        outParamDeclear = u"\n".join([param[1].declearVariantString(param[0]) for param in func.outParam ])
        parseBson = u"\n".join([ u"utils::safeParseBson(_response, \"%s\", %s);" % (param[0], param[0]) for param in func.inParam ] )
        #genBson = u"\n".join([ u"%s.appendElements(_builder);" % (param[0]) for param in func.inParam ] )
        genBson = u"\n".join([u"utils::appendToBuilder(_builder,\"%s\", %s);" % (param[0], param[0]) for param in func.outParam])
        inParamNames = u", ".join(param[0] for param in func.inParam)
        outParamNames = u", ".join(param[0] for param in func.outParam)
        if len(inParamNames) > 0: inParamNames += u", "
        if len(outParamNames) > 0: outParamNames += u","
        inParam = u", ".join(u"%s %s" % (param[1].paramString(), param[0]) for param in func.inParam)
        outParam = u", ".join(u"%s& %s" % (param[1].getTypeName(), param[0]) for param in func.outParam)
        if len(inParam) > 0 : inParam += u", "
        if len(outParam) > 0 : outParam += u","
        #print (inParam, outParam)

        sendOutParam = u",".join([param[1].inParamString(param[0]) for param in func.outParam ])
        if len(sendOutParam) > 0 : sendOutParam += u","

        ret = self.replace(ret, u"{{FuncName}}", funcName)
        ret = self.replace(ret, u"{{InParamDeclear}}", inParamDeclear)
        ret = self.replace(ret, u"{{OutParamDeclear}}", outParamDeclear)
        ret = self.replace(ret, u"{{ParseBson}}", parseBson)
        ret = self.replace(ret, u"{{GenBson}}", genBson)
        ret = self.replace(ret, u"{{InParamNames}}", inParamNames)
        ret = self.replace(ret, u"{{OutParamNames}}", outParamNames)
        ret = self.replace(ret, u"{{InParam}}", inParam)
        ret = self.replace(ret, u"{{OutParam}}", outParam)
        ret = self.replace(ret, u"{{SendOutParam}}", sendOutParam)
        return ret

    def genOnePushFunctionCode(self, func):
        funcName = func.name
        params = u", ".join([u"%s %s" % (param[1].paramString(), param[0]) for param in func.inParam])
        params1 = params
        if len(params1) > 0 : params1 += u", "
        ret = SERVER_PUSH_FUNCTION_TEMPLATE_HPP.replace(u"{{FuncName}}", funcName)
        ret = self.replace(ret, u"{{Params1}}", params1)
        ret = self.replace(ret, u"{{Params2}}", params)
        return ret

    def genOnePushFunctionCodeRealize(self, func):
        funcName = func.name
        params = u", ".join([u"%s %s" % (param[1].paramString(), param[0]) for param in func.inParam])
        params1 = params
        if len(params1) > 0 : params1 += u", "
        #genBson = u"\n".join([ u"%s.appendElements(_builder);" % (param[0]) for param in func.inParam ] )
        genBson = u"\n".join([u"utils::appendToBuilder(_builder, \"%s\", %s);" % (param[0], param[0]) for param in func.inParam])
        ret = SERVER_PUSH_FUNCTION_TEMPLATE_CPP.replace(u"{{FuncName}}", funcName)
        ret = self.replace(ret, u"{{Params1}}", params1)
        ret = self.replace(ret, u"{{Params2}}", params)
        ret = self.replace(ret, u"{{GenBson}}", genBson)
        return ret

    def genOneSubFunctionCode(self, func):
        ret = SERVER_SUB_FUNCTION_TEMPLATE_HPP
        funcName = func.name
        sendOutParam = u",".join([param[1].inParamString(param[0]) for param in func.outParam ])
        if len(sendOutParam) > 0 : sendOutParam += u","
        ret = self.replace(ret, u"{{FuncName}}", funcName)
        ret = self.replace(ret, u"{{SendOutParam}}", sendOutParam)
        return ret

    def genOneSubFunctionCodeRealize(self, func):
        ret = SERVER_SUB_FUNCTION_TEMPLATE_CPP
        funcName = func.name
        inParamDeclear = u"\n".join([param[1].declearVariantString(param[0]) for param in func.inParam])
        outParamDeclear = u"\n".join([param[1].declearVariantString(param[0]) for param in func.outParam ])
        parseBson = u"\n".join([ u"map<const char*, int>utils::safeParseBson(_response,\"%s\", %s);" % (param[0], param[0]) for param in func.inParam ] )
        #genBson = u"\n".join([ u"%s.appendElements(_builder);" % (param[0]) for param in func.inParam ] )
        genBson = u"\n".join([u"utils::appendToBuilder(_builder,\"%s\", %s);" % (param[0], param[0]) for param in func.outParam])
        inParamNames = u", ".join(param[0] for param in func.inParam)
        outParamNames = u", ".join(param[0] for param in func.outParam)
        if len(inParamNames) > 0: inParamNames += u", "
        if len(outParamNames) > 0: outParamNames += u","
        inParam = u", ".join(u"%s %s" % (param[1].paramString(), param[0]) for param in func.inParam)
        outParam = u", ".join(u"%s& %s" % (param[1].getTypeName(), param[0]) for param in func.outParam)
        if len(inParam) > 0 : inParam += u", "
        if len(outParam) > 0 : outParam += u","

        sendOutParam = u",".join([param[1].inParamString(param[0]) for param in func.outParam ])
        if len(sendOutParam) > 0 : sendOutParam += u","

        ret = self.replace(ret, u"{{FuncName}}", funcName)
        ret = self.replace(ret, u"{{InParamDeclear}}", inParamDeclear)
        ret = self.replace(ret, u"{{OutParamDeclear}}", outParamDeclear)
        ret = self.replace(ret, u"{{ParseBson}}", parseBson)
        ret = self.replace(ret, u"{{GenBson}}", genBson)
        ret = self.replace(ret, u"{{InParamNames}}", inParamNames)
        ret = self.replace(ret, u"{{OutParamNames}}", outParamNames)
        ret = self.replace(ret, u"{{InParam}}", inParam)
        ret = self.replace(ret, u"{{OutParam}}", outParam)
        ret = self.replace(ret, u"{{SendOutParam}}", sendOutParam)
        return ret