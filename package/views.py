#encoding=utf-8
from subprocess import Popen
import sys, tarfile
from customer.LicenseDataGenerator import LicenseDataGenerator
from customer.models import Machine, Customer
from module.RunInfoGenerator import getCrontable, genCheckAll
from utils.OsHelper import isWindows, isThisWindows
from utils.PathHelper import getLocalDir, getLicensePath, getMonitorDir
from utils.TarfileHelper import addfilefromstring
from xtplatform.PlatformGenerator import genPlatform

reload(sys)
sys.setdefaultencoding('utf-8')
__author__ = 'nerve'

from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.decorators import login_required
from django.shortcuts import render_to_response, render, get_object_or_404
from django.http import HttpResponse
from django.template import RequestContext
import json, logging, datetime, time, os
from package.models import Package
from usrmgr.models import User
from TTEngine.settings import ENCODE, HOST_IP
from TTEngine.constants import SOURCE_UPLOAD, CONTENT_TYPE, FILE_TYPE_COMPILE
from utils.TracebackHelper import getTraceBack
from module.models import *
from customer.models import *
from utils.SvnInfo import getSvnInfo

logger = logging.getLogger('django')

def tryAddString(path, str, mode = 644):
        detail = FileInfoDetail()
        detail.filePath = path
        detail.info = FileInfo()
        detail.info.filePath = path
        detail.info.rawPath = ""
        detail.info.mod = mode
        detail.info.fileType = FILE_TYPE_UNKNOWN
        detail.info.descript = ""
        detail.info.remark = "产生的文件"
        detail.info.createTime = datetime.datetime.now()
        detail.info.updateTime = datetime.datetime.now()
        detail.sha1 = hashlib.sha1(str).hexdigest()
        detail.size = len(str)
        detail.svnVersion = ""
        stingIo = StringIO(str)
        detail.file.put(stingIo)
        detail.createTime = datetime.datetime.now()
        detail.updateTime = datetime.datetime.now()
        return detail

def tryAddFile(path, rawPath, mode = 644):
    fStat = os.stat(rawPath)
    f = open(rawPath)
    content = f.read()
    return tryAddString(path, content, mode)

@csrf_exempt
@login_required
def create(request):
    """
    创建版本
    :param request:
    :return:
    """
    if request.method == "GET":
        return render_to_response("package/package_create.html", locals(), context_instance=RequestContext(request))
    elif request.method == 'POST':
        response = {"success": False, "error": ""}
        try:
            file_obj = request.FILES.get('uploadFile', None)
            file_name = file_obj.name
            file_size = file_obj.size
            #json_info = request.POST.get('json')
            remark = request.GET.get('remark')
            package_version = request.GET.get('package_version')
            package = Package()
            package.version = package_version
            #package.json_info = json.dumps(json.loads(json_info), ensure_ascii=False).encode(ENCODE)
            package.is_enabled = True
            package_suffix = file_name[file_name.rindex('.') + 1:]
            #写入流文件
            package.package.put(file_obj, content_type=CONTENT_TYPE[package_suffix])
            #文件名
            package.package_full_name = file_name
            package.package_name = file_name[0:file_name.rindex('.')]
            package.package_suffix = package_suffix
            package.package_size = file_size
            package.remark = remark
            package.upload_user = User.objects(pk=request.user.id)[0]
            package.create_time = datetime.datetime.now()
            package.source = SOURCE_UPLOAD
            package.save()
            response["success"] = True
            response["id"] = str(package.id)
            response["error"] = "执行成功!"
            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception, e:
            response["error"] = "系统异常![%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")


@csrf_exempt
@login_required
def list(request):
    """
    版本列表
    :param request:
    :return:
    """
    try:
        packages = Package.objects().order_by('-create_time')
        return render_to_response("package/package_list.html", locals(), context_instance=RequestContext(request))
    except Exception as e:
        error = "程序异常![%s]" % (str(e))
        logger.error(error + getTraceBack())
        return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))


@csrf_exempt
@login_required
def view(request):
    """
    版本列表查看
    :param request:
    :return:
    """
    try:
        package_id = request.GET.get('id', None)

        if package_id is None:
            error = "版本ID为空!"
            logger.error(error.encode(ENCODE))
            return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))

        package = Package.objects(pk=package_id)

        if len(package) == 0:
            error = "未获取到版本对象[id=%s]" % package_id
            logger.error(error.encode(ENCODE))
            return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))

        package = package[0]
        is_view = True

        return render_to_response("package/package_create.html", locals(), context_instance=RequestContext(request))
    except Exception as e:
        error = "程序异常![%s]" % str(e)
        logger.error(error + getTraceBack())
        return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))


@csrf_exempt
@login_required
def edit(request):
    """
    版本列表编辑
    :param request:
    :return:
    """
    if request.method == 'GET':
        try:
            package_id = request.GET.get('id', None)

            if package_id is None:
                error = "版本ID为空!"
                logger.error(error)
                return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))

            package = Package.objects(pk=package_id)

            if len(package) == 0:
                error = "未获取到版本对象[id=%s]" % package_id
                logger.error(error)
                return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))

            package = package[0]
            is_edit = True

            return render_to_response("package/package_create.html", locals(), context_instance=RequestContext(request))
        except Exception as e:
            error = "程序异常![%s]" % str(e)
            logger.error(error + getTraceBack())
            return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))
    elif request.method == 'POST':
        response = {"success": False, "error": ""}
        try:
            #获取参数
            package_id = request.POST.get('id', None)
            is_enabled = request.POST.get('is_enabled', None)
            if is_enabled == 'true':
                is_enabled = True
            elif is_enabled == 'false':
                is_enabled = False
            else:
                response['error'] = "[is_enabled=%s]参数异常!" % is_enabled
                return HttpResponse(json.dumps(response), mimetype="application/json")

            remark = request.POST.get('remark', None)
            #json_info = request.POST.get('json_info', None)

            if package_id is None:
                response['error'] = "版本ID为空!"
                return HttpResponse(json.dumps(response), mimetype="application/json")

            package = Package.objects(pk=package_id)

            if len(package) == 0:
                response['error'] = "未获取到版本对象[id=%s]" % package_id
                return HttpResponse(json.dumps(response), mimetype="application/json")

            package = package[0]
            #package.version = VERSION_PREFIX_PACKAGE + str(int(time.mktime(package.create_time.timetuple()) * 1000))
            #package.json_info = json.dumps(json.loads(json_info), ensure_ascii=False).encode(ENCODE)
            package.is_enabled = is_enabled
            package.remark = remark
            package.update_user = User.objects(pk=request.user.id)[0]
            package.update_time = datetime.datetime.now()
            package.save()

            response['success'] = True
            response['error'] = '更新成功!'
            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception as e:
            response['error'] = "程序异常![%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")


@csrf_exempt
@login_required
def change_status(request):
    """
    改变状态
    :param request:
    :return:
    """
    response = {"success": False, "error": ""}
    try:
        path = request.path
        is_enabled = None
        if path == '/package/enable/':
            is_enabled = True
        elif path == '/package/disable/':
            is_enabled = False

        package_id = request.POST.get('id', None)

        if package_id is None:
            response['error'] = "版本ID为空!"
            return HttpResponse(json.dumps(response), mimetype="application/json")

        package = Package.objects(pk=package_id)

        if len(package) == 0:
            response['error'] = "未获取到版本对象[id=%s]" % package_id
            return HttpResponse(json.dumps(response), mimetype="application/json")

        package = package[0]
        package.is_enabled = is_enabled
        package.save()

        response['success'] = True
        response['error'] = '启用成功!' if is_enabled else '禁用成功!'
        return HttpResponse(json.dumps(response), mimetype="application/json")
    except Exception as e:
        response['error'] = "程序异常![%s]" % str(e)
        logger.error(response["error"] + getTraceBack())
        return HttpResponse(json.dumps(response), mimetype="application/json")


@csrf_exempt
@login_required
def delete_package(request):
    """
    删除版本
    :param request:
    :return:
    """
    response = {"success": False, "error": ""}
    try:
        package_id = request.POST.get('id', None)

        if package_id is None:
            response['error'] = "版本ID为空!"
            return HttpResponse(json.dumps(response), mimetype="application/json")

        package = Package.objects(pk=package_id)

        if len(package) == 0:
            response['error'] = "未获取到版本对象[id=%s]" % package_id
            return HttpResponse(json.dumps(response), mimetype="application/json")

        package = package[0]
        package.delete()

        response['success'] = True
        response['error'] = '删除成功!'
        return HttpResponse(json.dumps(response), mimetype="application/json")
    except Exception as e:
        response['error'] = "程序异常![%s]" % str(e)
        logger.error(response["error"] + getTraceBack())
        return HttpResponse(json.dumps(response), mimetype="application/json")


@csrf_exempt
@login_required
def download_package(request):
    """
    下载版本
    :param request:
    :return:
    """
    try:
        package_id = request.GET.get('id', None)

        if package_id is None:
            error = "版本ID为空!"
            logger.error(error)
            return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))

        package = Package.objects(pk=package_id)

        if len(package) == 0:
            error = "未获取到版本对象[id=%s]" % package_id
            logger.error(error)
            return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))

        package = package[0]
        content = package.package.read()
        size = len(content)
        response = HttpResponse(content)
        response['Content-Length'] = size
        response['Content-Disposition'] = 'attachment; filename=%s' % package.package_full_name.encode('utf-8')
        return response
    except Exception as e:
        error = "下载文件异常![%s]" % str(e)
        logger.error(error + getTraceBack())
        return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))
