# encoding=utf-8
from django.db import transaction
from mongoengine import *
from mongoengine.django.auth import User, get_user
import datetime
from django.contrib.auth.hashers import make_password
from TTEngine.mongoSettings import mongo_connect

mongo_connect()

class UserGroup(Document):
    key = StringField(max_length=90, required=True, verbose_name="用户组名称Key", help_text="")
    value = StringField(max_length=90, required=True, verbose_name="用户组名称Value", help_text="")


class User(User):
    """
    用户表
    """

    group = StringField(max_length=90, required=True, verbose_name="用户组名称Key", help_text="")

    @staticmethod
    def create_user(username, password, group, telphone = None, email=None, is_staff=True, is_active=True, is_superuser=False):
        now = datetime.datetime.now()

        if email is not None:
            try:
                email_name, domain_part = email.strip().split('@', 1)
            except ValueError:
                pass
            else:
                email = '@'.join([email_name, domain_part.lower()])

        user = User()
        user.username = username
        user.password = make_password(password)
        user.group = group
        user.email = email
        user.telphone = telphone
        user.is_staff = is_staff
        user.is_active = is_active
        user.is_superuser = is_superuser
        user.date_joined = now
        user.save()

        return user

    @staticmethod
    def get_user(uuid):
        try:
            return User.objects.get(pk=uuid)
        except Exception as e:
            return None

    @staticmethod
    def get_user_by_name(name):
        try:
            return User.objects.get(username=name)
        except Exception as e:
            return None

    def start_user(self):
        if self.is_active:
            raise Exception, '用户已启用'
        else:
            self.is_active = True
            self.save()
        return self

    def stop_user(self):
        if not self.is_active:
            raise Exception, '用户已经是停用状态'
        else:
            self.is_active = False
            self.save()
        return self