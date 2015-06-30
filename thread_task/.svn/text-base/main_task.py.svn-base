# encoding=utf-8

import sys
import threading

reload(sys)
sys.setdefaultencoding('utf-8')
__author__ = 'nerve'

import logging
from utils.TracebackHelper import getTraceBack
import time
from programBranch.models import BranchInfo
import pysvn
from TTEngine.constants import *
from utils.svn_utils import SvnUtils

logger = logging.getLogger('django')

_svn_dict = {}


class SyncSvnInfoTask(threading.Thread):
    """
    同步各个分支SVN最新版本
    """

    def __init__(self, lock, sleep_time=60 * 15):
        # 一定要显式的调用父类的初始化函数
        super(SyncSvnInfoTask, self).__init__()
        self.lock = lock
        self.sleep_time = sleep_time

    def run(self):
        while True:
            try:
                self.lock.acquire()
                self.sync_svn_info()
                self.lock.release()
            except Exception as e:
                logger.error(e.message)
                logger.error(getTraceBack())
            finally:
                time.sleep(self.sleep_time)

    def sync_svn_info(self):

        svn_dict = {}
        # 获取portal所有分支对象
        branchs = BranchInfo.objects(programName__in=[TT_SERVICE, QUOTER, XT_TRADE_CLIENT, TT_MANAGEMENT_PORTAL, DEAMON, UPDATER])
        client = pysvn.Client()
        revision_start = pysvn.Revision(pysvn.opt_revision_kind.head)
        revision_end = pysvn.Revision(pysvn.opt_revision_kind.number, 0)
        limit = 1

        for item in branchs:
            svn_url = SvnUtils.get_svn_url(item.programName, item.branchTag)
            try:
                # get last svn log
                data = client.log(svn_url, revision_start=revision_start, revision_end=revision_end, limit=limit)[0].data

                svn_revision = data['revision'].number
                svn_author = data['author']
                svn_message = data.get('message', '')
                svn_commit_time = time.strftime('%Y-%m-%d %H:%M:%S', time.gmtime(data['date']))
                svn_dict[svn_url] = [str(svn_revision), '%s  %s  %s -> %s' % (svn_revision, svn_commit_time, svn_author, svn_message)]
            except Exception as e:
                logger.error(getTraceBack())
                logger.error('同步SVN信息[url:%s]异常![%s]' % (svn_url, e.message))

        global _svn_dict
        _svn_dict = svn_dict

        logger.info('同步SVN信息成功!共计[%s]条!' % len(_svn_dict))

    @staticmethod
    def get_svn_info_dict():
        return _svn_dict


class CheckBranchInfoTask(threading.Thread):
    """
    校验分支信息合法性
    """

    def __init__(self, lock, sleep_time=60 * 30):
        # 一定要显式的调用父类的初始化函数
        super(CheckBranchInfoTask, self).__init__()
        self.lock = lock
        self.sleep_time = sleep_time

    def run(self):
        while True:
            try:
                self.lock.acquire()
                self.check_brach_info()
                self.lock.release()
            except Exception as e:
                logger.error(e.message)
                logger.error(getTraceBack())
            finally:
                time.sleep(self.sleep_time)

    def check_brach_info(self):
        # 获取portal所有分支对象
        branchs = BranchInfo.objects()

        svn_utils = SvnUtils()

        exist = 0
        unknown = 0
        not_exist = 0

        for item in branchs:
            svn_url = SvnUtils.get_svn_url(item.programName, item.branchTag)
            flag = None
            try:
                flag = svn_utils.svn_url_exists(svn_url)
            except Exception as e:
                logger.error(getTraceBack())
                logger.error('校验BranchInfo[id=%s][url=%s]异常![%s]' % (str(item.id), svn_url, e.message))
            item.is_exist = flag
            item.save()

            if flag is True:
                exist += 1
            elif flag is False:
                not_exist += 1
            else:
                unknown += 1

        logger.info('校验BranchInfo对象成功!共计[%s]条!有效路径[%s]条!无效路径[%s]条!未知路径[%s]条!' % (len(branchs), exist, not_exist, unknown))