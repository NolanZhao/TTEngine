#encoding=utf-8
from mongoengine import *
from usrmgr.models import User
from module.models import FileInfoDetail
from TTEngine.mongoSettings import mongo_connect

mongo_connect()


class Package(Document):
    #json_info = StringField(required=False, verbose_name="版本的json数据", help_text="")
    is_enabled = BooleanField(required=True, verbose_name='是否可用')
    version = StringField(max_length=90, required=True, verbose_name="版本号,手工录入", help_text="")
    package = FileField(required=False, verbose_name="版本包", help_text="")
    package_full_name = StringField(required=True, max_length=300, verbose_name="全路径", help_text="")
    package_name = StringField(required=True, max_length=300, verbose_name="文件名", help_text="")
    package_suffix = StringField(required=True, max_length=300, verbose_name="后缀", help_text="")
    package_size = IntField(required=True, verbose_name="文件大小", help_text="")
    upload_user = ReferenceField(User, verbose_name="创建者")
    create_time = DateTimeField(required=True, verbose_name="创建时间", help_text="")
    update_user = ReferenceField(User, required=False, verbose_name="更新者")
    update_time = DateTimeField(required=False, verbose_name="创建时间", help_text="")
    remark = StringField(required=True, max_length=900, verbose_name="备注", help_text="")
    source = StringField(required=True, max_length=30, verbose_name="录入来源,一般三个,部署测试机,版本库上传,编译机升级", help_text="")


class UpdatePackage(Document):
    package = FileField(required=False, verbose_name="版本包", help_text="")
