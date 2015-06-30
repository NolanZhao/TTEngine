# -*- coding:utf-8 -*-

# 此脚本文件依赖win32平台。

import sys
import os
import shutil
import time
import subprocess

import SVN
import RCVersioner
import Solution
import SolutionThread
import PdbBackuper
import Util



class BuildModuleConfig:

    def __init__(self):
        self.product_name = ''
        self.tag_name = ''
        self.name = ''
        self.path = ''
        self.rc_files = []
        self.projects = []
        self.sln = ''
        self.version = ''
        self.pdb_dir = ''
        self.root_dir = ''
        self.svn_last_revision = {}
        self.bin_files = {}
        self.conf_files = {}
        self.update_svn = False
        self.clean = False
        self.build = False
        self.configuration = ''



class BuildModule:

    def __recursiveParseSVN(self, externals, root_path):
        tmp_external_file = ''
        if os.path.isdir(root_path):
            tmp_external_file = root_path + '\\' + 'tmp_externals.txt'
        else:
            tmp_external_file = root_path + '.tmp_externals.txt'
        cmd_line = 'svn propget -v -R svn:externals ' + root_path + ' > ' + tmp_external_file
        print cmd_line
        if 0 != os.system(cmd_line):
            raise Exception('获取SVN外链遇到问题')
        f = open(tmp_external_file)
        local_externals = {}
        try:
            all_lines = f.readlines()
            cur_dir = []
            cur_index = -1
            for line in all_lines:
                search_pattern = "\xa1\xb0"
                idx1 = line.find(search_pattern)
                if idx1 >= 0:
                    idxStart = idx1 + len(search_pattern)
                    idx2 = line.find('\xa1\xb1', idxStart)
                    if idx2 >= 0:
                        cur_dir.append(line[idxStart : idx2])
                elif line.find("svn:externals") >= 0:
                    cur_index += 1
                elif line.find('http://') >= 0:
                    url_and_path = line.split()
                    if 2 == len(url_and_path):
                        local_externals[url_and_path[0]] = cur_dir[cur_index] + '\\' + url_and_path[1]
        except:
            raise Exception('读取SVN外链错误')
        finally:
            f.close()
        for url in local_externals:
            if not url in externals:
                externals[url] = local_externals[url]
                self.__recursiveParseSVN(externals, externals[url])

    def __init__(self, bm_conf):
        print '\n初始化编译模块: ' + bm_conf.name + '\n'
        self.__bm_conf = bm_conf
        self.__svns = {}
        self.__svns['.'] = SVN.SVN(self.__bm_conf.path, self.__bm_conf.name)
        externals = {}
        self.__recursiveParseSVN(externals, self.__bm_conf.path)
        for url in externals:
            ref_path = os.path.relpath(externals[url], self.__bm_conf.path)
            print '解析外链: ' + url + ' -> ' + ref_path
            self.__svns[ref_path] = SVN.SVN(externals[url], ref_path)
        self.__sign_cmd_line = self.__bm_conf.root_dir + '\\script\\install\\\sign\\signtool.exe sign /f "' +  self.__bm_conf.root_dir +  '\\script\\install\\\sign\\mycert.pfx" /p "rzrk.verisign" /t "http://timestamp.verisign.com/scripts/timstamp.dll" '

    def updateSVN(self):
        for k in self.__svns:
            if self.__bm_conf.update_svn:
                self.__svns[k].update()
            self.__svns[k].getToRevision()

    def versionRC(self, rc_conf):
        if self.__bm_conf.build:
            file_list = []
            for f in self.__bm_conf.rc_files:
                file_list.append(self.__bm_conf.path + '\\' + f)
            versioner = RCVersioner.RCVersioner(rc_conf)
            versioner.versionRC(file_list)
    
    def genSolutionThead(self):
        return SolutionThread.SolutionThread(self.__bm_conf.product_name, self.__bm_conf.name, self.__bm_conf.version, self.__bm_conf.path, \
                self.__bm_conf.sln, self.__bm_conf.projects, self.__bm_conf.clean, self.__bm_conf.build, self.__bm_conf.configuration)

    def backupPdb(self):
        dirs = self.__bm_conf.bin_files.keys()
        dirs_abspath = []
        for d in dirs:
            dirs_abspath.append(self.__bm_conf.path + '\\' + d)
        bk = PdbBackuper.PdbBackuper(self.__bm_conf.version, dirs_abspath, self.__bm_conf.pdb_dir)
        bk.backupPdb()

    def updateRevision(self, conf_file, conf_parser):
        with open(conf_file, 'wt') as config_file:
            revisions = []
            for k in self.__svns:
                revisions.append(k + ':' + str(self.__svns[k].to_revision))
            str_revisions = (' | ').join(revisions)
            conf_parser.set(self.__bm_conf.tag_name, 'last_revision', str_revisions)
            conf_parser.write(config_file)

    def getRevisionInfo(self):
        info = self.__bm_conf.name + ' :<br/>------------------------------<br/><br/>'
        for k in self.__svns:
            info = info + k + ' : ' + str(self.__svns[k].to_revision) + '<br/>'
        info = info + '<br/><br/>'
        return info

    def getLog(self):
        log = '==================================================<br/>' + self.__bm_conf.name + ' :<br/>==================================================<br/><br/>'
        for k in self.__svns:
            r = 9999999 # 初次打包，没配就不显示日志，要不然太长了
            if k in self.__bm_conf.svn_last_revision:
                r = self.__bm_conf.svn_last_revision[k]
            log = log + k + ' : ' + str(self.__svns[k].to_revision) + '<br/>' + self.__svns[k].getLog(r) + '<br/><br/>'
        log = log + '<br/><br/>'
        return log

    def __copyFilesDirs(self, util, dst_dir, dict):
        for d in dict:
            for f in dict[d]:
                if '\\' == f:
                    src_dir = self.__bm_conf.path + '\\' + d
                    print u'复制文件夹 : 从 ' + src_dir + u' 到 ' + dst_dir
                    util.copyDirR(src_dir, dst_dir)
                elif '' != f:
                    src_and_dst = [ i.strip() for i in f.split('>') ]
                    if 2 == len(src_and_dst):
                        src_file = self.__bm_conf.path + '\\' + d + '\\' + src_and_dst[0]
                        dst_file = dst_dir + '\\' + src_and_dst[1]
                        print u'复制文件 : 从 ' + src_file + u' 到 ' + dst_file
                        shutil.copy(src_file, dst_file)
                    else:
                        src_dir = self.__bm_conf.path + '\\' + d
                        if os.path.isdir(src_dir + '\\' + f):
                            print u'复制文件夹 ' + f + u' : 从 ' + src_dir + u' 到 ' + dst_dir
                            util.copyDirR(src_dir + '\\' + f, dst_dir + '\\' + f)
                        else:
                            #print u'复制文件 ' + f + u' : 从 ' + src_dir + u' 到 ' + dst_dir
                            util.copyFile(src_dir, dst_dir, f)
    
    def copyFiles(self, dst_bin_dir, dst_conf_dir):
        util = Util.Util()
        self.__copyFilesDirs(util, dst_bin_dir, self.__bm_conf.bin_files)
        self.__copyFilesDirs(util, dst_conf_dir, self.__bm_conf.conf_files)

    def signBins(self, dst_bin_dir):
        for d in self.__bm_conf.bin_files:
            for f in self.__bm_conf.bin_files[d]:
                if '\\' != f:
                    src_and_dst = [ i.strip() for i in f.split('>') ]
                    if 2 == len(src_and_dst):
                        os.system(self.__sign_cmd_line + '"' + dst_bin_dir + '\\' + src_and_dst[1] + '" ')
                    else:
                        os.system(self.__sign_cmd_line + '"' + dst_bin_dir + '\\' + f + '" ')



class BuildModuleCenter:

    def __loadPaths(self, tag_name, key, dict):
        dirs = [ i.strip() for i in self.__conf_parser.get(tag_name, key).split('|') ]
        for d in dirs:
            dir_and_files = [ i.strip() for i in d.split(':') ]
            if 2 == len(dir_and_files):
                real_dir = dir_and_files[0]
                real_files = [ i.strip() for i in dir_and_files[1].split('*') ]
                if not real_dir in dict:
                    dict[real_dir] = real_files
                else:
                    dict[real_dir].extend(real_files)   # 同一path被多次配置的情形
    
    def __loadModule(self, i_module, version, pdb_dir, root_dir):
        bm_conf = BuildModuleConfig()
        tag_name = 'Module' + str(i_module)
        bm_conf.product_name = self.__product_name
        bm_conf.tag_name = tag_name
        bm_conf.name = self.__conf_parser.get(tag_name, 'name')
        bm_conf.path = self.__conf_parser.get(tag_name, 'path')
        bm_conf.rc_files = [ i.strip() for i in self.__conf_parser.get(tag_name, 'rc_files').split('|') ]
        bm_conf.projects = [ i.strip() for i in self.__conf_parser.get(tag_name, 'projects').split('|') ]
        bm_conf.sln = self.__conf_parser.get(tag_name, 'solution')
        svn_last_revisions = [ i.strip() for i in self.__conf_parser.get(tag_name, 'last_revision').split('|') ]
        for one_revision in svn_last_revisions:
            path_and_revision = [ i.strip() for i in one_revision.split(':') ]
            if 2 == len(path_and_revision):
                bm_conf.svn_last_revision[path_and_revision[0]] = int(path_and_revision[1])
        self.__loadPaths(tag_name, 'bin_files', bm_conf.bin_files)
        self.__loadPaths(tag_name, 'conf_files', bm_conf.conf_files)
        bm_conf.version = version
        bm_conf.pdb_dir = pdb_dir
        bm_conf.root_dir = root_dir
        bm_conf.update_svn = (self.__conf_parser.get(tag_name, 'update_svn') != '0')
        bm_conf.clean = (self.__conf_parser.get(tag_name, 'clean') != '0')
        bm_conf.build = (self.__conf_parser.get(tag_name, 'build') != '0')
        bm_conf.configuration = self.__conf_parser.get(tag_name, 'configuration')
        self.__modules.append(BuildModule(bm_conf))

    def __load(self, version, pdb_dir, root_dir):
        self.module_num = int(self.__conf_parser.get('Modules', 'modules_num'))
        self.__modules = []
        for i_module in range(0, self.module_num):
            self.__loadModule(i_module, version, pdb_dir, root_dir)

    def __init__(self, product_name, conf_parser, version, pdb_dir, root_dir):
        self.__product_name = product_name
        self.__conf_parser = conf_parser
        self.__load(version, pdb_dir, root_dir)

    def updateSVN(self):
        for m in self.__modules:
            m.updateSVN()

    def versionRC(self, rc_conf):
        for m in self.__modules:
            m.versionRC(rc_conf)

    def genSolutionThreads(self):
        threads = []
        for m in self.__modules:
            threads.append(m.genSolutionThead())
        return threads
    
    def backupPdb(self):
        for m in self.__modules:
            m.backupPdb()

    def updateRevisions(self, conf_file):
        for m in self.__modules:
            m.updateRevision(conf_file, self.__conf_parser)

    def getRevisionInfo(self):
        info = ''
        for m in self.__modules:
            info = info + m.getRevisionInfo()
        return info

    def getLog(self):
        log = ''
        for m in self.__modules:
            log = log + m.getLog()
        return log

    def copyFiles(self, dst_bin_dir, dst_conf_dir):
        for m in self.__modules:
            m.copyFiles(dst_bin_dir, dst_conf_dir)

    def signBins(self, dst_bin_dir):
        for m in self.__modules:
            m.signBins(dst_bin_dir)

