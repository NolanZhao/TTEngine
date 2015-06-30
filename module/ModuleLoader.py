#coding=utf8
__author__ = 'xujun'

import pymongo
from datetime import datetime
import time

class ModuleLoader(object):
    def __init__(self, MONGO_HOST):
        self.conn = pymongo.Connection(host=MONGO_HOST)
        self.db = self.conn.ttengine
        pass

    # 导入数据
    def loadPyScripts(self):
        scripts = {
            "common.py" : "基础类",
            "configParse.py" : "配置解析",
            "checkSystemAlarm.py" : "检查系统状态报警",
            "extractBanlance.py" : "提取结算单数据",
            "genSettlementInfo.py" :"产生结算单文本",
            "publicFunction.py" :"公共函数",
            "python_config.ini" :"python配置",
            "redisUpdateMysql.py" :"委托成交等数据入库",
            "sendMail.py" :"发送邮件",
            "subStockResp.py" :"将股票交割单写入库",
        }
        tag = "pyRunScripts"
        moduleName = "BasePythonScript"
        self.save(moduleName, tag, scripts)

    def loadLuaScrips(self):
        scripts = {
            "table2json.lua" : "从luaTable转json函数",
            "Settlement.lua" : "提取结算单数据",
            "MarketTime.lua" : "推送市场状态的市场时间",
            "monitor/checkOrder.lua" : "检查委托回报频率",
            "monitor/config_order.lua" : "检查委托反馈配置",
            "monitor/order.log4cxx" : "检查委托反馈日志配置",
            "monitor/checkOrderInfo.lua" : "检查委托发送频率",
            "monitor/config_orderInfo.lua" : "检查委托发送配置",
            "monitor/orderInfo.log4cxx" : "检查委托发送日志配置",
            "monitor/checkPosition.lua" : "检查持仓",
            "monitor/config_position.lua" : "检查持仓配置",
            "monitor/position.log4cxx" : "检查持仓日志配置",
        }
        tag = "luaRunScripts"
        moduleName = "BaseLuaScript"
        self.save(moduleName, tag, scripts)

    def loadConfigs(self):
        scripts = {
            "config.lua" : "基础类",
            "env.lua" : "配置解析",
            "configHelper.lua" : "检查系统状态报警",
            "getLog.lua" : "提取结算单数据",
            "localMerge.lua" :"合并本地配置",
            "configFromMysql.lua" :"从mysql中读取",
            "mysqlForIData.lua" :"IData数据查询",
            "configForRiskControl.lua" :"风控配置",
            "configForUser.lua" :"用户配置",
            "subStockResp.py" :"将股票交割单写入库",
        }
        tag = "config"
        moduleName = "BaseConfig"
        self.save(moduleName, tag, scripts)

    def save(self, moduleName, tag, datas):
        fileIds = []
        for k, v in datas.iteritems():
            d = {
                "filePath" : "server/%s/%s" %(tag, k),
                "rawPath" : "{{ttserviceBranch}}/_runtime/%s/%s" %(tag, k),
                "mod" : 644,
                "fileType" : 3,
                "descript" : v,
                "createTime" : datetime.now(),
                "updateTime" : datetime.now()
            }
            query = {"filePath":d["filePath"], "rawPath" : d["rawPath"]}
            data = self.db.file_info.find_one(query)
            objId = None
            if data is None:
                objId = self.db.file_info.isnert(d)
            else:
                objId = data["_id"]
                self.db.file_info.update({"_id":objId}, {"$set":d})
            fileIds.append(objId)
        d = {
            "name" : moduleName,
            "version" : "M_" + str(int(time.time() * 1000)),
            "craeteTime" : datetime.now(),
            "files" : fileIds,
        }
        self.db.module.update({"name":moduleName}, {"$set":d},  upsert=True)

if __name__ == "__main__":
    m = ModuleLoader("192.168.1.187")
    m.loadPyScripts();
    m.loadLuaScrips()
    m.loadConfigs()