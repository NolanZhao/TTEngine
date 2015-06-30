# encoding=utf-8
import sys

reload(sys)
sys.setdefaultencoding('utf-8')
import json
import datetime
import traceback
from django.contrib.auth.decorators import login_required
from django.template import RequestContext
from django.shortcuts import render_to_response
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth import authenticate, SESSION_KEY, BACKEND_SESSION_KEY
from django.http import HttpResponse, HttpResponseRedirect
from mongoengine import *
from utils.TracebackHelper import getTraceBack
from customer.views import cus_list
import logging
from django.contrib.sessions.models import Session

logger = logging.getLogger('django')


@login_required()
def home(request):
    user = request.user
    return render_to_response("z_new/index.html", locals(), context_instance=RequestContext(request))


@csrf_exempt
def login(request):
    if request.method == "GET":
        logger.info('跳转到登陆界面')
        if request.user.id is None:
            return render_to_response("login.html", locals(), context_instance=RequestContext(request))
        return render_page(request, "index.html", locals())
    else:
        logger.info('点击登陆')
        response = {"success": False, "error": ""}
        try:
            username = request.POST.get("username")
            password = request.POST.get("password")
            user = authenticate(username=username, password=password)
            if user:
                # 判断是否允许登陆
                is_staff = user.is_staff
                is_active = user.is_active
                is_superuser = user.is_superuser

                if not is_staff:
                    response["error"] = "禁止登陆!"
                    return HttpResponse(json.dumps(response), mimetype="application/json")

                if not is_active:
                    response["error"] = "用户未启用!"
                    return HttpResponse(json.dumps(response), mimetype="application/json")

                login_on_server(request, user)
                response["success"] = True
                response["error"] = "执行成功!"
            else:
                response["error"] = "登陆失败!"
            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception as e:
            response["error"] = str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")


def logout(request):
    if request.user.is_authenticated():
        try:
            logout_on_server(request)
        except Exception as e:
            pass
    return HttpResponseRedirect("/login/")


def logout_on_server(request):
    user = getattr(request, 'user', None)

    from django.contrib.auth.signals import user_logged_out

    if hasattr(user, 'is_authenticated') and not user.is_authenticated():
        user = None
    user_logged_out.send(sender=user.__class__, request=request, user=user)

    request.session.flush()
    if hasattr(request, 'user'):
        from django.contrib.auth.models import AnonymousUser

        request.user = AnonymousUser()


def login_on_server(request, user):
    try:
        if user is None:
            user = request.user
        if SESSION_KEY in request.session:
            if request.session[SESSION_KEY] != user.id:
                request.session.flush()
        else:
            request.session.cycle_key()
        request.session[SESSION_KEY] = user.id
        request.session[BACKEND_SESSION_KEY] = user.backend
        if hasattr(request, 'user'):
            request.user = user
        user.last_login = datetime.datetime.now()
        user.save()
    except Exception, e:
        logger.error(str(e) + getTraceBack())
        raise e


def render_page(request, tpl, contexts):
    return render_to_response(tpl, contexts, context_instance=RequestContext(request))