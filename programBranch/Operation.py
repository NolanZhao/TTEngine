# encoding=utf-8
# 标准库
from TTEngine.constants import is_windows

if is_windows():
    import sys
    import traceback
    import os
    import shutil
    import time
    import subprocess
    import fileinput

    # Django 库
    from programBranch.models import *
    from TTEngine.constants import *
    from logger.models import CoreLogger
    import logging
    from utils import SvnInfo

    # 自定义库
    sys.path.append('windows/_xtPlatform/script/python/')

    import BuildModule
    import Solution
    import Timer
    import SolutionThread
    sys.path.append('windows/script/install/python/')
    import xtCommon
    import Config
    import Packer
    import Mail


    logger = logging.getLogger('django')

    class Operation:
        def __init__(self, customer, tradeBranchInfo, settings={}, build_configuration='Deploy_Release'):
            self.build_configuration = build_configuration
            self.root_path = getLocalDir(tradeBranchInfo.programName)
            self.root_path += "/" + tradeBranchInfo.branchTag
            self.settings = settings
            self.customer = customer
            # 修改配置文件, 此处修改无效，故移动到打包位置
            self.__modifyConfig()

            # 读取配置
            config_file_path = self.root_path + u"/script/install/python/config.ini"
            self.conf = Config.Config(config_file_path)
            self.conf.parseConfig()
            self.conf.root_dir = self.root_path
            self.module_center = BuildModule.BuildModuleCenter(self.conf.product_name_cn, self.conf.conf_parser, self.conf.version, self.conf.pdb_dir + '\\' + self.conf.region, self.conf.root_dir)

        def checkSettings(self):
            try:
                if self.customer.proxy_ip.strip() == '':
                    return {'success': False, 'error': u'proxy ip is not set'}
            except:
               return {'success': False, 'error': u'proxy ip is not set'}

            try:
                if self.customer.name.strip() == '':
                    return {'success': False, 'error': u'customer name is not set'}
            except:
               return {'success': False, 'error': u'customer name is not set'}

            try:
                if self.customer.tag.strip() == '':
                    return {'success': False, 'error': u'customer tag is not set'}
            except:
               return {'success': False, 'error': u'customer tag is not set'}

            try:
                if self.customer.outer_market_ip.strip() == '':
                    return {'success': False, 'error': u'market ip is not set'}
            except:
               return {'success': False, 'error': u'market ip is not set'}

            try:
                if self.customer.outer_trade_ip.strip() == '':
                    return {'success': False, 'error': u'trade ip is not set'}
            except:
               return {'success': False, 'error': u'trade ip is not set'}

            return {'success': True, 'error': u'customer information is enough'}


        def __modifyConfig(self):
            #  修改 config_deploy_rzrk.ini 文件
            # 配置 [root_path]\\XtTradeClient\[branchTag]\script\install\python\config_deploy_rzrk.ini
            # 中文名需要修改下，根据券商名字修改，下面的RZRK相关的也需要改成券商名，一般用拼音,如 guojin (需要传过来)
            print '===============================modify settings================================='
            logger.info("modify ./script/install/python/config.ini: start")
            src_config_file = XT_TRADE_CLIENT_DIR + u"trunk/script/install/python/config_deploy_rzrk.ini"
            config_file_path = self.root_path + u"/script/install/python/config.ini"
            # 如果不存在，则需要 从 E:/XtTradeClient/trunk/script/install/python/config_deploy_rzrk.ini 拷贝一份
            if src_config_file != config_file_path:
                srcFile = open(src_config_file, 'r')
                targetFile = open(config_file_path, 'w')
                try:
                    for line in srcFile.readlines():
                        line = line.decode('gbk')
                        if line.find("path = " + XT_TRADE_CLIENT_DIR + "trunk") != -1:
                            line.replace("path = " + XT_TRADE_CLIENT_DIR + "trunk", "path = " + os.path.normpath(self.root_path))
                        elif line.find(u"product_name_cn") != -1:
                            line = u'product_name_cn = 迅投资产管理平台交易终端 ' + self.customer.name + u'版\n'
                        elif line.find(u'output_file_tag') != -1:
                            line = u'output_file_tag = ' + self.customer.tag + 'u\n'
                        elif line.find(u'update_temp_file') != -1:
                            line = u'update_temp_file = XtAmpTradeClient_' + self.customer.tag + '_setup.exe\n'
                        targetFile.write(line.encode('gbk'))
                except:
                    logger.error("[modifyConfig] Copy config_deploy_rzrk.ini failed")
                    #exit(1)
                finally:
                    srcFile.close()
                    targetFile.close()
            logger.info("modify ./script/install/python/config.ini: end")

            # customer.lua 配置(done), 需要修改 xtService, proxy 地址 (done)

            logger.info("modify ./_runtime/config_local/customer.lua: start")
            target_customer_lua_path = self.root_path + "/_runtime/config.pack/Win32.Deploy_Release/customer.lua"
            #target_customer_lua_path = self.root_path + "/_runtime/config.pack/Win32.Deploy_Release/customer.lua"
            src_customer_lua_path = XT_TRADE_CLIENT_DIR + "trunk/_runtime/config_local/customer.lua.example"
            target_customer_lua_dir = target_customer_lua_path.strip('customer.lua')
            print 'dir: ', target_customer_lua_dir
            if not os.path.exists(target_customer_lua_dir):
                os.mkdir(target_customer_lua_dir)
            target_customer_lua_file = open(target_customer_lua_path, 'w')
            src_customer_lua_file = open(src_customer_lua_path, 'r')
            mark_proxy_ip = False
            mark_proxy_setting = False
            for line in src_customer_lua_file.readlines():
                if line.find("g_xtservice_address = ") >= 0:
                    target_customer_lua_file.writelines("    g_xtservice_address = " + self.customer.outer_trade_ip + ",\n")
                    mark_proxy_ip = True
                elif mark_proxy_ip:
                    if line.find("proxy = ") != -1:
                        target_customer_lua_file.writelines("    g_proxy_address = " + self.customer.proxy_ip + ",\n")
                    else:
                        target_customer_lua_file.writelines("    g_proxy_address = " + self.customer.proxy_ip + ",\n")
                        target_customer_lua_file.writelines(line)
                    mark_proxy_ip = False
                elif line.find('xtservice = g_xtservice_address') >= 0:
                    target_customer_lua_file.writelines(line)
                    mark_proxy_setting = True
                elif mark_proxy_setting:
                    if line.find('proxy = g_proxy_address') > -1:
                        target_customer_lua_file.writelines(line)
                        mark_proxy_setting = False
                    else:
                        target_customer_lua_file.writelines('        proxy = g_proxy_address,\n')
                    mark_proxy_setting = False
                else:
                    target_customer_lua_file.writelines(line)
            target_customer_lua_file.close()
            src_customer_lua_file.close()
            logger.info("modify ./_runtime/config_local/customer.lua: end")

            # 修改xtquoter行情地址 E:/XtTradeClient/trunk/_runtime/config/xtquoterconfig.xml (to do)
            # 在 makePackage 中 实现

            # 修改  _runtime/config/env.lua, 将修改后的文件存为，env.lua.bak，然后用bak文件 覆盖原文件 (done)
            logger.info("modify ./_runtime/config/env.lua: start")
            env_lua_path = self.root_path + "/_runtime/config.pack/Win32.Deploy_Release/env.lua"
            env_lua_bak_path = XT_TRADE_CLIENT_DIR + 'trunk/_runtime/config/env.lua.bak'
            env_lua_bak_file = open(env_lua_bak_path, 'r')
            env_lua_file = open(env_lua_path, 'w')
            for line in env_lua_bak_file.readlines():
                line = line.decode('gbk')
                if line.find(u"g_company = ") >= 0:
                    line = u'g_company = \"' + self.customer.name + u'\"\n'
                elif line.find(u'xtservice=') >= 0:
                    line = u'    xtservice=\"' + self.customer.outer_trade_ip + u'\",\n'
                elif line.find(u'xtquoter=') >= 0:
                    line = u'    xtquoter="' + self.customer.outer_market_ip + u'",\n'
                elif line.find(u'proxy=') >= 0:
                    line = u'    proxy="' + self.customer.proxy_ip + u'",\n'
                env_lua_file.writelines(line.encode('gbk'))
            env_lua_file.close()
            env_lua_bak_file.close()
            logger.info("modify ./_runtime/config/env.lua: end")

            # copy E:\\XtTradeClient\trunk\script\install\python\Config.py to self.root_path + \script\install\python\Config.py (replace)
            logger.info("replace ./script/install/python/Config.py: start")
            targetFile = self.root_path + "/script/install/python/Config.py"
            srcFile = XT_TRADE_CLIENT_DIR + 'trunk/script/install/python/Config.py'
            if targetFile != srcFile:
                shutil.copy(srcFile, targetFile)
            logger.info("replace ./script/install/python/Config.py: end")
            logger.info("replace ./script/install/python/Packer.py: start")
            targetFile = self.root_path + "/script/install/python/Packer.py"
            srcFile = XT_TRADE_CLIENT_DIR + 'trunk/script/install/python/Packer.py'
            if targetFile != srcFile:
                shutil.copy(srcFile, targetFile)
            logger.info("replace ./script/install/python/Packer.py: end")
            # copy E:\\XtTradeClient\trunk\_xtPlatform\script\python\BuildModule.py to self.root_path + \_xtPlatform\script\python\BuildModule.py (如果文件名相同，则替换)
            logger.info("replace ./_xtPlatform/script/python/BuildModule.py: start")
            targetFile = self.root_path + "/_xtPlatform/script/python/BuildModule.py"
            srcFile = XT_TRADE_CLIENT_DIR + 'trunk/_xtPlatform/script/python/BuildModule.py'
            if targetFile != srcFile:
                shutil.copy(srcFile, targetFile)
            logger.info("replace ./_xtPlatform/script/python/BuildModule.py: end")
            # copy E:\\XtTradeClient\trunk\_xtPlatform\script\python\Solution.py to self.root_path + \_xtPlatform\script\python\Solution.py (如果文件名相同，则替换)
            logger.info("replace ./_xtPlatform/script/python/Solution.py: start")
            targetFile = self.root_path + "/_xtPlatform/script/python/Solution.py"
            srcFile = XT_TRADE_CLIENT_DIR + 'trunk/_xtPlatform/script/python/Solution.py'
            if targetFile != srcFile:
                shutil.copy(srcFile, targetFile)
            logger.info("replace ./_xtPlatform/script/python/Solution.py: end")

        # 验证打包锁
        def __checkLock(self):
            lock_file = 'd:/' + LOCK_FILE_NAME
            if os.path.isfile(lock_file):
                return ''
            f = file(lock_file, 'w')
            f.close()
            return lock_file

        # 打印exception并且发失败邮件，用户按键后退出。
        def __exceptQuit(self, lock_file, conf, build_log = ''):
            os.remove(lock_file)
            traceback.print_exc()
            mail = Mail.BuildMail()
            #mail.sendBuildFailMail(conf.product_name_cn, build_log, conf.fail_dst_addr)
            return False

        def get_version(self):
            return self.conf.version

        def updateSvn(self, branchInfo):
            # 验证 编译 锁
            lock_file = self.__checkLock()
            if lock_file == '':
                logger.error('另一个打包脚本正在运行...')
                return {'success': False, 'error': '另一个打包脚本正在运行...'}
            try:
                local_dir = getLocalDir(branchInfo.programName) + '/' + branchInfo.branchTag
                subp = subprocess.Popen(['svn', 'update', local_dir])
                ret_value = subp.wait()
                os.remove(lock_file)
                if ret_value != 0:
                    return {'success': False, 'error': '%s/%s 更新svn失败'%( branchInfo.programName, branchInfo.branchTag)}
                else:
                    return {'success': True, 'error': '%s/%s 更新svn成功'%( branchInfo.programName, branchInfo.branchTag)}
            except:
                os.remove(lock_file)
                return {'success': False, 'error': '发生异常，无法更新 %s' % branchInfo.programName}

        def buildSolution(self, branchInfo):
            # 验证 编译 锁
            lock_file = self.__checkLock()
            if lock_file == '':
                logger.error('另一个打包脚本正在运行...')
                return {'success': False, 'error': '另一个打包脚本正在运行...'}

            logger.info(branchInfo.programName + '/' + branchInfo.branchTag + '编译开始')
            logger.info("Name: %s" % branchInfo.programName)
            logger.info("Tag: %s" % branchInfo.branchTag)

            working_dir = getLocalDir(branchInfo.programName) + '/' + branchInfo.branchTag
            if branchInfo.programName == 'updater':
                try:
                    sol = Solution.Solution(working_dir, 'Updater.sln', False, 'Release')
                    sol.buildSolution(True, ['tlupdater'])
                    os.remove(lock_file)
                    if sol.status() == 3: # error
                        return {'success': False, 'error': 'build error %s/%s' % (branchInfo.programName, branchInfo.branchTag)}
                    elif sol.status() == 2: # finished
                        return {'success': True, 'error': 'build successfully %s/%s' % (branchInfo.programName, branchInfo.branchTag)}
                except Exception as e:
                    os.remove(lock_file)
                    return {'success':False, 'error': e.message}

            elif branchInfo.programName == 'daemon':
                try:
                    sol = Solution.Solution(working_dir, 'daemon.sln', False, "Deploy_Release")
                    sol.buildSolution(True, ['daemon'])
                    os.remove(lock_file)
                    if sol.status() == 3: # error
                        return {'success': False, 'error': 'build error %s/%s' % (branchInfo.programName, branchInfo.branchTag)}
                except Exception as e:
                    os.remove(lock_file)
                    return {'success':False, 'error': e.message}
            elif branchInfo.programName == 'quoter':
                try:
                    sol = Solution.Solution(working_dir, 'quoter.sln', False, "Deploy_Release")
                    sol.buildSolution(True, ['XtQuoter'])
                    os.remove(lock_file)
                    if sol.status() == 3: # error
                        return {'success': False, 'error': 'build error %s/%s' % (branchInfo.programName, branchInfo.branchTag)}
                except Exception as e:
                    os.remove(lock_file)
                    return {'success':False, 'error': e.message}
            elif branchInfo.programName == 'XtTradeClient':
                try:
                    sol = Solution.Solution(working_dir, 'XtTradeClient.full.sln', False, "Deploy_Release")
                    sol.buildSolution(True, ['XtTradeClient'])
                    os.remove(lock_file)
                    if sol.status() == 3: # error
                        return {'success': False, 'error': 'build error %s/%s' % (branchInfo.programName, branchInfo.branchTag)}
                except Exception as e:
                    os.remove(lock_file)
                    return {'success':False, 'error': e.message}
            logger.info(branchInfo.programName + '/' + branchInfo.branchTag + '编译完成')
            return {'success': True, 'error': 'build successfully %s/%s' % (branchInfo.programName, branchInfo.branchTag)}

        # clean 项目，root_path 末尾不带 /
        def cleanSolution(self, branchInfo):
            # 验证 编译 锁
            lock_file = self.__checkLock()
            if lock_file == '':
                logger.error('另一个打包脚本正在运行...')
                return {'success': False, 'error': '另一个打包脚本正在运行...'}

            sln_file = ''
            root_path = getLocalDir(branchInfo.programName) + '/' + branchInfo.branchTag
            if branchInfo.programName == 'updater':
                sln_file = 'Updater.sln'
            elif branchInfo.programName == 'daemon':
                sln_file = 'daemon.sln'
            elif branchInfo.programName == 'quoter':
                sln_file = 'quoter.sln'
            elif branchInfo.programName == 'XtTradeClient':
                sln_file = 'XtTradeClient.full.sln'
            if sln_file == '':
                if branchInfo.programName != '':
                    logger.error('program \"', branchInfo.programName, '\" does not exists')
                    os.remove(lock_file)
                    return {'success': False, 'error': 'program \"' + branchInfo.programName + '\" does not exists'}
                else:
                    os.remove(lock_file)
                    return {'success': False, 'error': 'program name is not set'}
            logger.info('%s/%s clean start' % (branchInfo.programName, branchInfo.branchTag))
            try:
                if branchInfo.programName == 'updater':
                    try:
                        sol = Solution.Solution(root_path, sln_file, True, "Release")
                        os.remove(lock_file)
                        if sol.status() == 3: # error
                            return {'success': False, 'error': 'clean error %s/%s' % (branchInfo.programName, branchInfo.branchTag)}
                    except Exception as e:
                        os.remove(lock_file)
                        return {'success': False, 'error': e.message}

                else:
                    try:
                        sol  = Solution.Solution(root_path, sln_file, True, self.build_configuration)
                        os.remove(lock_file)
                        if sol.status() == 3: # error
                            return {'success': False, 'error': 'clean error %s' % (branchInfo.programName, branchInfo.branchTag)}
                    except Exception as e:
                        os.remove(lock_file)
                        return {'success': False, 'error': e.message}
                logger.info('%s/%s clean end' % (branchInfo.programName, branchInfo.branchTag))
                return {'success': True, 'error': 'Clean %s succeeds' % sln_file}
            except Exception as e:
                os.remove(lock_file)
                logger.error('%s/%s: %s' %(branchInfo.programName, branchInfo.branchTag, e.message))
                return {'success': False, 'error': 'clean %s fails' % sln_file}

        def makePackage(self, quoter_settings):
            # 验证 打包 锁
            lock_file = self.__checkLock()
            if lock_file == '':
                logger.error('另一个打包脚本正在运行...')
                return {'success': False, 'error': '另一个打包脚本正在运行...'}

            try:
                logger.info(self.conf.product_name_cn + ' ' + self.conf.version + ' 正在生成……')

                # 复制文件
                logger.info('复制文件到指定目录 (copy files to certain folder)')
                packer = Packer.Packer(self.conf, self.build_configuration)
                bin_dir, conf_dir = packer.iniBinDir()
                self.module_center.copyFiles(bin_dir, conf_dir)

                # 修改配置文件
                self.__modifyConfig()

                # 重建 xtquoterconfig.xml
                quoter_config_file_path = self.root_path + '/_runtime/config.pack/Win32.Deploy_Release/xtquoterconfig.xml'
                file = open(quoter_config_file_path, 'w')
                file.write(quoter_settings)
                file.close()
                # 数字签名
                logger.info('数字签名 (digital sign)')
                self.module_center.signBins(bin_dir)

                # 调用NSIS生成安装包
                logger.info('生成安装文件 (produce installer)')
                installer = packer.packInstaller()

                # svn更新日志
                logger.info('提取svn更新日志 (get svn update record)')
                svn_log = 'SVN版本信息: <br/><br/>' + self.module_center.getRevisionInfo() + '<br/>SVN更新日志：<br/><br/>' + self.module_center.getLog()

                # 备份PDB
                logger.info('备份pdb文件')
                self.module_center.backupPdb()

                # 更新版本号
                logger.info('更新软件版本')
                self.conf.incVersion()
                '''
                # 发送打包成功邮件
                logger.info('正在发送打包成功邮件……')
                mail = Mail.BuildMail()
                mail.sendBuildSuccessMail(self.conf.output_download_url + self.conf.out_file, self.conf.product_name_cn, svn_log, self.conf.success_dst_addr)
                '''
                # 结束
                logger.info(self.conf.product_name_cn + ' ' + self.conf.version + ' make package finishes')
                os.remove(lock_file)
                return {'success': True, 'error': installer}
            except:
                self.__exceptQuit(lock_file, self.conf)
                return {'success': False, 'error': 'make package failure'}

    if __name__ == "__main__":
        BranchInfos = BranchInfo.objects(pk="53aa5c75715e264628ed06f2")
        tradeBranchInfo = BranchInfos[0]
        print tradeBranchInfo.programName, ", ", tradeBranchInfo.branchTag
        op = Operation(tradeBranchInfo)
        quoter = BranchInfo.objects.get(pk="53aa5c75715e264628ed06f1")
        BranchInfos = BranchInfo.objects(pk='53ba72d7fa032116ac4bb276')
        updater = BranchInfos[0]
        BranchInfos = BranchInfo.objects(pk='53ba8f8b98ea9b345ed1bc91')
        daemon = BranchInfos[0]
        op.cleanSolution(updater)
        op.buildSolution(updater)
        op.cleanSolution(daemon)
        op.buildSolution(daemon)
        op.cleanSolution(quoter)
        op.buildSolution(quoter)
        op.cleanSolution(tradeBranchInfo)
        op.buildSolution(tradeBranchInfo)
        op.makePackage()
