# -*- coding:utf-8 -*-

import sys
import os
import shutil
import smtplib
from email.mime.text import MIMEText

# 邮件类
class Mail:
    
    def sendMail(self, to_list, subject, content, is_html):
        me = self.__user_name + '<' + self.__user_name + '>'
        if True == is_html:
            msg = MIMEText(content, 'html')
        else:
            msg = MIMEText(content, 'plain')
        msg['Accept-Language'] = 'zh-CN'
        msg['Accept-Charset'] = 'ISO-8859-1,gbk'
        msg['Content-Type'] = 'application/octet-stream'
        msg['Subject'] = subject
        msg['From'] = me
        msg['To'] = ';'.join(to_list)
        msg.set_charset('gbk')
        self.__smtp.sendmail(me, to_list, msg.as_string())
    
    def __init__(self, user_name, password, smtp_host, port = 25, ssl = False):
        self.__user_name = user_name
        self.__password = password
        self.__smtp_host = smtp_host
        self.__smtp_port = port
        if ssl:
            self.__smtp = smtplib.SMTP_SSL()
        else:
            self.__smtp = smtplib.SMTP()
        self.__smtp.connect(self.__smtp_host, self.__smtp_port)
        self.__smtp.login(self.__user_name, self.__password)
        
    def __del__(self):
        self.__smtp.close()


# 子类：打包邮件类
class BuildMail(Mail):
    
    def sendBuildSuccessMail(self, url, show_name, svn_log, addr_list):
        content = '下载地址：<br/>' + url + '<br/><br/>' + svn_log
        Mail.sendMail(self, addr_list, show_name + ' 打包完成', content, True)
    
    def sendBuildFailMail(self, show_name, build_log, addr_list):
        content = build_log
        Mail.sendMail(self, addr_list, show_name + ' 打包失败', content, False)
    
    def __init__(self):
        Mail.__init__(self, 'package@thinktrader.net', 'package.rzrk1', 'smtp.thinktrader.net', 25, False)


