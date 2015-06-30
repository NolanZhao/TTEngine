import struct
# from bson import BSON
from rzrk_bson import BSON

NET_CMD_UNKOWN = 0
NET_CMD_KEEPALIVE = 1
NET_CMD_QUOTER = 2
NET_CMD_RPC = 3
NET_CMD_NOTIFICATION = 4
NET_CMD_VSS_MARKET_STATUS = 5
NET_CMD_VSS_QUOTE = 6


class TTPackage:
    def __init__(self, seq=0, cmd=0, data={}):
        self.packLen = 0
        self.seq = seq
        self.cmd = cmd
        self.data = data

    def decode(self, data):
        self.packLen, = struct.unpack_from("!I", data, 0)
        self.seq, self.cmd, tag, datas = struct.unpack_from("!IHH%ds" % (self.packLen - 12), data, 4)
        if self.cmd == NET_CMD_RPC:
            self.seq = ((tag >> 8) & 0x0f) << 32 | self.seq
            bson_data = BSON(datas)
            bson_decode = bson_data.decode(as_class=dict)
            self.data = bson_decode

    def encode(self):
        bdata = BSON().encode(self.data)
        packLen = len(bdata) + 12
        intSeq = int(self.seq)
        flagSeq = ((self.seq >> 32) & 0x0f) << 8
        tag = flagSeq
        datas = struct.pack("!IIHH%ds" % len(bdata), packLen, intSeq, self.cmd, tag, bdata)
        return datas