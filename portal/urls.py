# encoding=utf-8
from django.conf.urls import patterns, url


urlpatterns = patterns(
    '',
    #编译机参数查看
    url(r'^machine/view/$', 'portal.views.machine_view'),
    #编译机参数保存,删除
    url(r'^machine/operate/$', 'portal.views.machine_operate'),
    #生成portal程序包
    url(r'^package/create/$', 'portal.views.portal_package_create'),
    #portal包列表
    url(r'^package/list/$', 'portal.views.portal_package_list'),
    #启用禁用
    url(r'^package/change_is_enabled/$', 'portal.views.change_is_enabled'),
    #删除
    url(r'^package/del/$', 'portal.views.delete'),
    #下载程序包
    url(r'^package/download_package/$', 'portal.views.download_package'),
    #下载SQL
    url(r'^package/download_sql/$', 'portal.views.download_sql'),
    #查看Portal包详情
    url(r'^package/view/$', 'portal.views.package_view'),
    #编辑Portal包详情
    url(r'^package/edit/$', 'portal.views.package_edit'),
    #程序自动生成升级脚本
    url(r'^update/gen_sql/$', 'portal.views.update_gen_sql'),
    #上传两不同版本sql文件自动生成升级脚本
    url(r'^update/uploadfile_gen_sql/$', 'portal.views.uploadfile_gen_sql'),
    #上传SQL文件
    url(r'^update/uploadFile/$', 'portal.views.uploadFile'),
    #快速生成升级脚本
    url(r'^update/quick_gen_sql/$', 'portal.views.quick_gen_sql'),
    #邻近版本升级的脚本
    url(r'^update/update_sql/$', 'portal.views.update_sql'),
    #查询生成邻近版本升级的脚本进度
    url(r'^update/sqlgen_process_info/$', 'portal.views.sqlgenProcessInfo'),
    #下载邻近版本升级脚本
    url(r'^update/download_update_sql/$', 'portal.views.download_update_sql'),
    #下载比对生成的升级脚本
    url(r'^update/download/$', 'portal.views.download_upgrade_sql'),
    #下载快速拼接生成的升级脚本
    url(r'^update/download_quickgen_sql/$', 'portal.views.download_quickgen_sql'),
    #编译机参数查看
    url(r'^login_test/$', 'portal.views.login_test'),
    # 更新svn
    url(r'^update_svn/$', 'portal.views.update_svn'),
    # 获取 最新svn版本号
    url(r'^get_svn_info/$', 'portal.views.get_svn_info'),
)
