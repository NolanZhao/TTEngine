#!/usr/bin/python
#coding=utf-8

__author__ = 'zld'
#脚本用于转换rzrk broker需要的相关字段和函数到broker需要的格式，内部工具性质脚本，暂不专门做配置文件了

from StockClientCodeGenerator import *
from StockServerCodeGenerator import *
from base.RPCParser import *
from ServerCodeGenerator import *
from StdClientCodeGenerator import *
from StructCppCodeGenerator import *
from LuaCodeGenerator import *
import sys
import codecs as codecs
import os
from CodeGenerator import parseFile

'''
        // 报单
        const SgdField STRUCT_ORDER_INSERT[] =
        {
            { _fund_account, "资金账号", DT_STRING, true },
            { _instrument_key, "合约KEY", DT_STRUCT, true },
            { "m_securityType", "证券类型", DT_INT32 },
            { "m_tradingDay", "交易日，格式YYYYMMDD", DT_INT32 },
            { "m_insertTime", "录入时间，GMT+8时区，当天0点以来的秒数", DT_INT32 },
            { _session_id, "用户登入成功后的会话ID", DT_INT32 },
            { _order_ref, "报单ID，客户端填写", DT_STRING },
            { _entrust_no, "报单全局索引", DT_INT32 },
            { "m_offsetFlag", "开平标志", DT_INT32 },
            { "m_hedgeFlag", "投机套保标志", DT_INT32 },
            { "m_direction", "买卖方向", DT_INT32 },
            { "m_price", "申价", DT_DOUBLE },
            { "m_volume", "申量", DT_INT32 },
            { "m_orderType", "报单类型，市价单，市价转限价单，限价单", DT_INT32 },
            { "m_orderAttr", "报单属性，FAK，FAK5，FOK，FOK5，本方最优价，对方最优价", DT_INT32 },
            { "m_orderSrc", "报单来源", DT_INT32 },
            { "m_txt", "文本", DT_STRING },
        };
        '''

typeDict = {}
typeDict["XT_DATA_TYPE_INT"] = "DT_INT32"
typeDict["XT_DATA_TYPE_ENUM"] = "DT_INT32"
typeDict["XT_DATA_TYPE_LONG"] = "DT_INT64"
typeDict["XT_DATA_TYPE_DOUBLE"] = "DT_DOUBLE"
typeDict["XT_DATA_TYPE_STRING"] = "DT_STRING"
typeDict["XT_DATA_TYPE_BOOL"] = "DT_BOOLEAN"
typeDict["XT_DATA_TYPE_IDATA"] = "DT_STRUCT"

nameDict = {}
defstr = '''
#define _error_info     "m_rspInfo"
#define _error_no       "m_errorID"
#define _error_msg      "m_errorMsg"
#define _is_last        "is_last"
#define _fund_account   "m_accountID"
#define _password       "m_password"
#define _market         "m_exchangeID"
#define _stock_code     "m_instrumentID"
#define _instrument_key "m_instrumentKey"
#define _packet_type    "packet_type"
#define _src_addr       "src_addr"
#define _req_id         "req_id"
#define _func_no        "func_no"
#define _branch_no      "branch_no"
#define _entrust_way    "entrust_way"       // 委托方法，电话，网络，等等
#define _succ_tag       "succ_tag"
#define _record_cnt     "record_cnt"
#define _reserved       "reserved"
#define _request_num    "request_num"
#define _position_str   "position_str"

#define _account_type   "account_type"

#define _client_id      "client_id"

#define _bs_type        "bs_type"
#define _bs_flag        "m_direction"           // 买卖标志
#define _bs_name        "bs_name"
#define _start_date     "start_date"
#define _end_date       "end_date"
#define _money_code     "money_code"

#define _session_id     "m_sessionID"
#define _order_ref      "m_orderRef"
#define _entrust_no     "m_orderIndex"

#define _order_type     "m_orderType"       // 报单类型，市价单，市价转限价单，限价单
#define _order_attr     "m_orderAttr"       // 报单属性，FAK，FAK5，FOK，FOK5，本方最优价，对方最优价

#define _entrust_type   "entrust_type"      // 委托类型 （为 买卖类型 + 委托模式 的结合，用于下委托单）
#define _entrust_mode   "entrust_mode"      // 委托模式
#define _entrust_price  "m_price"
#define _entrust_vol    "m_volume"
#define _entrust_status "entrust_status"
#define _entrust_date   "entrust_date"
#define _entrust_time   "entrust_time"

#define _stock_name     "stock_name"
#define _stock_account  "stock_account"
#define _client_name    "client_name"

#define _deal_vol       "deal_vol"          // 成交量
#define _deal_price     "deal_price"
#define _deal_amount    "deal_amount"       // 成交金额
#define _deal_date      "deal_date"
#define _deal_time      "deal_time"
#define _deal_no        "deal_no"   // 成交编号

#define _status_name    "status_name"   // 委托或成交状态名称

#define _total_vol      "total_vol" // 持仓总量
#define _enable_vol     "enable_vol" // 持仓可用量
#define _market_value   "market_value"
#define _cost_price     "cost_price"
#define _last_price     "last_price"

#define _commission     "commission"    // 佣金
#define _stamp_tax      "stamp_tax"     // 印花税
#define _trsf_fee       "trsf_fee"      // 过户费

#define _current_balance    "current_balance"
#define _enable_balance     "enable_balance"
#define _fetch_balance      "fetch_balance"
'''

needErrList = []

def insertNameDict():
	strList = defstr.split("\n")
	for i in strList:
		if i.find("#define ") >= 0:
			nameDict[i.split(" \"")[1].split("\"")[0]] = i.split("#define ")[1].split(" ")[0]

def typeChange(typeName):
	newType = getXTTypeByItemType(typeName)
	if typeDict.has_key(newType):
		return typeDict[newType]
	else:
		return "DT_UNKNOWN"

def getName(name):
	retName = ""
	for i in name:
		if not i.islower():
			retName += "_"
		retName += i
	return retName.upper()

def tryTranStruct(desc, typeManager, structs):
	insertNameDict()
	for stu in desc.structs:
		if len(structs) == 0 or stu.name in structs:
		#if stu.name == "OrderInsertReq":
			resp = u"const SgdField STRUCT" + getName(stu.name) + "[] =\n{\n"
			for item in stu.items:
				if (nameDict.has_key(item.name)):
					fieldKey = nameDict[item.name]
				else:
					fieldKey = u"\"%s\"" %(item.name)
				chsName = item.chsname
				typeName = typeChange(item.type.typeName)
				resp += "    { %s, \"%s\", %s, false },\n" %(fieldKey, chsName, typeName)
#			if stu.name in needErrList:
#				resp += u"    { _error, \"错误信息\", DT_STRUCT, false },\n"
			resp += u"};"
			print resp
			print "\n"
	pass

'''
       // 查询资金
      { "queryFund", SGD_FUNC_QUERY_FUND, REQ_FIELDS_QFUND, ARRAYLEN(REQ_FIELDS_QFUND), RESP_FIELDS_QFUND, ARRAYLEN(RESP_FIELDS_QFUND), true, false},
'''

def tryTranFunc(desc, typeManager, funcs):
	for i in desc.functions:
		if (len(funcs) != 0 and (not i.name in funcs)):
			continue
		reqName = ""
		rspName = ""
		multi = "false"
		for j in i.strOutParam:
			if j[0] == u"rsp":
				if j[1].find("[") < 0:
					rspName = j[1]
				else:
					rspName = j[1].split("[")[1].split("]")[0]
					multi = "true"
					if rspName.find("Ptr") >= 0:
						needErrList.append(rspName.split("Ptr")[0])
					else:
						needErrList.append(rspName)
				if rspName.find("Ptr") >= 0:
					rspName = rspName.split("Ptr")[0]
				break
		for j in i.strInparam:
			if j[0] == u"req":
				if j[1].find("[") < 0:
					reqName = j[1]
				else:
					reqName = j[1].split("[")[1].split("]")[0]
				if reqName.find("Ptr") >= 0:
					reqName = reqName.split("Ptr")[0]
				break
		if len(rspName) == 0:
			rspName = "CommonResp"
		desc = "{ \"\", \"%s\", STRUCT%s, ARRAYLEN(STRUCT%s), STRUCT%s, ARRAYLEN(STRUCT%s), %s, false},\n" \
		       %(i.name, getName(reqName), getName(reqName), getName(rspName), getName(rspName), multi)
		print desc
	pass

#转换struct到broker拥兵需要的格式 参数structs为空，则解析所有格式，如果有内容，则只解析指定的结构
def doTranStruct(structs):
	typeManager = StdTypeManger()
	#input = "e:/server5/counter/trunk/Protocol/rpc/CounterStructs.rpc"
	input = "e:/server5/counter/trunk/Protocol/rpc/Structs.rpc"
	desc = parseFile(input, typeManager)
	tryTranStruct(desc, typeManager, structs)

#转换函数
def doTranFunc(funcs):
	typeManager = StdTypeManger()
	input = "e:/server5/counter/trunk/Protocol/rpc/Counter.rpc"
	desc = parseFile(input, typeManager)
	tryTranFunc(desc, typeManager, funcs)

if __name__ == "__main__":
	structs = []
	funcs = []
	#structs = ["CMarginRateDetail", "CCommissionRateDetail", "CInstrumentDetail", "CExchangeDetail"]
	#structs = ["CXtOrderTag"]
	#funcs = ["login"]
	doTranFunc(funcs)
	doTranStruct(structs)
