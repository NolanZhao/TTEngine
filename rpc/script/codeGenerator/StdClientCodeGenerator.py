#coding=utf8
__author__ = 'Administrator'
from ClientCodeGenerator import ClientCodeGenerator
from ClientTemplate import *
from StdClientTemplate import *

class StdClientCodeGenerator(ClientCodeGenerator):
    def __init__(self, desc, typeManager):
        ClientCodeGenerator.__init__(self, desc, typeManager)

    def genIncludeCodes(self, offset):
        ret = ClientCodeGenerator.genIncludeCodes(self, 0)
        if len(ret) > 0 : ret += u"\n"
        ret += u"#include <boost/signals2.hpp>"
        ret = self.offsetLines(ret, offset)
        return ret

    def genClassCode(self, offset):
        lines = []
        for func in self.desc.pushFunctions:
            #for param in func.inParam:
            #    print repr(param)
            line = u"boost::signals2::signal<void (%s)> sig_%s;" % (u" ,".join([param[1].paramString() for param in func.inParam ]), func.name)
            lines.append(line)
        signalFunctions = u"\n".join(lines)

        ret = STD_CLIENT_CLASS_TEMPLATE_HPP
        if self.desc.isNewError:
            ret = STD_CLIENT_CLASS_TEMPLATE_V2_HPP
        ret = self.replace(ret, u"{{SignalFunctions}}", signalFunctions)
        ret = self.replace(ret, u"{{FunctionContent}}", self.genFunctionCodes(offset))
        ret = self.replace(ret, u"{{PushFunctionDeclear}}", self.genPushFunctionDeclear(offset))
        ret = self.offsetLines(ret, offset)
        return ret

    def genClassCodeRealize(self, offset):
        notifyCodes = u"\n".join([NOTIFY_CODE_TEMPLATE.replace(u"{{PushFunction}}", func.name) for func in self.desc.pushFunctions] )
        ret = STD_CLIENT_CLASS_TEMPLATE_CPP
        if self.desc.isNewError:
            ret = STD_CLIENT_CLASS_TEMPLATE_V2_CPP
        ret = self.replace(ret, u"{{PushFunctionContent}}", self.genPushFunctionCodesRealize(offset))
        ret = self.replace(ret, u"{{FunctionContent}}", self.genFunctionCodesRealize(offset))
        ret = self.replace(ret, u"{{NotifyCodes}}", notifyCodes)
        ret = self.offsetLines(ret, offset)
        return ret

    def genPushFunctionDeclear(self, offset):
        ret = u"\n".join([ u"void on_%s(bson::bo _response);" % func.name for func in self.desc.pushFunctions ])
        return ret

    def genPushFunctionCodes(self, offset):
        ret = u""
        ret += u"\n".join([self.genOnePushFunctionCode(func) for func in self.desc.pushFunctions])
        ret = self.offsetLines(ret, offset)
        return ret

    def genPushFunctionCodesRealize(self, offset):
        ret = u""
        ret += u"\n".join([self.genOnePushFunctionCodeRealize(func) for func in self.desc.pushFunctions])
        ret = self.offsetLines(ret, offset)
        return ret

    def genOnePushFunctionCode(self, func):
        paramDeclear = u"\n".join([param[1].declearVariantString(param[0]) for param in func.inParam])
        paramNames = u", ".join([u"%s" % param[0] for param in func.inParam])
        params = u", ".join([u"%s %s" % (param[1].paramString(), param[0]) for param in func.inParam])
        parseBson = u"\n".join([ u"utils::safeParseBson(_response, \"%s\", %s);" % (param[0], param[0]) for param in func.inParam ] )

        ret = STD_CLIENT_PUSH_FUNC_TEMPLATE_HPP
        ret = self.replace(ret, u"{{FuncName}}", func.name)
        ret = self.replace(ret, u"{{ParamDeclear}}", paramDeclear)
        ret = self.replace(ret, u"{{ParseBson}}", parseBson)
        ret = self.replace(ret, u"{{ParamNames}}", paramNames)
        ret = self.replace(ret, u"{{Params}}", params)
        return ret

    def genOnePushFunctionCodeRealize(self, func):
        paramDeclear = u"\n".join([param[1].declearVariantString(param[0]) for param in func.inParam])
        paramNames = u", ".join([u"%s" % param[0] for param in func.inParam])
        params = u", ".join([u"%s %s" % (param[1].paramString(), param[0]) for param in func.inParam])
        parseBson = u"\n".join([ u"utils::safeParseBson(_response, \"%s\", %s);" % (param[0], param[0]) for param in func.inParam ] )

        ret = STD_CLIENT_PUSH_FUNC_TEMPLATE_CPP
        ret = self.replace(ret, u"{{FuncName}}", func.name)
        ret = self.replace(ret, u"{{ParamDeclear}}", paramDeclear)
        ret = self.replace(ret, u"{{ParseBson}}", parseBson)
        ret = self.replace(ret, u"{{ParamNames}}", paramNames)
        ret = self.replace(ret, u"{{Params}}", params)
        return ret