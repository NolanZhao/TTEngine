/********************************************************************
	created:	2013/10/14
	created:	14:10:2013   11:58
	filename: 	f:\server5\ttservice\branches\shoushan_20130828\libs\base\src\idata\IDataCodec.h
	file path:	f:\server5\ttservice\branches\shoushan_20130828\libs\base\src\idata
	file base:	IDataCodec
	file ext:	h
	author:		xujun
	
	purpose:	IData编解码
*********************************************************************/
#ifndef IDataCodec_2013_10_14_H
#define IDataCodec_2013_10_14_H
#include "google/protobuf/io/coded_stream.h"
#include "google/protobuf/wire_format_lite.h"
#include "google/protobuf/wire_format_lite_inl.h"
#include "idata/IData.h"
#include "idata/TypeManager.h"

namespace ttservice
{
    //////////////////////////
    //普通类型
    /////////////////////////
    template <>
    class PBCodec<IDataPtr>
    {
        PB_CODEC_DECLEAR();
    public :
        void parse_from_pb(CodedInputStream* input, IDataPtr& data)
        {
            uint32 typeId = 0;
            input->ReadVarint32(&typeId);
            data = TypeManager::instance()->create(typeId);
            if (NULL != data)
            {
                data->parse_from_pb_imp(input);
            }
        }

        void serialze_to_pb(CodedOutputStream* output, const IDataPtr& data)
        {
            data->serialze_to_pb_imp(output);
        }
    };
 }

#endif