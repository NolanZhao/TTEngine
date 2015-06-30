# encoding=utf-8
__author__ = 'nerve'

from django import template
from django.conf import settings
from module.models import RunInfo
# import chardet
import json
from TTEngine.constants import *
from customer.models import CustomerPermissionSettings, Machine
from module.models import FileInfo
from utils.OsHelper import OS_TYPES
from usrmgr.models import UserGroup

register = template.Library()


@register.simple_tag
def settings_value(name):
    """
    自定义标签
    :param name:
    :return:
    """
    return getattr(settings, name, "")


@register.filter(is_safe=True)
def encode(value):
    # if chardet.detect(value.encode(settings.ENCODE))["encoding"] != 'utf-8':
    # return value
    # else:
    # return value.encode(settings.ENCODE)
    return value


@register.filter(is_safe=True)
def parseRunInfoType(value):
    if not value:
        return '-'
    return RunInfo.runTypeDict[value]


@register.filter(is_safe=True)
def get_module_row_span(value):
    file_length = len(value.files)
    if file_length > 0:
        file_length += 1
    runInfos_length = len(value.runInfos)
    if runInfos_length > 0:
        runInfos_length += 1
    return 1 + runInfos_length + file_length


@register.filter(is_safe=True)
def get_customer_row_span(value):
    file_length = len(value.machines)
    if file_length > 0:
        file_length += 1
    return 1 + file_length


@register.filter(is_safe=True)
def parse_operate_type(value):
    if value == OPERATE_CREATE:
        return '<span style="color: green">创建</span>'
    elif value == OPERATE_UPDATE:
        return '更新'
    elif value == OPERATE_DELETE:
        return '<span style="color: blue">删除</span>'
    else:
        '<span style="font-weight: bolder">未知</span>'


@register.filter(is_safe=True)
def parse_result_type(value):
    template.Node()
    if value == RESULT_TYPE_FAILURE:
        return '<span style="color: red;font-weight: bolder">失败</span>'
    elif value == RESULT_TYPE_SUCCESS:
        return '成功'
    else:
        '<span style="font-weight: bolder">未知</span>'


@register.filter(is_safe=True)
def parse_machine_type(value):
    result = Machine.get_machine_type_name(value)
    if result:
        return result
    else:
        return '未知类型'


@register.filter(is_safe=True)
def parse_os_type(value):
    result = OS_TYPES.get(value, "未知")
    return result


@register.filter(is_safe=True)
def parse_file_type(value):
    result = FileInfo.get_file_type_name(value)
    return result


compile_status = {
    1: '成功',
    0: "失败",
    -1: "进行中",
}


@register.filter(is_safe=True)
def parse_compile_status(value):
    return compile_status[int(value)]


@register.filter(is_safe=True)
def set_length(value, length):
    if len(value) >= length:
        return value
    else:
        return value + (length - len(value)) * '-'


@register.filter(is_safe=True)
def get_permission_name(value):
    if not value:
        return None
    obj = CustomerPermissionSettings.objects.get(pk=value)
    if obj is not None:
        return obj.name
    else:
        return None


@register.filter(is_safe=True)
def get_permission_remark(value):
    if not value:
        return None
    obj = CustomerPermissionSettings.objects.get(pk=value)
    if obj is not None:
        return obj.remark
    else:
        return None


@register.filter(is_safe=True)
def get_permission_default_value(value):
    if not value:
        return None
    obj = CustomerPermissionSettings.objects.get(pk=value)
    if obj is not None:
        if obj.value_type == 'Boolean':
            return 'True' if obj.value == 'true' else 'False'
        elif obj.value_type == 'Number':
            return obj.value
    else:
        return None


@register.filter(is_safe=True)
def get_permission_type(value):
    if not value:
        return None
    obj = CustomerPermissionSettings.objects.get(pk=value)
    if obj is not None:
        return obj.value_type
    else:
        return None


@register.filter(is_safe=True)
def cus_perm_contain(value, obj_id):
    if value and value.has_key(str(obj_id)):
        return True
    return False


@register.filter(is_safe=True)
def cus_perm_get(value, obj_id):
    if value and value.has_key(str(obj_id)):
        return value[str(obj_id)]
    return ''


@register.filter(is_safe=True)
def parse_svn_url(value):
    if value:
        value_list = value.split('/')
        return '...' + value_list[len(value_list) - 1]
    else:
        return '-'


@register.filter(is_safe=True)
def parse_color(value):
    value = int(value)
    return "white" if value % 2 == 0 else " #F7F7F7"


@register.filter(is_safe=True)
def parse_svn_program_color(value):
    color_dict = {}
    for index, name in enumerate(ALL_SVN_LIST):
        color_dict[name] = 'white' if index % 2 == 0 else '#ECF5FF'
    return color_dict.get(value, 'yellow')


@register.filter(is_safe=True)
def get_svn_new_reversion(dict_value, key):
    return dict_value[key][0]


@register.filter(is_safe=True)
def get_svn_new_message(dict_value, key):
    return dict_value[key][1]


@register.filter(is_safe=True)
def get_group_value(key):
    return UserGroup.objects(key=key)[0].value


@register.filter(is_safe=True)
def generator_menu(user):
    group_key = user.group
    html = ''
    group_perm_list = get_user_group_perm(group_key)
    if not group_perm_list:
        return html

    for index, item in enumerate(group_perm_list):
        type = item[0]
        name = item[1]
        url = item[4]
        if type == MENU_MAIN:
            html += '<div title="%s" data-options="onResize:setMenuHeight">' % name
            # html += '<div title="%s" data-options="collapsed:false, onResize:setMenuHeight">' % name
        elif type == MENU_SUB:
            html += '<a href="#" data-src="%s" class="sub-menu">%s</a>' % (url, name)
            # 需要关闭标签
            if index == len(group_perm_list) - 1 or group_perm_list[index + 1][0] == MENU_MAIN:
                html += '</a>'
                html += '</div>'
    return html


def get_user_group_perm(group_key):
    """
    获取组权限配置
    :param group_key:
    """
    for item in USER_GROUP_LIST:
        if item.get('k') == group_key:
            return item.get('m')


@register.filter(name='access')
def access(value, arg):
    if arg in value:
        return value[arg]
    else:
        return None