# -*- coding: utf-8 -*-
__author__ = 'nerve'

import pysvn
from utils.TracebackHelper import getTraceBack
import logging
from programBranch.models import BranchInfo, KeySubmit
from mongoengine.queryset.visitor import *
from TTEngine.constants import *
import time

logger = logging.getLogger('django')


class SvnUtils():
    def __init__(self):
        self.client = pysvn.Client()

    def svn_url_exists(self, svn_url):
        """
        检查SVN路径是否存在
        :param svn_url:
        :return:
        """
        head = pysvn.Revision(pysvn.opt_revision_kind.head)
        try:
            entry = self.client.info2(svn_url, revision=head, recurse=False)[0]
            return True if isinstance(entry[1], pysvn.PysvnInfo) else False
        except pysvn._pysvn.ClientError as e:
            if e.message.find('forbidden') > 0:
                return None
            return False

    def get_key_submit_by_revision(self, svn_url, revision_end, revision_start=-1):
        """
        根据旧SVN数据获取之后的关键更新
        :param svn_url:
        :param revision_end:
        :param revision_start:
        :return:
        """
        branch_info = self.get_branch_from_url(svn_url)
        # 获取最新的SVN版本号
        if revision_start == -1:
            revision_start = self.get_current_svn_revision(svn_url)

        # 查询在此区间的关键更新对象
        key_submits = KeySubmit.objects(Q(branch=branch_info) & (Q(revision_end__lte=revision_start) & Q(revision_end__gte=revision_end)) | (Q(revision_start__lte=revision_start) & Q(revision_start__gte=revision_end))).order_by('-revision_start')
        return key_submits

    def get_current_svn_revision(self, svn_url):
        """
        根据SVN链接获取当前最新版本号
        :param svn_url:
        """
        head = pysvn.Revision(pysvn.opt_revision_kind.head)
        entry = self.client.info2(svn_url, revision=head, recurse=False)[0]
        revision_new = entry[1].data['last_changed_rev'].number
        return revision_new

    @staticmethod
    def get_svn_url(program_name, branch_tag):
        """
        获取SVN链接
        :param program_name:
        :param branch_tag:
        :return:
        """
        if program_name in [XT_TRADE_CLIENT, TT_MANAGEMENT_PORTAL, UPDATER, XT_PLATFORM]:
            return SVN_ROOT + program_name + "/" + branch_tag
        else:
            return SVN_ROOT + "server5/" + program_name + "/" + branch_tag

    @staticmethod
    def get_local_path(program_name, branch_tag):
        """
        获取本地副本路径
        :param program_name:
        :param branch_tag:
        :return:
        """
        if program_name in [XT_TRADE_CLIENT, TT_MANAGEMENT_PORTAL, UPDATER, XT_PLATFORM]:
            return PROGRAM_DIR + program_name + '/' + branch_tag
        else:
            return PROGRAM_DIR + "server5/" + program_name + "/" + branch_tag

    @staticmethod
    def get_branch_from_url(svn_url):
        """
        根据SVN链接获取BranchInfo对象
        :param svn_url:
        :return:
        """
        try:
            arr = None
            if svn_url.find('/server5/') > 0:
                arr = svn_url.split(SVN_ROOT + 'server5/')[1].split('/', 1)
            else:
                arr = svn_url.split(SVN_ROOT)[1].split('/', 1)
            program_name = arr[0]
            branch_tag = arr[1]
            branch_info = BranchInfo.objects(programName=program_name, branchTag=branch_tag)
            if len(branch_info) == 0:
                logger.error('根据SVN:[url=%s][program_name=%s][branch_tag=%s]获取BranchInfo对象为空!' % (svn_url, program_name, branch_tag))
                return None
            return branch_info[0]
        except Exception as e:
            logger.error('根据SVN:[url=%s]获取BranchInfo对象异常![%s]' % (svn_url, getTraceBack()))
            return None

    @staticmethod
    def get_branch_from_program_tag(program_name, branch_tag):
        """
        根据程序名称和分支获取BranchInfo对象
        :param program_name:
        :param branch_tag:
        """
        branch_info = BranchInfo.objects(programName=program_name, branchTag=branch_tag)

        if len(branch_info) == 0:
            return None
        return branch_info[0]


    def get_local_svn_info(self, svn_path):
        """
        获取本地SVN信息
        :param svn_path:
        :return:
        """
        entry = self.client.info(svn_path)
        svn_url = entry.url
        svn_commit_revision = entry.commit_revision.number
        svn_commit_time = time.strftime('%Y-%m-%d %H:%M:%S', time.gmtime(entry.commit_time))
        svn_author = entry.commit_author
        result = {
            'url': svn_url,
            'revision': svn_commit_revision,
            'author': svn_author,
            'commit_time': svn_commit_time
        }
        return result

    def get_local_svn_externals(self, local_path):
        """
        获取SVN外链信息
        :param local_path:
        :return:
        """
        result = []
        try:
            externals = self.client.propget('svn:externals', local_path, recurse=True)
            for local_path_item, info in externals.iteritems():
                result.extend(self._get_svn_externals_extract(local_path_item, info))
        except Exception as e:
            logger.error('获取本地SVN[path=%s]外链信息异常![%s]' % (local_path, e.message))
        return result

    def _get_svn_externals_extract(self, local_path, info):
        """
        解析SVN命令字符串
        :param local_path:
        :param info:
        :return:
        """
        result = []
        info = info.splitlines()
        for item in info:
            # eg about item
            # -r 159830 http://210.14.136.67/svn/svnrepos/server5/base/branches/shoushan_20130828/src/idata@159830 idata
            # http://210.14.136.67/svn/svnrepos/server5/base/trunk base
            line_arr = item.split(' ')
            local_path_item = local_path + '/' + line_arr[len(line_arr) - 1]
            local_revision = self.get_local_svn_info(local_path_item)['revision']

            url = line_arr[len(line_arr) - 2]
            # url可能包含'@',需要截取
            if url.find('@') > 0:
                url = url[0:url.find('@')]

            current_revision = self.get_current_svn_revision(url)

            result.append([local_path_item, local_revision, url, current_revision])
        return result


if __name__ == '__main__':
    svn_utils = SvnUtils()
    print svn_utils.svn_url_exists('http://210.14.136.67/svn/svnrepos/server5/ttservice/tags/test/')
    print svn_utils.svn_url_exists('http://210.14.136.67/svn/svnrepos/server5/ttservice/tags/changan_real_20140327/')