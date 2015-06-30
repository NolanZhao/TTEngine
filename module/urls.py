# encoding=utf-8
from django.conf.urls import patterns, include, url


urlpatterns = patterns(
    '',
    # 创建模块
    url(r'^create/$', 'module.views.create'),
    # 创建模块组
    url(r'^createGroup/$', 'module.views.createGroup'),
    # 模块列表
    url(r'^list/$', 'module.views.list'),
    # 模块组
    url(r'^group/$', 'module.views.groupList'),
    # 编辑模块
    url(r'^edit/$', 'module.views.edit'),
    # 查看模块
    url(r'^view/$', 'module.views.view'),
    # 删除模块
    url(r'^del/$', 'module.views.del_module'),
    # 删除模块组
    url(r'^delGroup/$', 'module.views.del_group'),
    # 查看更新记录
    url(r'^log/$', 'module.views.log'),
)
