#coding=utf8
# __author__ = 'xujun'

from net.RPCClient import request
import json

ADDRESS = "192.168.1.232:57000"
#ADDRESS = "127.0.0.1:57000"

def correct():
    account = {
        "m_nBrokerType": 2,
        "m_nPlatformID": 21002,  # 目前主要用于区别不同的行情, 根据此来选择对应行情
        "m_strBrokerID": "0",
        "m_nAccountType": -1,
        "m_strAccountID": "10001"
    }
    response = request(ADDRESS, "correct", {"req": account})
    print response


def queryStockData():
    account = {
        "m_nBrokerType": 2,
        "m_nPlatformID": 11001,  # 目前主要用于区别不同的行情, 根据此来选择对应行情
        "m_strBrokerID": "111000",
        "m_nAccountType": 49,
        "m_strAccountID": "37000149",
    }
    #ids = ["37000034", "37000178", "37000179", "37000025", "37000024", "37000139", "37000144", "37000080", "37000184", "37000086", "37000234"]
    #ids = ["37000045", "37000048", "37000053", "37000098", "37000058", "37000164", "37000149", "37000024", "37000167", "37000156", "37000212", "37000020","37000121", "37000147"]
    ids = ["37000149"]
    for id in ids:
        account["m_strAccountID"] = id
        response = request(ADDRESS, "queryData", {"req": {"metaId": 543, "account": account}})
        #print response["content"][0]
        print response
        #[u"m_iStatus"]


def queryFutureData():
    account = {
        "m_nBrokerType": 1,
        "m_nPlatformID": 21001,  # 目前主要用于区别不同的行情, 根据此来选择对应行情
        "m_strBrokerID": "1001",
        "m_nAccountType": -1,
        "m_strAccountID": "00000170",
        "m_strSubAccount": "00000170_02"
    }
    #ids = ["00000174", "00000222", "00000223", "00000224", "00000225", "00000228", "00000233", "00000234", "00000236", "00000237", "00000238", "00000241", "00000242", "00000243", "00000244"]
    #ids = ["37000045", "37000048", "37000053", "37000098", "37000058", "37000164", "37000149", "37000024", "37000167", "37000156", "37000212", "37000020","37000121", "37000147"]
    ids = ["00000170"]
    for id in ids:
        account["m_strAccountID"] = id
        response = request(ADDRESS, "queryData", {"req": {"metaType": 543, "account": account}})
        print id, response
        #print response["content"][0]
        #[u"m_iStatus"]


def correct():
    account = {
        "m_nBrokerType": 2,
        "m_nPlatformID": 11001,  # 目前主要用于区别不同的行情, 根据此来选择对应行情
        "m_strBrokerID": "111000",
        "m_nAccountType": 49,
        "m_strAccountID": "37000109",
    }
    response = request(ADDRESS, "correct", {"req": account})


def remove():
    account = {
        "m_nBrokerType": 2,
        "m_nPlatformID": 11001,  # 目前主要用于区别不同的行情, 根据此来选择对应行情
        "m_strBrokerID": "111000",
        "m_nAccountType": 49,
        "m_strAccountID": "37000109",
    }
    response = request(ADDRESS, "remove", {"req": account})


def queryRawAccountDetail(account):
    response = request(ADDRESS, "queryData", {"req": {"metaType": 543, "account": account}})
    return response


def getAccountDetails(account):
    response = request(ADDRESS, "getAccountDetails", {"accounts": [account]})
    return response


def queryRawPosition(account):
    response = request(ADDRESS, "queryData", {"req": {"metaType": 545, "account": account}})
    return response


if __name__ == "__main__":
    #correct()
    #queryFutureData()
    #queryStockData()
    #correct()
    #remove()
    account = {
        "m_nBrokerType": 1,
        "m_nPlatformID": 20001,  # 目前主要用于区别不同的行情, 根据此来选择对应行情
        "m_strBrokerID": "7080",
        "m_nAccountType": -1,
        "m_strAccountID": "20607115",
    }

    account = {
        "m_nBrokerType": 2,
        "m_nPlatformID": 11001,  # 目前主要用于区别不同的行情, 根据此来选择对应行情
        "m_strBrokerID": "111000",
        "m_nAccountType": 49,
        "m_strAccountID": "37000210",
    }
    print json.dumps(queryRawAccountDetail(account))
    # print json.dumps(queryRawPosition(account))
    # print json.dumps(getAccountDetails(account))
