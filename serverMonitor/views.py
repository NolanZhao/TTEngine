#encoding=utf-8
import sys

reload(sys)
sys.setdefaultencoding('utf-8')


from django.shortcuts import render_to_response, render, get_object_or_404, redirect
from django.template import RequestContext
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.decorators import login_required
from django.http import HttpResponse
from utils.TracebackHelper import getTraceBack
import json
from serverMonitor.models import *
import logging
from usrmgr.models import User
import datetime
from TTEngine.constants import ATTACHMENTS_DIR
from customer.models import Customer, Machine
from django.utils.safestring import SafeString

logger = logging.getLogger('django')


@csrf_exempt
@login_required
def serverMonitor_type_list(request):
    if request.method == "GET":
        settings = ServerMonitorLogType.objects().order_by("-create_time")
        return render_to_response('serverMonitor/montior_type_list.html', locals(), context_instance=RequestContext(request))
    elif request.method == "POST":
        error = "非法的连接方式!"
        logger.error(error)
        return render_to_response("item/temp.html", locals(), context_instance=RequestContext(request))

@csrf_exempt
@login_required
def serverMonitor_type_add(request):
    if request.method == "GET":
        action_type = request.GET.get("flag", None)
        create_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        create_user = User.objects.get(pk=request.user.id)
        settings = ServerMonitorLogType.objects.order_by("-create_time")
        serverMonitorModule = ServerMonitorModule.objects().order_by("-create_time")
        return render_to_response('serverMonitor/montior_type_create.html', locals(), context_instance=RequestContext(request))
    elif request.method == "POST":
        error = "非法的连接方式!"
        logger.error(error)
        return render_to_response("item/temp.html", locals(), context_instance=RequestContext(request))

@csrf_exempt
@login_required
def serverMonitor_type_edit(request):
    if request.method == "GET":
        id = request.GET.get("id", None)
        action_type = request.GET.get("flag", None)
        if id is None:
            return render_to_response("item/temp.html", locals(), context_instance=RequestContext(request))
        setting = ServerMonitorLogType.objects.get(pk=id)
        moduleBelongs = setting.moduleBelongs
        detail = setting.detail
        log_type = setting.log_type
        create_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        create_user = User.objects.get(pk=request.user.id)
        return render_to_response('serverMonitor/montior_type_create.html', locals(), context_instance=RequestContext(request))
    elif request.method == "POST":
        error = "非法的连接方式!"
        logger.error(error)
        return render_to_response("item/temp.html", locals(), context_instance=RequestContext(request))

@csrf_exempt
@login_required
def serverMonitor_type_save(request):
    response = {"success": False, "error": ""}
    if request.method == "POST":
        try:
            monitor_setting = json.loads(request.POST.get('json'))
            setting_id = monitor_setting["setting_id"]
            setting_name = monitor_setting["setting_name"]
            setting_detail = monitor_setting["setting_detail"]
            name_type = monitor_setting["name_type"]
            if setting_name is None or setting_name == "" or setting_detail is None or setting_detail == "":
                response["success"] = False
                response["error"] = "执行失败,必要参数为空!"
                return HttpResponse(json.dumps(response), mimetype="application/json")
            if name_type == "add":
                setting = ServerMonitorLogType()
                setting.log_type = setting_name
                setting.detail = setting_detail
                setting.create_user = User.objects.get(pk=request.user.id)
                setting.create_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                setting.save()
            elif name_type == "edit":
                setting = ServerMonitorLogType.objects.get(pk=setting_id)
                setting.log_type = setting_name
                setting.detail = setting_detail
                setting.create_user = User.objects.get(pk=request.user.id)
                setting.create_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                setting.save()
            response["success"] = True
            response["error"] = "执行成功!"
            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception, e:
            response["error"] = "[%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")

@csrf_exempt
@login_required
def serverMonitor_type_del(request):
    response = {"success": False, "error": ""}
    if request.method == "POST":
        try:
            setting_id = request.POST.get("settingId", None)
            setting = ServerMonitorLogType.objects(pk=setting_id)
            setting = setting[0]
            setting.delete()

            response["success"] = True
            response["error"] = "删除成功!"
            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception, e:
            response["error"] = "[%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")




@csrf_exempt
@login_required
def logPost(request):
    """
    提交日志信息
    :param request:
    :return:
    """
    if request.method == "GET":
        customer = Customer.objects()
        serverMonitorLogType = ServerMonitorLogType.objects()
        serverMonitorModule = ServerMonitorModule.objects()
        return render_to_response("serverMonitor/logPost.html", locals(), context_instance=RequestContext(request))
    elif request.method == "POST":
        response = {"success": True, "error": "上传成功!"}
        try:
            #获取参数
            cus_name = request.POST.get('cus_name', None)
            customer = Customer.objects.get(pk=cus_name)
            log_type = request.POST.get('log_type', None)
            log_type = ServerMonitorLogType.objects.get(pk=log_type)
            monitor_type = request.POST.get('monitor_type', None)
            module_type = request.POST.get('module_type', None)
            module = ServerMonitorModule.objects.get(module=module_type)
            detail = request.POST.get('detail', None)
            url = request.POST.get('url', None)
            create_time = datetime.datetime.now()
            create_user = User.objects.get(pk=request.user.id)

            # 保存监控日志信息
            logInfo = ServerMonitorLog()
            logInfo.cus = customer
            logInfo.log_type = log_type
            logInfo.monitor_type = int(monitor_type)
            logInfo.module_type = module
            logInfo.detail = detail
            logInfo.create_time = create_time
            logInfo.cus_uuid = customer.machines[0].code
            logInfo.create_user = create_user

            logInfo.attachment_url = url
            logInfo.save()
            return HttpResponse(json.dumps(response), mimetype="application/json")

        except Exception as e:
            response["success"] = False
            response["error"] = "系统异常![%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")


@csrf_exempt
@login_required
def uploadFile(request):
    if request.method == 'GET':
        return render_to_response("serverMonitor/logPost.html", locals(), context_instance=RequestContext(request))

    if request.method == 'POST':
        response = {"success": True, "error": "", "fileurl": ""}
        try:
            file_obj = request.FILES.get('uploadFile', None)
            fileName = str(file_obj)
            dst_file_path = ATTACHMENTS_DIR + fileName
            dst_file = open(dst_file_path, 'wb')
            content = file_obj.read()
            dst_file.write(content)
            dst_file.close()
            response["fileurl"] = dst_file_path

            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception, e:
            response["success"] = False
            response["error"] = unicode(e)
            return HttpResponse(json.dumps(response), mimetype="application/json")


@csrf_exempt
@login_required
def logList(request):
    if request.method == 'GET':
        logInfo = ServerMonitorLog.objects.all()
        return render_to_response("serverMonitor/logList.html", locals(), context_instance=RequestContext(request))




@csrf_exempt
@login_required
def getLogList(request):
    if request.method == 'GET':
        try:
            customerlist = Customer.objects.all()
            jsonResult = []
            for temp in customerlist:
                customerid = temp.pk
                if len(ServerMonitorLog.objects(cus=customerid)) > 0:
                    logInfo = ServerMonitorLog.objects(cus=customerid).order_by("-create_time")[0]
                    module_type = logInfo.module_type
                    log_type = logInfo.log_type
                    monitor_type = logInfo.monitor_type
                    detail = logInfo.detail
                    create_time = logInfo.create_time
                    cus_uuid = logInfo.cus_uuid
                    for item in customerlist:
                        for machine in item.machines:
                            if machine.code == cus_uuid:
                                cus = item
                    create_user = logInfo.create_user
                    jsonResult.append({
                        "cus_id": str(customerid),
                        "module_type": module_type.module,
                        "log_type": log_type.log_type,
                        "monitor_type": monitor_type,
                        "detail": detail,
                        "create_time": create_time.strftime("%Y-%m-%d %H:%I:%S"),
                        # "create_user": create_user.username,
                        "customer": cus.name,
                        # "attachment_url": logInfo.attachment_url
                    })
        except Exception, e:
            return HttpResponse(json.dumps({"success": False, "error": e.message}), mimetype="application/json")

        return HttpResponse(SafeString(json.dumps(jsonResult)), mimetype="application/json")


# 获取每家客户所有的日志
@csrf_exempt
@login_required
def getLogListDetail(request):
    if request.method == 'GET':
        try:
            jsonResult = []
            customerid = request.GET.get("customerid")
            logList = ServerMonitorLog.objects.filter(cus=customerid).order_by("-create_time")
            for logInfo in logList:
                module_type = logInfo.module_type
                log_type = logInfo.log_type
                monitor_type = logInfo.monitor_type
                detail = logInfo.detail
                cus = logInfo.cus
                create_time = logInfo.create_time
                create_user = logInfo.create_user
                jsonResult.append({
                    "cus_id": str(cus.id),
                    "module_type": module_type.module,
                    "log_type": log_type.log_type,
                    "monitor_type": monitor_type,
                    "detail": detail,
                    "create_time": create_time.strftime("%Y-%m-%d %H:%I:%S"),
                    "create_user": create_user.username,
                    "customer": cus.name,
                    "attachment_url": logInfo.attachment_url
                })
        except Exception, e:
            return HttpResponse(json.dumps({"success": False, "error": e.message}), mimetype="application/json")

        return HttpResponse(SafeString(json.dumps(jsonResult)), mimetype="application/json")



@csrf_exempt
@login_required
def getLogListDetailPage(request):
    if request.method == 'GET':
        cusId = request.GET.get("cusId")
        return render_to_response("serverMonitor/logListDetailPage.html", locals(), context_instance=RequestContext(request))


@csrf_exempt
@login_required
def monitorModule_show(request):
    if request.method == "GET":
        settings = ServerMonitorModule.objects().order_by("-create_time")
        return render_to_response('serverMonitor/montior_module_list.html', locals(), context_instance=RequestContext(request))
    elif request.method == "POST":
        error = "非法的连接方式!"
        logger.error(error)
        return render_to_response("item/temp.html", locals(), context_instance=RequestContext(request))

@csrf_exempt
@login_required
def monitorModule_add(request):
    if request.method == "GET":
        action_type = request.GET.get("flag", None)
        create_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        create_user = User.objects.get(pk=request.user.id)
        settings = ServerMonitorModule.objects.order_by("-create_time")
        return render_to_response('serverMonitor/montior_module_create.html', locals(), context_instance=RequestContext(request))
    elif request.method == "POST":
        error = "非法的连接方式!"
        logger.error(error)
        return render_to_response("item/temp.html", locals(), context_instance=RequestContext(request))

@csrf_exempt
@login_required
def monitorModule_edit(request):
    if request.method == "GET":
        id = request.GET.get("id", None)
        action_type = request.GET.get("flag", None)
        if id is None:
            return render_to_response("item/temp.html", locals(), context_instance=RequestContext(request))
        setting = ServerMonitorModule.objects.get(pk=id)
        description = setting.description
        module = setting.module
        create_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        create_user = User.objects.get(pk=request.user.id)
        return render_to_response('serverMonitor/montior_module_create.html', locals(), context_instance=RequestContext(request))
    elif request.method == "POST":
        error = "非法的连接方式!"
        logger.error(error)
        return render_to_response("item/temp.html", locals(), context_instance=RequestContext(request))

@csrf_exempt
@login_required
def monitorModule_save(request):
    response = {"success": False, "error": ""}
    if request.method == "POST":
        try:
            monitor_setting = json.loads(request.POST.get('json'))
            setting_id = monitor_setting["setting_id"]
            setting_name = monitor_setting["setting_name"]
            setting_detail = monitor_setting["setting_detail"]
            name_type = monitor_setting["name_type"]
            if setting_name is None or setting_name == "" or setting_detail is None or setting_detail == "":
                response["success"] = False
                response["error"] = "执行失败,必要参数为空!"
                return HttpResponse(json.dumps(response), mimetype="application/json")
            if name_type == "add":
                setting = ServerMonitorModule()
                setting.module = setting_name
                setting.description = setting_detail
                setting.create_user = User.objects.get(pk=request.user.id)
                setting.create_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                setting.save()
            elif name_type == "edit":
                setting = ServerMonitorModule.objects.get(pk=setting_id)
                setting.module = setting_name
                setting.description = setting_detail
                setting.create_user = User.objects.get(pk=request.user.id)
                setting.create_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                setting.save()
            response["success"] = True
            response["error"] = "执行成功!"
            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception, e:
            response["error"] = "[%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")

@csrf_exempt
@login_required
def monitorModule_del(request):
    response = {"success": False, "error": ""}
    if request.method == "POST":
        try:
            setting_id = request.POST.get("settingId", None)
            setting = ServerMonitorModule.objects(pk=setting_id)
            setting = setting[0]
            setting.delete()

            response["success"] = True
            response["error"] = "删除成功!"
            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception, e:
            response["error"] = "[%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")
