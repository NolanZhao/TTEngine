# encoding=utf-8
from mongoengine import *
from usrmgr.models import User
from TTEngine.mongoSettings import mongo_connect

mongo_connect()


class CoreLogger(Document):
    collection = StringField(max_length=60, required=True, verbose_name="表名", help_text="")
    operate_type = IntField(required=True, verbose_name="操作类型(10:create,20:update,30:delete,...)", help_text="")
    result_type = IntField(required=True, verbose_name="结果类型(0:失败,1:成功,...)", help_text="")
    old_version = StringField(max_length=30, required=False, verbose_name="旧数据版本号", help_text="")
    old_data = StringField(max_length=500000, required=False, verbose_name="旧数据", help_text="")
    new_version = StringField(max_length=30, required=False, verbose_name="新数据版本号", help_text="")
    new_data = StringField(max_length=500000, required=False, verbose_name="新数据", help_text="")
    response = StringField(max_length=900, required=False, verbose_name="方法返回值", help_text="")
    create_user = ReferenceField(User)
    create_time = DateTimeField(required=True, verbose_name="创建时间", help_text="")
