# encoding=utf-8
from mongoengine import *
from module.models import Module, FileInfoDetail
from usrmgr.models import User
from programBranch.models import BranchInfo
from utils.OsHelper import OS_TYPE_LINUX
from package.models import Package
from portal.models import PortalPackage
from TTEngine.mongoSettings import mongo_connect

mongo_connect()


class CustomerPermissionSettings(Document):
    """
    客户权限设置项
    """
    name = StringField(max_length=90, required=True, verbose_name="设置项", help_text="")
    value = StringField(max_length=90, required=True, verbose_name="默认值", help_text="")
    value_type = StringField(max_length=30, required=True, verbose_name="值类型", help_text="")
    remark = StringField(max_length=90, required=False, verbose_name="权限说明", help_text="")

    @staticmethod
    def get_value_type():
        return ['Number', 'Boolean']


class Machine(Document):
    @staticmethod
    def get_machine_type_name(value):
        type_dict = {1: '编译机', 2: '测试机', 3: '客户机'}
        if value is not None and type_dict.has_key(value):
            return type_dict[value]
        return None

    type = IntField(required=True, verbose_name='机器类型1:编译机,2:测试机,3:客户机器')
    name = StringField(max_length=90, required=True, verbose_name="机器名称", help_text="")
    code = StringField(max_length=90, required=True, verbose_name="机器码", help_text="")
    xtDir = StringField(max_length=90, required=True, verbose_name="迅投根目录", help_text="")
    modules = ListField(ReferenceField(Module), verbose_name="机器模块")
    os = IntField(required=True, verbose_name="操作系统", help_text="", default=OS_TYPE_LINUX)
    host = StringField(required=False, max_length=30, verbose_name="主机", help_text="")
    port = IntField(required=False, verbose_name="端口号", help_text="")
    username = StringField(required=False, max_length=30, verbose_name="SSH登陆机器:U_NAME", help_text="")
    password = StringField(required=False, max_length=60, verbose_name="SSH登陆机器:PWD", help_text="")
    remark = StringField(max_length=90, required=True, verbose_name="备注", help_text="")
    settings = StringField(required=True, verbose_name="客户本地配置", default="{}")


class Customer(Document):
    name = StringField(max_length=90, required=True, verbose_name="客户名称", help_text="")
    tag = StringField(max_length=90, required=True, verbose_name="客户标记", help_text="")
    aftersale = StringField(max_length=90, required=True, verbose_name="售后负责人", help_text="", default="未知")
    customerstatus = StringField(max_length=90, required=True, verbose_name="客户状态", help_text="", default="测试中")
    version = StringField(max_length=90, required=True, verbose_name="客户数据版本", help_text="")
    virtual_ip = StringField(max_length=90, required=False, verbose_name="虚拟Ip", help_text="")
    outer_trade_ip = StringField(max_length=90, required=False, verbose_name="对外交易服务地址", help_text="")
    outer_market_ip = StringField(max_length=90, required=False, verbose_name="对外行情服务地址", help_text="")
    outer_portal_ip = StringField(max_length=90, required=False, verbose_name="对外Portal地址", help_text="")
    proxy_ip = StringField(max_length=90, required=False, verbose_name="proxy地址(客户端)", help_text="")
    update_server_ip = StringField(max_length=90, required=False, verbose_name="升级服务器IP", help_text="")
    position = StringField(max_length=90, required=False, verbose_name="客户所在地", help_text="")
    machines = ListField(ReferenceField(Machine))
    modules = ListField(ReferenceField(Module))
    permissions = DictField(required=False, verbose_name='客户权限设置')
    settings = StringField(required=True, verbose_name="客户本地配置", default="{}")
    is_sys = BooleanField(required=True, verbose_name='是否为系统用户')
    createTime = DateTimeField(required=True, verbose_name="创建时间", help_text="")
    modifyTime = DateTimeField(required=True, verbose_name="更新时间", help_text="")


class InstallPackage(Document):
    version = StringField(max_length=90, required=True, verbose_name="版本号,自动生成", help_text="")
    group_key = StringField(max_length=90, required=False, verbose_name="打包时的分组依据,唯一", help_text="")
    customer = ReferenceField(Customer, required=True, verbose_name="客户", help_text="")
    machine = ReferenceField(Machine, required=True, verbose_name="机器", help_text="")
    create_time = DateTimeField(required=True, verbose_name="创建时间", help_text="")
    create_user = ReferenceField(User, required=False, verbose_name="录入者")
    files = ListField(ReferenceField(FileInfoDetail), verbose_name="文件", help_text="")
    branches = StringField(max_length=900, verbose_name="分支", help_text="")
    # DictField不能包含'$'和'.',fuck why
    svn_info = StringField(required=False, verbose_name='svn信息')
    remark = StringField(max_length=900, verbose_name="备注", help_text="")
    is_enabled = BooleanField(required=True, verbose_name='是否可用', default=True)

class ClientPackage(Document):
    version = StringField(max_length=90, required=True, verbose_name="版本号,自动生成", help_text="")
    customer = ReferenceField(Customer, required=True, verbose_name="客户", help_text="")
    machine = ReferenceField(Machine, required=True, verbose_name="机器", help_text="")
    start_time = DateTimeField(required=True, verbose_name="打包开始时间", help_text="")
    end_time = DateTimeField(required=True, verbose_name="打包结束时间", help_text="")
    create_user = ReferenceField(User, required=False, verbose_name="录入者")
    branches = ListField(ReferenceField(BranchInfo), verbose_name="分支", help_text="")
    file = ReferenceField(FileInfoDetail, required=False, verbose_name="文件", help_text="")
    svn_info = StringField(required=False, verbose_name='svn信息')
    remark = StringField(max_length=900, verbose_name="备注", help_text="")
    is_enabled = BooleanField(required=True, verbose_name='是否可用', default=True)

class CustomerPackage(Document):
    """
    客户安装包(包含server,portal,建库脚本,待加入client包)
    """
    name = StringField(max_length=90, required=True, verbose_name="安装包名称", help_text="")
    is_enabled = BooleanField(required=True, verbose_name='是否可用', default=True)
    customer = ReferenceField(Customer, required=True, verbose_name="客户", help_text="")
    machines = ListField(ReferenceField(Machine), required=True, verbose_name="机器列表", help_text="")
    machine_packages = ListField(ReferenceField(InstallPackage), required=True, verbose_name='单台机器对应的列表')
    portal_upgrade_sql = StringField(max_length=9000, required=False, verbose_name="Portal数据库升级脚本", help_text="")
    portal_package = ReferenceField(PortalPackage, required=True, verbose_name='Portal包')
    create_time = DateTimeField(required=True, verbose_name="创建时间", help_text="")
    create_user = ReferenceField(User, required=False, verbose_name="录入者")
    remark = StringField(max_length=900, verbose_name="备注", help_text="")


# 升级记录
class DeployRecord(Document):
    customer = ReferenceField(Customer, verbose_name="客户")
    machine = ReferenceField(Machine, verbose_name="客户机器")
    new_version = ReferenceField(InstallPackage, verbose_name="新版本(即新升级包)")
    portal_package = ReferenceField(PortalPackage, required=False, verbose_name="Portal程序包")
    portal_upgrade_sql = StringField(max_length=9000, required=False, verbose_name="Portal数据库升级脚本", help_text="")
    start_time = DateTimeField(required=False, verbose_name="升级开始时间", help_text="")
    end_time = DateTimeField(required=False, verbose_name="升级结束时间", help_text="")
    deploy_user = StringField(max_length=90, required=True, verbose_name="升级人,暂时写名字", help_text="")
    remark = StringField(max_length=900, required=True, verbose_name="升级备注,即升级原因", help_text="")
    create_time = DateTimeField(required=True, verbose_name="操作时间", help_text="")
    create_user = ReferenceField(User, required=False, verbose_name="录入者")
    generatorJson = StringField(required=True, verbose_name="生成文件的json", help_text="")


# 新升级记录
class CustomerDeployRecord(Document):
    customer = ReferenceField(Customer, verbose_name="客户")
    cus_package = ReferenceField(CustomerPackage, required=False, verbose_name="Server安装包")
    portal_upgrade_sql = StringField(max_length=9000, required=False, verbose_name="Portal数据库升级脚本", help_text="")
    start_time = DateTimeField(required=False, verbose_name="升级开始时间", help_text="")
    end_time = DateTimeField(required=False, verbose_name="升级结束时间", help_text="")
    deploy_user = StringField(max_length=90, required=True, verbose_name="升级人,暂时写名字", help_text="")
    check_user = StringField(max_length=90, required=True, verbose_name="升级检查人,暂时写名字", help_text="")
    is_checked = StringField(max_length=90, required=True, verbose_name="是否进行升级检查", help_text="")
    remark = StringField(max_length=900, required=True, verbose_name="升级备注,即升级原因", help_text="")
    create_time = DateTimeField(required=True, verbose_name="操作时间", help_text="")
    create_user = ReferenceField(User, required=False, verbose_name="录入者")

#升级检查记录
class CustomerDeployCheckRecord(Document):
    customer = ReferenceField(Customer, verbose_name="客户")
    start_time = DateTimeField(required=False, verbose_name="升级检查开始时间", help_text="")
    end_time = DateTimeField(required=False, verbose_name="升级检查结束时间", help_text="")
    check_user = StringField(max_length=90, required=True, verbose_name="升级检查人,暂时写名字", help_text="")
    remark = StringField(max_length=900, required=True, verbose_name="升级检查备注,即升级检查过程中出现的问题", help_text="")
    create_time = DateTimeField(required=True, verbose_name="操作时间", help_text="")
    create_user = ReferenceField(User, required=False, verbose_name="录入者")

# 客户小贴士
class CustomerTip(Document):
    customer = ReferenceField(Customer, verbose_name="客户")
    is_active = BooleanField(required=True, verbose_name='是否过期')
    content = StringField(required=True, verbose_name="备注内容", help_text="")
    file = FileField(required=False, verbose_name="文件", help_text="")
    file_size = IntField(required=False, verbose_name="文件大小", help_text="")
    file_name = StringField(required=False, verbose_name="文件名", help_text="")
    create_user = ReferenceField(User, required=True, verbose_name="创建人")
    create_time = DateTimeField(required=True, verbose_name="创建时间", help_text="")
    update_user = ReferenceField(User, required=False, verbose_name="更新人")
    update_time = DateTimeField(required=False, verbose_name="更新时间", help_text="")

# 客户默认分支
class CustomerDefaultBranch(Document):
    customer = ReferenceField(Customer, required=False, verbose_name="客户")
    programName = StringField(required=True, verbose_name='程序名')
    branchTag = StringField(required=False, verbose_name="分支", help_text="")

class ClientDefaultBranch(Document):
    customer = ReferenceField(Customer, required=False, verbose_name="客户")
    programName = StringField(required=True, verbose_name='程序名')
    branchTag = StringField(required=False, verbose_name="分支", help_text="")
	
	
#更新状态
class CustomerDeployStatus(Document):
    state = StringField(required=True, verbose_name='更新状态')
    customer = ReferenceField(Customer, required=True, verbose_name="客户")
    machines = ListField(ReferenceField(Machine), required=False, verbose_name="机器列表", help_text="")
    server_is_old = BooleanField(required=False, verbose_name='server是否为关键更新')
    portal_is_old = BooleanField(required=False, verbose_name='portal是否为关键更新')
    server_svn_info = ListField(required=False, verbose_name="svn信息", help_text="")
    portal_svn_info = ListField(required=False, verbose_name="svn信息", help_text="")
    create_time = DateTimeField(required=False, verbose_name="创建时间", help_text="")

#portal默认分支
class PortalDefaultBranch(Document):
    customer = ReferenceField(Customer, required=True, verbose_name="客户")
    svn_version = StringField(required=False, verbose_name="svn版本号", help_text="")
    branchtag = StringField(required=False, verbose_name="分支", help_text="")
