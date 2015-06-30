#encoding=utf-8
from mongoengine import *
from module.models import Module, FileInfoDetail
from usrmgr.models import User
from utils.OsHelper import OS_TYPE_LINUX
from package.models import Package
from portal.models import PortalPackage
from TTEngine.mongoSettings import mongo_connect
from customer.models import Customer
from django import forms

mongo_connect()


class ServerMonitorLogType(Document):
    create_time = DateTimeField(required=True, verbose_name="提交时间", help_text="")
    create_user = ReferenceField(User, required=False, verbose_name="录入者")
    log_type = StringField(max_length=90, required=True, verbose_name="日志类型", help_text="")
    detail = StringField(max_length=90, required=False, verbose_name="详细描述", help_text="")


class ServerMonitorModule(Document):
    create_time = DateTimeField(required=True, verbose_name="提交时间", help_text="")
    create_user = ReferenceField(User, required=False, verbose_name="录入者")
    module = StringField(max_length=90, required=True, verbose_name="监控模块", help_text="")
    description = StringField(max_length=90, required=True, verbose_name="详细描述", help_text="")


class ServerMonitorLog(Document):
    cus = ReferenceField(Customer, required=True, verbose_name="客户名称", help_text="")
    log_type = ReferenceField(ServerMonitorLogType, required=True, verbose_name="日志类型", help_text="")
    monitor_type = IntField(required=True, verbose_name="监控类型", help_text="")
    module_type = ReferenceField(ServerMonitorModule, required=True, verbose_name="模块类型", help_text="")
    detail = StringField(max_length=300, required=False, verbose_name="详细描述", help_text="")
    attachment_url = StringField(max_length=90, required=False, verbose_name="附件名", help_text="")
    create_time = DateTimeField(required=True, verbose_name="提交时间", help_text="")
    create_user = ReferenceField(User, required=False, verbose_name="录入者")
    cus_uuid = StringField(max_length=300, required=False, verbose_name="uuid码", help_text="")