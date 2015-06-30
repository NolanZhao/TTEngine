#coding=utf8
__author__ = 'xj'
import codecs
import struct
import zlib

def parseData(size, datas, tag, index, len):
    if (index + len) > size:
        return tag, "", ""
    else:
        d1= struct.unpack(tag, datas[index : index + len])
        d2= struct.unpack("!%s" % tag, datas[index : index + len])
        return tag, d1[0], d2[0]

def main():
    f = open("i:/data", "rb")
    datas = f.read()
    size = len(datas)
    for x in xrange(size):
        try:
            datas = zlib.decompress(datas[x:])
            print x
        except:
            pass

    for index in xrange(size):
        print index, datas[index]

    for index in xrange(size):
        d  = []
        d.append(index)
        d.append(datas[index])
        #d.append(parseData(size, datas, "c", index, 1))
        #d.append(parseData(size, datas, "b", index, 1))
        #d.append(parseData(size, datas, "B", index, 1))
        tag, d1, d2 = parseData(size, datas, "h", index, 2)
        if d1 > 0 and d1 < size + 1:
           d.append((tag, d1, d2))
           print d
        #tag, d1, d2 = parseData(size, datas, "b", index, 1)
        #if d1 > 0 and d1 < 55:
        #    d.append((tag, d1, d2))

        #d.append(parseData(size, datas, "H", index, 2))
        #d.append(parseData(size, datas, "i", index, 4))
        #d.append(parseData(size, datas, "I", index, 4))
        #d.append(parseData(size, datas, "l", index, 4))
        #d.append(parseData(size, datas, "L", index, 4))
        #d.append(parseData(size, datas, "q", index, 8))
        #d.append(parseData(size, datas, "Q", index, 8))
        #d.append(parseData(size, datas, "f", index, 4))
        #d.append(parseData(size, datas, "d", index, 8))


if __name__ == "__main__":
    main()
