/********************************************************************
	created:	2013/10/18
	created:	18:10:2013   17:48
	filename: 	f:\server5\ttservice\branches\shoushan_20130828\libs\base\src\idata\IFieldParse.h
	file path:	f:\server5\ttservice\branches\shoushan_20130828\libs\base\src\idata
	file base:	IFieldParse
	file ext:	h
	author:		xujun
	
	purpose:	Field½âÎö
*********************************************************************/
#ifndef IFieldParse_2013_10_18_H
#define IFieldParse_2013_10_18_H
#include "idata/EqualChecker.h"

namespace ttservice
{
    class IData;

    class IFieldParse
    {
    public:
        virtual void parseField(void* pData, const bson::be& element) const = 0;
        virtual void appendToBuilder_v1(bson::bob& objBuilder, const IData* pData) const = 0;
        virtual void appendToBuilder_v2(bson::bob& objBuilder, const IData* pData, const bool& equalAppend) const = 0;
        virtual bool isFieldEqual(const IData* pLeft, const IData* pRight) const = 0;
    };
    typedef boost::shared_ptr<IFieldParse> FieldParsePtr;

#define FIELD_PARSER(typeName, fieldName, index)\
    class typeName##_##fieldName : public IFieldParse\
    {\
    public:\
        typeName##_##fieldName()\
        {\
        m_strIndex = boost::lexical_cast<string>(index);\
        }\
        virtual void parseField(void* pData, const bson::be& element) const\
        {\
            utils::bsonValue(element, ((typeName*)pData)->fieldName);\
        };\
        virtual void appendToBuilder_v1(bson::bob& objBuilder, const IData* pData) const\
        {\
            utils::appendToBuilder(objBuilder, #fieldName, ((typeName*)pData)->fieldName);\
        };\
        virtual void appendToBuilder_v2(bson::bob& objBuilder, const IData* pData, const bool& equalAppend) const\
        {\
            if (equalAppend || !isFieldEqual(pData, &m_default))\
                utils::appendToBuilderV2(objBuilder, m_strIndex.c_str(), ((typeName*)pData)->fieldName);\
        };\
        virtual bool isFieldEqual(const IData* pLeft, const IData* pRight) const\
        {\
            return isEqual(((typeName*)pLeft)->fieldName, ((typeName*)pRight)->fieldName);\
        }\
    private:\
        std::string m_strIndex;\
        typeName m_default;\
    };\
    /* end */
}

#endif