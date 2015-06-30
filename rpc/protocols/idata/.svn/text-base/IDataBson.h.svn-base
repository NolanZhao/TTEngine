/**
 *  
 *
 *  @author xujun
 *  @since  2013-1-22
 */
#ifndef _IDataBson_2013_1_22_h__
#define _IDataBson_2013_1_22_h__

#include "idata/IData.h"
#include "idata/TypeManager.h"

namespace utils
{    
    template <>
    class Codec<boost::shared_ptr<ttservice::IData> >
    {
        CODEC_DECLEAR();
    public :
        void appendToBuilder(bson::bob& builder, const char* key, const boost::shared_ptr<ttservice::IData>& data)
        {
            bson::bob objBuilder(builder.subobjStart(key));
            if (NULL != data)
                data->appendElements(objBuilder);
            objBuilder.done();
        }
        void appendToArrayBuilder(bson::BSONArrayBuilder& builder, const boost::shared_ptr<ttservice::IData>& data)
        {
            bson::bob objBuilder(builder.subobjStart());
            if (NULL != data)
                data->appendElements(objBuilder);
            objBuilder.done();
        }
        void appendToBuilderV2(bson::bob& builder, const char* key, const boost::shared_ptr<ttservice::IData>& data)
        {
            bson::bob objBuilder(builder.subobjStart(key));
            if (NULL != data)
                data->appendElements_v2(objBuilder);
            objBuilder.done();
        }
        void appendToArrayBuilderV2(bson::BSONArrayBuilder& builder, const boost::shared_ptr<ttservice::IData>& data)
        {
            bson::bob objBuilder(builder.subobjStart());
            if (NULL != data)
                data->appendElements_v2(objBuilder);
            objBuilder.done();
        }
        void bsonValue(const bson::be& bdata, boost::shared_ptr<ttservice::IData>& data)
        {
            data = ttservice::TypeManager::instance()->parse(bdata.Obj());
        };
    };

    bson::bob& appendBuilderWithVectorUseBson(bson::bob& builder, const char* key, const vector<ttservice::IDataPtr>& datas);

}

#endif // IDataBson_h__