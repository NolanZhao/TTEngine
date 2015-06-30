__author__ = 'Administrator'

# coding=utf8
__author__ = 'Administrator'

import re
from datetime import date
from RPCTemplate import *
import hashlib
from LuaTemplate import *
from RPCCodeGenerator import RPCCodeGenerator

TAB_SIZE = 4
class LuaHCodeGenerator(RPCCodeGenerator):
    def __init__(self, desc, typeManager, tag = u"unknown"):
        self.desc = desc
        self.typeManager = typeManager
        self.tag = tag

    def genCodes(self):
        ret = LUA_H_CODES_TEMPLATE
        ret = self.replace(ret, u"{{Namespace}}", self.desc.nameSpace)
        ret = self.replace(ret, u"{{ServiceName}}", self.desc.serviceName)
        ret = self.replace(ret, u"{{tag}}", self.tag)
        return ret


class LuaCppCodeGenerator(RPCCodeGenerator):
    def __init__(self, desc, typeManager, tag = u"unknown"):
        self.desc = desc
        self.typeManager = typeManager
        self.tag = tag

    def genCodes(self):
        ret = LUA_CODES_TEMPLATE
        ret = self.replace(ret, u"{{RegisterCodes}}", "")
        ret = self.replace(ret , u"{{BindFuncs}}", self.genBindFincsCodes(0))
        ret = self.replace(ret , u"{{StructBindCodes}}", self.genLuaStructBindCodes(0))
        ret = self.replace(ret , u"{{StructCommonBindCodes}}", self.genCommonStructBindCodes(0))
        ret = self.replace(ret , u"{{StructsDeclear}}", self.genStructsDeclearCodes(0))
        ret = self.replace(ret , u"{{EnumsDeclear}}", self.genEnumsDeclearCodes(0))
        ret = self.replace(ret , u"{{ConstCodes}}", self.genConstLuaCodes(0))
        ret = self.replace(ret , u"{{EnumCodes}}", self.genEnumLuaCode(0))
        ret = self.replace(ret, u"{{StructIdCodes}}", self.genStructIdLuaCodes(0))
        ret = self.replace(ret, u"{{Namespace}}", self.desc.nameSpace)
        ret = self.replace(ret, u"{{ServiceName}}", self.desc.serviceName)
        ret = self.replace(ret, u"{{tag}}", self.tag)
        return ret

    def genBindFincsCodes(self, offset):
        ret = u"\n".join(["bind_struct_%s(state);" % astruct.name for astruct in self.desc.structs if astruct.property.has_key("lua")])
        ret = ret + u"\n"
        ret = ret + u"\n".join(["bind_struct_%s(state);" % aenum.name for aenum in self.desc.enums if aenum.property.has_key("lua")])
        return ret

    def genStructsDeclearCodes(self, offset):
        ret = u"\n".join(["static void bind_struct_%s(lua_State* state);" % astruct.name for astruct in self.desc.structs if  (astruct.property.has_key("lua"))])
        return ret

    def genEnumsDeclearCodes(self, offset):
        ret = u"\n".join(["static void bind_struct_%s(lua_State* state);" % aenum.name for aenum in self.desc.enums if  (aenum.property.has_key("lua"))])
        return ret

    def genStructDefCodes(self):
        ret = u'''
#ifndef STRUCTS_DEF_{{ServiceName}}_HPP
#define STRUCTS_DEF_{{ServiceName}}_HPP

namespace {{Namespace}}
{
    class IData;
    typedef boost::shared_ptr<IData> IDataPtr;

    {{CostDefineContentCodes}}
};
#endif\
'''
        ret = ret.replace(u"{{Namespace}}", self.desc.nameSpace).replace(u"{{ServiceName}}", self.desc.serviceName)
        codeDef = "\n".join( self.genOneStructDefCodes(astruct) for astruct in self.desc.structs)
        return self.replace(ret, u"{{CostDefineContentCodes}}", codeDef)


    def genOneStructDefCodes(self, astruct):
        if astruct.property.has_key("old"):
            ret = u"struct {{STRUCT_NAME}};\n".replace(u"{{STRUCT_NAME}}", astruct.name)
        else:
            ret = u"class {{STRUCT_NAME}};\n".replace(u"{{STRUCT_NAME}}", astruct.name)
        if astruct.property.has_key("ptr"):
            ret += u"typedef boost::shared_ptr<{{STRUCT_NAME}}> {{STRUCT_NAME}}Ptr;\n".replace(u"{{STRUCT_NAME}}", astruct.name)
        return ret


    def genEnumLuaCode(self, offset):
        codes = []
        for aenum in self.desc.enums :
            if aenum.property.has_key("lua"):
                template = 'global["{{ENUM_FIELD}}"] = (int){{ENUM_FIELD}};'
                v = []
                for x in aenum.items:
                    v.append(template.replace("{{ENUM_FIELD}}", x.name))
                code = ENUM_BIND_TEMPLATE
                code = self.replace(code, "{{StructName}}", aenum.name)
                code = self.replace(code, "{{EnumFieldsCodes}}", "\n".join(v))
                codes.append(code)
        return "\n".join(codes)

    def genConstLuaCodes(self, offset):
        template = 'global["{{ENUM_FIELD}}"] = {{ENUM_FIELD}};'
        ret = u"\n".join(template.replace("{{ENUM_FIELD}}", aconst.name) for aconst in self.desc.consts )
        return ret

    def genLuaStructBindCodes(self, offset):
        ret = u"\n".join(self._genOneStructLuaCode(astruct, STRUCT_BIND_TEMPLATE) for astruct in self.desc.structs if  (astruct.property.has_key("lua") and (not (astruct.property.has_key("old"))) ))
        return ret

    def genCommonStructBindCodes(self, offset):
        ret = u"\n".join(self._genOneStructLuaCode(astruct, STRUCT_BIND_TEMPLATE) for astruct in self.desc.structs if  (astruct.property.has_key("lua") and  (astruct.property.has_key("old"))) )
        return ret

    def genLuaStructFuncCodes(self, offset):
        ret = u"\n".join("bind_struct_%s();" % astruct.name for astruct in self.desc.structs if  (astruct.property.has_key("lua") and (not (astruct.property.has_key("old"))) ))
        return ret

    def _genOneStructLuaCode(self, astruct, template):
        fieldDefCodes = u"\n".join('.def_readwrite("%s", &%s::%s)' % (item.name, astruct.name, item.name) for item in astruct.items )
        ret = template
        ret = self.replace(ret, u"{{FieldDefCodes}}", fieldDefCodes)
        ret = self.replace(ret, u"{{StructName}}", astruct.name)
        ret = self.replace(ret, u"{{StructFiledIdCodes}}", self._genStructFiledIdLuaCodes(astruct))

        baseType = u"IData"
        if len(astruct.baseType) > 0 :
            baseType = astruct.baseType.strip()
        ret = self.replace(ret, u"{{BaseType}}", baseType)
        return ret

    def _genOneStructLuaCode(self, astruct, template):
        fieldDefCodes = u"\n".join('.def_readwrite("%s", &%s::%s)' % (item.name, astruct.name, item.name) for item in astruct.items )
        ret = template
        ret = self.replace(ret, u"{{FieldDefCodes}}", fieldDefCodes)
        ret = self.replace(ret, u"{{StructName}}", astruct.name)
        ret = self.replace(ret, u"{{StructFiledIdCodes}}", self._genStructFiledIdLuaCodes(astruct))

        baseType = u"IData"
        if len(astruct.baseType) > 0 :
            baseType = astruct.baseType.strip()
        ret = self.replace(ret, u"{{BaseType}}", baseType)
        return ret

    def _genStructFiledIdLuaCodes(self, astruct):
        template = 'global["{{STRUCT_NAME}}_{{ENUM_FIELD}}"] = {{STRUCT_NAME_RAW}}::ITEM_{{ENUM_FIELD}};'
        lines = []
        lines.append("\n //%s" % astruct.name)
        for item in astruct.items:
            lines.append(template.replace("{{ENUM_FIELD}}", item.name).\
            replace("{{STRUCT_NAME}}", astruct.name).replace("{{STRUCT_NAME_RAW}}", astruct.name))
        return u"\n".join(lines)

    def genStructIdLuaCodes(self, offset):
        template = 'global["{{ENUM_FIELD}}"] = (int){{ENUM_FIELD}};'
        ret = "\n".join(template.replace("{{ENUM_FIELD}}", ("XT_%s" % astruct.name)) for astruct in self.desc.structs if (astruct.property.has_key("lua") and (not (astruct.property.has_key("old")))))
        return ret

    def genFunctionLuaCode(self):
        ret = ""
        return ret