#coding=utf8
__author__ = 'xj'

from django.test import TestCase

class ViewTest(TestCase):
    def test(self):
        response = self.client.get('/test')
        self.failUnlessEqual('abc', response.content)
