# encoding=utf-8
from django.conf.urls import patterns, include, url


urlpatterns = patterns(
    '',
    # 创建客户
    url(r'^create/$', 'customer.views.create'),
    # 创建系统客户
    url(r'^system/create/$', 'customer.views.create'),
    #更新状态
    url(r'^customer/compare/$', 'customer.views.compare'),
    # 客户列表
    url(r'^list/$', 'customer.views.cus_list'),
    # 系统客户列表
    url(r'^system/list/$', 'customer.views.cus_list'),
    # 删除客户
    url(r'^del/$', 'customer.views.del_cus'),
    # 编辑客户
    url(r'^edit/$', 'customer.views.edit'),
    # 查看客户
    url(r'^view/$', 'customer.views.view'),
    # 查看更新记录
    url(r'^log/$', 'customer.views.log'),
    # 全部客户备注列表
    url(r'^remark/list/$', 'customer.views.remark_list'),
    # 指定客户备注列表
    url(r'^tips/$', 'customer.views.tips'),
    # 客户备注创建
    url(r'^tips/create/$', 'customer.views.tips_create'),
    # 客户备注删除
    url(r'^tips/del/$', 'customer.views.tips_del'),
    # 客户备注文件下载
    url(r'^tips/download/$', 'customer.views.tips_download'),
    # 指定ID编辑tips
    url(r'^tips/edit/$', 'customer.views.tips_edit'),
    # 更新记录删除
    url(r'^log/delete/$', 'customer.views.log_delete'),
    # 权限项查看
    url(r'^permission/view/$', 'customer.views.permission_view'),
    # 权限项编辑
    url(r'^permission/edit/$', 'customer.views.permission_edit'),
    #权限项删除
    url(r'^permission/del/$', 'customer.views.permission_del'),
    # 添加升级记录
    url(r'^deploy/record/$', 'customer.views.deploy_record'),
    # 删除升级记录[old]
    url(r'^deploy/record/del/$', 'customer.views.deploy_record_del'),
    # 删除客户升级记录
    url(r'^deploy/cus_record/del/$', 'customer.views.deploy_cus_record_del'),
    # 添加升级记录,顺带录入版本库
    url(r'^deploy/record/quick/$', 'customer.views.deploy_record_quick'),
    # 查看升级记录
    url(r'^deploy/record/list/$', 'customer.views.deploy_record_list'),
    #编辑升级记录
    url(r'^deploy/record/list/edit/$', 'customer.views.deploy_record_list_edit'),
    #发送邮件
    url(r'^deploy/record/list/email/$', 'customer.views.deploy_record_list_email'),
    # 查看所有升级记录
    url(r'^all/deploy/record/list/$', 'customer.views.all_deploy_record_list'),
    #所有升级记录--查询
    url(r'^all/deploy/record/list/search/$', 'customer.views.all_deploy_record_list_search'),
    # 显示检查升级页面
    url(r'^deploy/record/check/$', 'customer.views.deploy_record_check_list'),
    # 检查升级客户
    url(r'^deploy/record/checkupdate/$', 'customer.views.deploy_record_checkupdate'),
    #添加升级客户的检查记录
    url(r'^deploy/record/check/create/$', 'customer.views.deploy_record_check_create'),
    #删除升级检查记录
    url(r'^deploy/record/check/del/$', 'customer.views.deploy_record_check_del'),
    #显示所有未检查的客户升级记录
    url(r'^all/deploy/record/unchecked/list/$', 'customer.views.all_deploy_record_unchecked_list'),
    # 编译升级,下达编译指令
    url(r'^compiling/$', 'customer.views.compiling'),
    # 验证编译状态
    url(r'^compiling/status/$', 'customer.views.compiling_status'),
    # 查看编译机
    url(r'^compiling/list/$', 'customer.views.compiling_list'),
    # 查看编译日志
    url(r'^compiling/record/list/$', 'customer.views.compiling_record_list'),
    # 删除编译日志
    url(r'^compiling/record/del/$', 'customer.views.compiling_record_del'),
    # 客户端编译打包
    url(r'^client/compiling/$', 'customer.views.client_compiling'),
    # CustomerPackage 下载
    url(r'^client/download_package/$', 'customer.views.client_package_download'),
    # 查看Server包
    url(r'^package/view/$', 'customer.views.package_view'),
    # 客户包列表
    url(r'^package/(?P<cus_id>[a-z0-9]+)/$', 'customer.views.package_cus'),
    # 客户包删除
    url(r'^cus_package_del/$', 'customer.views.cus_package_del'),
    # 客户包创建
    url(r'^cus_package_create/$', 'customer.views.cus_package_create'),
    # 客户包编辑
    url(r'^cus_package_edit/$', 'customer.views.cus_package_edit'),
    # 客户包下载，用户远程部署
    url(r'^cus_package_download/$', 'customer.views.cus_package_download'),
    # Server包列表
    url(r'^package_list/$', 'customer.views.package_list'),
    #Server包升级列表
    url(r'^deploy_package_list/$', 'customer.views.deploy_package_list'),
    # 下载Server包
    url(r'^download_install_package/$', 'customer.views.download_install_package'),
    # 下载Server升级包
    url(r'^download_update_package/$', 'customer.views.download_update_package'),
    #一键更新
    url(r'^onekey_update/$', 'customer.views.onekey_update'),
    #获取一键更新信息
    url(r'^deploy_process_info/$', 'customer.views.deployProcessInfo'),
    #获取编译信息
    url(r'^compile_process_info/$', 'customer.views.compileProcessInfo'),
    #更新数据库
    url(r'^check_sql/$', 'customer.views.check_sql'),
    # 远程部署 (更新)
    url(r'^cus_package_update/$', 'customer.views.update_customer_package'),
    # 代码分支
    url(r'^package_branch/$', 'customer.views.package_branch'),
    # Server包文件列表
    url(r'^package_file/$', 'customer.views.package_file'),
    # 下载Server包文件
    url(r'^package_file/download/$', 'customer.views.package_file_download'),
    # 查看Server包文件
    url(r'^package_file/read/$', 'customer.views.package_file_read'),
    # Server包创建
    url(r'^package_create/$', 'customer.views.package_create'),
    # Server包删除
    url(r'^package_del/$', 'customer.views.package_del'),
    # 异步检查客户程序版本的更新状态
    url(r'^deploy/status/$', 'customer.views.deploy_status'),
    # 客户权限配置查看
    url(r'^permission_setting/$', 'customer.views.permission_setting'),
    # 客户权限配置修改
    url(r'^permission_setting/update/$', 'customer.views.permission_setting_update'),
    # 创建 客户包 tag，记录其某个历史状态
    url(r'^create_tag/$', 'customer.views.create_tag'),
    # 编译及打包默认分支
    url(r'^package_default/$', 'customer.views.saveDefaultBranch'),
    # portal默认分支
    url(r'^portal_default/$', 'customer.views.portalDefaultBranch'),
    # 客户端编译默认分支、
    url(r'^client_default/$','customer.views.clientDefaultBranch'),
    #比较是否生成关键更新
    url(r'^compare/$','customer.views.compare'),
    #读取关键更新中数据库的状态
    url(r'^status/$','customer.views.status'),
    #跳转到portal页面
    url(r'^switch_portal/$', 'customer.views.switch_portal'),
    # 查询SVN日志
    url(r'^getSvnLog/$', 'customer.views.getSvnLog'),
)

