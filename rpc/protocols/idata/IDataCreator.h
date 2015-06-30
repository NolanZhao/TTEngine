/********************************************************************
	company:    北京睿智融科控股有限公司
	fileName:	IDataCreator.h
	author:		xujun    
	created:	2013/26/12   18:43	
	purpose:	IData创建器
*********************************************************************/
#ifndef IDataCreator_2013_12_26_H
#define IDataCreator_2013_12_26_H

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

namespace ttservice
{
    // IData构造器
    class IDataCreator
    {
    public:
        virtual IDataPtr createByV1(bson::bo::iterator& iter) = 0;
        virtual IDataPtr createByV2(bson::bo::iterator& iter) = 0;
        virtual IDataPtr createInstance() = 0;
    };

    template <typename T>
    class TypeCreator : public IDataCreator
    {
    public :
        virtual IDataPtr createByV1(bson::bo::iterator& iter)
        {
            boost::shared_ptr<T> ret(new T);
            ret->bsonValueFromObj_v1(iter);
            return ret;
        };

        virtual IDataPtr createByV2(bson::bo::iterator& iter)
        {
            boost::shared_ptr<T> ret(new T);
            ret->bsonValueFromObj_v2(iter);
            return ret;
        };

        virtual IDataPtr createInstance()
        {
            boost::shared_ptr<T> ret(new T);
            return ret;
        };

    };
}


#endif