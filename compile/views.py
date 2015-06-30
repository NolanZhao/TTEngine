# encoding=utf-8
import sys

reload(sys)
sys.setdefaultencoding('utf-8')
__author__ = 'nerve'

from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.decorators import login_required
from django.shortcuts import render_to_response, render, get_object_or_404
from django.http import HttpResponse
from django.template import RequestContext
import json, datetime, time, logging, os, re, traceback, types
from compile.modules import CompilingUpdateRecord
from module.models import Module, FileInfoDetail
from customer.models import *
from utils.decorator import core_logger
from logger.models import CoreLogger
from TTEngine.constants import VERSION_PREFIX_CUSTOMER, DEFAULT_DATETIME, SOURCE_TEST, CONTENT_TYPE, is_windows, SYS_BIT
from package.models import Package
from usrmgr.models import User
from TTEngine.settings import ENCODE
from StringIO import StringIO
from utils.decorator import convert_machine_to_json, convert_compiling_record_to_json
from utils.TracebackHelper import getTraceBack
from programBranch.models import BranchInfo, PROGRAM_LIST, getLocalDir
from utils.StringHelper import replaceStr
from utils.SvnInfo import getSvnInfo
from TTEngine.constants import *

# 暂时排除Windows 64位情况
if not (is_windows() and SYS_BIT == 64):
    from compile.Compile import doCompile

logger = logging.getLogger('django')

# 创建客户
@csrf_exempt
@login_required
def compile(request):
    if request.method == "GET":
        pass
        return render_to_response("customer/customer_create.html", locals(), context_instance=RequestContext(request))
    elif request.method == 'POST':
        pass


def get_param_name(module):
    """
    以模块为单位获取原始路径参数名
    :param module:
    :return:
    """
    param_name = []
    files = module.files

    def get_param_replace(raw_path):
        """
        原始路径(替换用)
        :param raw_path:
        :return:
        """
        return re.findall(r'{{[a-zA-Z0-9_ ]+}}', raw_path)

    for file in files:
        raw_path = file.rawPath
        param_replace = get_param_replace(raw_path)
        for item in param_replace:
            name = re.findall(r'[a-zA-Z0-9_]+', item)[0]
            param_name.append(str(name))
    param_name = list(set(param_name))
    param_name.sort()
    return param_name


@csrf_exempt
@login_required
def compiling_list(request):
    """
    查看编译机状态
    :param request:
    :return:
    """
    if request.method == "GET":
        # 查询编译机
        machine_json = []
        machines = Machine.objects(type=1)
        for machine in machines:
            machine_json_item = {'machine': None, 'record': None}
            # 机器
            machine_json_item['machine'] = convert_machine_to_json(machine)

            # 查询编译机最后一条日志
            compiling_record = CompilingUpdateRecord.objects(machine=machine).order_by('-start_time')
            if len(compiling_record) > 0:
                compiling_record = compiling_record[0]
                machine_json_item['record'] = convert_compiling_record_to_json(compiling_record)
            else:
                compiling_record = None
                machine_json_item['record'] = None
            machine_json.append(machine_json_item)

        machine_json = json.dumps(machine_json)
        return render_to_response("customer/customer_view.html", locals(), context_instance=RequestContext(request))
    else:
        error = '请使用http-get方式请求'
        logger.error(error)
        return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))


@csrf_exempt
@login_required
def compiling_record_list(request):
    """
    查看编译机日志
    :param request:
    :return:
    """
    if request.method == "GET":
        records = CompilingUpdateRecord.objects().order_by("-start_time")
        return render_to_response("customer/customer_compile_record_list.html", locals(), context_instance=RequestContext(request))
    else:
        error = '请使用http-get方式请求'
        logger.error(error)
        return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))


@csrf_exempt
@login_required
def compiling_record_del(request):
    response = {"success": False, "error": ""}
    try:
        # 校验参数
        id = request.POST.get("id", None)

        if id is None or str(id).strip() == "":
            response["error"] = "必要参数为空!"
            return HttpResponse(json.dumps(response), mimetype="application/json")

        # 执行删除操作
        record = CompilingUpdateRecord.objects(pk=id)
        if len(record) == 0:
            response["error"] = "未找到该记录!"
            return HttpResponse(json.dumps(response), mimetype="application/json")

        record = record[0]
        record.delete()
        response["success"] = True
        response["error"] = "执行成功!"
        return HttpResponse(json.dumps(response), mimetype="application/json")
    except Exception, e:
        response["error"] = "系统异常![%s]" % str(e)
        logger.error(response["error"] + getTraceBack())
        return HttpResponse(json.dumps(response), mimetype="application/json")
