#coding=utf8
__author__ = 'Administrator'
CLIENT_INCLUDE_TEMPLATE = u'''\
#include <boost/signals2.hpp>
#include "net/RPCClient.h"
#include "utils/BsonHelper.h"
#include "utils/commonFunc.h"
#include "utils/TrafficWatch.h"
#include "utils/TTError.h"
 '''

# HPP file template
CLIENT_CLASS_TEMPLATE_HPP = \
'''\
class rpc_{{ServiceName}}_client
{
public:
    boost::shared_ptr<net::RPCClient> m_client;

    rpc_{{ServiceName}}_client();
    rpc_{{ServiceName}}_client(boost::shared_ptr<net::RPCClient> client);
    virtual ~rpc_{{ServiceName}}_client();
    void init();

    void onNotification(std::string func, bson::bo response);
    virtual bson::bo _request(std::string func, bson::bo param, r_uint8 compress = COMPRESS_NONE);
    virtual void _emitRequest(std::string func, bson::bo param, const net::CallbackFunc &cb, r_uint8 compress = COMPRESS_NONE);
    virtual bson::bo _subscribe(std::string func, bson::bo param, const net::CallbackFunc &cb, r_int64 &seq);
    virtual r_int64 _emitSubscribe(std::string func, bson::bo param, const net::CallbackFunc &cb);

    {{FunctionContent}}

    {{PushFunctionContent}}

    {{SubFunctionContent}}
};\
'''
CLIENT_SYNC_CODE_TEMPLATE_HPP = \
u'''\
virtual void {{FuncName}}({{InParam}} {{OutParam}} bson::bo* _rError, r_uint8 compress = COMPRESS_NONE);\
'''

CLIENT_SYNC_CODE_TEMPLATE_V2_HPP = \
u'''\
virtual void {{FuncName}}({{InParam}} {{OutParam}} utils::TTError* _tError, r_uint8 compress = COMPRESS_NONE);\
'''

CLIENT_ASYNC_CODE_TEMPLATE_HPP =\
u'''\
virtual void {{FuncName}}_async({{Param}} const boost::function<void ({{OutTypes}} bson::bo)>& _func, r_uint8 compress = COMPRESS_NONE);
virtual void on_{{FuncName}}(bson::bo _response, bson::bo _error, bool _isFirst, void* _func);\
'''

CLIENT_ASYNC_CODE_TEMPLATE_V2_HPP =\
u'''\
virtual void {{FuncName}}_async({{Param}} const boost::function<void ({{OutTypes}} const utils::TTError&)>& _func, r_uint8 compress = COMPRESS_NONE);
virtual void on_{{FuncName}}(bson::bo _response, bson::bo _error, bool _isFirst, void* _func);\
'''
CLIENT_SUBSCRIBE_TEMPLATE_HPP =\
u'''\
virtual r_int64 {{FuncName}}_async({{Param}} const boost::function<void ({{OutTypes}} bson::bo)>& _func);
virtual void on_{{FuncName}}(bson::bo _response, bson::bo _error, bool _isFirst, const void*& _func);
virtual r_int64 {{FuncName}}_async_unsub({{Param}} const boost::function<void (bool, bson::bo)>& _func);
virtual void on_{{FuncName}}_unsub(bson::bo _response, bson::bo _error, bool _isFirst, const boost::function<void (bool, bson::bo)>& _func);\
'''

CLIENT_SUBSCRIBE_TEMPLATE_V2_HPP =\
u'''\
virtual r_int64 {{FuncName}}_async({{Param}} const boost::function<void ({{OutTypes}} const utils::TTError&)>& _func);
virtual void on_{{FuncName}}(bson::bo _response, bson::bo _error, bool _isFirst, const void*& _func);
virtual r_int64 {{FuncName}}_async_unsub({{Param}} const boost::function<void (bool, const utils::TTError&)>& _func);
virtual void on_{{FuncName}}_unsub(bson::bo _response, bson::bo _error, bool _isFirst, const boost::function<void (bool, bson::bo)>& _func);\
'''

CLIENT_PUSH_CODE_TEMPLATE_HPP =\
u'''\
virtual void on_{{FuncName}}(bson::bo _response);
virtual void on_{{FuncName}}({{Params}});\
'''

# CPP File Template

CLIENT_CLASS_TEMPLATE_CPP =\
'''\
    rpc_{{ServiceName}}_client::rpc_{{ServiceName}}_client()
        :m_client()
    {

    };

    rpc_{{ServiceName}}_client::rpc_{{ServiceName}}_client(boost::shared_ptr<net::RPCClient> client)
        :m_client(client)
    {
        init();
    };

    rpc_{{ServiceName}}_client::~rpc_{{ServiceName}}_client()
    {

    };

    void rpc_{{ServiceName}}_client::init()
    {
        if (NULL != m_client)
        {
            m_client->setNotificationFunc(boost::bind(&rpc_{{ServiceName}}_client::onNotification, this, _1, _2));
        }
    }

    void rpc_{{ServiceName}}_client::onNotification(std::string func, bson::bo response)
    {
        {{NotifyCodes}}
    }

    bson::bo rpc_{{ServiceName}}_client::_request(std::string func, bson::bo param, r_uint8 compress /*= COMPRESS_NONE*/)
    {
        assert (NULL != m_client);
        return m_client->request(func, param, compress);
    };

    void rpc_{{ServiceName}}_client::_emitRequest(std::string func, bson::bo param, const net::CallbackFunc &cb, r_uint8 compress /*= COMPRESS_NONE*/)
    {
        assert (NULL != m_client);
        m_client->emitRequest(func, param, cb, compress);
    }

    bson::bo rpc_{{ServiceName}}_client::_subscribe(std::string func, bson::bo param, const net::CallbackFunc &cb, r_int64 &seq)
    {
        assert (NULL != m_client);
        return m_client->subscribe(func, param, cb, seq);
    }

    r_int64 rpc_{{ServiceName}}_client::_emitSubscribe(std::string func, bson::bo param, const net::CallbackFunc &cb)
    {
        assert (NULL != m_client);
        return m_client->emitSubscribe(func, param, cb);
    }

    {{FunctionContent}}
    {{PushFunctionContent}}
    {{SubFunctionContent}}\
'''
CLIENT_SYNC_CODE_TEMPLATE_CPP =\
u'''\
void rpc_{{ServiceName}}_client::{{FuncName}}({{InParam}} {{OutParam}} bson::bo* _rError, r_uint8 compress /*= COMPRESS_NONE*/)
{
    if ( NULL != m_client)
    {
        try {
            bson::bob _builder;
            {{GenBson}}
            bson::bo _response = _request("{{FuncName}}", _builder.obj(), compress);
            {{ParseBson}}
        }
        catch(bson::bo ex)
        {
            if (NULL != _rError)
            {
                *_rError = ex;
            }
        }
    } else {
        if (NULL != _rError)
        {
            *_rError = utils::TTError::makeErrorBson(TT_ERROR_NET_DISCONNECTED);
        }
    }
}\
'''

CLIENT_SYNC_CODE_TEMPLATE_V2_CPP =\
u'''\
void rpc_{{ServiceName}}_client::{{FuncName}}({{InParam}} {{OutParam}} utils::TTError* _tError, r_uint8 compress /*= COMPRESS_NONE*/)
{
    if ( NULL != m_client)
    {
        try {
            bson::bob _builder;
            {{GenBson}}
            bson::bo _response = _request("{{FuncName}}", _builder.obj(), compress);
            {{ParseBson}}
        }
        catch(const utils::TTError& terror)
        {
            if (NULL != _tError)
            {
                *_tError = terror;
            }
        }
        catch(bson::bo berror)
        {
            if (NULL != _tError)
            {
                _tError->bsonValueFromObj(berror);
                if (!(*_tError))
                {
                    _tError->setErrorId(TT_ERROR_DEFAULT);
                    _tError->setErrorMsg(berror.toString());
                }
            }
        }
    } else {
        if (NULL != _tError)
        {
            *_tError = utils::TTError(TT_ERROR_NET_DISCONNECTED);
        }
    }
}\
'''

CLIENT_ASYNC_CODE_TEMPLATE_CPP =\
u'''\
void rpc_{{ServiceName}}_client::{{FuncName}}_async({{Param}} const boost::function<void ({{OutTypes}} bson::bo)>& _func, r_uint8 compress /*= COMPRESS_NONE*/)
{
    boost::function<void ({{OutTypes}} bson::bo)>* pFunc = NULL;
    if (NULL != _func)
        pFunc = new boost::function<void ({{OutTypes}} bson::bo)>(_func);

    if ( NULL != m_client)
    {
        bson::bob _builder;
        {{GenBson}}
        bson::bo _obj = _builder.obj();
        _emitRequest("{{FuncName}}", _obj, boost::bind(&rpc_{{ServiceName}}_client::on_{{FuncName}}, this, _1, _2, _3, pFunc), compress);
        net::RPCEngine::instance()->trafficWatch()->watch("{{FuncName}}", _obj.objsize());
    } else {
        bson::bo _error = utils::TTError::makeErrorBson(TT_ERROR_NET_DISCONNECTED);
        on_{{FuncName}}(bson::bo(), _error, true, pFunc);
    }
}

void rpc_{{ServiceName}}_client::on_{{FuncName}}(bson::bo _response, bson::bo _error, bool _isFirst, void* _func)
{
    {{OutParamDeclear}}
    if (_error.isEmpty())
    {
        try
        {
            {{ParseBson}}
        }
        catch (...)
        {
			 {{MakeError}}
        }
    }
    boost::function<void ({{OutTypes}} bson::bo)>* _tmpFunc = static_cast< boost::function<void ({{OutTypes}} bson::bo)> *>(_func);
    if (NULL != _tmpFunc)
    {
        (*_tmpFunc)({{OutParamName}} _error);
        delete _tmpFunc;
    }

    net::RPCEngine::instance()->trafficWatch()->watch("on_{{FuncName}}", _response.objsize());
}\
'''

CLIENT_ASYNC_CODE_TEMPLATE_V2_CPP =\
u'''\
void rpc_{{ServiceName}}_client::{{FuncName}}_async({{Param}} const boost::function<void ({{OutTypes}} const utils::TTError&)>& _func, r_uint8 compress /*= COMPRESS_NONE*/)
{
    boost::function<void ({{OutTypes}} const utils::TTError&)>* pFunc = NULL;
    if (NULL != _func)
        pFunc = new boost::function<void ({{OutTypes}} const utils::TTError&)>(_func);

    if ( NULL != m_client)
    {
        bson::bob _builder;
        {{GenBson}}
        bson::bo _obj = _builder.obj();
        _emitRequest("{{FuncName}}", _obj, boost::bind(&rpc_{{ServiceName}}_client::on_{{FuncName}}, this, _1, _2, _3, pFunc), compress);
        net::RPCEngine::instance()->trafficWatch()->watch("{{FuncName}}", _obj.objsize());
    } else {
        bson::bo _error = utils::TTError::makeErrorBson(TT_ERROR_NET_DISCONNECTED);
        on_{{FuncName}}(bson::bo(), _error, true, pFunc);
    }
}

void rpc_{{ServiceName}}_client::on_{{FuncName}}(bson::bo _response, bson::bo _error, bool _isFirst, void* _func)
{
    {{OutParamDeclear}}
    if (_error.isEmpty())
    {
        try
        {
            {{ParseBson}}
        }
        catch (...)
        {
			 {{MakeError}}
        }
    }
    boost::function<void ({{OutTypes}} const utils::TTError&)>* _tmpFunc = static_cast< boost::function<void ({{OutTypes}} const utils::TTError&)> *>(_func);
    if (NULL != _tmpFunc)
    {
        utils::TTError _terror;
        if (!_error.isEmpty())
        {
            _terror.bsonValueFromObj(_error);
            if (!_terror)
            {
                _terror.setErrorId(TT_ERROR_DEFAULT);
                _terror.setErrorMsg(_error.toString());
            }
        }
        (*_tmpFunc)({{OutParamName}} _terror);
        delete _tmpFunc;
    }

    net::RPCEngine::instance()->trafficWatch()->watch("on_{{FuncName}}", _response.objsize());
}\
'''
CLIENT_SUBSCRIBE_TEMPLATE_CPP =\
u'''\
r_int64 rpc_{{ServiceName}}_client::{{FuncName}}_async({{Param}} const boost::function<void ({{OutTypes}} bson::bo)>& _func)
{
    if ( NULL != m_client)
    {
        bson::bob _builder;
        {{GenBson}}
        bson::bo _obj = _builder.obj();
        net::RPCEngine::instance()->trafficWatch()->watch("{{FuncName}}", _obj.objsize());
        return _emitSubscribe("{{FuncName}}", _obj, boost::bind(&rpc_{{ServiceName}}_client::on_{{FuncName}}, this, _1, _2, _3, _func));
    } else {
        bson::bo _error = utils::TTError::makeErrorBson(TT_ERROR_NET_DISCONNECTED);
        on_{{FuncName}}(bson::bo(), _error, true, _func);
        return 0;
    }
}

void rpc_{{ServiceName}}_client::on_{{FuncName}}(bson::bo _response, bson::bo _error, bool _isFirst, const void*& _func)
{
    {{OutParamDeclear}}
    if (_error.isEmpty())
    {
        {{ParseBson}}
    }
    boost::function<void ({{OutTypes}} bson::bo)> _tmpFunc = static_cast< boost::function<void ({{OutTypes}} bson::bo)> >(_func);
    if (NULL != _tmpFunc)
        _tmpFunc({{OutParamName}} _error);
    net::RPCEngine::instance()->trafficWatch()->watch("on_{{FuncName}}", _response.objsize());
}

r_int64 rpc_{{ServiceName}}_client::{{FuncName}}_async_unsub({{Param}} const boost::function<void (bool, bson::bo)>& _func)
{
    if ( NULL != m_client)
    {
        bson::bob _builder;
        {{GenBson}}
        return _emitSubscribe("{{FuncName}}_unsub", _builder.obj(), boost::bind(&rpc_{{ServiceName}}_client::on_{{FuncName}}_unsub, this, _1, _2, _3, _func));
    } else {
        bson::bo _error = utils::TTError::makeErrorBson(TT_ERROR_NET_DISCONNECTED);
        on_{{FuncName}}_unsub(bson::bo(), _error, true, _func);
        return 0;
    }
}

void rpc_{{ServiceName}}_client::on_{{FuncName}}_unsub(bson::bo _response, bson::bo _error, bool _isFirst, const boost::function<void (bool, bson::bo)>& _func)
{
    bool success = false;
    if (_error.isEmpty())
    {
        if (utils::safeParseBson(_response, "success", success);
    }
    if (NULL != _func)
        _func(success, _error);
}
'''

CLIENT_SUBSCRIBE_TEMPLATE_V2_CPP =\
u'''\
r_int64 rpc_{{ServiceName}}_client::{{FuncName}}_async({{Param}} const boost::function<void ({{OutTypes}} const utils::TTError&)>& _func)
{
    if ( NULL != m_client)
    {
        bson::bob _builder;
        {{GenBson}}
        bson::bo _obj = _builder.obj();
        net::RPCEngine::instance()->trafficWatch()->watch("{{FuncName}}", _obj.objsize());
        return _emitSubscribe("{{FuncName}}", _obj, boost::bind(&rpc_{{ServiceName}}_client::on_{{FuncName}}, this, _1, _2, _3, _func));
    } else {
        utils::TTError _terror = utils::TTError(TT_ERROR_NET_DISCONNECTED);
        on_{{FuncName}}(bson::bo(), _terror, true, _func);
        return 0;
    }
}

void rpc_{{ServiceName}}_client::on_{{FuncName}}(bson::bo _response, bson::bo _error, bool _isFirst, const void*& _func)
{
    {{OutParamDeclear}}
    if (_error.isEmpty())
    {
        {{ParseBson}}
    }
    boost::function<void ({{OutTypes}} bson::bo)> _tmpFunc = static_cast< boost::function<void ({{OutTypes}} bson::bo)> >(_func);
    if (NULL != _tmpFunc)
    {
        utils::TTError _terror;
        if (!_error.isEmpty())
        {
            _terror.bsonValueFromObj(_error);
            if (!_tError)
            {
                tError->setErrorId(TT_ERROR_DEFAULT);
                tError->setErrorMsg(berror.toString());
            }
        }
        _tmpFunc({{OutParamName}} _terror);
    }
    net::RPCEngine::instance()->trafficWatch()->watch("on_{{FuncName}}", _response.objsize());
}

r_int64 rpc_{{ServiceName}}_client::{{FuncName}}_async_unsub({{Param}} const boost::function<void (bool, const utils::TTError&)>& _func)
{
    if ( NULL != m_client)
    {
        bson::bob _builder;
        {{GenBson}}
        return _emitSubscribe("{{FuncName}}_unsub", _builder.obj(), boost::bind(&rpc_{{ServiceName}}_client::on_{{FuncName}}_unsub, this, _1, _2, _3, _func));
    } else {
        utils::TTError _error = utils::TTError(TT_ERROR_NET_DISCONNECTED);
        on_{{FuncName}}_unsub(bson::bo(), _error, true, _func);
        return 0;
    }
}

void rpc_{{ServiceName}}_client::on_{{FuncName}}_unsub(bson::bo _response, bson::bo _error, bool _isFirst, const boost::function<void (bool, bson::bo)>& _func)
{
    bool success = false;
    if (_error.isEmpty())
    {
        if (utils::safeParseBson(_response, "success", success);
    }
    if (NULL != _func)
    {
        utils::TTError _terror;
        if (!_error.isEmpty())
        {
            _terror.bsonValueFromObj(_error);
            if (!_tError)
            {
                tError->setErrorId(TT_ERROR_DEFAULT);
                tError->setErrorMsg(berror.toString());
            }
        }
        _func(success, _error);
    }
}
'''

CLIENT_PUSH_CODE_TEMPLATE_CPP =\
u'''\
void rpc_{{ServiceName}}_client::on_{{FuncName}}(bson::bo _response)
{
    {{ParamDeclear}}
    {{ParseBson}}
    on_{{FuncName}}({{ParamNames}});
    net::RPCEngine::instance()->trafficWatch()->watch("on_{{FuncName}}", _response.objsize());
}

void rpc_{{ServiceName}}_client::on_{{FuncName}}({{Params}})
{

}\
'''

NOTIFY_CODE_TEMPLATE = '''\
if (func == "{{PushFunction}}")
{
    on_{{PushFunction}}(response);
    return;
}
'''

IF_ELSE_FIXED = u'''\
bool update = false;
memset(sql, 0, sizeof(sql));
{{SPRINT_SELECT}}
if(!mysql_query(mysql, sql))
    {
    MYSQL_RES *results = mysql_store_result(mysql);
if(results)
    {
    MYSQL_ROW sqlrow = mysql_fetch_row(results);
if(NULL != sqlrow)
    {
    update = true;
}
}
mysql_free_result(results);
}
else
    {
    cout<<"mysql_query error,"<<mysql_error(mysql)<<endl;
continue;
}

//
memset(sql, 0, sizeof(sql));
'''

FILE_MAIN_SQL =u'''\
#include <redisclient.h>
#include <bson/src/bson.h>
#include <log4cxx/logger.h>
#include <log4cxx/propertyconfigurator.h>
#include <mysql/mysql.h>
#include "utils/Config.h"
#include "utils/convFunc.h"
#include "Protocol/rpc_ClientTrader.h"
#include "Protocol/rpc_Structs.h"
#include "Protocol/rpc_ClientTraderCommon.h"

using namespace boost;
using namespace std;

using namespace log4cxx;
using namespace utils;

string seconds2date(int seconds)
{
    time_t _seconds = seconds;
    r_int64 _time;
    struct tm tt;
    localtime_r(&_seconds, &tt);
    char buf[40] = {0};
    sprintf(buf, "%04d%02d%02d", tt.tm_year + 1900, tt.tm_mon + 1, tt.tm_mday);

    string date = buf;
    return date;
}

int main(int argc, char* argv[])
{
	if( argc != 2 )
	{
		cout<<"usage:"<<endl;
		cout<<"      "<<argv[0]<<" scanTask.ini"<<endl;
		return -1;
	}

	boost::shared_ptr<Configuration> m_config = boost::shared_ptr<Configuration>(new Configuration((const char*)argv[1]));
	m_config->load();
	string host = m_config->read("redis", "host");

	string ip = m_config->read("mysql", "ip");
	unsigned int port = m_config->readInt("mysql", "port", 3306);
	string user = m_config->read("mysql", "user");
	string pass = m_config->read("mysql", "pass");
	string db = m_config->read("mysql", "db");

	//connect redis
	boost::shared_ptr<redis::client> m_redis;
	try
	{
		m_redis.reset( new redis::client(host) );
	}
	catch(redis::redis_error e)
	{
		cerr<<e.what()<<endl;
		return -1;
	}

	//connect mysql
	MYSQL* mysql = NULL;
	if ( ( mysql = mysql_init(NULL))
		&& mysql_real_connect( mysql, ip.c_str(), user.c_str(), pass.c_str(), db.c_str(), port, NULL, CLIENT_MULTI_STATEMENTS ) )
	{
		if (mysql_set_server_option(mysql, MYSQL_OPTION_MULTI_STATEMENTS_ON))
		{
			cerr<<"mysql_set_server_option error"<<endl;
			return -1;
		}

		my_bool reconnect = 1;
		if (mysql_options(mysql, MYSQL_OPT_RECONNECT, &reconnect))
		{
			cerr<<"mysql_options error"<<endl;
			return -1;
		}
	}
	else
	{
		cerr<<"mysql_real_connect error,"<<mysql_error(mysql)<<endl;
		return -1;
	}

	{{CREATE_ALL_TABLE}}
	if(mysql_real_query(mysql, createStr, strlen(createStr)) ){
				cout<<"mysql_query error,"<<mysql_error(mysql)<<endl;
				cout<<createStr<<endl;
	}

	//scan redis
	vector<string> vkey;
	char buf[1024] = {0};
	string strDate = seconds2date(time(NULL));
	sprintf(buf, "*detailInfos*");
	m_redis->keys(buf, vkey);
	for(size_t i=0; i<vkey.size(); i++)
	{
	    string strdata = m_redis->get(vkey[i]);
	    bson::bo bsobj(strdata.c_str());
	    {{VALUE_INITE}}
	    ttservice::CFtAccountDetail accountDetail;
	    utils::safeParseBson(bsobj.copy(), "accounts", accountDetail);
	    char sql[4096] = {0};
		{{UPDATE_CODES}}
		return 0;
	}
}
'''