/**
 *  数据单元描述
 *
 *  @author xujun
 *  @since  2013-1-13
 */
#ifndef _FieldDescript_2013_1_13_h__
#define _FieldDescript_2013_1_13_h__

#include <boost/algorithm/string.hpp>
#include "Protocol/rpc_Enums.h"
#include "utils/commonFunc.h"
#include "idata/IFieldParse.h"

namespace ttservice
{
    // field描述
    struct  FieldDes 
    {
        int             m_nId;      // 编号
        EXT_DATA_TYPE   m_nType;    // 类型
        vector<string>  m_strNames;  // 展示的名称
        double          m_dPrecision;// 精度
        int             m_iFlag;    // 显示用
        int             m_nIDataId; // IData的数据类型, 如XT_CAccountDetail, 不是IData的则为-1
        vector<bool>    m_visible;  // 是否可见
        string          m_strFieldName; //Field的名称
        string          m_strTypeName; //类型名称
        map<int, bool>  m_propertys;   //各种属性
        map<string, vector< vector<int> > > m_funcs; //各种函数调用
        FieldParsePtr   m_parser;   //解析
        int             m_nOffset;  // 偏移

        FieldDes();
        void init(string name, string visible);

        FieldDes(int id, EXT_DATA_TYPE typ, string name, double precision = 2.0, int flag = 0, int nIDataId = -1, \
            string visible = "", string strTypeName = "", std::map<int, bool> propertys = std::map<int, bool>()\
            , std::map<string, vector< vector<int> > > funcs = map<string, vector< vector<int> > >(), string fieldName = "", FieldParsePtr parser = FieldParsePtr(), int nOffset = 0);
    };

    inline bool operator< (const FieldDes & l, const FieldDes & r)
    {
        return l.m_nId < r.m_nId;
    }

    // 结构描述
    struct  StructDes
    {
        typedef map<string, int> Key2IdMap;
        int             m_nId;      // 编号
        int             m_nBaseId;  // 基类编号
        string          m_strName;  // 名称
        map<int, FieldDes> m_fields;  // Field
        Key2IdMap m_key2fieldId;  // Field
        vector<FieldDes> m_vFields; // 此处结构重复, 在确定m_fields是否使用砍之
        int             m_size;
        int             m_baseSize;

        StructDes() { m_nId = -1; }
        StructDes(int id, int baseId, string name, const map<int, FieldDes>& fields) ;

        // 取得本类型Id
        inline int getId() const{
            return m_nId;
        }

        // 取得基类Id, 如果基类Id为-1则取该类型Id
        inline int getBaseId() const {
            if (m_nBaseId == -1)
            {
                return m_nId;
            } else {
                return m_nBaseId;
            }
        };

        inline const FieldDes& getFieldDes(const int& nId) const
        {
            int nIndex = nId - m_nId * 100 - 1;
            if (nIndex >= 0 && nIndex < 100)
            {
                return m_vFields[nIndex];
            } else {
                nIndex = nId - m_nBaseId * 100 - 1 + m_size;
                return m_vFields[nIndex];
            }
        }
    };
}

#endif // FieldDescript_h__