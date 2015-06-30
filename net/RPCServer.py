import asyncore
import socket
import struct
import bson
import traceback
from net.RPCBase import *

class Session(asyncore.dispatcher_with_send):
    
    def __init__(self, socket, parent):
        asyncore.dispatcher_with_send.__init__(self, socket)
        self.parent = parent        
        self.sendBuffer = []
        
        self.recvBuffer = ""
        self.packLen = 0
        
    def sendPackage(self, seq, params, cmd = NET_CMD_RPC, status = 0):
        package = TTPackage()
        package.seq = seq
        package.cmd = cmd
        package.data = { u"status":status, u"params":params}
        datas = package.encode()
        self.send(datas)

    def handle_read(self):
        data = self.recv(8192)
        if data:
            self.recvBuffer += data
            if self.packLen == 0 and len(self.recvBuffer) >= 4:
                self.packLen, = struct.unpack_from("!I", self.recvBuffer, 0)
            while len(self.recvBuffer) >= self.packLen and self.packLen != 0:
                package = TTPackage()
                package.decode(self.recvBuffer[0:self.packLen])
                if  package.cmd == NET_CMD_KEEPALIVE  :
                    self.send(self.recvBuffer[0:self.packLen])
                else:
                    self.handle_package(package)
                self.recvBuffer = self.recvBuffer[self.packLen:]
                self.packLen = 0                  
                if len(self.recvBuffer) >= 4 :
                    self.packLen,  = struct.unpack_from("!I", self.recvBuffer, 0)
            
    def handle_wite(self):
        pass
    
    def handle_package(self, package):
        self.parent.handle_package(package, self)       
    
    def handle_error(self):
        self.handle_close()

    def handle_close(self):
        self.close()
        self.parent.handle_close(self)

class RPCServer(asyncore.dispatcher):

    def __init__(self, host, port, handler):
        asyncore.dispatcher.__init__(self)
        self.handler = handler
        self.sessions = []
        self.create_socket(socket.AF_INET, socket.SOCK_STREAM)
        self.set_reuse_addr()
        self.bind((host, port))
        self.listen(5)

    def handle_accept(self):
        pair = self.accept()
        if pair is None:
            pass
        else:
            sock, addr = pair
            self.sessions.append(Session(sock, self))
            
    def handle_package(self, package, session):
        func = package.data.get(u"func")
        params = package.data.get(u"params")
        self.handle_request(package.seq, func, params, session)
        
    def handle_request(self, seq, func, param, session):
        try :
            # if keepAlive send redirect
            if func == "keepAlive":
                session.sendPackage(seq, {u"success":True})
                return

            method = getattr(self.handler, func)
            response = method(seq, param, session)
            if response != None:
                session.sendPackage(seq, response)
        except Exception, ex:
            if func != u"onError":
                session.sendPackage(seq, {u"error":unicode(ex), u"stack":unicode(traceback.format_exc())}, NET_CMD_RPC, 1)
            
    def handle_close(self, session):
        self.handle_request(0, u"onError", {}, session)
        if session in self.sessions:
            self.sessions.remove(session)
    
    def pushPackageToAll(self, method, params):
        data = { u"method":method, u"params":params}
        for session in self.sessions:
            session.sendPackage(0, data, NET_CMD_NOTIFICATION)

    def run(self):
        asyncore.loop()