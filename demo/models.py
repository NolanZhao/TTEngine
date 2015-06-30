# encoding=utf-8
from mongoengine import *
from TTEngine.mongoSettings import mongo_connect
from usrmgr.models import User

mongo_connect()


class Platform(Document):
    """
    平台类
    """
    # TODO 废弃,待删除
    platform_id = IntField(required=False, verbose_name="平台ID", help_text="")
    type = IntField(required=False, verbose_name='类型', help_text='')
    name = StringField(required=False, verbose_name="名称", help_text="", max_length=90)
    abbr_name = StringField(required=False, verbose_name="简称", help_text="", max_length=90)
    so_name = StringField(required=False, verbose_name="So名称", help_text="", max_length=90)
    config = StringField(required=False, verbose_name="配置", help_text="", max_length=90)
    logo = StringField(required=False, verbose_name="Logo", help_text="", max_length=90)
    quoter_tag = StringField(required=False, verbose_name="行情标记", help_text="", max_length=90)
    broker_tag = StringField(required=False, verbose_name="BrokerTag", help_text="", max_length=90)


class VideoInfo(Document):
    tittle = StringField(max_length=300, required=True, verbose_name="视频标题", help_text="")
    description = StringField(max_length=300, required=False, verbose_name="详细描述", help_text="")
    attachment_url = StringField(max_length=90, required=False, verbose_name="附件名", help_text="")
    create_time = DateTimeField(required=True, verbose_name="提交时间", help_text="")
    create_user = ReferenceField(User, required=False, verbose_name="录入者")