# encoding=utf-8
from django.conf.urls import patterns, include, url

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
import settings

admin.autodiscover()

urlpatterns = patterns(
    '',
    url(r'^$', 'TTEngine.views.home'),
    url(r'^home$', 'TTEngine.views.home', name='home'),
    url(r'^login/', 'TTEngine.views.login', name='login'),
    url(r'^logout/', 'TTEngine.views.logout', name='logout'),
    url(r'^module/', include("module.urls")),
    url(r'^customer/', include("customer.urls")),
    url(r'^package/', include("package.urls")),
    url(r'^demo/', include("demo.urls")),
    url(r'^portal/', include("portal.urls")),
    url(r'^programBranch/', include("programBranch.urls")),
    url(r'^user/', include("usrmgr.urls")),
    url(r'^serverMonitor/', include("serverMonitor.urls")),
    url(r'^media/(?P<path>.*)$', 'django.views.static.serve', {'document_root': settings.MEDIA_ROOT, 'show_indexes': True}),
    url(r'^admin/doc/', include('django.contrib.admindocs.urls')),
    url(r'^admin/', include(admin.site.urls)),
)