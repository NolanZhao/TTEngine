#include "common/Stdafx.h"
#include "idata/IDataBson.h"

namespace utils{

    bson::bob& appendBuilderWithVectorUseBson(bson::bob& builder, const char* key, const vector<ttservice::IDataPtr>& datas)
    {
        bson::BSONArrayBuilder arrayBuilder(builder.subarrayStart(key));
        for (vector<ttservice::IDataPtr>::const_iterator iter = datas.begin(); iter != datas.end(); ++iter)
        {
            ttservice::IDataPtr ptrData = *iter;
            if (NULL != ptrData)
            {
                arrayBuilder.append(ptrData->toBsonWithBson());
            }
        }
        arrayBuilder.done();
        return builder;
    }
}