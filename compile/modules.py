# encoding=utf-8
from mongoengine import *

from usrmgr.models import User
from programBranch.models import BranchInfo
from customer.models import Machine
from TTEngine.mongoSettings import mongo_connect

mongo_connect()

# 编译记录表
class CompilingUpdateRecord(Document):
    machine = ReferenceField(Machine, verbose_name="XX编译机")
    branch_info = ReferenceField(BranchInfo, required=True, verbose_name="当前分支信息")
    revision = IntField(verbose_name="当前分支版本号", required=False)
    start_time = DateTimeField(required=True, verbose_name="编译开始时间", help_text="")
    end_time = DateTimeField(required=False, verbose_name="编译结束时间", help_text="")
    # cmd_choices = {1: 'SVN更新', 2: 'SVN清理', 3: '编译'}
    cmd = IntField(required=True, verbose_name='指令类型[1:SVN更新,2:SVN清理,3:编译]')
    # status_choices = {1: '成功', 0: '失败', 2: '运行中'}
    status = IntField(required=True, verbose_name="编译状态[1:成功,0:失败,-1:运行中]")
    operate_user = ReferenceField(User, required=False, verbose_name="操作员")
    remark = StringField(required=False, max_length=5000, verbose_name="备注", help_text="")