# encoding=utf-8
from mongoengine import *
from usrmgr.models import User
from TTEngine.constants import SVN_ROOT
import logging
from utils.TracebackHelper import getTraceBack
from programBranch.models import BranchInfo
from TTEngine.mongoSettings import mongo_connect
logger = logging.getLogger('django')

mongo_connect()

class PortalMachine(Document):
    """
    Portal升级用机器,从上面获取安装包,SVN信息
    """
    name = StringField(required=True, max_length=30, verbose_name="别名", help_text="")
    host = StringField(required=True, max_length=30, verbose_name="主机", help_text="")
    port = IntField(required=True, verbose_name="端口号", help_text="")
    username = StringField(required=True, max_length=30, verbose_name="SSH登陆机器:U_NAME", help_text="")
    password = StringField(required=True, max_length=60, verbose_name="SSH登陆机器:PWD", help_text="")
    path = StringField(required=True, max_length=60, verbose_name="安装包获取路径", help_text="")
    create_time = DateTimeField(required=True, verbose_name="创建时间", help_text="")
    create_user = ReferenceField(User, verbose_name="创建者")
    update_time = DateTimeField(required=False, verbose_name="创建时间", help_text="")
    update_user = ReferenceField(User, required=False, verbose_name="更新者")


class PortalPackage(Document):
    """
    Portal版本
    """
    svn_url = StringField(required=True, max_length=180, verbose_name="SVN路径", help_text="")
    svn_version = StringField(max_length=90, required=False, verbose_name="SVN版本号,由程序写入", help_text="")
    is_enabled = BooleanField(required=True, verbose_name='是否可用')
    package = FileField(required=True, verbose_name="版本包", help_text="")
    package_size = IntField(required=True, verbose_name="文件大小", help_text="")
    sql = FileField(required=False, verbose_name="建库脚本", help_text="")
    sql_size = IntField(required=True, verbose_name="建库脚本大小", help_text="")
    sql_update = FileField(required=False, verbose_name="升级脚本", help_text="")
    portal_machine = ReferenceField(PortalMachine, verbose_name="源主机")
    create_user = ReferenceField(User, verbose_name="创建者")
    create_time = DateTimeField(required=True, verbose_name="创建时间", help_text="")
    update_user = ReferenceField(User, required=False, verbose_name="更新者")
    update_time = DateTimeField(required=False, verbose_name="创建时间", help_text="")
    remark = StringField(required=False, max_length=900, verbose_name="备注", help_text="")


    def get_branch_info(self):
        try:
            program_name, branch_tag = self._get_program_name_and_branch_tag()
            branch_info = BranchInfo.objects(programName=program_name, branchTag=branch_tag)
            if len(branch_info) == 0:
                logger.error('根据SVN:[url=%s][program_name=%s][branch_tag=%s]获取BranchInfo对象为空!' % (self.svn_url, program_name, branch_tag))
                return None
            return branch_info[0]
        except Exception as e:
            logger.error('根据SVN:[url=%s]获取BranchInfo对象异常![%s][%s]' % (self.svn_url, e.message, getTraceBack()))
            return None


    def get_program_name(self):
        program_name, branch_tag = self._get_program_name_and_branch_tag()
        return program_name


    def get_branch_tag(self):
        program_name, branch_tag = self._get_program_name_and_branch_tag()
        return branch_tag


    def _get_program_name_and_branch_tag(self):
        """
        根据URL解析program_name,branch_tag
        :return:
        """
        arr = None
        if self.svn_url.find('/server5/') > 0:
            arr = self.svn_url.split(SVN_ROOT + 'server5/')[1].split('/', 1)
        else:
            arr = self.svn_url.split(SVN_ROOT)[1].split('/', 1)
        program_name = arr[0]
        branch_tag = arr[1]
        return program_name, branch_tag


class PortalUpgradeSql(Document):
    """
    Portal升级脚本表
    """
    old_package = ReferenceField(PortalPackage, required=False, verbose_name="旧版本")
    new_package = ReferenceField(PortalPackage, required=False, verbose_name="新版本")
    version = StringField(max_length=90, required=True, verbose_name="升级包版本号", help_text="")
    sql = FileField(required=True, verbose_name="版本包", help_text="")
    create_user = ReferenceField(User, required=True, verbose_name="创建者")
    start_time = DateTimeField(required=True, verbose_name="创建时间", help_text="")
    end_time = DateTimeField(required=True, verbose_name="创建时间", help_text="")

class PortalUpdateSql(Document):
    """
    Portal升级脚本表(从上一个版本升级)
    """
    version = StringField(max_length=90, required=True, verbose_name="升级包版本号", help_text="")
    sql = FileField(required=True, verbose_name="版本包", help_text="")
    create_user = ReferenceField(User, required=True, verbose_name="创建者")
    start_time = DateTimeField(required=True, verbose_name="创建时间", help_text="")
    end_time = DateTimeField(required=True, verbose_name="创建时间", help_text="")


class PortalQuickupdateSql(Document):
    """
    Portal跨版本升级脚本表
    """
    upgrade_version = StringField(max_length=90, required=True, verbose_name="升级包版本号", help_text="")
    sql = FileField(required=True, verbose_name="版本包", help_text="")
    create_user = ReferenceField(User, required=True, verbose_name="创建者")

'''
class PortalDeployRecord(Document):
    """
    Portal升级记录表
    """
    customer = ReferenceField(Customer, verbose_name="客户")
    old_version = ReferenceField(PortalPackage, verbose_name="旧版本(即旧升级包)")
    new_version = ReferenceField(PortalPackage, verbose_name="新版本(即新升级包)")
    start_time = DateTimeField(required=False, verbose_name="升级开始时间", help_text="")
    end_time = DateTimeField(required=False, verbose_name="升级结束时间", help_text="")
    deploy_user = StringField(max_length=90, required=True, verbose_name="升级人,暂时写名字", help_text="")
    create_time = DateTimeField(required=True, verbose_name="操作时间", help_text="")
    create_user = ReferenceField(User, required=False, verbose_name="录入者")
    remark = StringField(max_length=90, required=True, verbose_name="升级备注,即升级原因", help_text="")
'''