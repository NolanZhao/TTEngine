# encoding=utf-8
from django.conf.urls import patterns, url


urlpatterns = patterns(
    '',
    url(r'^create/$', 'programBranch.views.create'),
    url(r'^list/$', 'programBranch.views.svn_list'),
    # 重新加载SVN分支信息
    url(r'^load/$', 'programBranch.views.load'),
    url(r'^operate/$', 'programBranch.views.operate'),
    url(r'^key/create/$', 'programBranch.views.key_create'),
    url(r'^key/list/$', 'programBranch.views.key_list'),
    url(r'^key/del/$', 'programBranch.views.key_del'),
    url(r'^svn/list/$', 'programBranch.views.svn_list_read'),
)
