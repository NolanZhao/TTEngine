#encoding=utf-8
from django.conf.urls import patterns, url


urlpatterns = patterns(
    '',
    #创建版本包
    url(r'^create/', 'package.views.create'),
    #版本包列表
    url(r'^list/', 'package.views.list'),
    #版本包查看
    url(r'^view/', 'package.views.view'),
    #版本包编辑
    url(r'^edit/', 'package.views.edit'),
    #启用版本
    url(r'^enable/$', 'package.views.change_status'),
    #禁用版本
    url(r'^disable/$', 'package.views.change_status'),
    #删除版本
    url(r'^delete_package/$', 'package.views.delete_package'),
    #下载版本
    url(r'^download_package/$', 'package.views.download_package'),
)
