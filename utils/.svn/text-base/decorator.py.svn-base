# encoding=utf-8
__author__ = 'nerve'
import sys

reload(sys)
sys.setdefaultencoding('utf-8')
import re
import logging
import json
from logger.models import CoreLogger
from module.models import Module
from customer.models import Customer, CustomerPermissionSettings
import datetime
from TTEngine.settings import ENCODE
from TTEngine.constants import OPERATE_CREATE, OPERATE_UPDATE, OPERATE_DELETE, RESULT_TYPE_FAILURE, RESULT_TYPE_SUCCESS
from usrmgr.models import User
from utils.TracebackHelper import getTraceBack
from bson.dbref import DBRef

logger = logging.getLogger('django')


def core_logger(fn):
    """
    关键日志记录装饰器
    :param fn:
    :return:
    """

    def inner_logger(request, *args, **kwargs):
        # 解析参数
        user = User.objects(username=request.user.username)[0]
        method = request.method
        path = request.get_full_path()
        # 判断是否需要记录日志
        logger_handler = get_logger_handler(method, path)
        # 不需要记录直接执行方法
        if not logger_handler:
            return fn(request)

        # 处理并记录日志
        log = '目的 : 记录[%s]核心日志 ; '
        log += '用户名 : %s ; ' % user.username.encode(ENCODE)
        log += '方法名 : %s ; ' % method
        log += 'URI : %s ; ' % path.encode(ENCODE)
        return logger_handler(request, fn, log)

    return inner_logger


def handle_modify_module(request, fn, log):
    """
    处理创建或编辑模块
    :param request:
    :param fn:
    """
    resp = None
    is_success = False
    try:
        # 获取参数
        request_json = json.loads(request.POST.get("json"))
        # 模块ID
        module_id = request_json["moduleId"]
        log = log % ('创建模块[id=%s]' % None) if module_id is None else ('编辑模块[id=%s]' % str(module_id))

        # 记录参数
        old_obj = None
        if module_id is not None:
            old_obj = Module.objects(pk=module_id)[0]

        old_json = None
        old_version = None
        if old_obj is not None:
            old_version = old_obj.version
            old_json = convert_module_to_json(old_obj)

        log += '旧数据版本 : [%s] ; ' % None if old_version is None else old_version.encode(ENCODE)
        log += '旧数据备份 : [%s] ; ' % None if old_json is None else json.dumps(old_json, ensure_ascii=False).encode(ENCODE)

        # 执行方法
        resp = fn(request)
        # 执行方法end
        # 方法响应参数
        resp_json = json.loads(resp.content)

        new_json = None
        new_version = None

        if module_id is not None:
            new_module = Module.objects(pk=module_id)[0]
            new_version = new_module.version
            new_json = convert_module_to_json(new_module)
        elif resp_json['id'] is not None:
            new_module = Module.objects(pk=resp_json['id'])[0]
            new_version = new_module.version
            new_json = convert_module_to_json(new_module)

        log += '新数据版本 : [%s] ; ' % new_version.encode(ENCODE)
        log += '新数据备份 : [%s] ; ' % json.dumps(new_json, ensure_ascii=False).encode(ENCODE)

        is_success = resp_json['success']

        core_log = CoreLogger()
        core_log.collection = 'module'
        core_log.operate_type = OPERATE_CREATE if module_id is None else OPERATE_UPDATE
        core_log.result_type = RESULT_TYPE_SUCCESS if is_success else RESULT_TYPE_FAILURE
        core_log.old_version = old_version
        core_log.old_data = None if old_json is None else json.dumps(old_json, ensure_ascii=False).encode(ENCODE)
        core_log.new_version = new_version
        core_log.new_data = json.dumps(new_json, ensure_ascii=False).encode(ENCODE)
        core_log.response = json.dumps(resp_json, ensure_ascii=False).encode(ENCODE)
        core_log.create_time = datetime.datetime.now()
        core_log.create_user = User.objects(username=request.user.username)[0]
        core_log.save()

        log += ' --> 执行成功!'
    except Exception as e:
        log += ' --> 记录过程异常![%s]\n[%s]' % (str(e), getTraceBack())
    finally:
        logger.info(log) if is_success else logger.error(log)
        return resp


def handle_del_module(request, fn, log):
    """
    处理删除模块
    :param request:
    :param fn:
    """
    resp = None
    is_success = False
    try:
        module_id = request.POST.get("moduleId", None)

        log = log % '删除模块[id=%s]' % str(module_id)

        old_obj = Module.objects(pk=module_id)[0]
        old_version = old_obj.version
        old_json = convert_module_to_json(old_obj)

        # 执行方法
        resp = fn(request)

        # 解析响应
        resp_json = json.loads(resp.content)
        is_success = resp_json["success"]

        core_log = CoreLogger()
        core_log.collection = 'module'
        core_log.operate_type = OPERATE_DELETE
        core_log.result_type = RESULT_TYPE_SUCCESS if is_success else RESULT_TYPE_FAILURE
        core_log.old_version = old_version
        core_log.old_data = json.dumps(old_json, ensure_ascii=False).encode(ENCODE)
        core_log.new_version = None
        core_log.new_data = None
        core_log.response = json.dumps(resp_json, ensure_ascii=False).encode(ENCODE)
        core_log.create_time = datetime.datetime.now()
        core_log.create_user = User.objects(username=request.user.username)[0]
        core_log.save()

        log += ' --> 执行成功!'
    except Exception as e:
        log += ' --> 记录过程异常![%s]' % str(e)
    finally:
        logger.info(log) if is_success else logger.error(log)
        return resp


def handle_modify_customer(request, fn, log):
    """
    处理创建或删除客户
    :param request:
    :param fn:
    """
    resp = None
    is_success = False
    try:
        # 获取参数
        request_json = json.loads(request.POST.get("json"))
        # 客户ID
        cus_id = request_json["customerId"]
        log = log % ('创建客户[id=%s]' % None) if cus_id is None else ('编辑客户[id=%s]' % str(cus_id))

        # 记录参数
        old_obj = None
        if cus_id is not None:
            old_obj = Customer.objects(pk=cus_id)[0]

        old_json = None
        old_version = None
        if old_obj is not None:
            old_version = old_obj.version
            old_json = convert_customer_to_json(old_obj)

        log += '旧数据版本 : [%s] ; ' % None if old_version is None else old_version.encode(ENCODE)
        log += '旧数据备份 : [%s] ; ' % None if old_json is None else json.dumps(old_json, ensure_ascii=False).encode(ENCODE)

        # 执行方法
        resp = fn(request)
        # 执行方法end
        # 方法响应参数
        resp_json = json.loads(resp.content)

        new_json = None
        new_version = None

        if cus_id is not None:
            new_obj = Customer.objects(pk=cus_id)[0]
            new_version = new_obj.version
            new_json = convert_customer_to_json(new_obj)
        elif resp_json['id'] is not None:
            new_obj = Customer.objects(pk=resp_json['id'])[0]
            new_version = new_obj.version
            new_json = convert_customer_to_json(new_obj)

        log += '新数据版本 : [%s] ; ' % new_version.encode(ENCODE)
        log += '新数据备份 : [%s] ; ' % json.dumps(new_json, ensure_ascii=False).encode(ENCODE)

        is_success = resp_json['success']

        core_log = CoreLogger()
        core_log.collection = 'customer'
        core_log.operate_type = OPERATE_CREATE if cus_id is None else OPERATE_UPDATE
        core_log.result_type = RESULT_TYPE_SUCCESS if is_success else RESULT_TYPE_FAILURE
        core_log.old_version = old_version
        core_log.old_data = None if old_json is None else json.dumps(old_json, ensure_ascii=False).encode(ENCODE)
        core_log.new_version = new_version
        core_log.new_data = json.dumps(new_json, ensure_ascii=False).encode(ENCODE)
        core_log.response = json.dumps(resp_json, ensure_ascii=False).encode(ENCODE)
        core_log.create_time = datetime.datetime.now()
        core_log.create_user = User.objects(username=request.user.username)[0]
        core_log.save()

        log += ' --> 执行成功!'
    except Exception as e:
        log += ' --> 记录过程异常![%s]\n[%s]' % (str(e), getTraceBack())
    finally:
        logger.info(log) if is_success else logger.error(log)
        return resp


def handle_del_customer(request, fn, log):
    """
    处理删除客户
    :param request:
    :param fn:
    """
    resp = None
    is_success = False
    try:
        cus_id = request.POST.get("cus_id", None)

        log = log % '删除客户[id=%s]' % str(cus_id)

        old_obj = Customer.objects(pk=cus_id)[0]
        old_version = old_obj.version
        old_json = convert_customer_to_json(old_obj)

        # 执行方法
        resp = fn(request)

        # 解析响应
        resp_json = json.loads(resp.content)
        is_success = resp_json["success"]

        core_log = CoreLogger()
        core_log.collection = 'customer'
        core_log.operate_type = OPERATE_DELETE
        core_log.result_type = RESULT_TYPE_SUCCESS if is_success else RESULT_TYPE_FAILURE
        core_log.old_version = old_version
        core_log.old_data = json.dumps(old_json, ensure_ascii=False).encode(ENCODE)
        core_log.new_version = None
        core_log.new_data = None
        core_log.response = json.dumps(resp_json, ensure_ascii=False).encode(ENCODE)
        core_log.create_time = datetime.datetime.now()
        core_log.create_user = User.objects(username=request.user.username)[0]
        core_log.save()

        log += ' --> 执行成功!'
    except Exception as e:
        log += ' --> 记录过程异常![%s]' % str(e)
    finally:
        logger.info(log) if is_success else logger.error(log)
        return resp


def get_logger_handler(method, path):
    """
    获取日志处理器
    :param method:
    :param path:
    :return:
    """
    for key, value in core_logger_url_dict.iteritems():
        if re.match(key, path):
            if value.has_key(method):
                return value[method]
    return False


# 用于判断是否需要记录日志
core_logger_url_dict = {
    '^/module/create/$': {
        'POST': handle_modify_module,
        'memo': '创建模块/编辑模块'
    },
    '^/module/del/$': {
        'POST': handle_del_module,
        'memo': '删除模块'
    },
    '^/customer/create/$': {
        'POST': handle_modify_customer,
        'memo': '创建客户/编辑客户'
    },
    '^/customer/del/$': {
        'POST': handle_del_customer,
        'memo': '删除客户'
    }
}


def convert_module_to_json(module_obj):
    """
    转型模块对象为json格式
    :param module_obj:
    :return:
    """
    if type(module_obj) is DBRef:
        return {}
    old_module_json = json.loads(module_obj.to_json())
    old_module_json['files'] = [json.loads(item.to_json()) for item in module_obj.files]
    old_module_json['runInfos'] = [json.loads(item.to_json() if type(item) is not DBRef else '{}') for item in module_obj.runInfos]
    return old_module_json


def convert_customer_to_json(customer_obj):
    """
    转型客户对象为json格式
    :param customer_obj:
    :return:
    """
    json_obj = json.loads(customer_obj.to_json())
    json_obj['machines'] = [convert_machine_to_json(item) for item in customer_obj.machines]
    json_obj['modules'] = [convert_module_to_json(item) for item in customer_obj.modules]
    json_obj['permissions'] = [convert_cus_permission_json(key, value) for key, value in customer_obj.permissions.items()]
    return json_obj


def convert_cus_permission_json(key, value):
    obj = CustomerPermissionSettings.objects(pk=key)[0]
    result = {'permission_obj': json.loads(obj.to_json()), 'cus_value': value}
    return result


def convert_machine_to_json(machine_obj):
    """
    转型机器对象为json格式
    :param machine_obj:
    :return:
    """
    json_obj = json.loads(machine_obj.to_json())
    json_obj['modules'] = [convert_module_to_json(item) for item in machine_obj.modules]
    return json_obj


def convert_compiling_record_to_json(compiling_record_obj):
    json_obj = json.loads(compiling_record_obj.to_json())
    json_obj['customer'] = convert_customer_to_json(compiling_record_obj.customer)
    json_obj['modules'] = [convert_module_to_json(module_item) for module_item in compiling_record_obj.modules]
    # module_raw_path修改调整
    # json_obj['module_raw_path'] = [json.loads(item.to_json()) for item in compiling_record_obj.module_raw_path]
    json_obj['operate_user'] = json.loads(compiling_record_obj.operate_user.to_json())
    return json_obj
