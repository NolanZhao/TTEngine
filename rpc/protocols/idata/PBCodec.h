/********************************************************************
	created:	2013/10/14
	created:	14:10:2013   15:59
	filename: 	f:\server5\ttservice\branches\shoushan_20130828\libs\base\src\idata\PBCodec.h
	file path:	f:\server5\ttservice\branches\shoushan_20130828\libs\base\src\idata
	file base:	PBCodec
	file ext:	h
	author:		xujun
	
	purpose:	
*********************************************************************/
#ifndef PBCodec_2013_10_14_H
#define PBCodec_2013_10_14_H

#include "google/protobuf/io/coded_stream.h"
#include "google/protobuf/wire_format_lite.h"
#include "google/protobuf/wire_format_lite_inl.h"
#include "google/protobuf/io/zero_copy_stream_impl.h"

namespace ttservice
{
    using namespace ::google::protobuf;
    using namespace ::google::protobuf::io;
    using namespace ::google::protobuf::internal;

#define PB_CODEC_DECLEAR() \
public :\
    static PBCodec& instance()\
    {\
    static PBCodec acodec;\
    return acodec;\
    }\
private:\
    PBCodec(){};\
    PBCodec(const PBCodec& acodec);\
    PBCodec& operator=(const PBCodec& rhs); 

    //////////////////////////
    //∆’Õ®¿‡–Õ
    /////////////////////////
    template <typename T>
    class PBCodec
    {
        PB_CODEC_DECLEAR();
    public :
        void parse_from_pb(CodedInputStream* input, T& data)
        {
            string str;
            uint32 size = 0;
            input->ReadVarint32(&size);
            input->ReadString(&str, size);

            bson::bo obj(str.c_str());
            data.bsonValueFromObj(obj);
        }

        void serialze_to_pb(CodedOutputStream* output, const T& data)
        {
            bson::bob builder;
            data.appendElements(builder);
            bson::bo obj = builder.obj();

            google::protobuf::internal::WireFormatLite::WriteInt32NoTag(obj.objsize(), output);
            output->WriteRaw(obj.objdata(), obj.objsize());
        }
    };

    //////////////////////////
    //bool
    /////////////////////////
    template <>
    class PBCodec<bool>
    {
        PB_CODEC_DECLEAR();
    public :
        void parse_from_pb(CodedInputStream* input, bool& data)
        {
            google::protobuf::internal::WireFormatLite::ReadPrimitive<bool, WireFormatLite::TYPE_BOOL>(input, &data);
        }

        void serialze_to_pb(CodedOutputStream* output, const bool& data)
        {
            google::protobuf::internal::WireFormatLite::WriteBoolNoTag(data, output);
        }
    };

    //////////////////////////
    //r_int32
    /////////////////////////
    template <>
    class PBCodec<r_int32>
    {
        PB_CODEC_DECLEAR();
    public :
        void parse_from_pb(CodedInputStream* input, r_int32& data)
        {
            google::protobuf::internal::WireFormatLite::ReadPrimitive<r_int32, WireFormatLite::TYPE_INT32>(input, &data);
        }

        void serialze_to_pb(CodedOutputStream* output, const r_int32& data)
        {
            google::protobuf::internal::WireFormatLite::WriteInt32NoTag(data, output);
        }
    };

    //////////////////////////
    //r_int64
    /////////////////////////
    template <>
    class PBCodec<r_int64>
    {
        PB_CODEC_DECLEAR();
    public :
        void parse_from_pb(CodedInputStream* input, r_int64& data)
        {
            google::protobuf::internal::WireFormatLite::ReadPrimitive<r_int64, WireFormatLite::TYPE_INT64>(input, &data);
        }

        void serialze_to_pb(CodedOutputStream* output, const r_int64& data)
        {
            google::protobuf::internal::WireFormatLite::WriteInt64NoTag(data, output);
        }
    };

    //////////////////////////
    //double
    /////////////////////////
    template <>
    class PBCodec<double>
    {
        PB_CODEC_DECLEAR();
    public :
        void parse_from_pb(CodedInputStream* input, double& data)
        {
            google::protobuf::internal::WireFormatLite::ReadPrimitive<double, WireFormatLite::TYPE_DOUBLE>(input, &data);
        }

        void serialze_to_pb(CodedOutputStream* output, const double& data)
        {
            google::protobuf::internal::WireFormatLite::WriteDoubleNoTag(data, output);
        }
    };

    //////////////////////////
    //string
    /////////////////////////
    template <>
    class PBCodec<string>
    {
        PB_CODEC_DECLEAR();
    public :
        void parse_from_pb(CodedInputStream* input, string& data)
        {
            uint32 size = 0;
            input->ReadVarint32(&size);
            input->ReadString(&data, size);
        }

        void serialze_to_pb(CodedOutputStream* output, const string& data)
        {
            output->WriteVarint32(data.size());
            output->WriteString(data);
        }
    };

    //////////////////////////
    //bson::bo
    /////////////////////////
    template <>
    class PBCodec<bson::bo>
    {
        PB_CODEC_DECLEAR();
    public :
        void parse_from_pb(CodedInputStream* input, bson::bo& data)
        {
            string str;
            uint32 size = 0;
            input->ReadVarint32(&size);
            input->ReadRaw(&str, size);
            data = bson::bo(str.c_str());
        }

        void serialze_to_pb(CodedOutputStream* output, const bson::bo& data)
        {
            size_t size = data.objsize();
            output->WriteVarint32(data.objsize());
            output->WriteRaw(data.objdata(), data.objsize());
        }
    };


    //////////////////////////
    //vector
    /////////////////////////
    template <typename T>
    class PBCodec< vector<T> >
    {
        PB_CODEC_DECLEAR();
    public :
        void parse_from_pb(CodedInputStream* input, vector<T>& data)
        {
            uint32 size = 0;
            input->ReadVarint32(&size);

            data.resize(size);
            for (uint32 i = 0; i < size; ++i)
            {
                PBCodec<T>::instance().parse_from_pb(input, data[i]);
            }
        }

        void serialze_to_pb(CodedOutputStream* output, const vector<T>& data)
        {
            output->WriteVarint32(data.size());
            size_t size = data.size();
            for (size_t i = 0; i < size; ++i)
            {
                PBCodec<T>::instance().serialze_to_pb(output, data[i]);
            }
        }
    };

    //////////////////////////
    //map
    /////////////////////////
    template <typename K, typename V>
    class PBCodec< map<K, V> >
    {
        PB_CODEC_DECLEAR();
    public :
        void parse_from_pb(CodedInputStream* input, map<K, V>& data)
        {
            uint32 size = 0;
            input->ReadVarint32(&size);

            K k;
            V v;
            for (uint32 i = 0; i < size; ++i)
            {
                PBCodec<K>::instance().parse_from_pb(input, k);
                PBCodec<V>::instance().parse_from_pb(input, v);
                data.insert(make_pair(k, v));
            }
        }

        void serialze_to_pb(CodedOutputStream* output, const map<K, V>& data)
        {
            size_t size = data.size();
            output->WriteVarint32(size);
            for (typename map<K, V>::const_iterator iter = data.begin(); iter != data.end(); ++iter)
            {
                PBCodec<K>::instance().serialze_to_pb(output, iter->first);
                PBCodec<V>::instance().serialze_to_pb(output, iter->second);
            }
        }
    };

    //////////////////////////
    //shared_ptr
    /////////////////////////
    template <typename T>
    class PBCodec< boost::shared_ptr<T> >
    {
        PB_CODEC_DECLEAR();
    public :
        void parse_from_pb(CodedInputStream* input, boost::shared_ptr<T>& data)
        {
            data = boost::shared_ptr<T>(new T());
            if (NULL != data)
                PBCodec<T>::instance().parse_from_pb(input, *data);
        }

        void serialze_to_pb(CodedOutputStream* output, const boost::shared_ptr<T>& data)
        {
            if (NULL != data)
            {
                PBCodec<T>::instance().serialze_to_pb(output, *data);
            }
        }
    };



    template <typename T>
    void parse_from_pb(CodedInputStream* input, T& data)
    {
        PBCodec<T>::instance().parse_from_pb(input, data);
    }

    template <typename T>
    void serialze_to_pb(CodedOutputStream* output, const T& data)
    {
        PBCodec<T>::instance().serialze_to_pb(output, data);
    }

#define PB_CODEC_ENUM_IMPLEMENT(typeName) \
    template <>\
    class PBCodec<typeName>\
    {\
    PB_CODEC_DECLEAR();\
    public :\
    void parse_from_pb(CodedInputStream* input, typeName& data)\
    {\
    int d = (int)data;\
    google::protobuf::internal::WireFormatLite::ReadPrimitive<r_int32, WireFormatLite::TYPE_INT32>(input, &d);\
    }\
    void serialze_to_pb(CodedOutputStream* output, const typeName& data)\
    {\
    google::protobuf::internal::WireFormatLite::WriteInt32NoTag((r_int32)data, output);\
    }\
    };

#define PB_CODEC_STRUCT_IMPLEMENT(typeName) \
    template <>\
    class PBCodec<typeName>\
    {\
    PB_CODEC_DECLEAR();\
    public :\
    void parse_from_pb(CodedInputStream* input, typeName& data)\
    {\
    string str;\
    uint32 size = 0;\
    input->ReadVarint32(&size);\
    input->ReadString(&str, size);\
    bson::bo obj(str.c_str());\
    data.bsonValueFromObj(obj);\
    }\
    void serialze_to_pb(CodedOutputStream* output, const typeName& data)\
    {\
    bson::bob builder;\
    data.appendElements(builder);\
    bson::bo obj = builder.obj();\
    google::protobuf::internal::WireFormatLite::WriteInt32NoTag(obj.objsize(), output);\
    output->WriteRaw(obj.objdata(), obj.objsize());\
    }\
    };


    template <typename T>
    void toType(int i, T& d)
    {
        d = (T)i;
    };

}


#endif