# -*- coding:utf-8 -*-

# 标准库
import sys
import os

# 自定义库
sys.path.append('../../../_xtPlatform/script/python/')
import Util

import xtCommon
import Config
import Mail


# 主程序
def mainProc(config_file_name):
    
    print '正在读取配置……'
    conf = Config.Config(config_file_name)
    conf.parseConfig()

    print '正在复制文件……'
    util = Util.Util()
    version = conf.getVersion(conf.rc_conf.ver_major, conf.rc_conf.ver_minor, conf.rc_conf.ver_revision, conf.rc_conf.ver_build - 1)
    out_file = conf.outputFile(version)
    print '文件 ' + out_file + ' 从 ' + conf.output_dir + ' 到 ' + conf.publish_dir
    util.copyFile(conf.output_dir, conf.publish_dir, out_file)

    print '正在发送发布成功邮件……'
    mail = Mail.BuildMail()
    mail.sendBuildSuccessMail(conf.publish_download_url + out_file, conf.product_name_cn, '', conf.publish_dst_addr)

    print '\n\n发布流程成功。\n--------------------------------------------------'
    os.system('pause')


# 脚本入口
if '__main__' == __name__:
    if len(sys.argv) <= 1:
        print '\nUsage : Publish.py [config.ini]'
        os.system('pause')
        print ''
    else:
        mainProc(sys.argv[1])

