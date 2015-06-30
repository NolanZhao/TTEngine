# -*- coding:utf-8 -*-

import sys
import traceback
import os
import shutil
import time
from xml.etree import ElementTree

def exceptQuit():
    traceback.print_exc()
    os.system('pause')
    exit()

def curFilePath():
    path = sys.path[0]
    if os.path.isdir(path):
        return path
    elif os.path.isfile(path):
        return os.path.dirname

file_path_out = curFilePath() + '\\result.txt'
solution_path = ''

def parseInput(input_file):
    try:
        root = ElementTree.parse(input_file)
        conf_node = root.find('conf')
        global solution_path
        solution_path = os.path.abspath(conf_node.attrib['solution_path'])
        d = {}
        list_node = root.getiterator('dependency')
        for node in list_node:
            first = node.attrib['check']
            second = node.attrib['key']
            d.setdefault(first, set())
            d[first].add(second)
        return d
    except:
        traceback.print_exc()

def checkSingleDependency(d_k, d_c):
    f_out = open(file_path_out, 'a')
    all_lines_out = []

    # solution_path = os.path.abspath('..')
    fs_key = [item for item in os.walk(solution_path + '\\include\\' + d_k)]
    fs_check = [item for item in os.walk(solution_path + '\\include\\' + d_c)] + [item for item in os.walk(solution_path + '\\src\\' + d_c)]
    for paths_key, dirs_key, files_key in fs_key:
        for file_key in files_key:
            if file_key.endswith('.h') or file_key.endswith('.hpp') or file_key.endswith('.inl'):
                for paths_check, dirs_check, files_check in fs_check:
                    for file_check in files_check:
                        if file_check.endswith('.h') or file_check.endswith('.hpp') or file_check.endswith('.inl') or file_check.endswith('.cpp'): 
                            try:
                                file_path_check = os.path.join(paths_check, file_check)
                                f_in = open(file_path_check)
                                all_lines_in = f_in.readlines()
                                for line in all_lines_in:
                                    if line.lower().startswith('#include') and line.lower().find(file_key.lower()) >= 0:
                                        err_msg = file_path_check + ' ' + line
                                        all_lines_out.append(err_msg)
                                        print(err_msg)

                            except:
                                print('读取 ' + file_path_check + '失败')

                            finally:
                                f_in.close()

    for line_out in all_lines_out:
        f_out.write(line_out)
    
    f_out.close()

def checkDependency(d):
    for dir_key in d.keys():
        s = d[dir_key]
        for dir_check in s:
            checkSingleDependency(dir_key, dir_check)

# -----------------------华丽的分割线------------------------

def mainProc():
    input_file = curFilePath() + '\\input.xml'
    print 'Processing directories...\n'
    if (os.path.isfile(file_path_out)):
        os.remove(file_path_out)

    dependency = parseInput(input_file)
    checkDependency(dependency)
    os.system('pause')

    
if '__main__' == __name__:
    mainProc()
