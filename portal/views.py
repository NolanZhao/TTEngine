# encoding=utf-8
import sys
from utils import svn_utils

reload(sys)
sys.setdefaultencoding('utf-8')
__author__ = 'nerve'

from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.decorators import login_required
from django.shortcuts import render_to_response
from django.http import HttpResponse
from django.template import RequestContext
import json
from portal.models import *
import logging
import time
from utils.TracebackHelper import getTraceBack
import datetime
from usrmgr.models import User
import paramiko
import os
from TTEngine.settings import TEMP_ROOT, UPDATE_SQL_DIR
from TTEngine.constants import *
import MySQLdb
import re
from programBranch.models import BranchInfo
from thread_task.main_task import SyncSvnInfoTask


logger = logging.getLogger('django')
sqlgenINFO = ""

@csrf_exempt
@login_required
def machine_view(request):
    """
    Portal部属机管理
    :param request:
    :return:
    """
    if request.method == 'GET':
        pms = PortalMachine.objects().order_by('host')
        return render_to_response("portal/portal_machine_view.html", locals(), context_instance=RequestContext(request))
    elif request.method == 'POST':
        error = "非法请求方式!"
        logger.error(error)
        return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))


@csrf_exempt
@login_required
def machine_operate(request):
    """
    Portal部属机保存,删除,更新
    :param request:
    :return:
    """
    if request.method == 'GET':
        error = "非法请求方式!"
        logger.error(error)
        return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))
    elif request.method == 'POST':
        # cmd in [update, save, delete]
        # cmd in [更新, 保存, 删除]
        response = {'success': False, 'error': ''}
        try:
            # 获取参数
            cmd = request.POST.get('cmd', None)
            pm_id = request.POST.get('pm_id', None)
            name = request.POST.get('name', None)
            host = request.POST.get('host', None)
            port = request.POST.get('port', None)
            port = None if port is None else int(port)
            username = request.POST.get('username', None)
            password = request.POST.get('password', None)
            path = request.POST.get('path', None)

            param_is_none = False

            if name is None or host is None or port is None or username is None or password is None or path is None:
                param_is_none = True

            if cmd is None:
                response["error"] = "CMD参数不能为空!"
                return HttpResponse(json.dumps(response), mimetype="application/json")

            if (cmd == 'delete' and pm_id is None) or \
                    (cmd == 'save' and param_is_none) or \
                    (cmd == 'update' and (param_is_none or pm_id is None)):
                response["error"] = "必要参数为空!"
                return HttpResponse(json.dumps(response), mimetype="application/json")

            # 创建
            if cmd == 'save':
                # 判断是否已有
                param_exist = PortalMachine.objects(host=host, port=port, path=path)

                if len(param_exist) > 0:
                    response["error"] = "已存在相同配置!请在原基础修改!"
                    return HttpResponse(json.dumps(response), mimetype="application/json")

                pm = PortalMachine()
                pm.name = name
                pm.host = host
                pm.port = port
                pm.username = username
                pm.password = password
                pm.path = path
                pm.create_time = datetime.datetime.now()
                pm.create_user = User.objects.get(pk=request.user.id)
                pm.save()
                response["id"] = str(pm.id)

            # 更新
            elif cmd == 'update':
                # 查找对象
                pm = PortalMachine.objects(pk=pm_id)
                if len(pm) == 0:
                    response["error"] = "未找到可更新对象!"
                    return HttpResponse(json.dumps(response), mimetype="application/json")
                pm = pm[0]
                pm.name = name
                pm.host = host
                pm.port = port
                pm.username = username
                pm.password = password
                pm.path = path
                pm.update_time = datetime.datetime.now()
                pm.update_user = User.objects.get(pk=request.user.id)
                pm.save()

            # 删除
            elif cmd == 'delete':
                # 查找对象
                pm = PortalMachine.objects(pk=pm_id)
                if len(pm) == 0:
                    response["error"] = "未找到可删除对象!"
                    return HttpResponse(json.dumps(response), mimetype="application/json")

                pm = pm[0]
                pm.delete()

            else:
                response["error"] = "CMD指令异常!"
                return HttpResponse(json.dumps(response), mimetype="application/json")

            response["success"] = True
            response["error"] = "执行成功!"
            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception as e:
            response["error"] = "系统异常![%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")


@csrf_exempt
@login_required
def portal_package_create(request):
    if request.method == 'GET':
        pms = PortalMachine.objects()

        portal_machine_list = []

        for pm in pms:
            portal_machine_list.append(pm.host + ' [' + pm.name + ']')

        portal_machine_list_json = json.dumps(portal_machine_list)
        return render_to_response('portal/portal_package_create.html', locals(), context_instance=RequestContext(request))
    elif request.method == 'POST':
        response = {'success': False, 'error': ''}
        try:
            pm_id = request.POST.get('pm_id', None)
            remark = request.POST.get('remark', None)

            if pm_id is None or pm_id == '':
                response["error"] = "必要参数为空!"
                return HttpResponse(json.dumps(response), mimetype="application/json")

            pm = PortalMachine.objects(pk=pm_id)

            if len(pm) == 0:
                response["error"] = "指定部属机不存在!"
                return HttpResponse(json.dumps(response), mimetype="application/json")

            pm = pm[0]

            # 执行登陆操作
            ssh = paramiko.SSHClient()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            ssh.connect(pm.host, pm.port, pm.username, pm.password, timeout=5)

            pp = PortalPackage()
            now = datetime.datetime.now()
            file_name = now.strftime('%Y_%m_%d_%H_%M_%S_%f')
            # 本地文件
            tar_file_path = os.path.join(TEMP_ROOT, "webserver.tar.gz")
            sql_file_path = os.path.join(TEMP_ROOT, "db.sql")
            # 远程文件
            remote_tar_file_path = '/deploy_portal/%s/webserver.tar.gz' % file_name
            remote_sql_file_path = '/deploy_portal/%s/db.sql' % file_name
            remote_refer_sql_file = '%s/doc/makedb/0828/ttmgrportal_0828.sql' % pm.path

            # 获取SVN数据
            stdin, stdout, stderr = ssh.exec_command('svn info %s' % pm.path)
            err_list = stderr.readlines()
            if len(err_list) > 0:
                response["error"] = "SVN信息读取失败!<br>%s!" % err_list[0].rstrip()
                return HttpResponse(json.dumps(response), mimetype="application/json")

            init_svn_info(stdout, pp)

            # 准备路径
            stdin, stdout, stderr = ssh.exec_command('mkdir /deploy_portal/')
            stdout.read()

            stdin, stdout, stderr = ssh.exec_command('mkdir /deploy_portal/%s/' % file_name)
            stdout.read()

            # 复制文件夹到目标路径
            stdin, stdout, stderr = ssh.exec_command('cp -r %s /deploy_portal/%s/webserver' % (pm.path, file_name))
            stdout.read()

            # 删除SVN文件
            stdin, stdout, stderr = ssh.exec_command('find /deploy_portal/%s/webserver/ -name .svn|xargs rm -rf' % file_name)
            stdout.read()

            # 删除PYC文件
            stdin, stdout, stderr = ssh.exec_command('find /deploy_portal/%s/webserver/ -name *.pyc|xargs rm -rf' % file_name)
            stdout.read()

            # 删除doc目录
            stdin, stdout, stderr = ssh.exec_command('rm -rf /deploy_portal/%s/webserver/doc' % file_name)
            stdout.read()

            # 删除上传文件目录
            stdin, stdout, stderr = ssh.exec_command('rm -r /deploy_portal/%s/webserver/media/packages/*' % file_name)
            stdout.read()

            # 复制建库脚本
            stdin, stdout, stderr = ssh.exec_command('cp %s %s' % (remote_refer_sql_file, remote_sql_file_path))
            stdout.read()

            # 打包程序
            stdin, stdout, stderr = ssh.exec_command('cd /deploy_portal/%s/webserver/;tar czvf %s ./*' % (file_name, remote_tar_file_path))
            stdout.read()

            # 执行打包操作,拷贝文件到本地
            sftp = ssh.open_sftp()
            sftp.get(remote_tar_file_path, tar_file_path)
            sftp.get(remote_sql_file_path, sql_file_path)

            # 删除生成的路径
            stdin, stdout, stderr = ssh.exec_command('rm -r /deploy_portal/*')
            stdout.read()

            ssh.close()
            # 记录文件到数据库
            sql_size = os.path.getsize(sql_file_path)
            tar_size = os.path.getsize(tar_file_path)
            sql_file = open(sql_file_path, 'rb')
            tar_file = open(tar_file_path, 'rb')

            pp.is_enabled = True
            pp.package.put(tar_file, content_type=CONTENT_TYPE['gz'])
            pp.package_size = tar_size
            pp.sql.put(sql_file, content_type='text/plain')
            pp.sql_size = sql_size
            pp.create_user = User.objects.get(pk=request.user.id)
            pp.create_time = datetime.datetime.now()
            pp.remark = remark
            pp.portal_machine = pm
            pp.save()

            sql_file.close()
            tar_file.close()

            response["id"] = str(pp.id)
            response["success"] = True
            response["error"] = "执行成功!"
            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception as e:
            response["error"] = "系统异常![%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")
    else:
        error = "非法请求方式!"
        logger.error(error)
        return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))


def init_svn_info(stdout, pp):
    """
    读取SVN信息
    """
    attr_dict = {
        'URL': 'svn_url',
        'Last Changed Rev': 'svn_version'
    }

    match = False
    lines = []

    for index in range(10):
        if pp.svn_url is None or pp.svn_version is None:
            line = stdout.readline()
            line = line.rstrip()
            lines.append(line)
            if line == '':
                continue
            arr = line.split(": ")
            key = arr[0]
            attr_val = arr[1]
            if key in attr_dict:
                pp.__setattr__(attr_dict[key], attr_val)
                match = True
        else:
            break

    if not match:
        return False


@csrf_exempt
@login_required
def login_test(request):
    """
    登陆测试
    :param request:
    :return:
    """
    response = {'success': False, 'error': ''}

    if request.method == 'POST':
        try:
            # 获取参数
            pm_id = request.POST.get('pm_id', None)

            if pm_id is None or pm_id == '':
                response["error"] = "测试ID不可为空!"
                return HttpResponse(json.dumps(response), mimetype="application/json")

            # 验证对象是否存在
            pm = PortalMachine.objects(pk=pm_id)

            if len(pm) == 0:
                response["error"] = "未找到该对象!"
                return HttpResponse(json.dumps(response), mimetype="application/json")

            pm = pm[0]

            # 执行SSH登陆测试
            login_result, info = test_login(pm.host, pm.port, pm.username, pm.password)

            response["success"] = login_result
            response["error"] = info
            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception as e:
            response["error"] = "系统异常![%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")
    else:
        response["error"] = "非法请求方式!"
        return HttpResponse(json.dumps(response), mimetype="application/json")


def test_login(ip, port, username, password):
    """
    测试SSH登陆
    :param ip:
    :param port:
    :param username:
    :param password:
    :return:
    """
    try:
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(ip, port, username, password, timeout=5)
        ssh.close()
        return True, '登陆成功!'
    except Exception as e:
        return False, '登陆失败![%s]' % e.message


@csrf_exempt
@login_required
def update_svn(request):
    """
    更新 SVN
    :param request:
    :return:
    """
    response = {'error': False, 'message': ''}

    if request.method == 'POST':
        try:
            # 获取参数
            pm_id = request.POST.get('pm_id', None)

            if pm_id is None or pm_id == '':
                response["error"] = "ID为空，无法通过ssh登录"
                return HttpResponse(json.dumps(response), mimetype="application/json")

            # 验证对象是否存在
            pm = PortalMachine.objects(pk=pm_id)

            if len(pm) == 0:
                response["error"] = "未找到该对象!"
                return HttpResponse(json.dumps(response), mimetype="application/json")

            pm = pm[0]

            # 执行 SVN 更新
            client = paramiko.SSHClient()
            client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            client.connect(pm.host, port=pm.port, username=pm.username, password=pm.password)
            # 更新 /home/rzrk/webserver/webserver目录
            stdin, stdout, stderr = client.exec_command("svn up %s" % pm.path)
            err_list = stderr.readlines()
            if len(err_list) > 0:
                response = {'success': False, 'error': 'SVN更新失败! <br />%s!' % err_list[0].rstrip()}
                return HttpResponse(json.dumps(response), mimetype="application/json")
            # 关闭 ssh 连接
            client.close()
            response = {'success': True, 'error': 'SVN更新成功！'}

            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception as e:
            response = {'success': False, 'error': '更新失败！[%s] pm.path: %s' % (e.message, pm.path)}
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")
    else:
        response = {'success': False, 'error': "非法请求方式"}
        return HttpResponse(json.dumps(response), mimetype="application/json")


@csrf_exempt
@login_required
def get_svn_info(request):
    """
    更新 SVN
    :param request:
    :return:
    """
    response = {'error': False, 'message': ''}

    if request.method == 'POST':
        try:
            # 获取参数
            pm_id = request.POST.get('pm_id', None)

            if pm_id is None or pm_id == '':
                response["error"] = "ID为空，无法通过ssh登录"
                return HttpResponse(json.dumps(response), mimetype="application/json")

            # 验证对象是否存在
            pm = PortalMachine.objects(pk=pm_id)

            if len(pm) == 0:
                response["error"] = "未找到该对象!"
                return HttpResponse(json.dumps(response), mimetype="application/json")

            pm = pm[0]

            # 获取svn信息
            client = paramiko.SSHClient()
            client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            print 'pm.host: %s, pm.port: %s, pm.username: %s, pm.password: %s' % (pm.host, pm.port, pm.username, pm.password)
            client.connect(pm.host, port=pm.port, username=pm.username, password=pm.password)
            # 更新 /home/rzrk/webserver/webserver目录
            stdin, stdout, stderr = client.exec_command("svn info %s" % pm.path)
            err_list = stderr.readlines()
            if len(err_list) > 0:
                response = {'success': False, 'error': '[error] -> [error]'}
                return HttpResponse(json.dumps(response), mimetype="application/json")

            svn_info_dict = dict()
            for index in range(9):
                line = stdout.readline()
                line = line.rstrip()
                if line == '':
                    continue
                arr = line.split(': ')
                svn_info_dict[arr[0]] = arr[1]
            local_rev = svn_info_dict['Revision']

            stdin, stdout, stderr = client.exec_command('svn info %s' % svn_info_dict['URL'])
            err_list = stderr.readlines()
            if len(err_list) > 0:
                response = {'success': True, 'error': '[当前版本:%s] -> [error]' % (local_rev)}
                return HttpResponse(json.dumps(response), mimetype="application/json")

            svn_info_dict2 = dict()
            for index in range(8):
                line = stdout.readline()
                line = line.rstrip()
                if line == '':
                    continue
                arr = line.split(': ')
                svn_info_dict2[arr[0]] = arr[1]
            url_rev = svn_info_dict2['Revision']

            # 关闭 ssh 连接
            client.close()
            if local_rev == url_rev:
                response = {'success': True, 'error': '[已为最新版本:%s]' % (url_rev), 'is_latest': 'True'}
            else:
                response = {'success': True, 'error': '[当前版本:%s] -> [最新版本:%s]' % (local_rev, url_rev), 'is_latest': 'False'}
            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception as e:
            response = {'success': False, 'error': '[err] -> [err](获取信息失败)'}
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")
    else:
        response = {'success': False, 'error': "[err] -> [err](非法请求方式)"}
        return HttpResponse(json.dumps(response), mimetype="application/json")


@csrf_exempt
@login_required
def portal_package_list(request):
    """
    Portal程序列表
    :param request:
    :return:
    """
    packages = PortalPackage.objects().order_by('-svn_version')

    svn_info_dict = SyncSvnInfoTask.get_svn_info_dict()

    return render_to_response("portal/portal_package_list.html", locals(), context_instance=RequestContext(request))


@csrf_exempt
@login_required
def change_is_enabled(request):
    """
    启用/禁用 Portal包
    :param request:
    :return:
    """
    response = {'success': False, 'error': ''}

    if request.method == 'POST':
        try:
            # 获取参数
            pp_id = request.POST.get('id', None)

            if pp_id is None or pp_id == '':
                response["error"] = "必要参数为空!"
                return HttpResponse(json.dumps(response), mimetype="application/json")

            # 验证对象是否存在
            pp = PortalPackage.objects(pk=pp_id)

            if len(pp) == 0:
                response["error"] = "未找到对应包!"
                return HttpResponse(json.dumps(response), mimetype="application/json")

            pp = pp[0]
            pp.is_enabled = not pp.is_enabled
            pp.save()

            response["success"] = True
            response["error"] = '操作成功!'
            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception as e:
            response["error"] = "系统异常![%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")
    else:
        response["error"] = "非法请求方式!"
        return HttpResponse(json.dumps(response), mimetype="application/json")


@csrf_exempt
@login_required
def delete(request):
    """
    删除Portal包
    :param request:
    :return:
    """
    response = {'success': False, 'error': ''}

    if request.method == 'POST':
        try:
            # 获取参数
            pp_id = request.POST.get('id', None)

            if pp_id is None or pp_id == '':
                response["error"] = "必要参数为空!"
                return HttpResponse(json.dumps(response), mimetype="application/json")

            # 验证对象是否存在
            pp = PortalPackage.objects(pk=pp_id)

            if len(pp) == 0:
                response["error"] = "未找到对应包!"
                return HttpResponse(json.dumps(response), mimetype="application/json")

            pp = pp[0]
            pp.delete()

            response["success"] = True
            response["error"] = '操作成功!'
            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception as e:
            response["error"] = "系统异常![%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")
    else:
        response["error"] = "非法请求方式!"
        return HttpResponse(json.dumps(response), mimetype="application/json")


@csrf_exempt
@login_required
def download_package(request):
    """
    下载Portal包
    :param request:
    :return:
    """
    try:
        # 获取参数
        pp_id = request.GET.get('id', None)

        if pp_id is None or pp_id == '':
            error = "必要参数为空!"
            logger.error(error)
            return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))

        # 验证对象是否存在
        pp = PortalPackage.objects(pk=pp_id)

        if len(pp) == 0:
            error = "未找到对应包!"
            logger.error(error)
            return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))

        pp = pp[0]

        content = pp.package.read()
        size = pp.package_size
        response = HttpResponse(content)
        response['Content-Length'] = size
        response['Content-Disposition'] = 'attachment; filename=portal_%s.tar.gz' % pp.svn_version
        return response
    except Exception as e:
        error = "下载文件异常![%s]" % str(e)
        logger.error(error + getTraceBack())
        return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))


@csrf_exempt
@login_required
def download_sql(request):
    """
    下载Portal包建库脚本
    :param request:
    :return:
    """
    try:
        # 获取参数
        pp_id = request.GET.get('id', None)

        if pp_id is None or pp_id == '':
            error = "必要参数为空!"
            logger.error(error)
            return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))

        # 验证对象是否存在
        pp = PortalPackage.objects(pk=pp_id)

        if len(pp) == 0:
            error = "未找到对应包!"
            logger.error(error)
            return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))

        pp = pp[0]

        content = pp.sql.read()
        size = pp.sql_size
        response = HttpResponse(content)
        response['Content-Length'] = size
        response['Content-Disposition'] = 'attachment; filename=portal_%s.sql' % pp.svn_version
        return response
    except Exception as e:
        error = "下载文件异常![%s]" % str(e)
        logger.error(error + getTraceBack())
        return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))


@csrf_exempt
@login_required
def package_view(request):
    """
    Portal包查看
    :param request:
    :return:
    """
    if request.method == 'GET':
        # 获取参数
        pp_id = request.GET.get('id', None)

        if pp_id is None or pp_id == '':
            error = "必要参数为空!"
            logger.error(error)
            return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))

        # 验证对象是否存在
        pp = PortalPackage.objects(pk=pp_id)

        if len(pp) == 0:
            error = "未找到对应包!"
            logger.error(error)
            return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))

        pp = pp[0]
        is_view = True

        return render_to_response("portal/portal_package_input.html", locals(), context_instance=RequestContext(request))
    elif request.method == 'POST':
        error = "非法请求方式!"
        logger.error(error)
        return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))


@csrf_exempt
@login_required
def package_edit(request):
    """
    Portal包编辑
    :param request:
    :return:
    """
    if request.method == 'GET':
        # 获取参数
        pp_id = request.GET.get('id', None)

        if pp_id is None or pp_id == '':
            error = "必要参数为空!"
            logger.error(error)
            return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))

        # 验证对象是否存在
        pp = PortalPackage.objects(pk=pp_id)

        if len(pp) == 0:
            error = "未找到对应包!"
            logger.error(error)
            return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))

        pp = pp[0]
        is_edit = True

        return render_to_response("portal/portal_package_input.html", locals(), context_instance=RequestContext(request))
    elif request.method == 'POST':
        response = {'success': False, 'error': ''}
        try:
            # 获取参数
            id = request.POST.get('id', None)
            is_enabled = request.POST.get('is_enabled', None)
            remark = request.POST.get('remark', None)

            if id is None or is_enabled is None:
                response["error"] = "必要参数不能为空!"
                return HttpResponse(json.dumps(response), mimetype="application/json")

            if is_enabled == 'true':
                is_enabled = True
            elif is_enabled == 'false':
                is_enabled = False
            else:
                response["error"] = "启用状态异常![%s]" % is_enabled
                return HttpResponse(json.dumps(response), mimetype="application/json")

            pp = PortalPackage.objects(pk=id)

            if len(pp) == 0:
                response["error"] = "未找到对应包!"
                return HttpResponse(json.dumps(response), mimetype="application/json")

            pp = pp[0]
            pp.is_enabled = is_enabled
            pp.remark = remark
            pp.update_user = User.objects.get(pk=request.user.id)
            pp.update_time = datetime.datetime.now()
            pp.save()

            response["success"] = True
            response["error"] = "执行成功!"
            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception as e:
            response["error"] = "系统异常![%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")


@csrf_exempt
@login_required
def update_gen_sql(request):
    """
    自动生成升级脚本
    :param request:
    :return:
    """
    if request.method == 'GET':
        # 查询所有Portal版本
        pps = PortalPackage.objects(is_enabled=True).order_by('-svn_version')

        return render_to_response("portal/portal_update_gen_sql.html", locals(), context_instance=RequestContext(request))
    elif request.method == 'POST':
        response = {'success': False, 'error': ''}
        try:
            # 获取参数
            old_id = request.POST.get('old_id', None)
            new_id = request.POST.get('new_id', None)
            # 获取file
            file_obj = request.FILES.get('upload_file', None)

            is_new = int(request.POST.get('is_new', 1))
            is_new = True if is_new == 1 else False

            start_time = datetime.datetime.now()

            if (file_obj is None and (old_id is None or new_id is None)) or (file_obj is not None and new_id is None):
                response["error"] = "必要参数不能为空!"
                return HttpResponse(json.dumps(response), mimetype="application/json")

            pp_old_sql_read = None
            pp_new_sql_read = None
            pp_old = None
            pp_new = None

            if file_obj is None:
                pp_old = PortalPackage.objects(pk=old_id)
                pp_new = PortalPackage.objects(pk=new_id)

                if len(pp_old) == 0 or len(pp_new) == 0:
                    response["error"] = "未找到对应Portal包!"
                    return HttpResponse(json.dumps(response), mimetype="application/json")

                pp_old = pp_old[0]
                pp_new = pp_new[0]

                pp_old_sql_read = pp_old.sql.read()
                pp_new_sql_read = pp_new.sql.read()
            else:
                pp_old = PortalPackage()
                pp_old.svn_version = 'unknown'
                pp_new = PortalPackage.objects(pk=new_id)

                if len(pp_new) == 0:
                    response["error"] = "未找到对应Portal包!"
                    return HttpResponse(json.dumps(response), mimetype="application/json")

                pp_old_sql_read = file_obj.read()
                pp_new = pp_new[0]
                pp_new_sql_read = pp_new.sql.read()

            # 比较文件是否相同
            if pp_old_sql_read == pp_new_sql_read:
                response["success"] = True
                response["error"] = "建库脚本无变动!无须升级!"
                return HttpResponse(json.dumps(response), mimetype="application/json")

            # 优先从数据库查询
            if not is_new and file_obj is None:
                exist = PortalUpgradeSql.objects(old_package=pp_old, new_package=pp_new).order_by('-end_time')
                if len(exist) > 0:
                    exist = exist[0]
                    response["success"] = True
                    response["id"] = str(exist.id)
                    response["error"] = "执行成功!"
                    return HttpResponse(json.dumps(response), mimetype="application/json")

            # 准备新旧建库脚本
            old_file_path = os.path.join(TEMP_ROOT, "old.sql")
            new_file_path = os.path.join(TEMP_ROOT, "new.sql")

            old_file = open(old_file_path, 'w')
            old_file.write(pp_old_sql_read)
            old_file.close()

            new_file = open(new_file_path, 'w')
            new_file.write(pp_new_sql_read)
            new_file.close()

            # 参数准备完毕,开始升级脚
            file_name = start_time.strftime('%Y_%m_%d_%H_%M_%S_%f') + '_sql'

            # 执行登陆操作
            ssh = paramiko.SSHClient()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            ssh.connect(PORTAL_GET_SQL_IP, PORTAL_GET_SQL_PORT, PORTAL_GET_SQL_USERNAME, PORTAL_GET_SQL_PASSWORD, timeout=5)

            # 准备路径
            stdin, stdout, stderr = ssh.exec_command('mkdir /deploy_portal_gen_sql/')
            stdout.read()

            stdin, stdout, stderr = ssh.exec_command('mkdir /deploy_portal_gen_sql/%s/' % file_name)
            stdout.read()

            sftp = ssh.open_sftp()
            sftp.put(old_file_path, '/deploy_portal_gen_sql/%s/old.sql' % file_name)
            sftp.put(new_file_path, '/deploy_portal_gen_sql/%s/new.sql' % file_name)

            # 登陆mysql,准备数据库
            db = MySQLdb.connect(host=PORTAL_GET_SQL_IP, user=PORTAL_GET_SQL_SQL_NAME, passwd=PORTAL_GET_SQL_SQL_PWD)
            cursor = db.cursor()
            sql = [
                'drop database if exists ttmgrportal_old',
                'drop database if exists ttmgrportal_new',
                'create database ttmgrportal_old',
                'create database ttmgrportal_new'
            ]
            for item_sql in sql:
                cursor.execute(item_sql)
            db.close()

            # 导入数据库
            stdin, stdout, stderr = ssh.exec_command('mysql -uroot -pmysql.rzrk ttmgrportal_old < /deploy_portal_gen_sql/%s/old.sql' % file_name)
            stdout.read()
            stdin, stdout, stderr = ssh.exec_command('mysql -uroot -pmysql.rzrk ttmgrportal_new < /deploy_portal_gen_sql/%s/new.sql' % file_name)
            stdout.read()

            # 执行比较语句
            cmd = 'schemasync -r --output-dir="/deploy_portal_gen_sql/%s/" mysql://%s:%s@%s:3306/ttmgrportal_new  mysql://%s:%s@%s:3306/ttmgrportal_old' %\
                                                     (file_name, PORTAL_GET_SQL_SQL_NAME, PORTAL_GET_SQL_SQL_PWD, '127.0.0.1', PORTAL_GET_SQL_SQL_NAME, PORTAL_GET_SQL_SQL_PWD, '127.0.0.1')
            print "CMD:  \n%s" % cmd
            stdin, stdout, stderr = ssh.exec_command(cmd)
            stdout.read()


            # 将文件获取到本地
            patch_flag = False

            patch_file_path = '/deploy_portal_gen_sql/%s/ttmgrportal_old.%s.patch.sql' % (file_name, start_time.strftime('%Y%m%d'))
            local_patch_file_path = os.path.join(TEMP_ROOT, "portal_%s_to_%s.sql" % (pp_old.svn_version, pp_new.svn_version))

            patch_log_path = '/deploy_portal_gen_sql/%s/schemasync.log' % file_name
            patch_log_file_path = os.path.join(TEMP_ROOT, "schemasync.log")

            try:
                # 文件拷贝到本地
                sftp.get(patch_file_path, local_patch_file_path)
                patch_flag = True
            except Exception as e:
                logger.error('执行比较脚本异常! --> ' + getTraceBack())

            # 删除生成的路径
            #stdin, stdout, stderr = ssh.exec_command('rm -r /deploy_portal_gen_sql/*')

            ssh.close()

            # 结束时间毫秒数
            end_milliseconds = time.time()

            # 解析建库脚本,及生成的比较语句,生成最终的建库脚本
            # 结束时间
            end_time = datetime.datetime.fromtimestamp(end_milliseconds)
            # 以结束时间作为版本号
            upgrade_version = VERSION_PREFIX_PORTAL_UPGRADE_SCRIPT + str(int(end_milliseconds * 1000))

            # 提取出需要的数据
            add_sql = get_add_sql(new_file_path)

            local_patch_file_final_path = os.path.join(TEMP_ROOT, "portal_%s_to_%s_final.sql" % (pp_old.svn_version, pp_new.svn_version))
            local_patch_file_final = open(local_patch_file_final_path, 'w')

            local_patch_file_final.write('\r\n')
            local_patch_file_final.write('\r\n')
            local_patch_file_final.write('-- --------------------------------------------------------' + '\r\n')
            local_patch_file_final.write('-- Portal upgrade script' + '\r\n')
            local_patch_file_final.write('-- script version: %s' % upgrade_version + '\r\n')
            local_patch_file_final.write('-- from   version: %s' % pp_old.svn_version + '\r\n')
            local_patch_file_final.write('-- to     version: %s' % pp_new.svn_version + '\r\n')
            local_patch_file_final.write('-- create by     : %s' % User.objects.get(pk=request.user.id).username + '\r\n')
            local_patch_file_final.write('-- start  time   : %s' % start_time.strftime('%Y-%m-%d %H:%M:%S.%f') + '\r\n')
            local_patch_file_final.write('-- end    time   : %s' % end_time.strftime('%Y-%m-%d %H:%M:%S.%f') + '\r\n')
            local_patch_file_final.write('-- power  by     : tt_engine' + '\r\n')
            local_patch_file_final.write('-- --------------------------------------------------------' + '\r\n')
            local_patch_file_final.write('\r\n')
            local_patch_file_final.write('\r\n')
            local_patch_file_final.write('SET FOREIGN_KEY_CHECKS=0;' + '\r\n')

            # 生成patch成功
            if patch_flag:
                with open(local_patch_file_path) as local_patch_file:
                    for line in local_patch_file:
                        if line.startswith('--') or not line.strip():
                            continue
                        if line.lower().strip().startswith('use'):
                            continue
                        local_patch_file_final.write(line + '\r\n')

            # 添加额外的SQL语句
            for key in add_sql:
                value = add_sql[key]
                local_patch_file_final.write('-- --------------------------------------------------------' + '\r\n')
                local_patch_file_final.write('-- init table %s' % key + '\r\n')
                local_patch_file_final.write('-- --------------------------------------------------------' + '\r\n')
                for item_sql in value:
                    local_patch_file_final.write(item_sql)

            local_patch_file_final.write('SET FOREIGN_KEY_CHECKS=1;' + '\r\n')
            local_patch_file_final.flush()
            local_patch_file_final.close()

            # 保存生成的脚本操作
            pus = PortalUpgradeSql()
            if not file_obj:
                pus.old_package = pp_old
            pus.new_package = pp_new
            pus.version = upgrade_version
            pus.sql.put(open(local_patch_file_final_path), content_type='text/plain')
            pus.create_user = User.objects.get(pk=request.user.id)
            pus.start_time = start_time
            pus.end_time = end_time
            pus.save()

            response["success"] = True
            response["id"] = str(pus.id)
            response["error"] = '执行成功!' if patch_flag else open(patch_log_file_path).read()
            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception as e:
            response["error"] = "系统异常![%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")


@csrf_exempt
@login_required
def uploadfile_gen_sql(request):
    """
    通过上传文件自动生成升级脚本
    :param request:
    :return:
    """
    if request.method == 'GET':
        return render_to_response("portal/portal_uploadfile_gen_sql.html", locals(), context_instance=RequestContext(request))

    elif request.method == 'POST':
        response = {'success': False, 'error': ''}
        try:
            pp_old = PortalPackage()
            pp_new = PortalPackage()
            pp_old.svn_version = 'unknown'
            pp_new.svn_version = 'unknown'

            # 准备新旧建库脚本
            old_file_path = os.path.join(TEMP_ROOT, "old.sql")
            new_file_path = os.path.join(TEMP_ROOT, "new.sql")

            old_file = open(old_file_path, 'r')
            pp_old_sql_read = old_file.read()

            new_file = open(new_file_path, 'r')
            pp_new_sql_read = new_file.read()

             # 比较文件是否相同
            if pp_old_sql_read == pp_new_sql_read:
                response["success"] = True
                response["error"] = "建库脚本无变动!无须升级!"
                return HttpResponse(json.dumps(response), mimetype="application/json")

            # 参数准备完毕,开始升级脚本
            start_time = datetime.datetime.now()
            file_name = start_time.strftime('%Y_%m_%d_%H_%M_%S_%f') + '_sql'

            # 执行登陆操作
            ssh = paramiko.SSHClient()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            ssh.connect(PORTAL_GET_SQL_IP, PORTAL_GET_SQL_PORT, PORTAL_GET_SQL_USERNAME, PORTAL_GET_SQL_PASSWORD, timeout=5)

            # 准备路径
            stdin, stdout, stderr = ssh.exec_command('mkdir /deploy_portal_gen_sql/')
            stdout.read()

            stdin, stdout, stderr = ssh.exec_command('mkdir /deploy_portal_gen_sql/%s/' % file_name)
            stdout.read()

            sftp = ssh.open_sftp()
            sftp.put(old_file_path, '/deploy_portal_gen_sql/%s/old.sql' % file_name)
            sftp.put(new_file_path, '/deploy_portal_gen_sql/%s/new.sql' % file_name)

            # 登陆mysql,准备数据库
            db = MySQLdb.connect(host=PORTAL_GET_SQL_IP, user=PORTAL_GET_SQL_SQL_NAME, passwd=PORTAL_GET_SQL_SQL_PWD)
            cursor = db.cursor()
            sql = [
                'drop database if exists ttmgrportal_old',
                'drop database if exists ttmgrportal_new',
                'create database ttmgrportal_old',
                'create database ttmgrportal_new'
            ]
            for item_sql in sql:
                cursor.execute(item_sql)
            db.close()

            # 导入数据库
            stdin, stdout, stderr = ssh.exec_command('mysql -uroot -pmysql.rzrk ttmgrportal_old < /deploy_portal_gen_sql/%s/old.sql' % file_name)
            stdout.read()
            stdin, stdout, stderr = ssh.exec_command('mysql -uroot -pmysql.rzrk ttmgrportal_new < /deploy_portal_gen_sql/%s/new.sql' % file_name)
            stdout.read()

            # 执行比较语句
            cmd = 'schemasync -r --output-dir="/deploy_portal_gen_sql/%s/" mysql://%s:%s@%s:3306/ttmgrportal_new  mysql://%s:%s@%s:3306/ttmgrportal_old' %\
                                                     (file_name, PORTAL_GET_SQL_SQL_NAME, PORTAL_GET_SQL_SQL_PWD, '127.0.0.1', PORTAL_GET_SQL_SQL_NAME, PORTAL_GET_SQL_SQL_PWD, '127.0.0.1')
            print "CMD:  \n%s" % cmd
            stdin, stdout, stderr = ssh.exec_command(cmd)
            stdout.read()


            # 将文件获取到本地
            patch_flag = False

            patch_file_path = '/deploy_portal_gen_sql/%s/ttmgrportal_old.%s.patch.sql' % (file_name, start_time.strftime('%Y%m%d'))
            local_patch_file_path = os.path.join(TEMP_ROOT, "portal_unknown_to_unknown.sql")

            patch_log_path = '/deploy_portal_gen_sql/%s/schemasync.log' % file_name
            patch_log_file_path = os.path.join(TEMP_ROOT, "schemasync.log")

            try:
                # 文件拷贝到本地
                sftp.get(patch_file_path, local_patch_file_path)
                patch_flag = True
            except Exception as e:
                logger.error('执行比较脚本异常! --> ' + getTraceBack())

            # 删除生成的路径
            #stdin, stdout, stderr = ssh.exec_command('rm -r /deploy_portal_gen_sql/*')

            ssh.close()

            # 结束时间毫秒数
            end_milliseconds = time.time()

            # 解析建库脚本,及生成的比较语句,生成最终的建库脚本
            # 结束时间
            end_time = datetime.datetime.fromtimestamp(end_milliseconds)
            # 以结束时间作为版本号
            upgrade_version = VERSION_PREFIX_PORTAL_UPGRADE_SCRIPT + str(int(end_milliseconds * 1000))

            # 提取出需要的数据
            add_sql = get_add_sql(new_file_path)

            local_patch_file_final_path = os.path.join(TEMP_ROOT, "portal_%s_to_%s_final.sql" % (pp_old.svn_version, pp_new.svn_version))
            local_patch_file_final = open(local_patch_file_final_path, 'w')

            local_patch_file_final.write('\r\n')
            local_patch_file_final.write('\r\n')
            local_patch_file_final.write('-- --------------------------------------------------------' + '\r\n')
            local_patch_file_final.write('-- Portal upgrade script' + '\r\n')
            local_patch_file_final.write('-- script version: %s' % upgrade_version + '\r\n')
            local_patch_file_final.write('-- from   version: unknown\r\n')
            local_patch_file_final.write('-- to     version: unknown\r\n')
            local_patch_file_final.write('-- create by     : %s' % User.objects.get(pk=request.user.id).username + '\r\n')
            local_patch_file_final.write('-- start  time   : %s' % start_time.strftime('%Y-%m-%d %H:%M:%S.%f') + '\r\n')
            local_patch_file_final.write('-- end    time   : %s' % end_time.strftime('%Y-%m-%d %H:%M:%S.%f') + '\r\n')
            local_patch_file_final.write('-- power  by     : tt_engine' + '\r\n')
            local_patch_file_final.write('-- --------------------------------------------------------' + '\r\n')
            local_patch_file_final.write('\r\n')
            local_patch_file_final.write('\r\n')
            local_patch_file_final.write('SET FOREIGN_KEY_CHECKS=0;' + '\r\n')

            # 生成patch成功
            if patch_flag:
                with open(local_patch_file_path) as local_patch_file:
                    for line in local_patch_file:
                        if line.startswith('--') or not line.strip():
                            continue
                        if line.lower().strip().startswith('use'):
                            continue
                        local_patch_file_final.write(line + '\r\n')

            # 添加额外的SQL语句
            for key in add_sql:
                value = add_sql[key]
                local_patch_file_final.write('-- --------------------------------------------------------' + '\r\n')
                local_patch_file_final.write('-- init table %s' % key + '\r\n')
                local_patch_file_final.write('-- --------------------------------------------------------' + '\r\n')
                for item_sql in value:
                    local_patch_file_final.write(item_sql)

            local_patch_file_final.write('SET FOREIGN_KEY_CHECKS=1;' + '\r\n')
            local_patch_file_final.flush()
            local_patch_file_final.close()

            # 保存生成的脚本操作
            pus = PortalUpgradeSql()
            pus.old_package = None
            pus.new_package = None
            pus.version = upgrade_version
            pus.sql.put(open(local_patch_file_final_path), content_type='text/plain')
            pus.create_user = User.objects.get(pk=request.user.id)
            pus.start_time = start_time
            pus.end_time = end_time
            pus.save()

            response["success"] = True
            response["id"] = str(pus.id)
            response["error"] = '执行成功!' if patch_flag else open(patch_log_file_path).read()
            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception as e:
            response["error"] = "系统异常![%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")




@csrf_exempt
@login_required
def uploadFile(request):
    if request.method == 'GET':
        return render_to_response("portal/portal_uploadfile_gen_sql.html", locals(), context_instance=RequestContext(request))

    if request.method == 'POST':
        response = {"success": True, "error": "上传成功!"}
        try:
            file_obj_old = request.FILES.get('uploadFile_old', None)
            if file_obj_old:
                dst_file_path = os.path.join(TEMP_ROOT, "old.sql")
                dst_file = open(dst_file_path, 'wb')
                content = file_obj_old.read()
                dst_file.write(content)
                dst_file.close()

            file_obj_new = request.FILES.get('uploadFile_new', None)
            if file_obj_new:
                dst_file_path = os.path.join(TEMP_ROOT, "new.sql")
                dst_file = open(dst_file_path, 'wb')
                content = file_obj_new.read()
                dst_file.write(content)
                dst_file.close()

            return render_to_response("portal/portal_uploadfile_gen_sql.html", locals(), context_instance=RequestContext(request))

        except Exception, e:
            response["success"] = False
            response["error"] = unicode(e)
            return HttpResponse(json.dumps(response), mimetype="application/json")


@csrf_exempt
@login_required
def update_sql(request):
    global sqlgenINFO
    sqlgenINFO = ""
    if request.method == 'POST':
        response = {'success': False, 'error': ''}
        try:
            sqlgenINFO = "获取升级参数"
            start_time = datetime.datetime.now()

            old_id = request.POST.get('old_id', None)
            pp_old = PortalPackage.objects(pk=old_id)
            pp_old = pp_old[0]
            content_old = pp_old.sql.read()

            new_id = request.POST.get('new_id', None)
            pp_new = PortalPackage.objects(pk=new_id)
            pp_new = pp_new[0]
            content_new = pp_new.sql.read()


            # 准备新旧建库脚本
            sqlgenINFO = "准备新旧建库脚本"
            old_file_path = os.path.join(TEMP_ROOT, "old.sql")
            new_file_path = os.path.join(TEMP_ROOT, "new.sql")

            old_file = open(old_file_path, 'w')
            old_file.write(content_old)
            old_file.close()

            new_file = open(new_file_path, 'w')
            new_file.write(content_new)
            new_file.close()

            # 参数准备完毕,开始升级脚本
            sqlgenINFO = "参数准备完毕,开始升级脚本"
            file_name = start_time.strftime('%Y_%m_%d_%H_%M_%S_%f') + '_sql'

            # 执行登陆操作
            sqlgenINFO = "执行登陆参数"
            ssh = paramiko.SSHClient()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            ssh.connect(PORTAL_GET_SQL_IP, PORTAL_GET_SQL_PORT, PORTAL_GET_SQL_USERNAME, PORTAL_GET_SQL_PASSWORD, timeout=5)

            # 准备路径
            sqlgenINFO = "准备路径"
            stdin, stdout, stderr = ssh.exec_command('mkdir /deploy_portal_gen_sql/')
            stdout.read()

            stdin, stdout, stderr = ssh.exec_command('mkdir /deploy_portal_gen_sql/%s/' % file_name)
            stdout.read()

            sftp = ssh.open_sftp()
            sftp.put(old_file_path, '/deploy_portal_gen_sql/%s/old.sql' % file_name)
            sftp.put(new_file_path, '/deploy_portal_gen_sql/%s/new.sql' % file_name)

            # 登陆mysql,准备数据库
            sqlgenINFO = "登陆mysql,准备数据库"
            db = MySQLdb.connect(host=PORTAL_GET_SQL_IP, user=PORTAL_GET_SQL_SQL_NAME, passwd=PORTAL_GET_SQL_SQL_PWD)
            cursor = db.cursor()
            sql = [
                'drop database if exists ttmgrportal_old',
                'drop database if exists ttmgrportal_new',
                'create database ttmgrportal_old',
                'create database ttmgrportal_new'
            ]
            for item_sql in sql:
                cursor.execute(item_sql)
            db.close()

            # 导入数据库
            sqlgenINFO = "导入数据库"

            stdin, stdout, stderr = ssh.exec_command('mysql -uroot -pmysql.rzrk ttmgrportal_old < /deploy_portal_gen_sql/%s/old.sql' % file_name)
            stdout.read()
            stdin, stdout, stderr = ssh.exec_command('mysql -uroot -pmysql.rzrk ttmgrportal_new < /deploy_portal_gen_sql/%s/new.sql' % file_name)
            stdout.read()

            # 执行比较语句
            sqlgenINFO = "执行比较语句"
            cmd = 'schemasync -r --output-dir="/deploy_portal_gen_sql/%s/" mysql://%s:%s@%s:3306/ttmgrportal_new  mysql://%s:%s@%s:3306/ttmgrportal_old' %\
                                                     (file_name, PORTAL_GET_SQL_SQL_NAME, PORTAL_GET_SQL_SQL_PWD, '127.0.0.1', PORTAL_GET_SQL_SQL_NAME, PORTAL_GET_SQL_SQL_PWD, '127.0.0.1')
            print "CMD:  \n%s" % cmd
            stdin, stdout, stderr = ssh.exec_command(cmd)
            stdout.read()


            # 将文件获取到本地
            sqlgenINFO = "将文件获取到本地"
            patch_flag = False

            patch_file_path = '/deploy_portal_gen_sql/%s/ttmgrportal_old.%s.patch.sql' % (file_name, start_time.strftime('%Y%m%d'))
            local_patch_file_path = os.path.join(TEMP_ROOT, "portal_%s_to_%s.sql" % (pp_old.svn_version, pp_new.svn_version))

            patch_log_path = '/deploy_portal_gen_sql/%s/schemasync.log' % file_name
            patch_log_file_path = os.path.join(TEMP_ROOT, "schemasync.log")

            try:
                # 文件拷贝到本地
                sftp.get(patch_file_path, local_patch_file_path)
                patch_flag = True
            except Exception as e:
                logger.error('执行比较脚本异常! --> ' + getTraceBack())

            # 删除生成的路径
            #stdin, stdout, stderr = ssh.exec_command('rm -r /deploy_portal_gen_sql/*')

            ssh.close()

            # 结束时间毫秒数
            end_milliseconds = time.time()

            # 解析建库脚本,及生成的比较语句,生成最终的建库脚本
            # 结束时间
            end_time = datetime.datetime.fromtimestamp(end_milliseconds)
            # 以结束时间作为版本号
            upgrade_version = VERSION_PREFIX_PORTAL_UPGRADE_SCRIPT + str(int(end_milliseconds * 1000))

            # 提取出需要的数据
            add_sql = get_add_sql(new_file_path)

            local_patch_file_final_path = os.path.join(UPDATE_SQL_DIR, "%s_to_%s.sql" % (pp_old.svn_version, pp_new.svn_version))
            local_patch_file_final = open(local_patch_file_final_path, 'w')

            local_patch_file_final.write('\r\n')
            local_patch_file_final.write('\r\n')
            local_patch_file_final.write('-- --------------------------------------------------------' + '\r\n')
            local_patch_file_final.write('-- Portal upgrade script' + '\r\n')
            local_patch_file_final.write('-- script version: %s' % upgrade_version + '\r\n')
            local_patch_file_final.write('-- from   version: %s' % pp_old.svn_version + '\r\n')
            local_patch_file_final.write('-- to     version: %s' % pp_new.svn_version + '\r\n')
            local_patch_file_final.write('-- create by     : %s' % User.objects.get(pk=request.user.id).username + '\r\n')
            local_patch_file_final.write('-- start  time   : %s' % start_time.strftime('%Y-%m-%d %H:%M:%S.%f') + '\r\n')
            local_patch_file_final.write('-- end    time   : %s' % end_time.strftime('%Y-%m-%d %H:%M:%S.%f') + '\r\n')
            local_patch_file_final.write('-- power  by     : tt_engine' + '\r\n')
            local_patch_file_final.write('-- --------------------------------------------------------' + '\r\n')
            local_patch_file_final.write('\r\n')
            local_patch_file_final.write('\r\n')
            local_patch_file_final.write('SET FOREIGN_KEY_CHECKS=0;' + '\r\n')

            # 生成patch成功
            if patch_flag:
                with open(local_patch_file_path) as local_patch_file:
                    for line in local_patch_file:
                        if line.startswith('--') or not line.strip():
                            continue
                        if line.lower().strip().startswith('use'):
                            continue
                        local_patch_file_final.write(line + '\r\n')

            # 添加额外的SQL语句
            sqlgenINFO = "添加而外的sql语句"
            for key in add_sql:
                value = add_sql[key]
                local_patch_file_final.write('-- --------------------------------------------------------' + '\r\n')
                local_patch_file_final.write('-- init table %s' % key + '\r\n')
                local_patch_file_final.write('-- --------------------------------------------------------' + '\r\n')
                for item_sql in value:
                    local_patch_file_final.write(item_sql)

            local_patch_file_final.write('SET FOREIGN_KEY_CHECKS=1;' + '\r\n')
            local_patch_file_final.flush()
            local_patch_file_final.close()


            # 保存生成的脚本操作
            sqlgenINFO = "保存sql脚本到mongodb"
            pus = PortalPackage.objects(version=pp_new.svn_version)
            pus = pus[0]
            if len(pus) != 0:
                pus.delete()

            pus = PortalUpdateSql()
            pus.version = pp_new.svn_version
            pus.sql.put(open(local_patch_file_final_path), content_type='text/plain')
            pus.create_user = User.objects.get(pk=request.user.id)
            pus.start_time = start_time
            pus.end_time = end_time
            pus.save()

            response["success"] = True
            response["id"] = str(pus.id)
            response["error"] = '执行成功!' if patch_flag else open(patch_log_file_path).read()
            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception as e:
            response["error"] = "系统异常![%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")
    else:
        return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))

#sql生成进度查询
def sqlgenProcessInfo(request):
    global sqlgenINFO
    if request.method == "GET":
        response = {"success": True, "sqlgenINFO": sqlgenINFO}
        return HttpResponse(json.dumps(response), mimetype="application/json")


@csrf_exempt
@login_required
def quick_gen_sql(request):
    """
    快速生成升级脚本
    :param request:
    :return:
    """
    if request.method == 'GET':
         # 查询所有Portal版本
        pps = PortalPackage.objects(is_enabled=True).order_by('-svn_version')
        return render_to_response("portal/portal_quick_gen_sql.html", locals(), context_instance=RequestContext(request))

    elif request.method == 'POST':
        response = {'success': False, 'error': ''}
        try:
            new_version = request.POST.get('new_version', None)
            old_version = request.POST.get('old_version', None)
            pus = PortalUpdateSql.objects().order_by('svn_version')
            pus_new = PortalUpdateSql.objects(version=new_version)
            pus_old = PortalUpdateSql.objects(version=old_version)

            pps = PortalPackage.objects(is_enabled=True).order_by('svn_version')
            sql_file_path = os.path.join(TEMP_ROOT, "portal_%s_to_%s.sql" % (old_version, new_version))
            svn_list = []
            for pp in pps:
                svn_list.append(pp.svn_version)

            for version in svn_list:
                if (version > old_version) and (version <= new_version):
                    pus_final = PortalUpdateSql.objects(version=version)
                    if len(pus_final) > 0:
                        pus_final = pus_final[0]
                        pp_sql_read = pus_final.sql.read()
                        with open(sql_file_path, 'ab+') as sql_file:
                            sql_file.write(pp_sql_read)


            upgrade_version = old_version + "to" + new_version

            pqs = PortalQuickupdateSql.objects(upgrade_version=upgrade_version)
            if len(pqs) != 0:
                pqs.delete()

            pqs = PortalQuickupdateSql()
            pqs.upgrade_version = upgrade_version
            pqs.sql.put(open(sql_file_path), content_type='text/plain')
            pqs.create_user = User.objects.get(pk=request.user.id)
            pqs.save()

            response["success"] = True
            response["id"] = str(pqs.id)
            response["error"] = '执行成功!'
            return HttpResponse(json.dumps(response), mimetype="application/json")

        except Exception as e:
            response["error"] = "系统异常![%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")


@csrf_exempt
@login_required
def download_quickgen_sql(request):
    """
    下载Portal包升级脚本
    :param request:
    :return:
    """
    try:
        # 获取参数
        id = request.GET.get('id', None)

        if id is None or id == '':
            error = "必要参数为空!"
            logger.error(error)
            return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))

        # 验证对象是否存在
        pqs = PortalQuickupdateSql.objects(pk=id)

        if len(pqs) == 0:
            error = "未找到对应升级脚本!"
            logger.error(error)
            return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))

        pqs = pqs[0]

        content = pqs.sql.read()
        size = len(content)
        response = HttpResponse(content)
        response['Content-Length'] = size
        response['Content-Disposition'] = 'attachment; filename=portal_%s.sql' % (pqs.upgrade_version)
        return response
    except Exception as e:
        error = "下载文件异常![%s]" % str(e)
        logger.error(error + getTraceBack())
        return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))




@csrf_exempt
@login_required
def download_update_sql(request):
    """
    下载邻近版本升级脚本
    :param request:
    :return:
    """
    try:
        # 获取参数
        version = request.GET.get('version', None)
        old_version = request.GET.get('old_version', None)

        if version is None or version == ''or old_version is None or old_version == '':
            error = "必要参数为空!"
            logger.error(error)
            return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))

        # 验证对象是否存在
        pus = PortalUpdateSql.objects(version=version)

        if len(pus) == 0:
            error = "未找到对应升级脚本!"
            logger.error(error)
            return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))

        pus = pus[0]

        content = pus.sql.read()
        size = len(content)
        response = HttpResponse(content, mimetype='text/plain')
        response['Content-Length'] = size
        response['Content-Disposition'] = 'attachment; filename=%sto%s.sql' % (old_version, version)
        return response
    except Exception as e:
        error = "下载文件异常![%s]" % str(e)
        logger.error(error + getTraceBack())
        return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))





def get_add_sql(new_file_path):
    """
    获取需要额外添加的SQL语句
    :param new_file_path:
    :return:
    """
    add_sql = {}
    for item in PORTAL_GEN_SQL_ADD_TABLE:
        add_sql[item] = []
    # add_sql = {item: [] for item in PORTAL_GEN_SQL_ADD_TABLE}

    match_str = None
    is_not_end = False
    with open(new_file_path) as new_file:
        for line in new_file:
            # 过滤掉注释行
            if line.startswith('--'):
                continue
            if is_not_end:
                add_sql[match_str].append(line)
                if line.strip().endswith(';'):
                    is_not_end = False
                continue

            # 是否匹配
            flag, str = match_sql_key(line)

            if not flag:
                continue
            # 排除一些索引的情况
            if not line.lower().strip().startswith('create table') and not line.lower().strip().startswith('insert into') and not line.lower().strip().startswith('drop table'):
                continue
            # 添加到SQL集
            add_sql[str].append(line)
            if not line.strip().endswith(';'):
                is_not_end = True
                match_str = str
    return add_sql


def match_sql_key(line):
    for item in PORTAL_GEN_SQL_ADD_TABLE:
        m = re.match(r'^.*`%s`.*$' % item, line)
        if m:
            return True, item
    return False, None


@csrf_exempt
@login_required
def download_upgrade_sql(request):
    """
    下载Portal包升级脚本
    :param request:
    :return:
    """
    try:
        # 获取参数
        id = request.GET.get('id', None)

        if id is None or id == '':
            error = "必要参数为空!"
            logger.error(error)
            return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))

        # 验证对象是否存在
        pus = PortalUpgradeSql.objects(pk=id)

        if len(pus) == 0:
            error = "未找到对应升级脚本!"
            logger.error(error)
            return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))

        pus = pus[0]

        content = pus.sql.read()
        size = len(content)
        response = HttpResponse(content)
        response['Content-Length'] = size
        response['Content-Disposition'] = 'attachment; filename=portal_unknown_to_unknown_final.sql'
        return response
    except Exception as e:
        error = "下载文件异常![%s]" % str(e)
        logger.error(error + getTraceBack())
        return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))