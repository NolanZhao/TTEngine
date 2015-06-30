# encoding=utf-8
from django.conf.urls import patterns, url


urlpatterns = patterns(
    '',
    # Redis数据库配置
    url(r'^redis/view/', 'demo.views.redis_view'),
    # GDBM数据库配置
    url(r'^gdbm/view/', 'demo.views.gdbm_view'),
    # 随机密码生成
    url(r'^passwdGen/', 'demo.views.passwdGen'),
    # 视频播放
    url(r'^video/', 'demo.views.video'),
    # 平台管理-页面
    url(r'^platform/view/', 'demo.views.platform_view'),
    # 平台管理-操作
    url(r'^platform/operate/$', 'demo.views.platform_operate'),
    #删除无效模块
    url(r'^removeInvalidModule/$', 'demo.views.removeInvalidModule'),
    #修改平台信息
    url(r'^modifyPlatformLua/$', 'demo.views.modifyPlatformLua'),
    # 基础包列表
    url(r'^showBaseSoft/$', 'demo.views.showBaseSoft'),
    # 下载压缩包
    url(r'^downloadZip/$', 'demo.views.downloadZip'),
    # 下载文件
    url(r'^downloadFile/$', 'demo.views.downloadFile'),
    # 上传文件
    url(r'^uploadFile/$', 'demo.views.uploadFile'),
    # 上传视频
    url(r'^uploadVideo/$', 'demo.views.uploadVideo'),
    # 上传视频属性信息
    url(r'^videoPost/$', 'demo.views.videoPost'),
    # 上传基础包
    url(r'^uploadBaseSoft/$', 'demo.views.uploadBaseSoft'),
    # 删除基础包
    url(r'^deleteFile/$', 'demo.views.deleteFile'),
    #快速查找
    url(r'^quickSearch/$', 'demo.views.quickSearch'),
    #显示股票列表和交易日列表
    url(r'^StockAndTrade/$', 'demo.views.StockAndTrade'),
    #187获取股票列表和交易日列表
    url(r'^getStockAndTrade/$', 'demo.views.getStockAndTrade'),
    #下载股票列表和交易日列表
    url(r'^downStockAndTrade/$', 'demo.views.downStockAndTrade'),
    #下载股票列表和交易日列表中的单个文件
    url(r'^downStockAndTradeFile/$', 'demo.views.downStockAndTradeFile'),
)
