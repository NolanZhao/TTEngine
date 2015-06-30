# coding=utf8
__author__ = 'Administrator'

from TTEngine.constants import DEFAULT_STRUCT_ID


class TypeInfo:
    def __init__(self, typeName, needInit, constRef):
        self.typeName = typeName
        self.needInit = needInit
        self.constRef = constRef
        if not self.needInit:
            if self.isEnum():
                self.needInit = True

    def paramString(self):
        if self.constRef:
            return u"const %s&" % self.typeName
        else:
            return self.typeName

    def getTypeName(self):
        return self.typeName

    def isNeedInit(self):
        return self.needInit

    def declearVariantString(self, name):
        ret = u"%s %s" % (self.getTypeName(), name)
        if self.isNeedInit():
            if self.getTypeName() == u"bool":
                ret += u" = false"
            else:
                ret += u" = utils::getDefaultValue< %s >()" % self.getTypeName()
        ret += u";"
        return ret

    def inParamString(self, name):
        ret = u"%s %s" % (self.paramString(), name)
        return ret

    def outParamString(self, name):
        ret = u"%s& %s" % (self.getTypeName(), name)
        return ret

    def isEnum(self):
        lines = self.typeName.split(":")
        if len(lines) > 0:
            line = lines[-1]
            if line.startswith("E"):
                return True
            else:
                return False
        else:
            return False

    def __repr__(self):
        return self.typeName


class TypeManager:
    def __init__(self):
        self.types = {}
        self.types[u"b"] = TypeInfo(u"bool", True, False)
        self.types[u"i"] = TypeInfo(u"int", True, False)
        self.types[u"d"] = TypeInfo(u"double", True, False)
        self.types[u"l"] = TypeInfo(u"long long", True, False)

    def getTypeInfo(self, tag):
        tag = tag.strip(u"#")
        if len(tag) == 1:
            tag = tag.lower()
        typeInfo = self.types.get(tag, None)
        if typeInfo is None:
            typeName = self.getTypeName(tag)
            typeInfo = TypeInfo(typeName, False, True)
        return typeInfo

    def registerType(self, typeName):
        self.types[typeName] = TypeInfo(typeName, False, True)

    def getTypeName(self, tag):
        rawTag = tag
        tag = tag.strip(u"#").strip()
        if len(tag) == 1:
            tag = tag.lower()
        typeName = u""
        typeInfo = self.types.get(tag, None)
        if typeInfo is None:
            # 判断是否是list
            if tag.startswith(u"[") and tag.endswith("]"):
                content = tag[1:-1]
                lName = self.types.get(u"v", None)
                if lName is None:
                    raise Exception("list name not find")
                typeName = u"%s< %s >" % (lName, self.getTypeName(content))

            # 判断是否是Map
            elif tag.startswith(u"{") and tag.endswith("}"):
                content = tag[1:-1]
                fields = content.split(u":", 1)
                mName = self.types.get(u"m", None)
                if mName is None:
                    raise Exception("map name not find")
                typeName = u"%s< %s, %s >" % (mName, self.getTypeName(fields[0].strip()), self.getTypeName(fields[1].strip()))
            else:
                if tag.find(u"::") >= 0:
                    typeName = tag
                else:
                    typeName = u"{{Namespace}}::%s" % tag
        else:
            typeName = typeInfo.getTypeName()
        #print typeName
        return typeName


class Function:
    def __init__(self, name, inParam, outParam):
        self.name = name
        self.strInparam = inParam
        self.strOutParam = outParam

        # 外部使用的参数
        self.inParam = []  # [ [#s, TypeInfo] ] , #s代表参数名, TypeInfo代表参数类型
        self.outParam = []  # [ [#s, TypeInfo] ] , #s代表参数名, TypeInfo代表参数类型

    def genTypeInfos(self, typeManger):
        self.inParam = [[param[0], typeManger.getTypeInfo(param[1])] for param in self.strInparam]
        self.outParam = [[param[0], typeManger.getTypeInfo(param[1])] for param in self.strOutParam]

    def __str__(self):
        return u"name:" + self.name + u"\n" + u"inparam:" + str(self.inParam) + u"\n" + u"outParam:" + str(self.outParam) + u"\n"

    def __repr__(self):
        return self.__str__()


class EnumItem:
    def __init__(self):
        self.name = u""
        self.value = u""
        self.comment = u""
        self.chsname = u""  #中文显示

    def __repr__(self):
        return u"name: %s, value: %s, comment: %s" % (self.name, self.value, self.comment)


class Enum:
    def __init__(self):
        self.name = u""
        self.items = []
        self.property = {}

    def __repr__(self):
        ret = u""
        ret += u"name : %s" % (self.name)
        ret += u"\n".join([repr(item) for item in self.items])
        return ret

    def getDefault(self):
        ret = u""
        if len(self.items) > 0:
            ret = self.items[0].name
        return ret


class Struct:
    def __init__(self):
        self.name = u""
        self.property = {}
        self.items = []
        self.baseType = ""
        #结构的序号
        self.num = "0"
        self.id = DEFAULT_STRUCT_ID

    def __repr__(self):
        ret = u""
        ret += u"name : %s" % (self.name)
        ret += u"\n".join([repr(item) for item in self.items])
        return ret

    def getDefault(self):
        return u""


class StructItem:
    def __init__(self):
        #字段名
        self.name = u""
        #序号
        self.num = 0
        #是否是key
        self.isKey = False
        #中文名
        self.chsname = u""
        #类型
        self.type = u""
        #精度
        self.precision = 1
        #标识
        self.flag = 0
        #注释
        self.comment = u""
        #默认值
        self.default = u""
        #是否显示,给c++那边传递一个字符串，1001这样的，1为真，0为假
        self.invisible = u""
        #这个item的属性
        self.propertys = []
        #这个item的显示的时候应该调用的函数
        self.funcs = []

    def __repr__(self):
        return u"name: %s, type: %s, comment: %s, num:%d, chinese name:%s default: %s" % (self.name, self.type, self.comment, self.num, self.chsname, self.default)


class ConstItem:
    def __init__(self):
        self.name = u""
        self.type = None
        self.value = u""
        self.comment = u""

    def __repr__(self):
        return u"name: %s, type: %s, value: %s, comment: %s" % (self.name, self.type, self.value, self.comment)


class RPCDescript:
    def __init__(self):
        # namespace
        self.nameSpace = u""
        # 服务名称
        self.serviceName = u""
        # 头文件, [#s]
        self.HppIncludes = []
        self.CppIncludes = []
        # 常量定义 [#s]
        self.consts = []
        # 枚举类型([ Enum])
        self.enums = []
        # 结构( [Struct] )
        self.structs = []
        # 请求函数 [ Function ]
        self.functions = []
        # 主推函数 [ Function ]
        self.pushFunctions = []
        # 订阅函数 [ Function ]
        self.subFunctions = []
        # 错误类型
        self.isNewError = False
        # 类型管理器
        self.typeManager = StdTypeManger()

    def genTypeInfos(self, typeManager):
        for struct in self.structs:
            for item in struct.items:
                item.type = typeManager.getTypeInfo(item.type)
        for item in self.functions:
            item.genTypeInfos(typeManager)
        for item in self.pushFunctions:
            item.genTypeInfos(typeManager)
        for item in self.subFunctions:
            item.genTypeInfos(typeManager)
        for aconst in self.consts:
            aconst.type = typeManager.getTypeInfo(aconst.type)

    def getStruct(self, name):
        if len(name):
            for i in self.structs:
                if i.name == name:
                    return i
        return None


class StdTypeManger(TypeManager):
    def __init__(self):
        TypeManager.__init__(self)
        self.types[u"s"] = TypeInfo(u"std::string", False, False)
        self.types[u"v"] = TypeInfo(u"std::vector", True, False)
        self.types[u"m"] = TypeInfo(u"std::map", True, False)


if __name__ == "__main__":
    tm = StdTypeManger()
    tag = u"{#s : {#s: #s} }"
    #print tm.getTypeInfo(tag)
    #print tm.getTypeName(tag)
