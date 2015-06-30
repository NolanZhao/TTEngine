# encoding=utf-8
import sys
import os

reload(sys)
sys.setdefaultencoding('utf-8')
__author__ = 'nerve'

from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.decorators import login_required
from django.shortcuts import render_to_response
from django.template import RequestContext
from django.http import HttpResponse
import logging
import json
from utils.TracebackHelper import getTraceBack
from rzrk_bson import BSON


logger = logging.getLogger('django')