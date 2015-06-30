# -*- coding:utf-8 -*-

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

class BranchMaker(object):
    def __init__(self, localDir, src_tag, dst_tag, src_revision):
        self.localDir = localDir
        self.src_tag = src_tag.strip("/")
        self.dst_tag = dst_tag.strip("/")
        self.src_url = ""
        self.dst_url = ""
        self.src_revision = src_revision

        self.client = pysvn.Client()
        src_branch = os.path.join(localDir, src_tag)
        self.src_url = self.getUrl(src_branch)

        dst_branch = os.path.join(localDir, dst_tag)
        relPath = os.path.relpath(dst_branch, src_branch)
        self.dst_url = self.src_url.replace(src_tag, dst_tag)

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
        print 'src_tag:%s dst_tag:%s'%(self.src_tag,self.dst_tag)
        print "make_branch_and_modify_externals", src_branch, dst_branch
        if self.is_url_exist(dst_url):
            print 'Url \'' + dst_url + '\' already exists, do not copy.'
        else:
            print 'Copy \'' + src_url + '\' to \'' + dst_url + '\'.'
            my_getLog = lambda : getLog(src_branch, dst_branch)
            self.client.callback_get_log_message = my_getLog
            if self.src_revision < 0:
                self.client.copy(src_url, dst_url)
            else:
                self.client.copy(src_url, dst_url, pysvn.Revision(pysvn.opt_revision_kind.number, self.src_revision))
            self.client.update(dst_branch)
            externalDirs = self.getExternalDir(src_branch)
            print "externals: ", "\n".join(externalDirs)
            for dir in externalDirs:
                dstDir = dir.replace(self.src_tag, self.dst_tag)
                self.make_branch_and_modify_externals(dir, dstDir)
            self.do_modify_external(src_url, dst_url, src_branch, dst_branch)

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

    def do_modify_external(self, src_url, dst_url, src_branch, dst_branch):
        old_externals = self.client.propget('svn:externals', src_branch, recurse=True)
        externals = {}
        for path, data in old_externals.iteritems():
            relPath = os.path.relpath(path, src_branch)
            externals[relPath] = data
            print data
        print 'Commit externals modification.', src_branch, dst_branch
        # update new external files to local
        self.client.update(dst_branch)
        # first update dsb_branch, then update externals
        # if not the revision will be 1 older than needed
        for relPath, external in externals.iteritems():
            path = os.path.join(dst_branch, relPath)
            external = external.replace(self.src_tag, self.dst_tag)
            if int(self.src_revision) < 0:
                prefix = ""
            else:
                prefix = "-r " + str(self.client.info(dst_branch).revision.number) + " "
            self.client.propset('svn:externals', prefix + external, path, base_revision_for_url=0)
            print 'Modify \'' + src_branch + '\' externals : ' + external
            # commit external modifications
        self.client.checkin(dst_branch, 'Modify externals from ' + src_branch + ' to ' + dst_branch)

        print 'Update externals modification.', src_branch, dst_branch

def my_getLog():
    return True, 'delete tags'


def remove():
    client = pysvn.Client()
    client.callback_get_log_message = my_getLog
    for x in xrange(20):
        try:
            client.remove("http://210.14.136.67/svn/svnrepos/server5/ttservice/trunk/..\\tags\\xujun_test_201406%d" % (14 + x))
        except:
            pass

def removeTag(tag):
    client = pysvn.Client()
    client.callback_get_log_message = my_getLog
    #d = ["base", "tradebase", "ttservice"]
    #for x in d:
    #    print "excute" , x
    #    try:
    urlPath = "http://210.14.136.67/svn/svnrepos/server5/deploy/test/test1/" + tag
    try:
        client.remove(urlPath)
    except:
        print traceback.print_exc()
    #    except:
    #        print traceback.print_exc()
    #client.remove("http://210.14.136.67/svn/svnrepos/XtTradeClient/%s" % tag)

def main():
    try:
        localDir = "E:/server5/deploy/test/test1/"
        src_tag = "trunk"
        dst_tag = "tags/zhaoshuailong_20140635"
        src_version = -1
        maker = BranchMaker(localDir, src_tag, dst_tag, src_version)
        #externals = maker.getExternalDir("E:/server5/deploy/test/test1/")
        maker.main()
    except:
        traceback.print_exc()
    finally:
        os.system('pause')

def ls():
    client = pysvn.Client()
    d = client.ls("http://210.14.136.67/svn/svnrepos/server5/deploy/test/test1/tags")
    for x in d:
        print x

# split svnExternals and leave other job to getUrlRevision2
def getUrlRevision(svnExternals):
    root = "E:/installPackage/"
    externalList = svnExternals.split("\n")
    revision = 0
    for external in externalList:
        command_list = ['svn', 'checkout']
        extList = external.split(" ")
        if len(extList) == 4:
            command_list.append(extList[0])
            command_list.append(extList[1])
            command_list.append(extList[2])
        elif len(extList) == 2:
            command_list.append(extList[0])
        else:
            return -1
        newRev = getUrlRevision2(command_list, root)
        if newRev > revision:
            revision = newRev
    #print "The largest revision: ", revision
    return revision

# generate (svnURL and file/folder path) according to (url and root disk path given)
def genUrlPath(url, root):
    urlpath = list()
    tmpList = url.split("/")
    jumpValue = 100
    pathList = []
    myUrl = ''
    myPath = root
    for ele in tmpList:
        if ele == "trunk":
            jumpValue = 0
            pathList = tmpList[5:tmpList.index(ele) + 1]
        elif ele == 'branches' or ele == 'tags':
            jumpValue = 1
            if len(pathList) == 0:
                pathList = tmpList[5:tmpList.index(ele) + 2]
        myUrl += ele
        myUrl += '/'
        jumpValue -= 1
        if jumpValue < 0:
            break
    for ele in pathList:
        myPath += ele
        myPath += "/"

    urlpath.append(myUrl)
    urlpath.append(myPath)
    return urlpath

# execute command_list from getUrlRevision
# return the biggest revision number (recursively)
def getUrlRevision2(command_list, root):
        revision = 0
        urlpath = list()
        if len(command_list) == 3:
            urlpath = genUrlPath(command_list[2], root)
            command_list[2] = urlpath[0]
            command_list.append(urlpath[1])
        elif len(command_list) == 5:
            urlpath = genUrlPath(command_list[4], root)
            command_list[4] = urlpath[0]
            command_list.append(urlpath[1])
        else:
            return -1
        #print '[getUrlRevision2] command_list: ', command_list
        subp = subprocess.Popen(command_list)
        subp.wait()

        client = pysvn.Client(urlpath[1])
        info = client.info2(urlpath[1], recurse=False)
        revision = info[0][1]['rev'].number

        externals = client.propget('svn:externals', urlpath[1], recurse=True)
        for path, data in externals.iteritems():
            extRev = getUrlRevision(data)
            if revision < extRev:
                revision = extRev
        return revision

# generate files/folders according to installpackage id, and put them under rootPath
# return biggest revision
# limit can be 'ttservice', 'XtTrader', 'base', etc.
def getPackageRevision(id, rootPath, limit='all'):
    """

    :param id:
    """
    package = InstallPackage.objects().get(pk=id)
    revision = 0
    # get svnVersion
    for fileInfoDetail in package.files:
        svnVersion = fileInfoDetail['svnVersion']
        svnVersion = svnVersion.strip('[]')
        if svnVersion == '':
            continue
        tmpList = svnVersion.split(":")
        newRev = tmpList[len(tmpList) - 1]
        if revision == 0:
            revision = int(newRev)
            break
    # get url 2 path map
    url2path = dict()
    for fileInfoDetail in package.files:
        svnVersions = fileInfoDetail['svnVersion']
        svnVersions = svnVersion.strip("[]")
        myPath = rootPath
        if len(svnVersions) != 0:
            svnList = svnVersion.split(",")
            for svnVersion in svnList:
                urlpath = genUrlPath(svnVersion.strip('" '), myPath)
                if limit == 'all' or urlpath[0].find(limit) != -1:  # use limit to filter update
                    url2path[urlpath[0]] = urlpath[1]  # save the url 2 path relation, avoid repetition

    # create the folder to get its externals
    for url, path in url2path.iteritems():
        command_list = ['svn', 'checkout', '-r', str(revision), url, path]
        # print '[getPackageRevision] command_list: ', command_list
        subp = subprocess.Popen(command_list)
        subp.wait()


    # iterate externals and get its biggest revision
    for url, path in url2path.iteritems():
        client = pysvn.Client()
        externals = client.propget('svn:externals', path, recurse=True)
        print "[getPackageRevision] external list: "
        for extPath, data in externals.iteritems():
            print extPath, ": ", data
            extRev = getUrlRevision(data)
            if revision < extRev:
                revision = extRev
    return revision

def checkRevision(branchInfo, firstBugRevision, lastBugRevision, customer_id):
    deployRecords = DeployRecord.objects(customer=customer_id)
    pkg2revision = dict()
    for dr in deployRecords:
        pkgId = dr.new_version.id
        # limit the update to 'all', 'ttservice', 'base', or other
        revision = getPackageRevision(pkgId, 'E:/installPackage/', branchInfo.programName)
        if pkgId not in pkg2revision:
            pkg2revision[pkgId] = revision
        elif revision > pkg2revision[pkgId]:
            pkg2revision[pkgId] = revision
    retRev = -1
    for pkgid, revision in pkg2revision.iteritems():
        if retRev < revision:
            retRev = revision
    if firstBugRevision <= retRev <= lastBugRevision:
        return False # buggy
    else:
        return True # normal

if '__main__' == __name__:
    #print getPackageRevision("53a79b4898ea9b0e7856b27b", 'E:/installPackage/')
    # branchInfos = BranchInfo.objects(id=ObjectId("53aa5c74715e264628ed06e3"))
    # for branchInfo in branchInfos:
    #     checkRevision(branchInfo, 0, 0, ObjectId("539aeb7798ea9b177ca39e36"))
    main()