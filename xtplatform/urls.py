#encoding=utf-8
from django.conf.urls import patterns, url
from common.XtModuleView import *

urlpatterns = patterns('',
)

platformView =  XtModelView("Platform", "PlatformForm", "_id", "platform")
platformView.register_url(urlpatterns)