__author__ = 'xujun'

#coding=utf8

def test1(**a):
    for k, v in a.iteritems():
        print k, v

if __name__ == "__main__":
    d = {u"a":1, u"b":32}
    test1(**d)
