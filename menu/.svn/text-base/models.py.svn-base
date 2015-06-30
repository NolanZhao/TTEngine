# encoding=utf-8
from mongoengine import *
from TTEngine.mongoSettings import mongo_connect

mongo_connect()


class Menu(Document):
    """
    菜单类
    """
    type = IntField(required=True, verbose_name='菜单类型:1:主菜单,2:子菜单', help_text='')
    name = StringField(required=True, verbose_name="名称", help_text="", max_length=90)
    url = StringField(required=False, verbose_name="子菜单Url", help_text="", max_length=90)
    p_key = StringField(required=False, verbose_name="父菜单唯一标识", help_text="", max_length=90)
    c_key = StringField(required=False, verbose_name="子菜单唯一标识", help_text="", max_length=90)

    @staticmethod
    def gen_new_menu(type, name, p_key, c_key, url):
        """
        创建Menu对象
        :param type:
        :param name:
        :param p_key:
        :param c_key:
        :param url:
        :return:
        """
        menu = Menu()
        menu.type = type
        menu.name = name
        menu.p_key = p_key
        menu.c_key = c_key
        menu.url = url
        menu.save()
        return menu