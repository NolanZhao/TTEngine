#include "common/Stdafx.h"
#include "idata/DataDesc.h"

namespace ttservice
{
    FieldDes::FieldDes()
        : m_nId(0) 
        , m_nType(XT_DATA_TYPE_BOOL) 
        , m_dPrecision(2) 
        , m_iFlag(utils::FDF_NONE) 
        , m_nIDataId(-1)
        , m_visible(vector<bool>(1, true))
        , m_propertys(std::map<int, bool>() )
        , m_funcs(std::map<string, vector< vector<int> > >() )
    {

    };
        
    FieldDes::FieldDes(int id, EXT_DATA_TYPE typ, string name, double precision, int flag, int nIDataId, string visible, string strTypeName, std::map<int, bool> propertys\
        , std::map<string, vector< vector<int> > > funcs, string fieldName, FieldParsePtr parser, int nOffset)
        : m_nId(id)
        //, m_strNames(name) 
        , m_dPrecision(precision) 
        , m_iFlag(flag) 
        , m_nIDataId(nIDataId)
        , m_strTypeName(strTypeName)
        , m_propertys(propertys)
        , m_funcs(funcs)
        , m_strFieldName(fieldName)
        , m_parser(parser)
        ,m_nOffset(nOffset)
    { 
        m_nId = id;
        m_nType = typ;
        boost::split(m_strNames, name, boost::is_any_of(","));
        if (m_strNames.empty())
        {
            m_strNames.push_back("");
        }
        m_dPrecision = precision;
        m_iFlag = flag;
        m_nIDataId = nIDataId;
        vector<string> tmp;
        boost::split(tmp, visible, boost::is_any_of(","));
        size_t sizeT = tmp.size();
        m_visible.resize(sizeT);
        for (size_t i = 0; i < sizeT; i ++)
        {
            m_visible[i] = tmp[i].empty();
        }
        m_strTypeName = strTypeName;
        
    }

    void FieldDes::init(string name, string visible)
    {
        boost::split(m_strNames, name, boost::is_any_of(","));
        if (m_strNames.empty())
        {
            m_strNames.push_back("");
        }
        vector<string> tmp;
        boost::split(tmp, visible, boost::is_any_of(","));
        size_t sizeT = tmp.size();
        m_visible.resize(sizeT);
        for (size_t i = 0; i < sizeT; i ++)
        {
            m_visible[i] = tmp[i].empty();
        }
    }


    StructDes::StructDes(int id, int baseId, string name, const map<int, FieldDes>& fields) 
        :m_nId(id),
        m_nBaseId(baseId),
        m_strName(name),
        m_fields(fields)
    { 
        m_size = 0;
        m_baseSize = 0;

        // 本类
        for (map<int, FieldDes>::const_iterator iter = fields.begin(); iter != fields.end(); ++iter)
        {
            if (abs(iter->second.m_nId - m_nId * 100) < 100)
            {
                ++m_size;
                m_key2fieldId.insert(make_pair(iter->second.m_strFieldName.c_str(), iter->first));
                m_vFields.push_back(iter->second);
            }
        }

        // 基类
        for (map<int, FieldDes>::const_iterator iter = fields.begin(); iter != fields.end(); ++iter)
        {
            if (abs(iter->second.m_nId - m_nId * 100) >= 100)
            {
                ++m_baseSize;
                m_key2fieldId.insert(make_pair(iter->second.m_strFieldName.c_str(), iter->first));
                m_vFields.push_back(iter->second);
            }
        }
    }
}