﻿# -*- coding:utf-8 -*-

# 标准库
import sys
import traceback
import os
import time

# 自定义库
sys.path.append('../../../_xtPlatform/script/python/')
import BuildModule
import Solution
import Timer

import Config
import Packer
import Mail

# 验证打包锁
def checkLock(lock_file_name):
    lock_file = 'c:\\' + lock_file_name
    if os.path.isfile(lock_file):
        print '另一个打包脚本正在运行，请等待其结束后再打包。'
        os.system('pause')
        exit()
    f = file(lock_file, 'w')
    f.close()
    return lock_file


# 打印exception并且发失败邮件，用户按键后退出。
def exceptQuit(lock_file, conf, build_log = ''):
    os.remove(lock_file)
    traceback.print_exc()
    mail = Mail.BuildMail()
    mail.sendBuildFailMail(conf.product_name_cn, build_log, conf.fail_dst_addr)
    print ''
    os.system('pause')
    exit()


def curFilePath():
    path = sys.path[0]
    if os.path.isdir(path):
        return path
    elif os.path.isfile(path):
        return os.path.dirname


def waitThreads(threads, lock_file, conf):
    allDone = False
    while not allDone:
        time.sleep(0.1)
        allDone = True
        for t in threads:
            if Solution.SOLUTION_STATUS_ERROR == t.status():
                for t1 in threads:
                    t1.stop()
                return [False, t.log()]
            elif Solution.SOLUTION_STATUS_FINISHED != t.status():
                allDone = False
    return [True, '']


def showBuildTime(the_timer):
    print the_timer.name() + '编译耗时' + str(the_timer.mins) + '分' + str(the_timer.secs) + '秒。'


def showTime(the_timer):
    print the_timer.name() + '耗时' + str(the_timer.mins) + '分' + str(the_timer.secs) + '秒。'


# 主程序
def mainProc(config_file_name, lock_file_name):
    
    # 验证打包锁
    lock_file = checkLock(lock_file_name)

    # 读取配置
    conf = Config.Config(config_file_name)
    conf.parseConfig()

    total_timer = Timer.Timer(1, conf.product_name_cn + '打包整个流程')
    
    try:
        total_timer.start()

        # 读取和各编译模块相关的配置
        module_center = BuildModule.BuildModuleCenter(conf.product_name_cn, conf.conf_parser, conf.version, conf.pdb_dir + '\\' + conf.region, conf.root_dir)
        
        print conf.product_name_cn + ' ' + conf.version + ' 准备编译……'
        
        # 更新svn
        module_center.updateSVN()

        # 更新rc文件版本号
        module_center.versionRC(conf.rc_conf)

    except:
        total_timer.stop()
        exceptQuit(lock_file, conf)

    # 编译各工程
    build_timer = Timer.Timer(1, conf.product_name_cn + '所有编译', True)
    build_timer.start()
    
    threads = module_center.genSolutionThreads()
    build_configuration = 'Deploy_Release'

    '''
    if xtCommon.CV_STANDALONE == conf.client_version:
        build_configuration = 'Standalone_Release'
    if xtCommon.CV_STANDALONE == conf.client_version:
        threads.append(SolutionThread(conf, 'Broker', conf.broker_dir, 'broker.sln', ['sfit', 'hsfutures', 'invs', 'CJStock', 'rzrk_futures', 'rzrk_stock', 'CiticStock', 'qiluSecurities', 'broker'], build_configuration))
        threads.append(SolutionThread(conf, 'TTService', conf.ttservice_dir, 'XtService.full.sln', [''], build_configuration))
    threads.append(SolutionThread(conf, 'Updater', conf.updater_dir, 'Updater.sln', ['']))
    threads.append(SolutionThread(conf, 'Daemon', conf.daemon_dir, 'daemon.sln', ['daemon'], build_configuration))
    threads.append(SolutionThread(conf, 'Quoter', conf.quoter_dir, 'quoter.sln', ['XtQuoter'], build_configuration))
    threads.append(SolutionThread(conf, conf.product_name_en, conf.root_dir, 'XtTradeClient.full.sln', ['XtTradeClient'], build_configuration))
    '''

    for t in threads:
        t.start()

    res = waitThreads(threads, lock_file, conf)

    if res[0]:
        build_timer.stop()
        try:
            print (conf.product_name_cn + ' ' + conf.version + ' 正在生成……')

            # 复制文件
            print '复制文件到指定目录'
            packer = Packer.Packer(conf, build_configuration)
            bin_dir, conf_dir = packer.iniBinDir()
            module_center.copyFiles(bin_dir, conf_dir)
            
            # 数字签名
            print '数字签名'
            module_center.signBins(bin_dir)

            # 调用NSIS生成安装包
            print '生成安装文件'
            packer.packInstaller()
            
            # svn更新日志
            print '提取svn更新日志'
            svn_log = 'SVN版本信息: <br/><br/>' + module_center.getRevisionInfo() + '<br/>SVN更新日志：<br/><br/>' + module_center.getLog()

            # 备份PDB
            print '备份pdb文件'
            module_center.backupPdb()

            # 更新版本号
            print '更新软件版本'
            conf.incVersion()

            # 更新新的svn revision到配置文件中
            print '更新svn revision到配置文件'
            module_center.updateRevisions(conf.conf_file)

            # 发送打包成功邮件
            print '正在发送打包成功邮件……'
            mail = Mail.BuildMail()
            mail.sendBuildSuccessMail(conf.output_download_url + conf.out_file, conf.product_name_cn, svn_log, conf.success_dst_addr)
            
            # 结束
            total_timer.stop()
            print (conf.product_name_cn + ' ' + conf.version + ' 打包完成')
            print '\n\n编译打包流程成功。\n--------------------------------------------------'
            for t in threads:
                showBuildTime(t.timer())
            showTime(build_timer)
            showTime(total_timer)
            os.remove(lock_file)
        except:
            total_timer.stop()
            exceptQuit(lock_file, conf)
    else:
        build_timer.stop()
        total_timer.stop()
        log_file = res[1]
        if os.path.isfile(log_file):
            f = open(log_file)
            all_log = f.read()
            f.close()
            os.startfile(log_file)
        exceptQuit(lock_file, conf, all_log)

# 脚本入口
if '__main__' == __name__:
    if len(sys.argv) <= 2:
        print '\nUsage : Build.py [config_ini] [lock_file]'
        os.system('pause')
        print ''
    else:
        mainProc(sys.argv[1], sys.argv[2])

