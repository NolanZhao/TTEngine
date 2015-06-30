
#coding=utf8
__author__ = 'Administrator'
from RPCCodeGenerator import RPCCodeGenerator
from ServerTemplate import *
from tools.StringHelper import *

class ServerCodeGenerator(RPCCodeGenerator):
    def __init__(self, desc, typeManager):
        RPCCodeGenerator.__init__(self, desc, typeManager, u"server")
        
    def _genServerIncludeCodes(self, offset):
        str = u"\n".join([u"#include \"%s\"" % item.strip() for item in self.desc.serverIncludes ])
        return str
        
    def genCodes(self):
        ret = RPCCodeGenerator.genCodes(self, True)
        ret = self.replace(ret , u"{{ServerIncludeCodes}}", self._genServerIncludeCodes(0))
        ret = self.replace(ret , u"{{ClientIncludeCodes}}", "")
        ret = self.replace(ret, u"{{RegisterCodes}}", "")
        return ret

    def genCodesRealize(self, hppOutputFile):
        ret = RPCCodeGenerator.genCodesRealize(self, True, hppOutputFile)
        return ret

    def genClassCode(self, offset):
        ret = SERVER_CLASS_TEMPLATE_HPP
        ret = self.replace(ret, u"{{FunctionContent}}", self.genFunctionCodes(offset))
        ret = self.replace(ret, u"{{PushFunctionContent}}", self.genPushFunctionCodes(offset))
        ret = self.replace(ret, u"{{SubFunctionContent}}", self.genSubFunctionCodes(offset))
        ret = self.replace(ret, u"{{VirtualFuncDeclear}}", self.genVirtualFuncs(offset))
        ret = self.replace(ret, u"{{VirtualSubDeclear}}", self.genVirtualSubs(offset))
        #print "........."
        #print self.genVirtualSubs(offset)
        return ret

    def genClassCodeRealize(self, offset):
        RegisterFunctions = u"\n".join([u"ret.insert(std::make_pair(\"%s\", boost::bind(&rpc_{{ServiceName}}_server::_%s, this, _1, _2, _3)));" % (function.name, function.name )for function in self.desc.functions])

        subTemplate = u'''\
ret.insert(std::make_pair(\"{{FuncName}}\", boost::bind(&rpc_{{ServiceName}}_server::_{{FuncName}}, this, _1, _2, _3)));
ret.insert(std::make_pair(\"{{FuncName}}_unsub\", boost::bind(&rpc_{{ServiceName}}_server::_{{FuncName}}_unsub, this, _1, _2, _3)));\
'''
        RegisterSubs = u"\n".join([subTemplate.replace(u"{{FuncName}}", function.name)for function in self.desc.subFunctions])

        ret = SERVER_CLASS_TEMPLATE_CPP
        ret = self.replace(ret, u"{{FunctionContent}}", self.genFunctionCodesRealize(offset))
        ret = self.replace(ret, u"{{RegisterFunctions}}", RegisterFunctions)
        ret = self.replace(ret, u"{{RegisterSubs}}", RegisterSubs)
        ret = self.replace(ret, u"{{PushFunctionContent}}", self.genPushFunctionCodesRealize(offset))
        ret = self.replace(ret, u"{{SubFunctionContent}}", self.genSubFunctionCodesRealize(offset))
        #ret = self.replace(ret, u"{{VirtualSubDeclear}}", self.genVirtualSubs(offset))
        #print "........."
        #print self.genVirtualSubs(offset)
        return ret

    def genOneFunctionCode(self, func):
        ret = SERVER_FUNCTION_TEMPLATE_HPP
        # 避免重复
        funcName = func.name
        sendOutParam = u",".join([param[1].inParamString(param[0]) for param in func.outParam ])
        if len(sendOutParam) > 0 : sendOutParam += u","
        ret = self.replace(ret, u"{{FuncName}}", funcName)
        ret = self.replace(ret, u"{{SendOutParam}}", sendOutParam)
        return ret

    def genOneFunctionCodeRealize(self, func):
        ret = SERVER_FUNCTION_TEMPLATE_CPP
        # 避免重复
        funcName = func.name
        inParamDeclear = u"\n".join([param[1].declearVariantString(param[0]) for param in func.inParam])
        outParamDeclear = u"\n".join([param[1].declearVariantString(param[0]) for param in func.outParam ])
        parseBson = u"\n".join([ u"utils::safeParseBson(_response, \"%s\", %s);" % (param[0], param[0]) for param in func.inParam ] )
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
        parseBson = u"\n".join([ u"utils::safeParseBson(_response, \"%s\", %s);" % (param[0], param[0]) for param in func.inParam ] )
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

    def genIncludeCodes(self, offset):
        return self.offsetLines(SERVER_INCLUDE_TEMPLATE, offset)

    def genVirtualFuncs(self, offset):
        codes = []
        for func in self.desc.functions:
            funcName = func.name
            inParam = u", ".join(u"%s %s" % (param[1].paramString(), param[0]) for param in func.inParam)
            outParam = u", ".join(u"%s& %s" % (param[1].getTypeName(), param[0]) for param in func.outParam)
            inoutParam = joinStr(inParam, outParam, u",")
            if len(inoutParam) > 0 : inoutParam = inoutParam + u", "
            code = VIRTUAL_FUNCTION_TEMPLATE
            code = self.replace(code, u"{{FuncName}}", funcName)
            code = self.replace(code, u"{{InOutParam}}", inoutParam)
            codes.append(code)
        ret = u"\n".join(codes)
        return self.offsetLines(ret, offset)

    def genVirtualSubs(self, offset):
        codes = []
        for func in self.desc.subFunctions:
            funcName = func.name
            inParam = u", ".join(u"%s %s" % (param[1].paramString(), param[0]) for param in func.inParam)
            outParam = u", ".join(u"%s& %s" % (param[1].getTypeName(), param[0]) for param in func.outParam)
            inoutParam = joinStr(inParam, outParam, u",")
            if len(inoutParam) > 0 : inoutParam = inoutParam + u", "
            code = VIRTUAL_SUB_FUNCTION_TEMPLATE
            code = self.replace(code, u"{{FuncName}}", funcName)
            code = self.replace(code, u"{{InOutParam}}", inoutParam)
            if len(inParam) > 0 : inParam = inParam + u", "
            code = self.replace(code, u"{{InParam}}", inParam)
            codes.append(code)
        ret = u"\n".join(codes)
        return self.offsetLines(ret, offset)