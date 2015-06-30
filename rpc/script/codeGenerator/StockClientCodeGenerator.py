#coding=utf8
__author__ = 'Administrator'
from StdClientCodeGenerator import StdClientCodeGenerator
from ClientTemplate import *

class StockClientCodeGenerator(StdClientCodeGenerator):
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
        #genBson = u"\n".join([ u"%s.appendElements(_builder);" % (param[0]) for param in func.inParam ] )
        genBson = u"\n".join([ u"utils::appendToBuilder(_builder, \"%s\", %s);" % (param[0], param[0]) for param in func.inParam ] )
        #parseBson = u"\n".join([ u"utils::safeParseBson(_response, \"%s\", %s);" % (param[0], param[0]) for param in func.outParam ] )
        parseBson = u"\n"
        hasResponse = False
        for param in func.outParam:
            tempKey = param[0]
            if param[0] == u"response":
                hasResponse = True
                tempKey = u"records"
            parseBson += u"utils::safeParseBson(_response, \"%s\", %s);\n" % (tempKey, param[0])
        if hasResponse:
            parseBson += u"size_t sizeT = response.size(); for (size_t i = 0; i < sizeT; i++) { response[i]->success = success; response[i]->error = \"\"; }"
        ret = CLIENT_SYNC_CODE_TEMPLATE_HPP.replace(u"{{FuncName}}", func.name)
        ret = self.replace(ret, u"{{InParam}}", inParamStr)
        ret = self.replace(ret, u"{{OutParam}}", outParamStr)
        ret = self.replace(ret, u"{{GenBson}}", genBson)
        ret = self.replace(ret, u"{{ParseBson}}", parseBson)
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
        #parseBson = u"\n".join([ u"utils::safeParseBson(_response, \"%s\", %s);" % (param[0], param[0]) for param in func.outParam ] )
        parseBson = u"\n"
        hasResponse = False
        for param in func.outParam:
            tempKey = param[0]
            if param[0] == u"response":
                hasResponse = True
                tempKey = u"records"
            parseBson += u"utils::safeParseBson(_response, \"%s\", %s);\n" % (tempKey, param[0])
        if hasResponse:
            print hasResponse
            parseBson += u"size_t sizeT = response.size(); for (size_t i = 0; i < sizeT; i++) { response[i]->success = success; response[i]->error = \"\"; }"
        ret = CLIENT_SYNC_CODE_TEMPLATE_CPP.replace(u"{{FuncName}}", func.name)
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
        #parseBson = u"\n".join([ u"utils::safeParseBson(_response[\"%s\"], %s);" % (param[0], param[0]) for param in func.outParam ] )
        parseBson = u"\n"
        hasResponse = False
        errorCode = u""
        for param in func.outParam:
            tempKey = param[0]
            if param[0] == u"response":
                hasResponse = True
                tempKey = u"records"
            parseBson += u"utils::safeParseBson(_response, \"%s\", %s);\n" % (tempKey, param[0])
        if hasResponse:
            parseBson += u"size_t sizeT = response.size(); for (size_t i = 0; i < sizeT; i++) { response[i]->success = success; response[i]->error = \"\"; }"
            errorCode = u'error_no = 10001; error_info = "字段解析错误"; success = false;'
        ret = CLIENT_ASYNC_CODE_TEMPLATE_HPP.replace(u"{{FuncName}}", func.name)
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
        #parseBson = u"\n".join([ u"utils::safeParseBson(_response[\"%s\"], %s);" % (param[0], param[0]) for param in func.outParam ] )
        parseBson = u"\n"
        hasResponse = False
        errorCode = u""
        for param in func.outParam:
            tempKey = param[0]
            if param[0] == u"response":
                hasResponse = True
                tempKey = u"records"
            parseBson += u"utils::safeParseBson(_response, \"%s\", %s);\n" % (tempKey, param[0])
        if hasResponse:
            parseBson += u"size_t sizeT = response.size(); for (size_t i = 0; i < sizeT; i++) { response[i]->success = success; response[i]->error = \"\"; }"
            errorCode = u'error_no = 10001; error_info = "字段解析错误"; success = false;'
        ret = CLIENT_ASYNC_CODE_TEMPLATE_CPP
        if self.desc.isNewError:
            ret = CLIENT_ASYNC_CODE_TEMPLATE_V2_CPP
        ret = ret.replace(u"{{FuncName}}", func.name)
        #ret = CLIENT_ASYNC_CODE_TEMPLATE_HPP.replace(u"{{FuncName}}", func.name)
        ret = self.replace(ret, u"{{Param}}", inParamStr)
        ret = self.replace(ret, u"{{OutTypes}}", outTypes)
        ret = self.replace(ret, u"{{GenBson}}", genBson)
        ret = self.replace(ret, u"{{ParseBson}}", parseBson)
        ret = self.replace(ret, u"{{OutParamDeclear}}", outParamDeclear)
        ret = self.replace(ret, u"{{OutParamName}}", outParamName)
        ret = self.replace(ret, u"{{MakeError}}", errorCode)
        return ret