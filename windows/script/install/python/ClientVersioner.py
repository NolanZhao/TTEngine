# -*- coding:utf-8 -*-

import sys
import os
import shutil

# 版本控制类
class ClientVersioner:

    def setClientVersion(self):
        # 设置config.lua
        config_lua_file = self.__conf.root_dir + '\\_runtime\\config\\' + self.__conf.config_file
        f_in = open(config_lua_file)
        all_lines_in = []
        all_lines_out = []
        # 读每一行
        try:
            all_lines_in = f_in.readlines()
            for line in all_lines_in:
                if line.find('g_client_version_config') >= 0:                    
                    all_lines_out.append('g_client_version_config = {m_strExeNameMain="%s", m_strExeName="%s", m_strProductName="%s", m_strBrowserExe="XtAmpBrowser.exe", m_strBrowserName="迅投资管门户", m_strRegion="%s", m_strInstallerFile="%s"}\n' % (self.__conf.product_name_en, self.__conf.product_name_en + '.exe', self.__conf.product_name_cn, self.__conf.region, self.__conf.update_temp_file))
                else:
                    all_lines_out.append(line)
        except:
            raise Exception(self.__conf.config_file + '读取出错。')
        finally:
            f_in.close()
        # 写每一行
        f_out = open(config_lua_file, 'w')
        try:
            for line in all_lines_out:
                f_out.write(line)
        except:
            raise Exception(self.__conf.config_file + '修改出错。')
        finally:
            f_out.close()

    # 初始化函数
    def __init__(self, conf):
        self.__conf = conf
