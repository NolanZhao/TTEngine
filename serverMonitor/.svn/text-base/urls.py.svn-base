__author__ = 'zhaoxu'
# encoding=utf-8
from django.conf.urls import patterns, include, url

urlpatterns = patterns(
    '',
    #显示监控类型列表
    url(r'^logType/$', 'serverMonitor.views.serverMonitor_type_list'),
    #编辑监控项
    url(r'^logType/edit/$', 'serverMonitor.views.serverMonitor_type_edit'),
    #添加监控项
    url(r'^logType/add/$', 'serverMonitor.views.serverMonitor_type_add'),
    #保存监控项
    url(r'^logType/save/$', 'serverMonitor.views.serverMonitor_type_save'),
    #删除监控项
    url(r'^logType/del/$', 'serverMonitor.views.serverMonitor_type_del'),
    # 监控日志列表
    url(r'^logList/', 'serverMonitor.views.logList'),
    # 监控日志提交
    url(r'^logPost/', 'serverMonitor.views.logPost'),
    # 上传附件
    url(r'^uploadFile/', 'serverMonitor.views.uploadFile'),
    # 监控列表
    url(r'^getLogList/', 'serverMonitor.views.getLogList'),
    # 客户日志详情页面
    url(r'^getLogListDetailPage/', 'serverMonitor.views.getLogListDetailPage'),
    # 客户日志详情
    url(r'^getLogListDetail/', 'serverMonitor.views.getLogListDetail'),
    # 显示监控模块
    url(r'^monitorModule/', 'serverMonitor.views.monitorModule_show'),
    # 编辑监控模块
    url(r'^monitorModule_edit/', 'serverMonitor.views.monitorModule_edit'),
    # 添加监控模块
    url(r'^monitorModule_add/', 'serverMonitor.views.monitorModule_add'),
    # 保存监控模块
    url(r'^monitorModule_save/', 'serverMonitor.views.monitorModule_save'),
    # 删除监控模块
    url(r'^monitorModule_del/', 'serverMonitor.views.monitorModule_del'),
)
