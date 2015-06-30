#coding=utf8
__author__ = 'Administrator'


STD_CLIENT_PUSH_FUNC_TEMPLATE_HPP =\
u'''\
inline void rpc_{{ServiceName}}_client::on_{{FuncName}}(bson::bo _response)
{
    {{ParamDeclear}}
    {{ParseBson}}
    sig_{{FuncName}}({{ParamNames}});
}
'''
# HPP File Template
STD_CLIENT_CLASS_TEMPLATE_HPP =\
'''\
class rpc_{{ServiceName}}_client
{
public:
    boost::shared_ptr<net::RPCClient> m_client;

public:
    {{SignalFunctions}}

public:
    rpc_{{ServiceName}}_client();
    rpc_{{ServiceName}}_client(boost::shared_ptr<net::RPCClient> client);
    virtual ~rpc_{{ServiceName}}_client();
    void init();
    void destroy();
    void onNotification(std::string func, bson::bo response);

    virtual bson::bo _request(std::string func, bson::bo param, r_uint8 compress = COMPRESS_NONE);
    virtual void _emitRequest(std::string func, bson::bo param, const net::CallbackFunc &cb, r_uint8 compress = COMPRESS_NONE);
    virtual bson::bo _subscribe(std::string func, bson::bo param, const net::CallbackFunc &cb, r_int64 &seq);
    virtual r_int64 _emitSubscribe(std::string func, bson::bo param, const net::CallbackFunc &cb);

    virtual void connect(bson::bo* _rError);
    virtual void connect_async( const boost::function<void (bson::bo)>& _func);
    virtual void on_connect(bson::bo _response, bson::bo _error, bool _isFirst, const boost::function<void (bson::bo)>& _func);

    virtual void disconnect( bool& success,  bson::bo* _rError);
    virtual void disconnect_async( const boost::function<void (bool,  bson::bo)>& _func);
    virtual void on_disconnect(bson::bo _response, bson::bo _error, bool _isFirst, const boost::function<void (bool,  bson::bo)>& _func);

    {{FunctionContent}}

    {{PushFunctionDeclear}}
};

'''


STD_CLIENT_CLASS_TEMPLATE_V2_HPP =\
'''\
class rpc_{{ServiceName}}_client
{
public:
    boost::shared_ptr<net::RPCClient> m_client;

public:
    {{SignalFunctions}}

public:
    rpc_{{ServiceName}}_client();
    rpc_{{ServiceName}}_client(boost::shared_ptr<net::RPCClient> client);
    virtual ~rpc_{{ServiceName}}_client();
    void init();
    void destroy();
    void onNotification(std::string func, bson::bo response);
    virtual bson::bo _request(std::string func, bson::bo param, r_uint8 compress = COMPRESS_NONE);
    virtual void _emitRequest(std::string func, bson::bo param, const net::CallbackFunc &cb, r_uint8 compress = COMPRESS_NONE);
    virtual bson::bo _subscribe(std::string func, bson::bo param, const net::CallbackFunc &cb, r_int64 &seq);
    virtual r_int64 _emitSubscribe(std::string func, bson::bo param, const net::CallbackFunc &cb);
    virtual void connect(utils::TTError* _tError);
    virtual void connect_async( const boost::function<void (const utils::TTError&)>& _func);
    virtual void on_connect(bson::bo _response, bson::bo _error, bool _isFirst, const boost::function<void (const utils::TTError&)>& _func);
    virtual void disconnect(utils::TTError* _rError);
    virtual void disconnect_async( const boost::function<void (const utils::TTError&)>& _func);
    virtual void on_disconnect(bson::bo _response, bson::bo _error, bool _isFirst, const boost::function<void (const utils::TTError&)>& _func);

    {{FunctionContent}}
    {{PushFunctionDeclear}}
};

'''

# CPP File Template

STD_CLIENT_PUSH_FUNC_TEMPLATE_CPP =\
u'''\
inline void rpc_{{ServiceName}}_client::on_{{FuncName}}(bson::bo _response)
{
    {{ParamDeclear}}
    {{ParseBson}}
    sig_{{FuncName}}({{ParamNames}});
}
'''

STD_CLIENT_CLASS_TEMPLATE_CPP =\
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

void rpc_{{ServiceName}}_client::destroy()
{
    if (NULL != m_client)
    {
        m_client->destroy();
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

void rpc_{{ServiceName}}_client::connect(bson::bo* _rError)
{
    if ( NULL != m_client)
    {
        try {
            bson::bob _builder;
            bson::bo error = _request("connect", _builder.obj());
            if (NULL != _rError)
            {
                *_rError = error;
            }
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
}

void rpc_{{ServiceName}}_client::connect_async( const boost::function<void (bson::bo)>& _func)
{
    if ( NULL != m_client)
    {
        bson::bob _builder;

        _emitSubscribe("connect", _builder.obj(), boost::bind(&rpc_{{ServiceName}}_client::on_connect, this, _1, _2, _3, _func));
    } else {
        bson::bo error = utils::TTError::makeErrorBson(TT_ERROR_NET_DISCONNECTED);
        on_connect(bson::bo(), error, true, _func);
    }
}

void rpc_{{ServiceName}}_client::on_connect(bson::bo _response, bson::bo _error, bool _isFirst, const boost::function<void (bson::bo)>& _func)
{
    if (NULL != _func)
        _func(_error);
}

void rpc_{{ServiceName}}_client::disconnect( bool& success,  bson::bo* _rError)
{
    if ( NULL != m_client)
    {
        try {
            bson::bob _builder;

            bson::bo _response = _request("disconnect", _builder.obj());
            utils::safeParseBson(_response, "success", success);
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
}

void rpc_{{ServiceName}}_client::disconnect_async( const boost::function<void (bool,  bson::bo)>& _func)
{
    if ( NULL != m_client)
    {
        bson::bob _builder;

        _emitRequest("disconnect", _builder.obj(), boost::bind(&rpc_{{ServiceName}}_client::on_disconnect, this, _1, _2, _3, _func));
    } else {
        bson::bo error = utils::TTError::makeErrorBson(TT_ERROR_NET_DISCONNECTED);
        on_disconnect(bson::bo(), error, true, _func);
    }
}

void rpc_{{ServiceName}}_client::on_disconnect(bson::bo _response, bson::bo _error, bool _isFirst, const boost::function<void (bool,  bson::bo)>& _func)
{
    bool success = false;
    if (_error.isEmpty())
    {
        utils::safeParseBson(_response, "success", success);
    }
    if (NULL != _func)
        _func(success,  _error);
}

{{FunctionContent}}
{{PushFunctionContent}}
'''


STD_CLIENT_CLASS_TEMPLATE_V2_CPP =\
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

void rpc_{{ServiceName}}_client::destroy()
{
    if (NULL != m_client)
    {
        m_client->destroy();
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

void rpc_{{ServiceName}}_client::connect(utils::TTError* _tError)
{
    if ( NULL != m_client)
    {
        try {
            bson::bob _builder;
            bson::bo error = _request("connect", _builder.obj());
            if (NULL != _tError)
            {
                _tError->bsonValueFromObj(error);
            }
        }
        catch(const utils::TTError& terror)
        {
            if (NULL != _tError)
            {
                *_tError = terror;
            }
        }
        catch(bson::bo ex)
        {
            if (NULL != _tError)
            {
                _tError->bsonValueFromObj(ex);
            }
        }
    } else {
        if (NULL != _tError)
        {
            *_tError = utils::TTError(TT_ERROR_NET_DISCONNECTED);
        }
    }
}

void rpc_{{ServiceName}}_client::connect_async( const boost::function<void (const utils::TTError&)>& _func)
{
    if ( NULL != m_client)
    {
        bson::bob _builder;

        _emitSubscribe("connect", _builder.obj(), boost::bind(&rpc_{{ServiceName}}_client::on_connect, this, _1, _2, _3, _func));
    } else {
        bson::bo error = utils::TTError::makeErrorBson(TT_ERROR_NET_DISCONNECTED);
        on_connect(bson::bo(), error, true, _func);
    }
}

void rpc_{{ServiceName}}_client::on_connect(bson::bo _response, bson::bo _error, bool _isFirst, const boost::function<void (const utils::TTError&)>& _func)
{
    if (NULL != _func)
    {
        utils::TTError _tError;
        _tError.bsonValueFromObj(_error);
        _func(_tError);
    }
}

void rpc_{{ServiceName}}_client::disconnect(utils::TTError* _rError)
{
    if ( NULL != m_client)
    {
        try {
            bson::bob _builder;

            bson::bo _response = _request("disconnect", _builder.obj());
        }
        catch(bson::bo ex)
        {
            if (NULL != _rError)
            {
                _rError->bsonValueFromObj(ex);
            }
        }
    } else {
        if (NULL != _rError)
        {
            *_rError = utils::TTError(TT_ERROR_NET_DISCONNECTED);
        }
    }
}

void rpc_{{ServiceName}}_client::disconnect_async( const boost::function<void (const utils::TTError&)>& _func)
{
    if ( NULL != m_client)
    {
        bson::bob _builder;

        _emitRequest("disconnect", _builder.obj(), boost::bind(&rpc_{{ServiceName}}_client::on_disconnect, this, _1, _2, _3, _func));
    } else {
        bson::bo error = utils::TTError::makeErrorBson(TT_ERROR_NET_DISCONNECTED);
        on_disconnect(bson::bo(), error, true, _func);
    }
}

void rpc_{{ServiceName}}_client::on_disconnect(bson::bo _response, bson::bo _error, bool _isFirst, const boost::function<void (const utils::TTError&)>& _func)
{
    bool success = false;
    if (NULL != _func)
    {
        utils::TTError _terror;
        _terror.bsonValueFromObj(_error);
        _func(_terror);
    }
}

{{FunctionContent}}

{{PushFunctionContent}}

'''