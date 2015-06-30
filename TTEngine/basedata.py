# encoding=utf-8
__author__ = 'nerve'
import sys

reload(sys)
sys.setdefaultencoding('utf-8')

from usrmgr.models import User, UserGroup
import datetime
import logging
import os
from rpc.script.codeGenerator.base.RPCStruct import StdTypeManger
from rpc.script.codeGenerator.CodeGenerator import parseFile
from TTEngine.settings import *
from TTEngine.constants import *
from menu.models import Menu

logger = logging.getLogger('django')

# 初始化数据库数据
try:
    # user表
    if  len(User.objects()) == 0 :
        User.create_user('admin', '123', is_staff=True, is_active=True, is_superuser=True)
        logger.info('创建admin用户成功!')
    else:
        logger.info('已有用户，无需创建admin')

except Exception as e:
    logger.error('程序异常 --> [%s]' % str(e))

# 初始化用户组对象
try:
    for item_dict in USER_GROUP_LIST:
        key = item_dict['k']
        value = item_dict['v']
        if len(UserGroup.objects(key=key)) == 0:
            group = UserGroup()
            group.key = key
            group.value = value
            group.save()
    logger.info('初始化用户组成功!')
except Exception as e:
    logger.error('初始化用户组异常![%s]' % e.message)

# 初始化菜单对象
try:
    for menu_item in MENU_LIST:
        main_menu = menu_item['main']
        if not Menu.objects(type=MENU_MAIN, p_key=main_menu[2], c_key=main_menu[3]):
            Menu.gen_new_menu(main_menu[0], main_menu[1], main_menu[2], main_menu[3], main_menu[4])
            logger.info('生成主菜单:[%s][%s][%s][%s][%s]' % (main_menu[0], main_menu[1], main_menu[2], main_menu[3], main_menu[4]))
        sub_menu = menu_item['sub']
        for sub_menu_item in sub_menu:
            if not Menu.objects(type=MENU_SUB, p_key=sub_menu_item[2], c_key=sub_menu_item[3]):
                Menu.gen_new_menu(sub_menu_item[0], sub_menu_item[1], sub_menu_item[2], sub_menu_item[3], sub_menu_item[4])
                logger.info('生成子菜单:[%s][%s][%s][%s][%s]' % (sub_menu_item[0], sub_menu_item[1], sub_menu_item[2], sub_menu_item[3], sub_menu_item[4]))

    logger.info('初始化菜单成功!')
except Exception as e:
    logger.error('初始菜单异常![%s]' % e.message)


# key:ID,value:Struct cache
rpc_structs = {}


def init_rpc_data():
    """
    初始化RPC数据
    """
    try:
        # 查找RPC文件
        path = os.path.join(os.path.join(PROJECT_PATH, 'rpc'), 'protocols')
        file_list = []
        # 遍历查找RPC文件
        for root, subFolders, files in os.walk(path):
            # 排除特定的子目录
            if 'done' in subFolders:
                subFolders.remove('done')
            # 查找特定扩展名的文件，只要包含'.py'字符串的文件，都会被包含
            for f in files:
                if f.endswith('.rpc'):
                    file_list.append(os.path.join(root, f))

        # 序列化RPC结构定义
        typeManager = StdTypeManger()
        for item in file_list:
            desc = parseFile(item, typeManager)
            # 查找结构体对象
            structs = desc.structs
            for item in structs:
                if item.id == DEFAULT_STRUCT_ID:
                    continue
                rpc_structs[item.id] = item

        logger.info('RPC结构体数据ID初始化成功!')
    except Exception as e:
        logger.error('初始化RPC数据异常! --> [%s]' % ( str(e)))

# 暂时不执行此方法
# init_rpc_data()

if SYNC_SVN_INFO_TASK:
    try:
        import threading
        from thread_task.main_task import SyncSvnInfoTask
        # 启动线程
        sync_svn_info_task = SyncSvnInfoTask(threading.Lock(), sleep_time=SYNC_SVN_INFO_TASK_SLEEP_TIME)
        sync_svn_info_task.setName('同步各个分支SVN信息守护线程')
        sync_svn_info_task.start()
    except Exception as e:
        logger.error('启动同步各个分支SVN信息守护线程失败[%s]' % e.message)

if CHECK_BRANCH_INFO_TASK:
    try:
        import threading
        from thread_task.main_task import CheckBranchInfoTask
        # 启动线程
        check_branch_info_task = CheckBranchInfoTask(threading.Lock(), sleep_time=CHECK_BRANCH_INFO_TASK_SLEEP_TIME)
        check_branch_info_task.setName('校验SVNBranch对象守护线程')
        check_branch_info_task.start()
    except Exception as e:
        logger.error('启动校验SVNBranch对象守护线程失败[%s]' % e.message)

if __name__ == '__main__':
    init_rpc_data()