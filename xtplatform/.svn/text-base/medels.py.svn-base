# coding=utf8
__author__ = 'xujun'

from mongoengine import *
from TTEngine.mongoSettings import mongo_connect

mongo_connect()


class Platform(Document):
    m_nType = IntField(required=True, verbose_name="类型", help_text="", default=1)
    m_nId = IntField(required=True, verbose_name="平台Id", help_text="")
    m_strName = StringField(required=True, max_length=30, verbose_name="平台名称", help_text="")
    m_strAbbrName = StringField(max_length=30, verbose_name="平台缩写", help_text="")
    m_strSoName = StringField(required=True, max_length=30, verbose_name="动态库名称", help_text="")
    m_strLogo = StringField(max_length=30, required=True, verbose_name="logo", help_text="")
    m_strConfig = StringField(max_length=30, required=True, verbose_name="配置路径", help_text="")
    m_strQuoterTag = StringField(max_length=90, required=True, verbose_name="行情标记", help_text="")
    m_strBrokerTag = StringField(max_length=90, required=True, verbose_name="BrokerTag", help_text="")
    m_strfastTag = StringField(max_length=90, required=True, verbose_name="快速交易", help_text="",default=0)


    def getFields(self):
        return tuple([k for k, v in self._fields.iteritems() if k != "id"])

    def getData(self):
        data = {}
        for k, v in self._data.iteritems():
            if k != "id":
                data[k] = v
        return data