# encoding=utf-8
__author__ = 'nerve'

import re
import platform

# 不运行
RUN_TYPE_NONE = 0
# 安装时运行
RUN_TYPE_SETUP = 1
# 主机一直运行
RUN_TYPE_MASTER_ALWAYS = 2
# 定时运行
RUN_TYPE_TIMER = 3
# 主备同时运行
RUN_TYPE_ALL_ALWAYS = 4

# 创建
OPERATE_CREATE = 10
# 更新
OPERATE_UPDATE = 20
# 删除
OPERATE_DELETE = 30

# 成功
RESULT_TYPE_SUCCESS = 1
# 失败
RESULT_TYPE_FAILURE = 0
# 运行中
RESULT_TYPE_RUNNING = -1

# 版本前缀
VERSION_PREFIX_MODULE = 'M_'
VERSION_PREFIX_CUSTOMER = 'C_'
VERSION_PREFIX_PACKAGE = 'P_'
VERSION_PREFIX_COMPILING = 'CP_'
# portal升级脚本版本
VERSION_PREFIX_PORTAL_UPGRADE_SCRIPT = 'U_'

# 机器类型
MACHINE_TYPE_COMPILING = 1
MACHINE_TYPE_TEST = 2
MACHINE_TYPE_CUSTOMER = 3

# 更新包来源
# 版本库上传
SOURCE_UPLOAD = 'upload'
# 测试机上传
SOURCE_TEST = 'test'
# 编译机编译
SOURCE_COMPILE = 'compile'
# 自动产生
SOURCE_AUTO = 'autoGen'

# content_type
CONTENT_TYPE = {
    'zip': 'application/zip',
    'gz': 'application/gzip'
}

# datetime format string
DEFAULT_DATETIME = '%Y-%m-%d %H:%M:%S'

# file_type
FILE_TYPE_UNKNOWN = 0  # 未知文件
FILE_TYPE_COMPILE = 1  # 编译文件
FILE_TYPE_CONFIG = 2  # 配置文件
FILE_TYPE_SCRIPT = 3  # 脚本文件
FILE_TYPE_LINK = 4  # 软链文件

FILE_TYPE_DICT = {
    FILE_TYPE_UNKNOWN: '未知文件',
    FILE_TYPE_COMPILE: '编译文件',
    FILE_TYPE_CONFIG: '配置文件',
    FILE_TYPE_SCRIPT: '脚本文件',
    FILE_TYPE_LINK: '软链文件'
}

# 默认RPC结构体ID
DEFAULT_STRUCT_ID = -1

# 操作系统平台
SYS_OS = platform.architecture()[1]
# 操作系统位数(这个应该是python程序的位数)
SYS_BIT = int(platform.architecture()[0][0:2])


def is_windows():
    """
    判断是否为windows系统
    :return:
    """
    pattern = re.compile(r'^Windows[\w]*$')
    return True if pattern.match(SYS_OS) else False


SVN_ROOT = 'http://210.14.136.67/svn/svnrepos/'
PROGRAM_DIR = "/home/sourcecode/work/"
if is_windows():
    PROGRAM_DIR = "E:/"

TT_SERVICE = 'ttservice'
BROKER = 'broker'
QUOTER = 'quoter'
CLEARSERVICE = 'clearservice'
CTPSERVICE = 'ctpservice'
APISERVICE = 'tradeapiservice'
XT_TRADE_CLIENT = 'XtTradeClient'
TT_MANAGEMENT_PORTAL = 'TTManagementPortal'
DEAMON = 'daemon'
UPDATER = 'updater'
XT_PLATFORM = 'XtPlatform'
BASE = 'base'
TRADER_BASE = 'traderbase'

#附件保存位置
ATTACHMENTS_DIR = "media/monitor_log/"
VIDEO_DIR = "media/video/"

PROGRAM_LIST = [TT_SERVICE, BROKER, QUOTER, XT_TRADE_CLIENT, CLEARSERVICE, CTPSERVICE, APISERVICE]

PROGRAM_LIST4SVN = [TT_SERVICE, BROKER, QUOTER, CLEARSERVICE, CTPSERVICE, APISERVICE, XT_TRADE_CLIENT, TT_MANAGEMENT_PORTAL, BASE, TRADER_BASE]

ALL_SVN_LIST = [UPDATER, TT_SERVICE, QUOTER, DEAMON, BROKER, XT_TRADE_CLIENT, TT_MANAGEMENT_PORTAL, CLEARSERVICE, CTPSERVICE, APISERVICE]

# Portal升级数据库脚本专用机器S
PORTAL_GET_SQL_IP = '192.168.1.205'
PORTAL_GET_SQL_PORT = 22
PORTAL_GET_SQL_USERNAME = 'root'
PORTAL_GET_SQL_PASSWORD = 'rzrk.suse'
PORTAL_GET_SQL_SQL_NAME = 'root'
PORTAL_GET_SQL_SQL_PWD = 'mysql.rzrk'

PORTAL_GEN_SQL_ADD_TABLE = ['roles_menu', 'roles_permission','workflow_workflow','workflow_nodes']

XT_TRADE_CLIENT_DIR = PROGRAM_DIR + 'XtTradeClient/'
LOCK_FILE_NAME = 'build_make_packege.lock'

CMD_SVN_UP = 1
CMD_MAKE_CLEAN = 2
CMD_COMPILE = 3

USER_GROUP_ADMIN = 'administrator'

# 添加菜单流程
# 1.新建菜单对象
# 2.加入菜单树[MENU_LIST],加入全部菜单[ALL_MENU]
# 3.配置组权限[USER_GROUP_LIST]

# 主菜单
MENU_MAIN = 1
# 子菜单
MENU_SUB = 2
# 菜单列表
USER = [MENU_MAIN, '用户管理', 'user', None, None]
USER_LIST = [MENU_SUB, '用户列表', 'user', 'user_list', '/user/list/']
USER_CREATE = [MENU_SUB, '创建用户', 'user', 'user_create', '/user/create/']

MODULE = [MENU_MAIN, '模块管理', 'module', None, None]
MODULE_LIST = [MENU_SUB, '模块列表', 'module', 'module_list', '/module/list/']
MODULE_GROUP_LIST = [MENU_SUB, '模块组', 'module', 'module_group', '/module/group/']

CUSTOMER = [MENU_MAIN, '客户管理', 'customer', None, None]
CUSTOMER_LIST = [MENU_SUB, '客户列表', 'customer', 'customer_list', '/demo/quickSearch/']
CUSTOMER_LIST = [MENU_SUB, '客户列表', 'customer', 'customer_list', '/customer/list']
CUSTOMER_PERMISSION_VIEW = [MENU_SUB, '权限项配置', 'customer', 'customer_permission_view', '/customer/permission/view/']
CUSTOMER_PERMISSION_SETTING = [MENU_SUB, '客户权限表', 'customer', 'permission_setting', '/customer/permission_setting/']
CUSTOMER_REMARK_LIST = [MENU_SUB, '客户备注', 'customer', 'customer_remark_list', '/customer/remark/list/']
CUSTOMER_ALL_DEPLOY_RECORD_LIST = [MENU_SUB, '升级记录', 'customer', 'customer_all_deploy_record_list', '/customer/all/deploy/record/list/']
CUSTOMER_ALL_DEPLOY_UNCHECKED_LIST = [MENU_SUB, '待检查记录', 'customer', 'customer_all_deploy_unchecked_list', '/customer/all/deploy/record/unchecked/list/']

PROGRAMBRANCH = [MENU_MAIN, 'Svn管理', 'programBranch', None, None]
PROGRAMBRANCH_LIST = [MENU_SUB, '分支列表', 'programBranch', 'programBranch_list', '/programBranch/list/']
PROGRAMBRANCH_KEY_LIST = [MENU_SUB, '关键更新', 'programBranch', 'programBranch_key_list', '/programBranch/key/list/']

PORTAL = [MENU_MAIN, 'Portal管理', 'portal', None, None]
PORTAL_PACKAGE_LIST = [MENU_SUB, '程序包列表', 'portal', 'portal_package_list', '/portal/package/list/']
PORTAL_PACKAGE_CREATE = [MENU_SUB, '生成程序包', 'portal', 'portal_package_create', '/portal/package/create/']
PORTAL_UPDATE_GEN_SQL = [MENU_SUB, '生成升级脚本', 'portal', 'portal_update_gen_sql', '/portal/update/gen_sql/']
PORTAL_UPLOADFILE_GEN_SQL = [MENU_SUB, '上传文件生成升级脚本', 'portal', 'portal_uploadfile_gen_sql', '/portal/update/uploadfile_gen_sql/']
PORTAL_QUICK_GEN_SQL = [MENU_SUB, '快速生成升级脚本', 'portal', 'portal_quick_gen_sql', '/portal/update/quick_gen_sql/']
PORTAL_MACHINE_VIEW = [MENU_SUB, '部属机配置', 'portal', 'portal_machine_view', '/portal/machine/view/']

CUSTOMER_SYSTEM = [MENU_MAIN, '测试机管理', 'customer_system', None, None]
CUSTOMER_SYSTEM_LIST = [MENU_SUB, '测试机列表', 'customer_system', 'customer_system_list', '/customer/system/list/']

CUSTOMER_COMPILING = [MENU_MAIN, '编译机管理', 'customer_compiling', None, None]
CUSTOMER_COMPILING_RECORD_LIST = [MENU_SUB, '编译机日志', 'customer_compiling', 'customer_compiling_record_list', '/customer/compiling/record/list/']

DEMO_PLATFORM = [MENU_MAIN, '平台管理', 'demo_platform', None, None]
DEMO_PLATFORM_VIEW = [MENU_SUB, '平台管理', 'demo_platform', 'demo_platform_view', '/demo/platform/view/']

SERVER_MONITOR = [MENU_MAIN, '服务器监控', 'server_monitor', None, None]
SERVER_MONITOR_TYPE = [MENU_SUB, '监控类型', 'server_monitor', 'server_monitor_type', '/serverMonitor/logType/']
SERVER_MONITOR_LIST = [MENU_SUB, '监控列表', 'server_monitor', 'server_monitor_list', '/serverMonitor/logList/']
SERVER_MONITOR_MODULE = [MENU_SUB, '监控模块', 'server_monitor', 'server_monitor_module', '/serverMonitor/monitorModule/']
SERVER_MONITOR_LOG = [MENU_SUB, '提交日志', 'server_monitor', 'server_monitor_log', '/serverMonitor/logPost/']


DEMO = [MENU_MAIN, '快捷功能', 'demo', None, None]
DEMO_REDIS_VIEW = [MENU_SUB, 'Redis数据库', 'demo', 'demo_redis_view', '/demo/redis/view/']
DEMO_STOCKANDTRADE = [MENU_SUB, '交易日和股票列表', 'demo', 'demo_StockAndTrade', '/demo/StockAndTrade']
DEMO_SHOWBASESOFT = [MENU_SUB, '下载基础包', 'demo', 'demo_showBaseSoft', '/demo/showBaseSoft/']
DEMO_UPLOADFILE = [MENU_SUB, '上传文件', 'demo', 'demo_uploadFile', '/demo/uploadFile/']
DEMO_QUICKSEARCH = [MENU_SUB, '快速查找', 'demo', 'demo_quickSearch', '/demo/quickSearch/']
DEMO_GDBM = [MENU_SUB, 'GDBM', 'demo', 'demo_gdbm_view', '/demo/gdbm/view']
DEMO_PASSWDGEN = [MENU_SUB, '随机密码生成器', 'demo', 'demo_passwdGen', '/demo/passwdGen/']
DEMO_VIDEO = [MENU_SUB, '视频播放', 'demo', 'demo_video', '/demo/video/']

# 全部菜单,管理员配置用
ALL_MENU = [
    USER,
    USER_LIST,
    USER_CREATE,
    MODULE,
    MODULE_LIST,
    MODULE_GROUP_LIST,
    CUSTOMER,
    CUSTOMER_LIST,
    CUSTOMER_PERMISSION_VIEW,
    CUSTOMER_PERMISSION_SETTING,
    CUSTOMER_REMARK_LIST,
    CUSTOMER_ALL_DEPLOY_RECORD_LIST,
    CUSTOMER_ALL_DEPLOY_UNCHECKED_LIST,
    PROGRAMBRANCH,
    PROGRAMBRANCH_LIST,
    PROGRAMBRANCH_KEY_LIST,
    PORTAL,
    PORTAL_PACKAGE_LIST,
    PORTAL_PACKAGE_CREATE,
    PORTAL_UPDATE_GEN_SQL,
    PORTAL_UPLOADFILE_GEN_SQL,
    PORTAL_QUICK_GEN_SQL,
    PORTAL_MACHINE_VIEW,
    CUSTOMER_SYSTEM,
    CUSTOMER_SYSTEM_LIST,
    CUSTOMER_COMPILING,
    CUSTOMER_COMPILING_RECORD_LIST,
    DEMO_PLATFORM,
    DEMO_PLATFORM_VIEW,
    SERVER_MONITOR,
    SERVER_MONITOR_TYPE,
    SERVER_MONITOR_LIST,
    SERVER_MONITOR_MODULE,
    SERVER_MONITOR_LOG,
    DEMO,
    DEMO_REDIS_VIEW,
    DEMO_STOCKANDTRADE,
    DEMO_SHOWBASESOFT,
    DEMO_UPLOADFILE,
    DEMO_QUICKSEARCH,
    DEMO_GDBM,
    DEMO_PASSWDGEN,
    DEMO_VIDEO
]

# 菜单树
MENU_LIST = [
    {
        'main': USER,
        'sub': [
            USER_LIST,
            USER_CREATE
        ]
    },
    {
        'main': MODULE,
        'sub': [
            MODULE_LIST,
            MODULE_GROUP_LIST
        ]
    },
    {
        'main': CUSTOMER,
        'sub': [
            CUSTOMER_LIST,
            CUSTOMER_PERMISSION_VIEW,
            CUSTOMER_REMARK_LIST,
            CUSTOMER_ALL_DEPLOY_RECORD_LIST,
            CUSTOMER_ALL_DEPLOY_UNCHECKED_LIST
        ]
    },
    {
        'main': PROGRAMBRANCH,
        'sub': [
            PROGRAMBRANCH_LIST,
            PROGRAMBRANCH_KEY_LIST
        ]
    },
    {
        'main': PORTAL,
        'sub': [
            PORTAL_PACKAGE_LIST,
            PORTAL_PACKAGE_CREATE,
            PORTAL_UPDATE_GEN_SQL,
            PORTAL_UPLOADFILE_GEN_SQL,
            PORTAL_QUICK_GEN_SQL,
            PORTAL_MACHINE_VIEW
        ]
    },
    {
        'main': CUSTOMER_SYSTEM,
        'sub': [
            CUSTOMER_SYSTEM_LIST
        ]
    },
    {
        'main': CUSTOMER_COMPILING,
        'sub': [
            CUSTOMER_COMPILING_RECORD_LIST
        ]
    },
    {
        'main': DEMO_PLATFORM,
        'sub': [
            DEMO_PLATFORM_VIEW
        ]
    },
    {
        'main': SERVER_MONITOR,
        'sub': [
                SERVER_MONITOR_TYPE,
                SERVER_MONITOR_LIST,
                SERVER_MONITOR_MODULE,
                SERVER_MONITOR_LOG
        ]
    },
    {
        'main': DEMO,
        'sub': [
            DEMO_REDIS_VIEW,
            DEMO_STOCKANDTRADE,
            DEMO_SHOWBASESOFT,
            DEMO_UPLOADFILE,
            DEMO_GDBM,
            DEMO_PASSWDGEN,
            DEMO_VIDEO
        ]
    }
]

# 用户组权限配置
USER_GROUP_LIST = [
    {
        'k': 'after_sale',
        'v': '销售员',
        'm': [
            CUSTOMER,
            CUSTOMER_LIST,
            CUSTOMER_PERMISSION_VIEW,
            CUSTOMER_PERMISSION_SETTING,
            CUSTOMER_REMARK_LIST,
            CUSTOMER_ALL_DEPLOY_RECORD_LIST,
            DEMO_PLATFORM,
            DEMO_PLATFORM_VIEW,
        ]
    },
    {
        'k': 'operation',
        'v': '运维员',
        'm': [
            MODULE,
            MODULE_LIST,
            MODULE_GROUP_LIST,
            CUSTOMER,
            CUSTOMER_LIST,
            CUSTOMER_PERMISSION_VIEW,
            CUSTOMER_PERMISSION_SETTING,
            CUSTOMER_REMARK_LIST,
            CUSTOMER_ALL_DEPLOY_RECORD_LIST,
            PROGRAMBRANCH,
            PROGRAMBRANCH_LIST,
            PROGRAMBRANCH_KEY_LIST,
            PORTAL,
            PORTAL_PACKAGE_LIST,
            PORTAL_PACKAGE_CREATE,
            PORTAL_UPDATE_GEN_SQL,
            PORTAL_UPLOADFILE_GEN_SQL,
            PORTAL_QUICK_GEN_SQL,
            PORTAL_MACHINE_VIEW,
            CUSTOMER_SYSTEM,
            CUSTOMER_SYSTEM_LIST,
            CUSTOMER_COMPILING,
            CUSTOMER_COMPILING_RECORD_LIST,
            DEMO_PLATFORM,
            DEMO_PLATFORM_VIEW,
            SERVER_MONITOR,
            SERVER_MONITOR_TYPE,
            SERVER_MONITOR_LIST,
            SERVER_MONITOR_MODULE,
            SERVER_MONITOR_LOG,
            DEMO,
            DEMO_REDIS_VIEW,
            DEMO_STOCKANDTRADE,
            DEMO_SHOWBASESOFT,
            DEMO_UPLOADFILE,
            DEMO_GDBM,
            DEMO_PASSWDGEN,
            DEMO_VIDEO
        ]
    },
    {
        'k': USER_GROUP_ADMIN,
        'v': '管理员',
        'm': ALL_MENU
    }
]

if __name__ == '__main__':
    print SYS_OS
    print SYS_BIT
    print is_windows()