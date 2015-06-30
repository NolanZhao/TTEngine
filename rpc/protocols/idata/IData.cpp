#include "common/Stdafx.h"
#include "idata/IData.h"

namespace ttservice
{
    // xujun(20131015) 新增内容为protobuf的Idata数据, 为了兼容portal以及脚本, 增加此函数
    void IData::appendElementsWithNoTypeIdWithBson(bson::bob& objBuilder) const 
    {
        appendElementsWithNoTypeId(objBuilder);
    };

    bson::bo IData::toBsonWithBson() const
    {
        return toBson();
    };

    void IData::bsonValueFromObj(bson::bo obj) 
    {
        bson::bo::iterator objIter(obj);
        if (!objIter.more())
        {
            return;
        }

        bson::be element = *objIter;
        if (strcmp(element.fieldName(), "_t") == 0)
        {
            if (objIter.more())
            {
                ++objIter;
                bsonValueFromObj_v2(objIter);
            }
        }
        else if (strcmp(element.fieldName(), "_typeId") == 0)
        {
            if (objIter.more())
            {
                ++objIter;
                bsonValueFromObj_v1(objIter);
            }
        } else {
            bsonValueFromObj_v1(objIter);
        }
    }


    void IData::bsonValueFromObj_v1(bson::bo::iterator& objIter)
    {
        const StructDes& structDes = getStructDes();
        vector<FieldDes>::const_iterator desIter = structDes.m_vFields.begin();
        bson::be element = *objIter;
        while (desIter != structDes.m_vFields.end())
        {
            if (strcmp(desIter->m_strFieldName.c_str(), element.fieldName()) == 0)
            {
                desIter->m_parser->parseField(this, element);
            } else {
                break;
            }

            if (objIter.more())
            {
                ++desIter;
                ++objIter;
                element = *objIter;
            } else {
                return;
            }
        }

        while (true)
        {
            StructDes::Key2IdMap::const_iterator key2idIter = structDes.m_key2fieldId.find(string(element.fieldName()));
            if (key2idIter != structDes.m_key2fieldId.end())
            {
                const int& nId = key2idIter->second;
                const FieldDes& fieldDes = structDes.getFieldDes(nId);
                fieldDes.m_parser->parseField(this, element);
            }

            if (objIter.more())
            {
                ++objIter;
                element = *objIter;
            } else {
                return;
            }
        }
    }

    void IData::bsonValueFromObj_v2(bson::bo::iterator& objIter)
    {
        const StructDes& structDes = getStructDes();
        const vector<FieldDes>& fields = structDes.m_vFields;
        int nBaseStart = 0;
        int preIndex = -1;

        bson::be element;
        while (true)
        {
            element = *objIter;
            int nFieldIndex = atoi(element.fieldName());
            if (nFieldIndex == 0 && strcmp(element.fieldName(), "_t") == 0)
            {
                nBaseStart = structDes.m_size;
            } else {

                // 切换到基类
                if (nFieldIndex <= preIndex)
                {
                    nBaseStart = structDes.m_size;
                }

                if ( (nFieldIndex + nBaseStart) < (int)fields.size())
                {
                    fields[nFieldIndex + nBaseStart].m_parser->parseField(this, element);
                }

                preIndex = nFieldIndex;
            }

            if (objIter.more())
            {
                ++objIter;
            } else {
                break;
            }
        }
    }

    void IData::appendElements(bson::bob& objBuilder) const
    {
        const StructDes& structDes = getStructDes();
        utils::appendToBuilder(objBuilder, "_typeId", structDes.m_nId);;
        appendElementsWithNoTypeId(objBuilder);
    }

    void IData::appendElements_v2(bson::bob& objBuilder) const
    {
        const StructDes& structDes = getStructDes();
        utils::appendToBuilder(objBuilder, "_t", structDes.m_nId);
        appendElementsWithNoTypeId_v2(objBuilder);
    };

    void IData::appendElementsWithNoTypeId(bson::bob& objBuilder) const
    {
        const StructDes& structDes = getStructDes();
        for (vector<FieldDes>::const_iterator iter = structDes.m_vFields.begin(); iter != structDes.m_vFields.end(); ++iter)
        {
            const FieldDes& fdes = *iter;
            fdes.m_parser->appendToBuilder_v1(objBuilder, this);
        }
    }

    void IData::appendElementsWithNoTypeId_v2(bson::bob& objBuilder) const
    {
        const StructDes& structDes = getStructDes();

        // 如果有继承关系, 则子类的第一个数据必须写入, 这样在解析的时候可以保证解析出第一个
        bool equalAppend = (structDes.getBaseId() != -1);        
        vector<FieldDes>::const_iterator start = structDes.m_vFields.begin();
        for (vector<FieldDes>::const_iterator iter = structDes.m_vFields.begin(); iter != structDes.m_vFields.end(); ++iter)
        {
            const FieldDes& fdes = *iter;            
            fdes.m_parser->appendToBuilder_v2(objBuilder, this, equalAppend);
            if (equalAppend)
            {
                equalAppend = false;
            }
        }
    }

    int IData::getBaseId() const
    {
        return getStructDes().getBaseId();
    }

    const FieldDes& IData::getFieldDes(int id) const
    {
        return getStructDes().getFieldDes(id);
    }

    int IData::getOffset(int id) const
    {
        return getFieldDes(id).m_nOffset;
    }

    const map<int, FieldDes>& IData::getFieldDes() const
    {
        return getStructDes().m_fields;
    }

    bool IData::isEqual(const IData* pRight) const
    {
        bool ret = true;
        if (NULL != pRight && this->getStructDes().getId() == pRight->getStructDes().getId())
        {
            const StructDes& des = this->getStructDes();
            for (vector<FieldDes>::const_iterator iter = des.m_vFields.begin(); iter != des.m_vFields.end(); ++iter)
            {
                FieldParsePtr ptrParse = iter->m_parser;
                if (NULL != ptrParse)
                {
                    if (!ptrParse->isFieldEqual(this, pRight))
                    {
                        ret = false;
                        break;
                    }
                }
            }
        } else {
            ret = false;
        }
        return ret;
    }
}