#coding=utf-8
__author__ = 'Administrator'

from django.template import  loader, Context, Library
from django.conf import settings
import codecs as codecs
import stat
import os

settings.configure()

def saveFile(outputFile, str):
    try:
        os.chmod(outputFile, stat.S_IWRITE)
    except :
        pass
    outputHandler = codecs.open(outputFile, 'wb', 'utf-8')
    outputHandler.write(str)
    #os.chmod(outputFile, stat.S_IREAD)

def translate_from_file_to_file(template, context, output):
    settings.configure()
    s = codecs.open(template, "rb", "utf-8")
    s = s.lstrip( unicode( codecs.BOM_UTF8, "utf8" ) )
    t = loader.get_template_from_string(s.read())
    ret = t.render(Context(context))
    saveFile(output, ret)

def translate_from_string_to_file(template, context, output):
    settings.configure()
    t = loader.get_template_from_string(template)
    ret = t.render(Context(context))
    saveFile(output, ret)

def translate_from_file_to_string(template, context):
    settings.configure()
    s = codecs.open(template, "rb", "utf-8")
    s = s.lstrip( unicode( codecs.BOM_UTF8, "utf8" ) )
    t = loader.get_template_from_string(s.read())
    ret = t.render(Context(context))
    return ret

def translate_from_string_to_string(template, context):
    t = loader.get_template_from_string(template)
    ret = t.render(Context(context))
    register = Library() #作为合法的模板库，模块需要包含一个名为register的模块级变量
    return ret

if __name__ == "__main__":
    init()
    template = '''
    {% load rpcfilters %}
    {{a}}
{# 头文件 #}
{% for x in includes %}
#include {{x|kaonilaomu}}\
{% endfor %}

{% if includes|length == 4 %}
中华人民
{% else %}
中华人民共和国
{% endif %}

'''
    #print translate_from_string_to_string(template, {u"includes":[1,2,3,4], u"a":u"hehe"})