# encoding=utf-8
__author__ = 'nerve'

import json
import datetime
import time
import logging

from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.decorators import login_required
from django.shortcuts import render_to_response
from django.http import HttpResponse
from django.template import RequestContext

from module.models import RunInfo, FileInfo, Module, Group
from utils.decorator import core_logger
from logger.models import CoreLogger
from TTEngine.constants import VERSION_PREFIX_MODULE
from utils.TracebackHelper import getTraceBack
from bson.dbref import DBRef
from customer.models import Customer


logger = logging.getLogger('django')

# 创建模块
@csrf_exempt
@login_required
def create(request):
    if request.method == "GET":
        p_id = request.GET.get('p_id', None)
        is_extends = False
        module = None

        if p_id:
            is_extends = True
            module = Module.objects.get(pk=p_id)
        groups = Group.objects()
        return render_to_response("module/module_create.html", locals(), context_instance=RequestContext(request))

    elif request.method == 'POST':
        response = {"success": False, "error": "", "id": None}
        try:
            # 获取参数
            request_json = json.loads(request.POST.get("json"))
            now = datetime.datetime.now()
            # 校验参数
            module_id = request_json["moduleId"]
            module_name = request_json["moduleName"]
            module_remark = request_json["module_remark"]
            module_group = request_json["module_group"]
            module = None
            if module_id is not None:
                module = Module.objects.get(pk=module_id)
                module_by_name = Module.objects(name=module_name)
                if len(module_by_name) > 0:
                    if len(module_by_name) > 1:
                        response["error"] = "模块名称重复!"
                        logger.error(response["error"])
                        return HttpResponse(json.dumps(response), mimetype="application/json")

                    module_by_name = module_by_name[0]
                    if module_by_name.id != module.id:
                        response["error"] = "模块名称重复!"
                        logger.error(response["error"])
                        return HttpResponse(json.dumps(response), mimetype="application/json")
            else:
                module_by_name = Module.objects(name=module_name)
                if len(module_by_name) > 0:
                    response["error"] = "模块名称重复!"
                    logger.error(response["error"])
                    return HttpResponse(json.dumps(response), mimetype="application/json")
                module = Module()

            # 保存
            # 先保存文件信息
            runInfoList = request_json["runInfoList"]
            run_info_list = []
            for item in runInfoList:
                run_info = None
                run_info_id = item["runInfoId"]
                if run_info_id is not None:
                    run_info = RunInfo.objects(pk=run_info_id)[0]
                else:
                    run_info = RunInfo()
                run_info.run_info_name = item["run_info_name"]
                run_info.workingDir = item["workingDir"]
                run_info.runParam = item["runParam"]
                run_info.runType = item["runType"]
                run_info.timerParam = item["timerParam"]
                run_info.save()
                run_info_list.append(run_info)

            # 保存文件信息
            fileInfoList = request_json["fileInfoList"]
            file_info_list = []
            for item in fileInfoList:
                file_info_id = item["fileInfoId"]
                if file_info_id is not None:
                    file_info = FileInfo.objects(pk=file_info_id)[0]
                else:
                    file_info = FileInfo()
                file_info.filePath = item["filePath"]
                file_info.mod = item["mod"]
                file_info.descript = item["descript"]
                file_info.fileType = item["file_type"]
                file_info.rawPath = item["rawPath"]
                file_info.remark = item["remark"]
                if file_info_id is None:
                    file_info.createTime = now
                file_info.updateTime = now
                file_info.save()
                file_info_list.append(file_info)

            # 保存模块信息
            module.name = module_name
            module.head = request_json["moduleHead"]
            module.remark = module_remark
            module.version = VERSION_PREFIX_MODULE + str(int(time.time() * 1000))
            module.group = module_group
            # 删除已删除的file和run信息
            for item in set(module.files) - set(file_info_list):
                if type(item) is not DBRef:
                    item.delete()
            for item in set(module.runInfos) - set(run_info_list):
                if type(item) is not DBRef:
                    item.delete()

            module.files = file_info_list
            module.runInfos = run_info_list
            if module_id is None:
                module.createTime = now
            module.save()

            response["success"] = True
            response["id"] = str(module.id)
            response["error"] = "执行成功!"
            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception, e:
            response["error"] = "系统异常![%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")


# 列出模块和模块组
@csrf_exempt
@login_required
def list(request):
    groups = Group.objects().order_by("name")
    modules = Module.objects().order_by("name")
    return render_to_response("module/module_list.html", locals(), context_instance=RequestContext(request))

def groupList(request):
    groups = Group.objects().order_by("name")
    modules = Module.objects().order_by("name")
    return render_to_response("module/module_group.html", locals(), context_instance=RequestContext(request))


@csrf_exempt
@login_required
def edit(request):
    if request.method == 'GET':
        try:
            is_edit = True
            module_id = request.GET.get("module_id", None)

            if module_id is None or module_id == '':
                error = "模块ID为空!"
                logger.error(error)
                return render_to_response("item/temp.html", locals(), context_instance=RequestContext(request))
            module = Module.objects(pk=module_id)

            if len(module) == 0:
                error = "模块[ID=%s]并不存在!" % module_id
                logger.error(error)
                return render_to_response("item/temp.html", locals(), context_instance=RequestContext(request))

            groups = Group.objects().order_by("name")
            module = module[0]
            return render_to_response("module/module_create.html", locals(), context_instance=RequestContext(request))
        except Exception as e:
            error = '编辑模块信息异常[%s]' % str(e)
            logger.error(error + getTraceBack())
            return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))
    elif request.method == 'POST':
        error = "非法请求方式!"
        logger.error(error)
        return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))


@csrf_exempt
@login_required
def view(request):
    if request.method == 'GET':
        try:
            is_view = True
            module_id = request.GET.get("module_id", None)

            if module_id is None or module_id == '':
                error = "模块ID为空!"
                logger.error(error)
                return render_to_response("item/temp.html", locals(), context_instance=RequestContext(request))
            module = Module.objects(pk=module_id)

            if len(module) == 0:
                error = "模块[ID=%s]并不存在!" % module_id
                logger.error(error)
                return render_to_response("item/temp.html", locals(), context_instance=RequestContext(request))

            groups = Group.objects()
            module = module[0]
            return render_to_response("module/module_create.html", locals(), context_instance=RequestContext(request))
        except Exception as e:
            error = '查看模块信息异常[%s]' % str(e)
            logger.error(error + getTraceBack())
            return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))
    elif request.method == 'POST':
        error = "非法请求方式!"
        logger.error(error)
        return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))


@csrf_exempt
@login_required
def del_module(request):
    response = {"success": False, "error": ""}
    try:
        # 校验参数
        module_id = request.POST.get("moduleId", None)

        if module_id is None or str(module_id).strip() == "":
            response["error"] = "必要参数为空!"
            return HttpResponse(json.dumps(response), mimetype="application/json")

        path = request.path
        is_sys = None
        if path == '/customer/system/list/':
            is_sys = True
        elif path == '/customer/list/':
            is_sys = False
        else:
            is_sys = False
        customers = Customer.objects(is_sys=is_sys).order_by('+tag')
        error = request.GET.get("error", None)

        # 执行删除操作
        module = Module.objects(pk=module_id)
        if len(module) == 0:
            response["error"] = "未找到该模块!"
            return HttpResponse(json.dumps(response), mimetype="application/json")

        module = module[0]
        for item in module.files:
            if not isinstance(item, DBRef):
                item.delete()
        for item in module.runInfos:
            if not isinstance(item, DBRef):
                item.delete()
        for customer in customers:
            cus_modules = customer.modules
            for cus_module in cus_modules:
                 if  module.name == cus_module.name:
                     response["error"] = "此模块被客户[%s]使用,不能删除!" % str(customer.name)
                     return HttpResponse(json.dumps(response), mimetype="application/json")


        module.delete()
        response["success"] = True
        response["error"] = "执行成功!"
        return HttpResponse(json.dumps(response), mimetype="application/json")
    except Exception, e:
        response["error"] = "系统异常![%s]" % str(e)
        logger.error(response["error"] + getTraceBack())
        return HttpResponse(json.dumps(response), mimetype="application/json")

@csrf_exempt
@login_required
def del_group(request):
    response = {"success": False, "error": ""}
    try:
        # 校验参数
        group_name = request.POST.get("groupName", None)

        if group_name is None or str(group_name).strip() == "":
            response["error"] = "必要参数为空!"
            return HttpResponse(json.dumps(response), mimetype="application/json")

        # 执行删除操作
        group = Group.objects(name=group_name)
        if len(group) == 0:
            response["error"] = "未找到该模块!"
            return HttpResponse(json.dumps(response), mimetype="application/json")
        else:
            group.delete()

        response["success"] = True
        response["error"] = "执行成功!"
        return HttpResponse(json.dumps(response), mimetype="application/json")
    except Exception, e:
        response["error"] = "系统异常![%s]" % str(e)
        logger.error(response["error"] + getTraceBack())
        return HttpResponse(json.dumps(response), mimetype="application/json")

@csrf_exempt
@login_required
def log(request):
    """
    客户更新记录
    :param request:
    :return:
    """
    logs = CoreLogger.objects(collection='module').order_by('-create_time')
    return render_to_response("customer/customer_list_log.html", locals(), context_instance=RequestContext(request))

# 创建模块组
@csrf_exempt
@login_required
def createGroup(request):
    if request.method == "GET":
        return render_to_response("module/group_create.html", locals(), context_instance=RequestContext(request))
    elif request.method == 'POST':
        response = {"success": False, "error": "", "id": None}
        try:
            # 获取参数
            request_json = json.loads(request.POST.get("json"))
            now = datetime.datetime.now()
            # 校验参数
            group_name = request_json["groupName"]
            group = None

            if group_name is not None:
                group = Group.objects(name=group_name)
                if len(group) == 0:
                    group = Group()
                    group.name = group_name
                    group.createTime = now
                    group.save()

                else:
                    response["error"] = "组名称重复!"
                    logger.error(response["error"])
                    return HttpResponse(json.dumps(response), mimetype="application/json")

            response["success"] = True
            response["id"] = str(group.id)
            response["error"] = "执行成功!"
            return HttpResponse(json.dumps(response), mimetype="application/json")

        except Exception, e:
            response["error"] = "系统异常![%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")
