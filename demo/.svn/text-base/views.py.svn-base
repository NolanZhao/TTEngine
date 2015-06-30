# encoding=utf-8
import sys
import os


reload(sys)
sys.setdefaultencoding('utf-8')
__author__ = 'nerve'

from django.core.paginator import Paginator, InvalidPage, EmptyPage, PageNotAnInteger
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.decorators import login_required
from django.shortcuts import render_to_response
from django.template import RequestContext
from django.http import HttpResponse
import logging
import json
import redis
from net.RPCClient import RPCClient, request
from utils.TracebackHelper import getTraceBack
from rzrk_bson import BSON
import zlib
from xtplatform.medels import Platform
from TTEngine.settings import PAGE_SIZE
from customer.models import Customer
from customer.models import CustomerPermissionSettings
import re
from customer.models import CustomerDeployStatus
from random import choice
import string
from usrmgr.models import User
from demo.models import VideoInfo
from TTEngine.constants import VIDEO_DIR


logger = logging.getLogger('django')

ReaderAddress = "210.14.136.70:55400"
# WriterAddress = getAddress("xtsource")
WriterAddress = "192.168.1.206:63000"
StockAndTradePATH = "/home/rzrk/deployserver/"
StockAndTradeDIR = StockAndTradePATH + "datas"


@csrf_exempt
@login_required
def redis_view(request):
    if request.method == "GET":

        search_key = request.GET.get('search_key', None)
        host = request.GET.get('host', None)
        port = request.GET.get('port', None)

        if search_key:
            r = redis.StrictRedis(host=host, port=int(port), db=0)
            keys = r.keys(search_key)

            results = []
            for item in keys:
                results.append([item, json.dumps(BSON(zlib.decompress(r.get(item))).decode())])

        return render_to_response("demo/redis_view.html", locals(), context_instance=RequestContext(request))
    elif request.method == 'POST':
        response = {"success": False, "error": "", "id": None}
        try:
            response["success"] = True
            response["error"] = "执行成功!"
            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception, e:
            response["error"] = "系统异常![%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")


def gdbm_view(request):
    if request.method == "GET":
        search_key = request.GET.get('search_key', None)
        host = request.GET.get('host', None)
        port = request.GET.get('port', None)
        strDb = 'XtTradeData'
        param_key = {
            'strDb': strDb
        }
        param_value = {}

        if host and port:
            r = RPCClient(host=host, port=int(port))
            keys = r.request('getAllKeys', param_key).values()[0]
            results = []
            for item in keys:
                if re.search(search_key, item):
                    param_value = {
                        'strDb': strDb,
                        'strKey': item
                    }
                    ret = r.request('readData', param_value).values()[0]
                    results.append([item, json.dumps(ret)])

        return render_to_response("demo/gdbm_view.html", locals(), context_instance=RequestContext(request))

    elif request.method == 'POST':
        response = {"success": False, "error": "", "id": None}
        try:
            response["success"] = True
            response["error"] = "执行成功!"
            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception, e:
            response["error"] = "系统异常![%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")


@csrf_exempt
@login_required
def platform_view(request):
    """
    平台管理
    :param request:
    :return:
    """
    if request.method == 'GET':
        platforms = Platform.objects().order_by('m_nID')
        after_range_num = 2
        try:
            page = int(request.GET.get("page", 1))
            if page < 1:
                page = 1
        except ValueError:
            page = 1
        paginator = Paginator(Platform.objects.order_by('m_nType','m_nId'), PAGE_SIZE)
        befor_range_num = 1
        try:
            platforms_list = paginator.page(page)
        except(EmptyPage, InvalidPage, PageNotAnInteger):
            platforms_list = paginator.page(paginator.num_pages)
        if page >= after_range_num:
            page_range = paginator.page_range[page - after_range_num:page + befor_range_num]
        else:
            page_range = paginator.page_range[0:int(page) + befor_range_num]
        return render_to_response('demo/platform_view.html', {'platforms': platforms_list, 'page_range': page_range, 'request': request})
    else:
        error = '请使用http-get方式请求'
        logger.error(error)
        return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))



@csrf_exempt
@login_required
def platform_operate(request):
    """
    平台保存,删除,更新
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
            id = request.POST.get('id', None)

            m_nId = request.POST.get('m_nId', None)
            m_nId = int(m_nId) if m_nId else None

            m_nType = request.POST.get('m_nType', None)
            m_nType = int(m_nType) if m_nType else None

            m_strName = request.POST.get('m_strName', None)
            m_strAbbrName = request.POST.get('m_strAbbrName', None)
            m_strSoName = request.POST.get('m_strSoName', None)
            m_strConfig = request.POST.get('m_strConfig', None)
            m_strLogo = request.POST.get('m_strLogo', None)
            m_strQuoterTag = request.POST.get('m_strQuoterTag', None)
            m_strBrokerTag = request.POST.get('m_strBrokerTag', None)
            m_strfastTag = request.POST.get('m_strfastTag', None)

            if cmd is None:
                response["error"] = "CMD参数不能为空!"
                return HttpResponse(json.dumps(response), mimetype="application/json")

            param_is_none = False
            if not m_nId or not m_nType:
                param_is_none = True

            if (cmd == 'delete' and id is None) or \
                    (cmd == 'save' and param_is_none) or \
                    (cmd == 'update' and (param_is_none or id is None)):
                response["error"] = "必要参数为空!"
                return HttpResponse(json.dumps(response), mimetype="application/json")

            # 创建
            if cmd == 'save':
                # 判断是否已有
                param_exist = Platform.objects(m_strName=m_strName, m_nType=m_nType)

                if len(param_exist) > 0:
                    response["error"] = "已存在相同平台!请在原基础修改!"
                    return HttpResponse(json.dumps(response), mimetype="application/json")

                platform = Platform()
                platform.m_nId = m_nId
                platform.m_nType = m_nType
                platform.m_strName = m_strName
                platform.m_strAbbrName = m_strAbbrName
                platform.m_strSoName = m_strSoName
                platform.m_strConfig = m_strConfig
                platform.m_strLogo = m_strLogo
                platform.m_strQuoterTag = m_strQuoterTag
                platform.m_strBrokerTag = m_strBrokerTag
                platform.m_strfastTag = m_strfastTag
                platform.save()
                response["id"] = str(platform.id)

            # 更新
            elif cmd == 'update':
                # 查找对象
                platform = Platform.objects(pk=id)
                if len(platform) == 0:
                    response["error"] = "未找到可更新对象!"
                    return HttpResponse(json.dumps(response), mimetype="application/json")
                platform = platform[0]
                platform.m_nId = m_nId
                platform.m_nType = m_nType
                platform.m_strName = m_strName
                platform.m_strAbbrName = m_strAbbrName
                platform.m_strSoName = m_strSoName
                platform.m_strConfig = m_strConfig
                platform.m_strLogo = m_strLogo
                platform.m_strQuoterTag = m_strQuoterTag
                platform.m_strBrokerTag = m_strBrokerTag
                platform.m_strfastTag = m_strfastTag
                platform.save()



            # 删除
            elif cmd == 'delete':
                # 查找对象
                platform = Platform.objects(pk=id)
                if len(platform) == 0:
                    response["error"] = "未找到可删除对象!"
                    return HttpResponse(json.dumps(response), mimetype="application/json")

                platform = platform[0]
                path = request.path
                is_sys = None
                if path == '/customer/system/list/':
                    is_sys = True
                elif path == '/customer/list/':
                    is_sys = False
                else:
                    is_sys = False

                customers = Customer.objects(is_sys=is_sys).order_by('+tag')
                for customer in customers:
                    cus_modules = customer.modules
                    for module in cus_modules:
                        if module.group == "Broker实盘" or module.group == "Broker模拟":
                                name_list = module.name.split('_')
                                if len(name_list) >= 3:
                                    if str(platform.m_nId) == name_list[2]:
                                        response["error"] = "该平台被客户[%s]使用,不能删除!" % str(customer.name)
                                        return HttpResponse(json.dumps(response), mimetype="application/json")


                platform.delete()

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


from customer.models import Machine

from module.models import Module


@csrf_exempt
@login_required
def removeInvalidModule(request):
    machines = Machine.objects()
    for machine in machines:
        invalidModules = []
        for module in machine.modules:
            if type(module) != type(Module()):
                invalidModules.append(module)
        if len(invalidModules) > 0:
            for module in invalidModules:
                machine.modules.remove(module)
            print machine.name, "saved"
            machine.save()
    return HttpResponse("成功")


from xtplatform.PlatformGenerator import genPlatform
import hashlib, datetime
from StringIO import StringIO
from module.models import FileInfoDetail, FileInfo, FILE_TYPE_UNKNOWN
from customer.models import InstallPackage


@csrf_exempt
@login_required
def modifyPlatformLua(request):
    """
    machines =  Machine.objects()
    for machine in machines:
        str = genPlatform(machine.modules)
        path = "server/config/platform.lua"

        sha1 = hashlib.sha1(str).hexdigest()
        size = len(str)
        details = FileInfoDetail.objects(filePath=path, sha1=sha1, size=size)
        detail = None
        if len(details) > 0:
            detail = details[0]
            detail.filePath = path
            detail.sha1 = hashlib.sha1(str).hexdigest()
            detail.size = len(str)
            detail.svnVersion = ""
            stingIo = StringIO(str)
            detail.file.put(stingIo)
            detail.createTime = datetime.datetime.now()
            detail.updateTime = datetime.datetime.now()
    """
    path = "server/config/platform.lua"
    packages = InstallPackage.objects(version="国联安实盘_192.168.2.204_20140702   ")
    for package in packages:
        for file in package.files:
            if file.filePath == path:
                str = genPlatform(package.machine.modules)
                sha1 = hashlib.sha1(str).hexdigest()
                size = len(str)
                # if file.sha1 != sha1 or file.size != size:
                print package.version, "must modify"
                stingIo = StringIO(str)
                file.sha1 = sha1
                file.size = size
                file.file.replace(stingIo)
                file.save()
                break

    return HttpResponse("成功")


def showBaseSoft(request):
    try:
        DIR = "/home/ftpuser/linux_soft/"
        file0 = DIR + "soft"
        file1 = DIR + "soft.tar.gz"
        dirs = os.listdir(file0)
        return render_to_response("demo/soft_view.html", locals(), context_instance=RequestContext(request))


    except Exception as e:
        error = "下载文件异常![show_base_soft][%s]" % str(e)
        logger.error(error + getTraceBack())
        return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))


def downloadZip(request):
    try:
        DIR = "/home/ftpuser/linux_soft/"
        file1 = DIR + "soft.tar.gz"

        fp0 = open(file1, "r")
        content = fp0.read()
        size = len(content)
        response = HttpResponse(content)
        response['Content-Length'] = size
        response['Content-Disposition'] = 'attachment; filename=%s' % 'soft.tar.gz'
        return response
    except Exception as e:
        error = "下载文件异常![%s]" % str(e)
        logger.error(error + getTraceBack())
        return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))


def downloadFile(request):
    DIR = "/home/ftpuser/linux_soft/soft/"

    if True:
        filename = request.GET.get("file")
        filepath = DIR + filename
        print 'exists: ', os.path.exists(filepath)
        fp = open(filepath, 'r')
        content = fp.read()
        size = len(content)
        response = HttpResponse(content)
        response['Content-Length'] = size
        response['Content-Disposition'] = 'attachment; filename=%s' % filename
        return response

def deleteFile(request):
    DIR = "/home/ftpuser/linux_soft/soft/"
    if True:
        filename = request.GET.get("file")
        targetFile = os.path.join(DIR, filename)
        os.remove(targetFile)
        return render_to_response("demo/soft_view.html", locals(), context_instance=RequestContext(request))


def uploadFile(request):
    if request.method == 'GET':
        return render_to_response("demo/uploadFile.html", locals(), context_instance=RequestContext(request))

    if request.method == 'POST':
        response = {"success": True, "error": "上传成功!"}
        try:
            DIR = "E:/home/ftpuser/"
            file_obj = request.FILES.get('uploadFile', None)
            fileName = str(file_obj)
            dst_file_path = DIR + fileName
            dst_file = open(dst_file_path, 'wb')
            content = file_obj.read()
            dst_file.write(content)
            dst_file.close()

            return HttpResponse(json.dumps(response), mimetype="application/json")

        except Exception, e:
            response["success"] = False
            response["error"] = unicode(e)
            return HttpResponse(json.dumps(response), mimetype="application/json")


def uploadBaseSoft(request):
    if request.method == 'POST':
        response = {"success": True, "error": "上传成功!"}
        try:
            DIR = "/home/ftpuser/linux_soft/soft/"
            file_obj = request.FILES.get('uploadBaseSoft', None)
            fileName = str(file_obj)
            dst_file_path = DIR + fileName
            dst_file = open(dst_file_path, 'wb')
            content = file_obj.read()
            dst_file.write(content)
            dst_file.close()
            return HttpResponse(json.dumps(response), mimetype="application/json")

        except Exception, e:
            response["success"] = False
            response["error"] = unicode(e)
            return HttpResponse(json.dumps(response), mimetype="application/json")


@csrf_exempt
@login_required
def quickSearch(request):
    if request.method == "GET":
        search_customer = request.GET.get("customer", None)
        search_manager = request.GET.get('manager', None)
        search_status = request.GET.get('status', None)
        search_module = request.GET.get('module', None)
        search_permission = request.GET.get('permission', None)
        search_perm_num = request.GET.get('num', None)
        search_perm_bool = request.GET.get('bool', None)
        search_config = request.GET.get('config', None)
        is_actual = request.GET.get('isActual', None)
        search_position = request.GET.get('position', None)
        if search_customer:
            if is_actual == "是":
                customers = Customer.objects(is_sys=False).order_by('+tag')
            elif is_actual == "否":
                customers = Customer.objects(is_sys=True).order_by('+tag')
            elif is_actual == "任意":
                customers = Customer.objects().order_by('+tag')

            cus_states = CustomerDeployStatus.objects()
            error = request.GET.get("error", None)
            cus_aftersales = []
            for customer in customers:
                if customer.aftersale in cus_aftersales:
                    continue
                cus_aftersales.append(customer.aftersale)

            results = []
            if search_customer:
                for customer in customers:
                    if search_customer == customer.name:
                                results.append(customer)
            if search_manager and search_manager != '任意':
                for customer in customers:
                    if search_manager == customer.aftersale:
                        if is_actual == '是':
                            if "实盘" in customer.name:
                                    results.append(customer)
                        else:
                            results.append(customer)
            if search_status and search_status != '任意':
                for customer in customers:
                    if search_status == customer.customerstatus:
                        if is_actual == '是':
                            if "实盘" in customer.name:
                                    results.append(customer)
                        else:
                            results.append(customer)
            if search_module and search_module != '任意':
                for customer in customers:
                    cus_modules = customer.modules;
                    for module in cus_modules:
                        if search_module == module.name:
                           if is_actual == '是':
                               if "实盘" in customer.name:
                                    results.append(customer)
                           else:
                                results.append(customer)
            if search_permission and search_permission != '任意':
                for customer in customers:
                    cus_permission = customer.permissions
                    perm_settings = CustomerPermissionSettings.objects()
                    for perm_setting in perm_settings:
                        if perm_setting.name == search_permission[1:]:
                            perm_id = str(perm_setting.id)
                            if str(search_perm_num) == str(cus_permission[perm_id]) or str(search_perm_bool) == str(cus_permission[perm_id]):
                                if is_actual == '是':
                                    if "实盘" in customer.name:
                                        results.append(customer)
                                else:
                                      results.append(customer)
            if search_config:
                 for customer in customers:
                      setting = customer.settings
                      pattern = re.compile(search_config, re.X)
                      match = pattern.search(setting)
                      if match is not None:
                             if is_actual == '是':
                                 if "实盘" in customer.name:
                                    results.append(customer)
                             else:
                                 results.append(customer)

            if is_actual == '是':
                 for customer in customers:
                      if '实盘' in customer.name:
                          results.append(customer)
            elif is_actual == '否':
                 for customer in customers:
                      results.append(customer)

            if search_position and search_position != '任意':
                  for customer in customers:
                       if customer.position == search_position:
                           results.append(customer)

        else:
            customers = Customer.objects().order_by('+tag')
            cus_states = CustomerDeployStatus.objects()
            error = request.GET.get("error", None)
            cus_aftersales = []
            results = []
            for customer in customers:
                if customer.aftersale in cus_aftersales:
                    continue
                    cus_aftersales.append(customer.aftersale)
                    results.append(customer)
        return render_to_response("demo/search_view.html", locals(), context_instance=RequestContext(request))

    elif request.method == 'POST':
        response = {"success": False, "error": "", "id": None}
        try:
            response["success"] = True
            response["error"] = "执行成功!"
            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception, e:
            response["error"] = "系统异常![%s]"% str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")


def dispatchFromNet(market):
    # 请求交易日
    param = {"market": market, "stock": "FFFFFF", "metaId": 2, "period": 86400000L, "timeTag": 0x1F3FFFFF830L, "compress": False}
    response = request(ReaderAddress, "requestByCount", param)

    # 写入交易日信息
    address = WriterAddress.split(":")
    client = RPCClient(address[0], int(address[1]), 100)
    for x in response["C"]:
        param = {"F": {"M": market, "S": "FFFFFF"}, "C": [{"C": x}]}
        r = client.request("writeData", param)
        #print "write data ", param
    # 更新市场状态
    if len(response["C"]) > 1:
        r = client.request("update", {u"path": u"marketStatus/%s" % market, u"data": {u"date": response["C"][-1]["G"], u"status": 2}})
        print "update market status", param

    # 写入日数据信息
    if len(response["C"]) > 1:
        lastDate =response["C"][-1]["G"]
        print lastDate
        param = {"market": "SF", "stock": "XXXXXX", "metaId": 2000, "period": 86400000L, "timeTag": lastDate, "seq": 0L, "compress": False}
        response = request(ReaderAddress, "requestByDaily", param)
        print "request by daily ", len(response)
        param = {"M": market, "G": lastDate, "C": response}
        response = request(WriterAddress, "writeDaily", param)
        print "write daily ", response

def writeToFile(data, file):
    f = open(file, "w")
    f.write(json.dumps(data, indent=4))
    f.close()

def save(market, dir):
    # 写入交易日
    param = {"market": market, "stock": "FFFFFF", "metaId": 2, "period": 86400000L, "timeTag": 0x1F3FFFFF830L, "compress": False}
    response = request(ReaderAddress, "requestByCount", param)
    writeToFile(response, "%s/%s_tradeDate" % (dir, market))

    # 写入股票列表
    if len(response["C"]) > 1:
        lastDate = response["C"][-1]["G"]
        print lastDate
        param = {"market": market, "stock": "XXXXXX", "metaId": 2000, "period": 86400000L, "timeTag": lastDate, "seq": 0L, "compress": False}
        response = request(ReaderAddress, "requestByDaily", param)
        writeToFile(response, "%s/%s_stockList" % (dir, market))

def loadFromFile(file):
    f = open(file, "r")
    response = json.load(f)
    return response

def dispatchFromFile(market, dir):
    # 请求交易日
    fileName = "%s/%s_tradeDate" % (dir, market)
    response = loadFromFile(fileName)
    # 写入交易日信息
    address = WriterAddress.split(":")
    client = RPCClient(address[0], int(address[1]), 100)
    for x in response["C"]:
        param = {"F": {"M": market, "S": "FFFFFF"}, "C": [{"C": x}]}
        r = client.request("writeData", param)
        #print "write data ", param
    # 更新市场状态
    if len(response["C"]) > 1:
        r = client.request("update", {u"path": "marketStatus/%s" % market, u"data": {u"date": response["C"][-1]["G"], u"status": 2}})
        print "update market status", param

    # 写入日数据信息
    if len(response["C"]) > 1:
        lastDate = response["C"][-1]["G"]
        print lastDate
        fileName = "%s/%s_stockList" % (dir, market)
        response = loadFromFile(fileName)
        print "request by daily ", len(response)
        param = {"M": market, "G": lastDate, "C": response}
        response = request(WriterAddress, "writeDaily", param)
        print "write daily ", response

def InitByFile():
    markets = ["IF", "SF", "DF", "ZF", "SH", "SZ"]
    for x in markets:
        print "dispatch ", x
        #dispatch(x)
        dispatchFromFile(x, "E:/tmp/datas")

def InitByNet():
    markets = ["IF", "SF", "DF", "ZF"]
    for x in markets:
        print "dispatch ", x
        dispatchFromNet(x, StockAndTradeDIR)

def saveToFile():
    markets = ["IF", "SF", "DF", "ZF", "SH", "SZ"]
    for x in markets:
        print "dispatch ", x
        #dispatch(x)
        save(x, StockAndTradeDIR)


def StockAndTrade(request):
    try:
        file0 = StockAndTradeDIR
        dirs = os.listdir(file0)
        if request.method == 'GET':
            return render_to_response("demo/downStockAndTrade.html", locals(), context_instance=RequestContext(request))

    except Exception as e:
        error = "下载文件异常![StockAndTrade][%s]" % str(e)
        logger.error(error + getTraceBack())
        return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))


def getStockAndTrade(request):
    try:
        saveToFile()
        command = "cd %s; tar -zcf datas.tar.gz datas" %(StockAndTradePATH)
        os.system(command)
    except Exception as e:
        error = "下载文件异常![getStockAndTrade][%s]" % str(e)
        logger.error(error + getTraceBack())
        return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))


def downStockAndTrade(request):
    try:

        file1 = StockAndTradePATH + "datas.tar.gz"

        fp0 = open(file1, "r")
        content = fp0.read()
        size = len(content)
        response = HttpResponse(content)
        response['Content-Length'] = size
        response['Content-Disposition'] = 'attachment; filename=%s' % 'datas.tar.gz'
        return response

    except Exception as e:
        error = "下载文件异常![%s]" % str(e)
        logger.error(error + getTraceBack())
        return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))

def downStockAndTradeFile(request):
    if True:
        filename = request.GET.get("file")
        filepath = StockAndTradeDIR + "/" + filename
        print 'exists: ', os.path.exists(filepath)
        fp = open(filepath, 'r')
        content = fp.read()
        size = len(content)
        response = HttpResponse(content)
        response['Content-Length'] = size
        response['Content-Disposition'] = 'attachment; filename=%s' % filename
        return response

@csrf_exempt
@login_required
def passwdGen(request):
    response = {"success": False, "error": ""}
    if request.method == 'GET':
        return render_to_response("demo/passwdGen.html", locals(), context_instance=RequestContext(request))
    elif request.method == 'POST':
        try:
            chars = string.ascii_letters+string.digits
            length = 8
            Password = ''.join([choice(chars) for i in range(length)])
            response["success"] = True
            response["error"] = Password
            return HttpResponse(json.dumps(response), mimetype="application/json")

        except Exception, e:
            response["success"] = False
            response["error"] = unicode(e)
            return HttpResponse(json.dumps(response), mimetype="application/json")


@csrf_exempt
@login_required
def video(request):
    videos = VideoInfo.objects()
    return render_to_response("demo/video.html", locals(), context_instance=RequestContext(request))


@csrf_exempt
@login_required
def uploadVideo(request):
    if request.method == 'GET':
        return render_to_response("demo/videoUpload.html", locals(), context_instance=RequestContext(request))

    if request.method == 'POST':
        response = {"success": True, "error": "", "fileurl": ""}
        try:
            file_obj = request.FILES.get('uploadFile', None)
            fileName = str(file_obj)
            dst_file_path = VIDEO_DIR + fileName
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
def videoPost(request):
    """
    提交视频信息
    :param request:
    :return:
    """
    if request.method == "GET":
        return render_to_response("demo/videoUpload.html", locals(), context_instance=RequestContext(request))
    elif request.method == "POST":
        response = {"success": True, "error": "上传成功!"}
        try:
            #获取参数
            tittle = request.POST.get('tittle', None)
            description = request.POST.get('description', None)
            url = request.POST.get('url', None)
            create_time = datetime.datetime.now()
            create_user = User.objects.get(pk=request.user.id)

            # 保存视频信息
            logInfo = VideoInfo()
            logInfo.tittle = tittle
            logInfo.description = description
            logInfo.create_time = create_time
            logInfo.create_user = create_user
            logInfo.attachment_url = url
            logInfo.save()
            return HttpResponse(json.dumps(response), mimetype="application/json")

        except Exception as e:
            response["success"] = False
            response["error"] = "系统异常![%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")

