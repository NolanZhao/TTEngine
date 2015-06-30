# encoding=utf-8
from mongoengine import *
from TTEngine.constants import *
from usrmgr.models import User
from TTEngine.mongoSettings import mongo_connect

mongo_connect()

def getLocalDir(tag):
    """
    获取本地副本路径
    :param tag:
    :return:
    """
    if tag in [XT_TRADE_CLIENT, TT_MANAGEMENT_PORTAL, UPDATER, XT_PLATFORM]:
        return PROGRAM_DIR + tag
    else:
        return PROGRAM_DIR + "server5/" + tag


def getSvnUrl(tag):
    """
    待删除,未用方法
    :param tag:
    :return:
    """
    if tag == XT_TRADE_CLIENT:
        return SVN_ROOT + tag
    else:
        return SVN_ROOT + "server5/" + tag


class BranchInfo(Document):
    programName = StringField(max_length=90, required=True, verbose_name="程序名称", help_text="")
    branchTag = StringField(max_length=90, required=True, verbose_name="分支路径", help_text="")
    customerTag = StringField(max_length=90, verbose_name="客户标记", help_text="", default="")
    is_exist = BooleanField(required=False, verbose_name='SVN路径是否存在')
    createDate = StringField(max_length=90, verbose_name="创建日期", help_text="")


class KeySubmit(Document):
    branch = ReferenceField(BranchInfo, required=True, verbose_name="分支路径")
    revision_start = IntField(required=True, verbose_name='svn起始版本号')
    revision_end = IntField(required=True, verbose_name='svn结束版本号')
    remark = StringField(max_length=600, verbose_name="备注", help_text="", default="")
    create_user = ReferenceField(User, verbose_name="创建者")
    create_time = DateTimeField(required=True, verbose_name="创建时间", help_text="")
    update_user = ReferenceField(User, required=False, verbose_name="更新者")
    update_time = DateTimeField(required=False, verbose_name="更新时间", help_text="")