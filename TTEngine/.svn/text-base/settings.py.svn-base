# Django settings for TTEngine project.
# encoding=utf-8
# **************自定义配置开始**************#
import os
from utils.OsHelper import isThisWindows

# 获取项目根路径
PROJECT_PATH = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), os.path.pardir))

TEMPLATE_DIRS = (
    os.path.join(PROJECT_PATH, "templates"),
)

HOST_IP = "192.168.1.187"
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.',  # Add 'postgresql_psycopg2', 'mysql', 'sqlite3' or 'oracle'.
        'NAME': 'ttengine',  # Or path to database file if using sqlite3.
        'USER': '',  # Not used with sqlite3.
        'PASSWORD': '',  # Not used with sqlite3.
        'HOST': HOST_IP,  # Set to empty string for localhost. Not used with sqlite3.
        'PORT': '27017',  # Set to empty string for default. Not used with sqlite3.
    }
}

# 分页数据条数
PAGE_SIZE = 20

# add session
SESSION_ENGINE = 'mongoengine.django.sessions'
SESSION_SERIALIZER = 'mongoengine.django.sessions.BSONSerializer'
import mongoengine

AUTH_USER_MODEL = 'mongo_auth.MongoUser'

AUTHENTICATION_BACKENDS = (
    'mongoengine.django.auth.MongoEngineBackend',
)

LOGIN_URL = "/login/"

DEBUG = True

TIME_ZONE = 'Asia/Shanghai'
LANGUAGE_CODE = 'zh-cn'

MAIN_PROJECT_NAME = '睿智融科Engine管理系统'

# 默认编码
ENCODE = 'utf-8'

# TTService配置
TT_IP = "192.168.1.187"

TT_PORT = 56000

TT_GATEWAY = "webservice"

TT_SESSION_KEY = "40bd001563085fc35232329ea1ff5c5ecbdbbeef"

# 线程启动设置
# 同步各个分支最后一次提交记录
SYNC_SVN_INFO_TASK = False
SYNC_SVN_INFO_TASK_SLEEP_TIME = 60 * 15
# 校验SVN分支信息
CHECK_BRANCH_INFO_TASK = False
CHECK_BRANCH_INFO_TASK_SLEEP_TIME = 60 * 30


EMAIL_HOST = 'smtp.thinktrader.net'
EMAIL_PORT = 25
EMAIL_HOST_USER='majing@thinktrader.net'
EMAIL_HOST_PASSWORD='rark1122'
EMAIL_USE_TLS = True
SERVER_EMAIL = DEFAULT_FROM_EMAIL = EMAIL_HOST_USER
# **************自定义配置结束**************#

TEMPLATE_DEBUG = DEBUG

ADMINS = (
    # ('Your Name', 'your_email@example.com'),
)

MANAGERS = ADMINS

# Hosts/domain names that are valid for this site; required if DEBUG is False
# See https://docs.djangoproject.com/en/1.4/ref/settings/#allowed-hosts
ALLOWED_HOSTS = []

SITE_ID = 1

# If you set this to False, Django will make some optimizations so as not
# to load the internationalization machinery.
USE_I18N = True

# If you set this to False, Django will not format dates, numbers and
# calendars according to the current locale.
USE_L10N = True

# If you set this to False, Django will not use timezone-aware datetimes.
USE_TZ = True

# Absolute filesystem path to the directory that will hold user-uploaded files.
# Example: "/home/media/media.lawrence.com/media/"
MEDIA_ROOT = os.path.join(PROJECT_PATH, "media")
TEMP_ROOT = os.path.join(PROJECT_PATH, "media", "temp")
UPDATE_SQL_DIR = os.path.join(PROJECT_PATH, "media", "update_sql")
# URL that handles the media served from MEDIA_ROOT. Make sure to use a
# trailing slash.
# Examples: "http://media.lawrence.com/media/", "http://example.com/media/"
MEDIA_URL = ''

# Absolute path to the directory static files should be collected to.
# Don't put anything in this directory yourself; store your static files
# in apps' "static/" subdirectories and in STATICFILES_DIRS.
# Example: "/home/media/media.lawrence.com/static/"
STATIC_ROOT = PROJECT_PATH + '/../engine_log/'

try:
    if not os.path.exists(STATIC_ROOT):
        os.makedirs(STATIC_ROOT)
except:
    print '自动检录log目录失败!'

# URL prefix for static files.
# Example: "http://media.lawrence.com/static/"
STATIC_URL = PROJECT_PATH + '/static/'

# Additional locations of static files
STATICFILES_DIRS = (
    # Put strings here, like "/home/html/static" or "C:/www/django/static".
    # Always use forward slashes, even on Windows.
    # Don't forget to use absolute paths, not relative paths.
)

# List of finder classes that know how to find static files in
# various locations.
STATICFILES_FINDERS = (
    'django.contrib.staticfiles.finders.FileSystemFinder',
    'django.contrib.staticfiles.finders.AppDirectoriesFinder',
    # 'django.contrib.staticfiles.finders.DefaultStorageFinder',
)

# Make this unique, and don't share it with anybody.
SECRET_KEY = 'in9k4o(e-71(4+dyq&amp;=hnzrhd%1sgz&amp;jxqw(rj(t37t5y3zyv6'

# List of callables that know how to import templates from various sources.
TEMPLATE_LOADERS = (
    'django.template.loaders.filesystem.Loader',
    'django.template.loaders.app_directories.Loader',
    # 'django.template.loaders.eggs.Loader',
)

MIDDLEWARE_CLASSES = (
    'django.middleware.common.CommonMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    # Uncomment the next line for simple clickjacking protection:
    # 'django.middleware.clickjacking.XFrameOptionsMiddleware',
)

ROOT_URLCONF = 'TTEngine.urls'

# Python dotted path to the WSGI application used by Django's runserver.
WSGI_APPLICATION = 'TTEngine.wsgi.application'

INSTALLED_APPS = (
    'django.contrib.auth',
    'mongoengine.django.mongo_auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.sites',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    # Uncomment the next line to enable the admin:
    'django.contrib.admin',
    # Uncomment the next line to enable admin documentation:
    # 'django.contrib.admindocs',
    'TTEngine',
    'module',
    'customer',
    'programBranch',
)

LOGGING = {
    'version': 1,
    'disable_existing_loggers': True,
    'formatters': {
        'standard': {
            'format': '[%(levelname)s] %(asctime)s [%(threadName)s:%(thread)d] [%(module)s:%(lineno)d] - %(message)s'
        },
    },
    'filters': {
    },
    'handlers': {
        'mail_admins': {
            'level': 'ERROR',
            'class': 'django.utils.log.AdminEmailHandler',
            'include_html': True
        },
        'default': {
            'level': 'DEBUG',
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': os.path.join(STATIC_ROOT, 'engine.log'),
            'maxBytes': 1024 * 1024 * 500,  # 500 MB
            'backupCount': 5,
            'formatter': 'standard'
        },
        'console': {
            'level': 'DEBUG',
            'class': 'logging.StreamHandler',
            'formatter': 'standard'
        },
        'request_handler': {
            'level': 'DEBUG',
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': os.path.join(STATIC_ROOT, 'request.log'),
            'maxBytes': 1024 * 1024 * 500,  # 500 MB
            'backupCount': 5,
            'formatter': 'standard'
        },
        'scprits_handler': {
            'level': 'DEBUG',
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': os.path.join(STATIC_ROOT, 'scprits.log'),
            'maxBytes': 1024 * 1024 * 500,  # 500 MB
            'backupCount': 5,
            'formatter': 'standard'
        }
    },
    'loggers': {
        'django': {
            'handlers': ['default', 'console'],
            'level': 'DEBUG',
            'propagate': False
        },
        'engine': {
            'handlers': ['default', 'console'],
            'level': 'DEBUG',
            'propagate': True
        },
        'django.request': {
            'handlers': ['request_handler'],
            'level': 'DEBUG',
            'propagate': False
        },
        'scripts': {
            # 脚本专用日志
            'handlers': ['scprits_handler'],
            'level': 'INFO',
            'propagate': False
        }
    }
}

import types, locale


def setlocale():
    language_code, encoding = locale.getdefaultlocale()
    if language_code is None:
        language_code = 'en_GB'
    if encoding is None:
        encoding = 'UTF-8'
    if encoding.lower() == 'utf':
        encoding = 'UTF-8'
    if not isThisWindows():
        locale.setlocale(locale.LC_ALL, '%s.%s' % (language_code, encoding))


setlocale()

import sys

sys.setrecursionlimit(5000)