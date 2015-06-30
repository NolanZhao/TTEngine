# -*- coding:utf-8 -*-

import os
import shutil

class RCVersionConf:

    def __init__(self):
        self.ver_major = 1
        self.ver_minor = 0
        self.ver_revision = 0
        self.ver_build = 0
        self.exe_name = ''


# RC文件版本修改器
class RCVersioner:

    # 根据版本号改写RC文件
    def versionRC(self, file_list):
        #改版本号
        for one_file in file_list:
            f_in = open(one_file)
            all_lines_in = []
            all_lines_out = []
            # 读每一行
            try:
                all_lines_in = f_in.readlines()
                for line in all_lines_in:
                    if line.find('FILEVERSION') >= 0:
                        all_lines_out.append(' FILEVERSION %d,%d,%d,%d\n' % (self.__conf.ver_major, self.__conf.ver_minor, self.__conf.ver_revision, self.__conf.ver_build))
                    elif line.find('PRODUCTVERSION') >= 0:
                        all_lines_out.append(' PRODUCTVERSION %d,%d,%d,%d\n' % (self.__conf.ver_major, self.__conf.ver_minor, self.__conf.ver_revision, self.__conf.ver_build))
                    elif line.find('VALUE \"FileVersion\"') >= 0:
                        all_lines_out.append('            VALUE \"FileVersion\", \"%d, %d, %d, %d\"\n' % (self.__conf.ver_major, self.__conf.ver_minor, self.__conf.ver_revision, self.__conf.ver_build))
                    elif line.find('VALUE \"ProductVersion\"') >= 0:
                        all_lines_out.append('            VALUE \"ProductVersion\", \"%d, %d, %d, %d\"\n' % (self.__conf.ver_major, self.__conf.ver_minor, self.__conf.ver_revision, self.__conf.ver_build))
                    else:
                        all_lines_out.append(line)
            except:
                raise Exception('RC文件版本读取出错。')
            finally:
                f_in.close()
            # 写每一行
            try:
                f_out = open(one_file, 'w')
                for line in all_lines_out:
                    f_out.write(line)
            except:
                raise Exception('RC文件版本修改出错。')
            finally:
                f_out.close()


    # 构造函数
    def __init__(self, conf):
        self.__conf = conf
