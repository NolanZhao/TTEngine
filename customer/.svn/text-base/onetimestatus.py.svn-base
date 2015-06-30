__author__ = 'rzrk001'
# encoding=utf-8
import pysvn
import os
import traceback
import datetime
from customer.models import CustomerDeployStatus,Customer,CustomerDeployRecord
from django.http import HttpResponse
import json
from utils.svn_utils import SvnUtils
def main():
    response = {"success": False, "error": ""}
    customers = Customer.objects.order_by('-create_time')


    machine_json = {'portal_svn_info':[],'server_svn_info':[]}
    i=0
    for customer in customers:
        i +=1
        print i
        if not customer:
            response['error'] = '查找客户失败!'
            return HttpResponse(json.dumps(response, ensure_ascii=False), mimetype="application/json")

        customerdeploystatus  = CustomerDeployStatus()
        customerdeploystatus.customer = customer
        if not customer.machines:
            customerdeploystatus.state = 'unkown'
            customerdeploystatus.save()
            continue
        machines = customer.machines
        portal_is_old = False
        server_is_old = False
        customerdeploystatus.machines = machines

        records = CustomerDeployRecord.objects(customer=customer).order_by("-start_time")

        server_key_submits = []
        portal_key_submits = []

        if len(records) == 0:
            customerdeploystatus.state = '未知'
            customerdeploystatus.save()
            continue

        record = records[0]

        cus_pack = record.cus_package
        portal_package = cus_pack.portal_package
        server_pack = cus_pack.machine_packages[0]
        if not server_pack:
            response['error'] = '查找server包失败!'
            return HttpResponse(json.dumps(response, ensure_ascii=False), mimetype="application/json")
        if not portal_package:
            response['error'] = '查找portal包失败!'
            return HttpResponse(json.dumps(response, ensure_ascii=False), mimetype="application/json")

        #判断portal的svn_url和server的svn_url是否存在
        if not portal_package.svn_url and not server_pack.svn_info:
            customerdeploystatus.state = '未知'
            customerdeploystatus.save()
            continue
        if portal_package.svn_url :
            machine_json['portal_svn_info'],portal_is_old,portal_key_submits = get_portal_status(portal_package)

        if server_pack.svn_info:
            machine_json['server_svn_info'],server_is_old,server_key_submits = get_serve_status(server_pack.svn_info)

        #判断是否为关键更新
        if (portal_is_old and portal_key_submits) or (server_key_submits and server_is_old):
            customerdeploystatus.portal_svn_info = machine_json['portal_svn_info']
            customerdeploystatus.server_svn_info = machine_json['server_svn_info']
            customerdeploystatus.state = '关键更新'
        elif portal_is_old or server_is_old :
            customerdeploystatus.portal_svn_info = machine_json['portal_svn_info']
            customerdeploystatus.server_svn_info = machine_json['server_svn_info']
            customerdeploystatus.state = '有更新'
        else:
            customerdeploystatus.state = '未知'
        customerdeploystatus.portal_is_old = portal_is_old
        customerdeploystatus.server_is_old = server_is_old
        customerdeploystatus.create_time = datetime.datetime.now()
        customerdeploystatus.save()


    return HttpResponse(json.dumps(response, ensure_ascii=False), mimetype="application/json")






def get_portal_status(portal_pack):
    svn_utils = SvnUtils()
    svn_url = portal_pack.svn_url
    portal_is_old = False
    current_revision = svn_utils.get_current_svn_revision(svn_url)
    previous_revision = int(portal_pack.svn_version)
    if current_revision > previous_revision:
        portal_is_old = True
    machine_json = {'portal_svn_info':[]}
    portal_json = {
        'svn_url': svn_url,
        'previous_revision': previous_revision,
        'current_revision': current_revision,
        'is_old': portal_is_old,
        'key_submits': []
    }
    portal_key_submits = svn_utils.get_key_submit_by_revision(svn_url, previous_revision, revision_start=current_revision)
    if portal_key_submits:
        for key_submit in portal_key_submits:
            d = {
                'start': key_submit.revision_start,
                'end': key_submit.revision_end,
                'remark': key_submit.remark
            }
            portal_json['key_submits'].append(d)
    machine_json['portal_svn_info'].append(portal_json)
    return machine_json['portal_svn_info'],portal_is_old,portal_key_submits

def get_serve_status(svn_info):
    server_is_old = False
    if svn_info:
        svn_info = json.loads(svn_info)
        svn_utils= SvnUtils()
        machine_json = {'server_svn_info':[]}
        for server_svn_url in svn_info:
            value = svn_info[server_svn_url]
            server_previous_revision = value[1]
            server_current_revision = svn_utils.get_current_svn_revision(server_svn_url)
            branch_is_old = False
            if server_current_revision > server_previous_revision:
                server_is_old = True
                branch_is_old = True
            server_json = {
                'server_svn_url': server_svn_url,
                'server_previous_revision': server_previous_revision,
                'server_current_revision': server_current_revision,
                'is_old': branch_is_old,
                'key_submits': []
            }

            server_key_submits = svn_utils.get_key_submit_by_revision(server_svn_url, server_previous_revision, revision_start=server_current_revision)
            for server_key_submit in server_key_submits:
                server_json['key_submits'].append({
                    'start': server_key_submit.revision_start,
                    'end': server_key_submit.revision_end,
                    'remark': server_key_submit.remark
                })
            machine_json['server_svn_info'].append(server_json)

    return machine_json['server_svn_info'],server_is_old,server_key_submits


if '__main__' == __name__:
    main()

