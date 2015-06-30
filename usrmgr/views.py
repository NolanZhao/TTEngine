# encoding=utf-8

import sys

reload(sys)
sys.setdefaultencoding('utf-8')

__author__ = 'nerve'

from TTEngine import settings
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.decorators import login_required
from django.shortcuts import render_to_response, render, get_object_or_404, redirect
from django.template import RequestContext
from django.http import HttpResponse
import json
import datetime
import time
import logging
from TTEngine.constants import *
from usrmgr.models import User, UserGroup
from utils.TracebackHelper import getTraceBack
from django.contrib.auth.hashers import make_password


logger = logging.getLogger('django')


@csrf_exempt
@login_required
def create(request):
    """
    创建用户
    :param request:
    :return:
    """
    if request.method == "GET":
        groups = UserGroup.objects.all()
        return render_to_response("user/user_create.html", locals(), context_instance=RequestContext(request))
    elif request.method == 'POST':
        response = {"success": False, "error": "", "id": None}
        try:
            # 获取参数
            json_str = request.POST.get('json', None)

            if not json_str:
                response['error'] = '必要参数为空!'
                return HttpResponse(json.dumps(response), mimetype="application/json")

            json_obj = json.loads(json_str)

            username = json_obj.get('username', None)
            password = json_obj.get('password', None)
            group_str = json_obj.get('group', None)
            telphone = json_obj.get('telphone', None)
            email = json_obj.get('email', None)
            is_staff = json_obj.get('is_staff', None)
            is_active = json_obj.get('is_active', None)

            if not username or not password:
                response['error'] = '必要参数为空!'
                return HttpResponse(json.dumps(response), mimetype="application/json")

            # UserGroup
            group = UserGroup.objects(key=group_str)
            if not group:
                response['error'] = '非法用户组!'
                return HttpResponse(json.dumps(response), mimetype="application/json")
            group = group[0]

            # User
            if User.objects(username=username):
                response['error'] = '用户名已存在!'
                return HttpResponse(json.dumps(response), mimetype="application/json")

            user_obj = User.create_user(username, password, group.key, telphone=telphone, is_staff=is_staff, is_active=is_active, is_superuser=True if group.key == USER_GROUP_ADMIN else False, email=email if email else None)

            response["id"] = str(user_obj.id)
            response["success"] = True
            response["error"] = "执行成功!"
            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception, e:
            response["error"] = "系统异常![%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")


@csrf_exempt
@login_required
def edit(request):
    """
    编辑用户
    :param request:
    :return:
    """
    if request.method == "GET":
        try:
            # 标记编辑
            is_edit = True
            id = request.GET.get("id", None)
            if id is None:
                error = '必要参数为空!'
                logger.error(error)
                return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))

            user_obj = User.objects.get(pk=id)
            groups = UserGroup.objects.all()

            return render_to_response("user/user_create.html", locals(), context_instance=RequestContext(request))
        except Exception as e:
            error = '编辑用户异常![%s]' % str(e)
            logger.error(error + getTraceBack())
            return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))
    elif request.method == 'POST':
        response = {"success": False, "error": "", "id": None}
        try:
            # 获取参数
            json_str = request.POST.get('json', None)

            if not json_str:
                response['error'] = '必要参数为空!'
                return HttpResponse(json.dumps(response), mimetype="application/json")

            json_obj = json.loads(json_str)

            user_id = json_obj.get('user_id', None)
            password = json_obj.get('password', None)
            group_str = json_obj.get('group', None)
            email = json_obj.get('email', None)
            is_staff = json_obj.get('is_staff', None)
            is_active = json_obj.get('is_active', None)

            if not user_id or not password:
                response['error'] = '必要参数为空!'
                return HttpResponse(json.dumps(response), mimetype="application/json")

            # UserGroup
            group = UserGroup.objects(key=group_str)
            if not group:
                response['error'] = '非法用户组!'
                return HttpResponse(json.dumps(response), mimetype="application/json")
            group = group[0]

            # User
            user = User.objects(pk=user_id)
            if not user:
                response['error'] = '用户未找到!'
                return HttpResponse(json.dumps(response), mimetype="application/json")

            user = user[0]
            user.password = make_password(password)
            user.group = group.key
            user.email = email if email else None
            user.is_staff = is_staff
            user.is_active = is_active
            user.is_superuser = True if group.key == USER_GROUP_ADMIN else False
            user.save()

            response["success"] = True
            response["error"] = "执行成功!"
            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception, e:
            response["error"] = "系统异常![%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")


# 查看客户
@csrf_exempt
@login_required
def view(request):
    if request.method == "GET":
        try:
            cus_id = request.GET.get("cus_id", None)
            if cus_id is None:
                error = '查看用户时ID为空!'
                logger.error(error)
                return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))

            return render_to_response("customer/customer_create.html", locals(), context_instance=RequestContext(request))
        except Exception as e:
            error = '查看用户异常![%s]' % str(e)
            logger.error(error + getTraceBack())
            return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))
    elif request.method == 'POST':
        error = "非法请求方式!"
        logger.error(error)
        return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))


# 用户列表
@csrf_exempt
@login_required
def user_list(request):
    users = User.objects.all().order_by('-date_joined')
    return render_to_response("user/user_list.html", locals(), context_instance=RequestContext(request))


# 删除客户
@csrf_exempt
@login_required
def delete(request):
    response = {"success": False, "error": ""}
    try:
        # 校验参数
        id = request.POST.get('id', None)

        if not id:
            response["error"] = "必要参数为空!"
            return HttpResponse(json.dumps(response), mimetype="application/json")

        user = User.objects.get(pk=id)
        user.delete()

        response["success"] = True
        response["error"] = "执行成功!"
        return HttpResponse(json.dumps(response), mimetype="application/json")
    except Exception, e:
        response["error"] = "系统异常![%s]" % str(e)
        logger.error(response["error"] + getTraceBack())
        return HttpResponse(json.dumps(response), mimetype="application/json")


