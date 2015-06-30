# -*- coding:utf-8 -*-
# =====================================================================================
# written by: 赵帅龙 implemented according to 'makeBranch.py'
# function: 根据指定版本号创建一个tag，与 makeBranch.py 不同的是，这里创建的是历史版本的tag
# =====================================================================================
import pysvn
import os
import traceback
from customer.models import InstallPackage, Customer, DeployRecord
import subprocess
from utils import SvnInfo
from programBranch.models import *
from bson.objectid import ObjectId

def getLog(src_branch, dst_branch):
    return True, 'Create branch/tag from ' + src_branch + ' to ' + dst_branch

class TagMaker(object):
    def __init__(self, src_tag, dst_tag, base_tag, tradebase_tag, program_name=TT_SERVICE, src_rev=-1, base_rev=-1, tradebase_rev=-1):
        self.src_tag = src_tag.strip("/")   # tt_service source branch
        self.dst_tag = dst_tag.strip("/")   # tt_service destination branch
        self.base_tag = base_tag.strip('/') # external 'base' branch
        self.tradebase_tag = tradebase_tag.strip('/')   # external 'traderbase' branch

        self.localDir = getLocalDir(program_name).strip('/')  # tt_service local folder, such as e:/server5/ttservice
        #self.localDir = localDir

        self.client = pysvn.Client()
        self.src_url = self.getUrl(os.path.join(self.localDir, src_tag))  # svn url for tt_service source branch in the disk
        self.dst_url = self.src_url.replace(src_tag, dst_tag)  # svn destination url for tt_service destinantion branch ( not yet created)
        self.src_revision = src_rev # tt_service source branch revision assigned( -1 as default, latest version)
        self.base_revision = base_rev # external 'base' branch revision assigned( -1 as default, latest version)
        self.traderbase_revision = tradebase_rev # exteranl 'traderbase' branch revision assigned( -1 as default, latest version)
        self.ext_rev = self.src_revision  # if external revision is not assigned, the source branch revision is used

    def main(self):
        return self.make_branch_and_modify_externals(self.src_url, self.dst_url)

    def make_branch_and_modify_externals(self, src_url, dst_url):
        """
        :param src_url:
        :param dst_url:
        :return:
        """
        if len(src_url) == 0 or len(dst_url) == 0:
            return

        print "make_branch_and_modify_externals", src_url, dst_url
        src_branch = os.path.normpath(os.path.join(self.localDir + "/" + self.src_tag, os.path.relpath(src_url, self.src_url)))
        dst_branch = os.path.normpath(os.path.join(self.localDir + "/" + self.dst_tag, os.path.relpath(dst_url, self.dst_url)))
        print "make_branch_and_modify_externals", src_branch, dst_branch
        if self.is_url_exist(dst_url):
            print 'Url \'' + dst_url + '\' already exists, do not copy.'
        else:
            print 'Copy \'' + src_url + '\' to \'' + dst_url + '\'.'
            my_getLog = lambda : getLog(src_branch, dst_branch)
            self.client.callback_get_log_message = my_getLog

            tmp_revision = self.ext_rev
            is_set = False
            if TT_SERVICE in src_branch:
                tmp_revision = self.src_revision
                is_set = True
            elif 'base' in src_branch:
                tmp_revision = self.base_revision
                is_set = True
            elif 'traderbase' in src_branch:
                tmp_revision = self.tradebase_revision
                is_set = True

            if is_set:
                self.ext_rev = tmp_revision

            if tmp_revision < 0:
                self.client.copy(src_url, dst_url)
                self.client.update(dst_branch)
            else:
                self.client.copy(src_url, dst_url, pysvn.Revision(pysvn.opt_revision_kind.number, tmp_revision))

            externalDirs = self.getExternalDir(src_branch)
            print "externals: ", "\n".join(externalDirs)
            for dir in externalDirs:
                dstDir = dir.replace(self.src_tag, self.dst_tag)
                self.make_branch_and_modify_externals(dir, dstDir)
            self.do_modify_external(src_url, dst_url, src_branch, dst_branch, self.ext_rev)

    def getUrl(self, localPath, recurse=False):
        info = self.client.info2(localPath, recurse=recurse)
        return info[0][1]['URL']

    def is_url_exist(self, url):
        try:
            e = self.client.info2(url, recurse=False)
            return True
        except:
            return False

    def get_root_url(self, url, tag):
        idx = url.find(tag)
        if idx >= 0:
            return url[0 : idx] + tag
        return url

    def getExternalDir(self, src_branch):
        propories = self.client.propget('svn:externals', src_branch, recurse=True)
        rootUrls = []
        for path, data in propories.iteritems():
            items = data.split("\n")
            for item in items:
                s = item.split(" ")
                d = s[0].split("/")
                rootUrl = self.get_root_url(s[0], self.src_tag)
                if len(rootUrl) > 0 and rootUrls.count(rootUrl) == 0 :
                    rootUrls.append(rootUrl)
        return rootUrls

    def do_modify_external(self, src_url, dst_url, src_branch, dst_branch, external_revision):
        old_externals = self.client.propget('svn:externals', src_branch, recurse=True)
        externals = {}
        for path, data in old_externals.iteritems():
            relPath = os.path.relpath(path, src_branch)
            externals[relPath] = data
            print data
        print 'Commit externals modification.', src_branch, dst_branch
        # update new external files to local
        #self.client.update(dst_branch)
        # first update dsb_branch, then update externals
        # if not the revision will be 1 older than needed
        for relPath, external in externals.iteritems():
            path = os.path.join(dst_branch, relPath)
            external = external.replace(self.src_tag, self.dst_tag)

            if 'base' in external:
                prefix = '-r ' + self.base_revision + ' '
            elif 'traderbase' in external:
                prefix = '-r ' + self.tradebase_revision + ' '
            elif self.ext_rev > 0:
                prefix = '-r ' + external_revision + ' '
            else:
                prefix = ''
            self.client.propset('svn:externals', prefix + external, path, base_revision_for_url=0)
            print 'Modify \'' + src_branch + '\' externals : ' + external
            # commit external modifications
        self.client.checkin(dst_branch, 'Modify externals from ' + src_branch + ' to ' + dst_branch)

        print 'Update externals modification.', src_branch, dst_branch

def my_getLog():
    return True, 'delete tags'


def main():
    try:
        # localDir = "E:/server5/deploy/test/test1/"
        src_tag = "trunk"
        dst_tag = "tags/zhaoshuailong_20140713"

        base_tag = 'trunk'
        traderbase_tag = 'trunk'
        src_version = -1
        #maker = TagMaker(localDir, src_tag, dst_tag, base_tag, traderbase_tag, TT_SERVICE, -1, -1, -1)
        maker = TagMaker(src_tag, dst_tag, base_tag, traderbase_tag, TT_SERVICE, -1, -1, -1)
        # externals = maker.getExternalDir("E:/server5/deploy/test/test1/")
        maker.main()
    except:
        traceback.print_exc()
    finally:
        os.system('pause')


if '__main__' == __name__:
    main()