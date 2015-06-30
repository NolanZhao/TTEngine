#encoding=utf-8
import sys

reload(sys)
sys.setdefaultencoding('utf-8')

from net.RPCClient import RPCClient
from settings import TT_IP, TT_PORT, TT_GATEWAY, TT_SESSION_KEY
import logging


logger = logging.getLogger('django')


def sync_request(func_name, params, gateway=TT_GATEWAY):
    """
    基础RPC请求方法
    :param func_name:
    :param params:
    :param gateway:
    :return:
    """
    s_client = RPCClient(TT_IP, TT_PORT, 10)
    return s_client.request(gateway, {"function": func_name, "param": params, "session": TT_SESSION_KEY})


def req_to_tt_service(func_name, params={}):
    account_params = {"m_strSubAccount": ""}
    params.update({"account": account_params})

    logger.info("func_name: %s ; params : %s" % (func_name, params))

    try:
        return sync_request(func_name, params, TT_GATEWAY)
    except Exception, e:
        print func_name, "req to ttservice error", e
        msg = e.message
        detail = ""
        if isinstance(msg, dict) and msg.has_key(u"ErrorMsg") and msg.has_key(u"ErrorID"):
            detail = "ID: %s, 摘要: %s" % (msg[u"ErrorID"], msg[u"ErrorMsg"])

        #错误代码在serverapi/constants.py里,不可随意更改
        return {"error": "与核心服务通信时出现错误! " + detail, "errorCode": 902}


if __name__ == '__main__':
    print req_to_tt_service("getRunningLicenseConfig", {})