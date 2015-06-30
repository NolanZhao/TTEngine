# encoding=utf-8
import sys

reload(sys)
sys.setdefaultencoding('utf-8')
__author__ = 'nerve'

from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.decorators import login_required
from django.shortcuts import render_to_response, redirect
from django.template import RequestContext
import logging
from programBranch.models import BranchInfo, getLocalDir, KeySubmit
from usrmgr.models import User
from programBranch.makeBranch import BranchMaker
import os, datetime, time
import pysvn
from django.http import HttpResponse
import json
from utils.TracebackHelper import getTraceBack
from subprocess import Popen, PIPE
from customer.models import Customer
from mongoengine.queryset.visitor import *
from utils.svn_utils import SvnUtils
from TTEngine.constants import *

logger = logging.getLogger('django')


@csrf_exempt
@login_required
def create(request):
    """
    创建分支
    :param request:
    :return:
    """
    if request.method == "GET":
        src_version = -1
        src_branch = "trunk"
        dst_branch = "tags/"
        customer_tag = request.GET.get("customerTag", None)
        if customer_tag is not None:
            dst_branch = "tags/" + customer_tag + "_" + datetime.datetime.now().strftime("%Y%m%d")
        branches = PROGRAM_LIST4SVN
        return render_to_response("programBranch/programBranch_create.html", locals(), context_instance=RequestContext(request))
    elif request.method == 'POST':
        SRC_REVISION = request.POST.get("src_version", -1)
        SRC_BRANCH = request.POST.get("src_branch", None).strip()
        DST_BRANCH = request.POST.get("dst_branch", None).strip()
        # TODO 客户标记这个参数并没有用到
        CUSTOM_TAG = request.POST.get("customer_tag", None).strip()
        if (SRC_BRANCH is None) or (len(SRC_BRANCH) == 0):
            error = "源路径设置有误为空"
            logger.error(error)
            return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))
        if (DST_BRANCH is None) or (len(DST_BRANCH) == 0):
            error = "目标路径设置有误为空"
            logger.error(error)
            return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))
        branches = request.POST.getlist("svn_branches")
        client = pysvn.Client()
        for x in branches:
            localDir = getLocalDir(x)
            maker = BranchMaker(localDir, SRC_BRANCH, DST_BRANCH, SRC_REVISION)
            try:
                maker.main()
            except Exception as e:
                error = e.message
                logger.error(error)
                return render_to_response('item/temp.html', locals(), context_instance=RequestContext(request))
        return redirect("/programBranch/load/")


@csrf_exempt
@login_required
def svn_list(request):
    """
    版本列表
    :param request:
    :return:
    """
    branches = BranchInfo.objects().order_by('-programName')
    return render_to_response("programBranch/programBranch_list.html", locals(), context_instance=RequestContext(request))


def getCustomerTag(name):
    tag = ""
    if len(name) > 9:
        try:
            date = int(name[-8:])
            tag = name[0:-9]
        except:
            pass
    items = tag.split("/")
    if len(items) == 2:
        tag = items[1]
    return tag


def getCreateDate(name):
    date = ""
    if len(name) > 9:
        try:
            dateInt = int(name[-8:])
            date = name[-8:]
        except:
            pass
    return date


def getBranches(client, url, tag):
    ret = []
    subs = client.ls(url + "/" + tag)
    for x in subs:
        items = x.name.split("/")
        if len(items) > 0:
            ret.append(tag + "/" + items[-1])
    return ret


@csrf_exempt
@login_required
def load(request):
    """
    版本列表
    :param request:
    :return:
    """
    client = pysvn.Client()
    logger.info("load svn")

    for program in ALL_SVN_LIST:
        dir = getLocalDir(program)
        url = client.info(dir).data['url']
        logger.info("program:[%s],url:[%s]" % (program, url))
        # trunk
        info = None
        try:
            info = BranchInfo.objects().get(programName=program, branchTag="trunk")
        except:
            pass
        if info is None:
            info = BranchInfo()
            info.programName = program
            info.branchTag = "trunk"
            info.createDate = "999999"
            info.save()

        branches = []
        branches.extend(getBranches(client, url, "branches"))
        try:
            branches.extend(getBranches(client, url, "tags"))
        except Exception as e:
            pass
        for x in branches:
            info = None
            try:
                info = BranchInfo.objects().get(programName=program, branchTag=x)
            except:
                pass
            if info is None:
                info = BranchInfo()
                info.programName = program
                info.branchTag = x
                customerTag = getCustomerTag(x)
                customer = Customer.objects(tag=customerTag)
                if len(customer) > 0:
                    info.customerTag = customerTag
                info.createDate = getCreateDate(x)
                info.save()
    return redirect("/programBranch/list/", locals())


@csrf_exempt
@login_required
def operate(request):
    """
    SVN相关操作
    :param request:
    :return:
    """
    response = {"success": False, "error": ""}

    if request.method == "POST":
        try:
            # 获取参数
            cmd = request.POST.get('cmd', None)
            id = request.POST.get('id', None)

            if not cmd or not id:
                response["error"] = "必要参数为空!"
                return HttpResponse(json.dumps(response), mimetype="application/json")

            branch = BranchInfo.objects(pk=id)

            if len(branch) == 0:
                response["error"] = "未找到对象!"
                return HttpResponse(json.dumps(response), mimetype="application/json")

            branch = branch[0]

            path = getLocalDir(branch.programName) + "/" + branch.branchTag

            # 直接删除URL,无须变更操作目录
            if cmd != 'delete':
                os.chdir(path)

            if cmd == 'update':
                p = Popen(["svn", "up"], stdin=PIPE, stdout=PIPE, stderr=PIPE)
                outStr, errorStr = p.communicate()
                if len(errorStr) > 0:
                    response["error"] = '更新失败![%s]' % errorStr
                    return HttpResponse(json.dumps(response), mimetype="application/json")

            elif cmd == 'clean':
                p = Popen(["make", "clean"], stdin=PIPE, stdout=PIPE, stderr=PIPE)
                p.wait()

            elif cmd == 'compile':
                p = Popen(["make", "-j8", "all"], stdin=PIPE, stdout=PIPE, stderr=PIPE)
                outStr, errorStr = p.communicate()
                if len(errorStr) > 0:
                    response["error"] = '编译失败![%s]' % errorStr
                    return HttpResponse(json.dumps(response), mimetype="application/json")
            elif cmd == 'delete':
                svn_url = SvnUtils.get_svn_url(branch.programName, branch.branchTag)
                logger.info('删除目录 : [%s]!' % svn_url)
                if SvnUtils().svn_url_exists(svn_url):
                    p = Popen(["svn", "delete", "-m", "%s delete %s" % (User.objects.get(pk=request.user.id).username, svn_url), svn_url], stdin=PIPE, stdout=PIPE, stderr=PIPE)
                    outStr, errorStr = p.communicate()
                    if len(errorStr.strip()) > 0 and not str(errorStr).startswith('svn: E160013:'):
                        response["error"] = '删除失败![%s]' % errorStr
                        return HttpResponse(json.dumps(response, ensure_ascii=False), mimetype="application/json")
                branch.delete()
                response["id"] = id
            else:
                response["error"] = "限制操作!"
                return HttpResponse(json.dumps(response), mimetype="application/json")

            response["success"] = True
            response["error"] = "执行成功!"
            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception, e:
            response["error"] = "系统异常![%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")
    else:
        response["error"] = "请使用http-post方法请求!"
        return HttpResponse(json.dumps(response), mimetype="application/json")


@csrf_exempt
@login_required
def key_create(request):
    if request.method == "GET":
        branchs = BranchInfo.objects().order_by('-programName', 'branchTag')

        program_list = []
        tag_dict = {}

        for branch in branchs:
            program_name = branch.programName
            if program_name in tag_dict:
                tag_dict[program_name].append({
                    'id': str(branch.id),
                    'tag': branch.branchTag
                })
            else:
                program_list.append(program_name)
                tag_dict[program_name] = [{'id': str(branch.id), 'tag': branch.branchTag}]

        program_list_json = json.dumps(program_list)
        tag_dict_json = json.dumps(tag_dict)
        return render_to_response("programBranch/key_submit_create.html", locals(), context_instance=RequestContext(request))
    elif request.method == 'POST':
        response = {"success": False, "error": ""}
        try:
            # 获取参数
            json_str = request.POST.get('json', None)

            if not json_str:
                response['error'] = '必要参数为空!'
                return HttpResponse(json.dumps(response), mimetype="application/json")

            json_obj = json.loads(json_str)

            remark = json_obj['remark']
            id = json_obj['id']
            revision_1 = int(json_obj['revision_1'])
            revision_2 = json_obj['revision_2']
            revision_2 = revision_1 if revision_2 is None else int(revision_2)

            branch = BranchInfo.objects(pk=id)

            if not branch:
                response['error'] = '未找到分支对象!'
                return HttpResponse(json.dumps(response), mimetype="application/json")

            branch = branch[0]

            # 验证是否重叠
            exists = KeySubmit.objects(branch=branch, revision_start__lte=revision_1, revision_end__gte=revision_2)

            if exists:
                response['error'] = '关键提交重叠!'
                return HttpResponse(json.dumps(response), mimetype="application/json")

            key_submit = KeySubmit()
            key_submit.branch = branch
            key_submit.revision_start = revision_1
            key_submit.revision_end = revision_2
            key_submit.remark = remark
            key_submit.create_time = datetime.datetime.now()
            key_submit.create_user = User.objects.get(pk=request.user.id)
            key_submit.save()

            response["success"] = True
            response["error"] = "执行成功!"
            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception, e:
            response["error"] = "系统异常![%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")


@csrf_exempt
@login_required
def key_list(request):
    if request.method == "GET":
        submits = KeySubmit.objects().order_by('branch', 'revision_start')
        return render_to_response("programBranch/key_submit_list.html", locals(), context_instance=RequestContext(request))
    else:
        response = {"success": False, "error": "请使用http-get方法请求!"}
        return HttpResponse(json.dumps(response), mimetype="application/json")


@csrf_exempt
@login_required
def key_del(request):
    if request.method == "POST":
        response = {"success": False, "error": ""}
        try:
            id = request.POST.get('id', None)
            if not id:
                response['error'] = '必要参数为空!'
                return HttpResponse(json.dumps(response), mimetype='application/json')

            submit = KeySubmit.objects(pk=id).first()

            if not submit:
                response['error'] = '未找到对象!'
                return HttpResponse(json.dumps(response), mimetype='application/json')

            submit.delete()
            response['success'] = True
            response['error'] = '执行成功!'
            return HttpResponse(json.dumps(response), mimetype='application/json')
        except Exception as e:
            response['error'] = '程序异常![%s]' % e.message
            logger.error(response['error'] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype='application/json')
    else:
        response = {"success": False, "error": "请使用http-post方法请求!"}
        return HttpResponse(json.dumps(response), mimetype="application/json")


@login_required
def svn_list_read(request):
    response = {"success": False, "error": ""}

    if request.method == "GET":
        try:
            id = request.GET.get('id', None)
            revision_start_number = request.GET.get('revision_start', None)
            revision_end_number = request.GET.get('revision_end', None)
            limit = int(request.GET.get('limit', 30))

            if not id:
                response['error'] = '你要参数为空!'
                return HttpResponse(json.dumps(response), mimetype="application/json")

            branch = BranchInfo.objects(pk=id)

            if not branch:
                response['error'] = '未找到分支对象!'
                return HttpResponse(json.dumps(response), mimetype="application/json")

            branch = branch[0]

            # 读取最近50条更新
            svn_url = SvnUtils.get_svn_url(branch.programName, branch.branchTag)

            client = pysvn.Client()
            revision_start = pysvn.Revision(pysvn.opt_revision_kind.head)
            if revision_start_number:
                revision_start = pysvn.Revision(pysvn.opt_revision_kind.number, int(revision_start_number))
                limit += 1

            revision_end = pysvn.Revision(pysvn.opt_revision_kind.number, 0 if not revision_end_number else revision_end_number)

            svn_logs = client.log(svn_url, revision_start=revision_start, revision_end=revision_end, limit=limit)

            if revision_start_number:
                # 过滤掉页面已有数据
                svn_logs = svn_logs[1:]

            svn_log_json = convert_svn_log_json(svn_logs)

            key_submit_dict = {}
            if svn_logs:
                svn_revision_start = svn_logs[0].data['revision'].number
                svn_revision_end = svn_logs[len(svn_logs) - 1].data['revision'].number

                # 查询已有关键提交,标记之
                key_submits = KeySubmit.objects(Q(branch=branch) & (Q(revision_end__lte=svn_revision_start) & Q(revision_end__gte=svn_revision_end)) | (Q(revision_start__lte=svn_revision_start) & Q(revision_start__gte=svn_revision_end))).order_by('-revision_start')
                for item in key_submits:
                    revision_start_item = item.revision_start
                    revision_end_item = item.revision_end
                    # 版本号开始在区间内
                    if svn_revision_start >= revision_start_item >= svn_revision_end:
                        result = {'type': ['start'], 'remark': item.remark, 'create_user': item.create_user.username, 'id': str(item.id), 'time': item.create_time.strftime('%Y-%m-%d %H:%M:%S')}
                        key_submit_dict[revision_start_item] = result
                    # 版本号结束在区间内
                    if svn_revision_start >= revision_end_item >= svn_revision_end:
                        result = {'type': ['end'], 'remark': item.remark, 'create_user': item.create_user.username, 'id': str(item.id), 'time': item.create_time.strftime('%Y-%m-%d %H:%M:%S')}
                        if revision_end_item in key_submit_dict:
                            key_submit_dict[revision_end_item]['type'].append('end')
                        else:
                            key_submit_dict[revision_end_item] = result

            response['data'] = svn_log_json
            response['key_submit'] = key_submit_dict
            response['success'] = True
            return HttpResponse(json.dumps(response), mimetype="application/json")
        except Exception as e:
            response["error"] = "程序异常![%s]" % str(e)
            logger.error(response["error"] + getTraceBack())
            return HttpResponse(json.dumps(response), mimetype="application/json")

    else:
        response['error'] = '请使用Http-GET方式请求!'
        return HttpResponse(json.dumps(response), mimetype="application/json")


def convert_svn_log_json(svn_logs):
    result = []
    for svn_log in svn_logs:
        data = svn_log.data
        result.append({
            'author': data['author'],
            'revision': data['revision'].number,
            'message': data.get('message', ''),
            'date_time': time.strftime('%Y-%m-%d %H:%M:%S', time.gmtime(data['date']))
        })
    return result