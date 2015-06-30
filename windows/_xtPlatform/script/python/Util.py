# -*- coding:utf-8 -*-

import shutil
import sys
import os
import shutil


# 一些通用函数、操作的定义类
class Util:
    
    # 复制一个文件
    def copyFile(self, src_dir, dst_dir, file_name):
        shutil.copyfile(src_dir + '\\' + file_name, dst_dir + '\\' + file_name)
        
    # 清空一个目录
    def clearDir(self, src_dir):
        if os.path.isdir(src_dir):
            for f in os.listdir(src_dir):
                abs_path = src_dir + os.sep + f
                if os.path.isfile(abs_path):
                    os.remove(abs_path)
                elif os.path.isdir(abs_path) and f != '.' and f != '..':
                    self.clearDir(abs_path)
                    os.rmdir(abs_path)
    
    # 递归复制文件夹，不复制隐藏目录和SVN目录
    def copyDirR(self, src_dir, dst_dir):
        if os.path.isdir(src_dir):
            if not os.path.isdir(dst_dir):
                os.mkdir(dst_dir)
            for f in os.listdir(src_dir):
                abs_path = src_dir + os.sep + f
                if os.path.isfile(abs_path):
                    shutil.copy(abs_path, dst_dir + os.sep + f)
                elif os.path.isdir(abs_path) and f != '.svn' and f != '.' and f != '..':
                    dst_subdir = dst_dir + os.sep + f
                    self.copyDirR(abs_path, dst_subdir)

    # 复制文件夹中所有文件，不递归
    def copyDir(self, src_dir, dst_dir):
        if os.path.isdir(src_dir):
            if not os.path.isdir(dst_dir):
                os.mkdir(dst_dir)
            for f in os.listdir(src_dir):
                abs_path = src_dir + os.sep + f
                if os.path.isfile(abs_path):
                    shutil.copy(abs_path, dst_dir + os.sep + f)

    # 递归创建目录，如父目录不是目录则创建父目录
    def makeDir(self, d):
        p, v = os.path.split(d)
        if os.path.isdir(p):
            os.mkdir(d)
        elif p != d and len(p) > 0:
            self.makeDir(p)
            os.mkdir(d)
