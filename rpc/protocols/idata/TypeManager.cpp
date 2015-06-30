#include "common/Stdafx.h"
#include "idata/TypeManager.h"
#include "utils/BsonHelper.h"

namespace ttservice
{
    static TypeManager* s_temp = TypeManager::instance();

    template <typename TVector>
    int tradeTypeToIdx(const TVector & v, EXtTraderType eType)
    {
        if (v.empty())
        {
            return -1;
        }

        int idx = 0;
        if (TDT_FUTURE == eType)
        {
            idx = 1;
        }
        if (TDT_COMPOSE == eType)
        {
            idx = 2;
        }
        if (TDT_CREDIT == eType)
        {
            idx = 3;
        }

        return std::min<int>(idx, v.size() - 1);
    }

    TypeManager* TypeManager::instance()
    {
        static TypeManager s_instance;
        return &s_instance;
    }

    // 注册构造器
    void TypeManager::registerType(const StructDes& sd, IDataCreatorPtr creator)
    {
        size_t typeId = sd.m_nId;
        if (m_creators.find(typeId) != m_creators.end())
        {
            throw string("type duplicate");
        }
        m_creators[typeId] = creator;
        m_structes[typeId] = sd;
    }

    // 解码
    IDataPtr TypeManager::parse(bson::bo data)
    {
        IDataPtr ret;
        // 解析typeId
        int typeId = -1;
        bson::bo::iterator iter(data);
        bson::bo::iterator stIter = iter;
        bool flag = true;
        while (iter.more())
        {
            bson::be element = *iter;
            if (strcmp(element.fieldName(), "_t") == 0)
            {
                typeId = element.numberInt();
                if (typeId >= 0)
                {
                    IDataCreatorPtr creator = m_creators[typeId];
                    if (NULL != creator)
                    {
                        if (iter.more())
                        {
                            if (flag)
                            {
                                ++iter;
                                ret = creator->createByV2(iter);
                            }
                            else
                            {
                                ret = creator->createByV2(stIter);
                            }
                        }
                    }
                }
                break;
            }
            else if(strcmp(element.fieldName(), "_typeId") == 0)
            {
                typeId = element.numberInt();
                if (typeId >= 0)
                {
                    IDataCreatorPtr creator = m_creators[typeId];
                    if (NULL != creator)
                    {
                        if (iter.more())
                        {
                            if (flag)
                            {
                                ++iter;
                                ret = creator->createByV1(iter);
                            }
                            else
                            {
                                ret = creator->createByV1(stIter);
                            }
                        }
                    }
                }
                break;
            } else {
                ++iter;
            }
            flag = false;
        }
        return ret;
    }


    IDataPtr TypeManager::create(const int& typeId)
    {
        IDataPtr ret;
        IDataCreatorPtr creator = m_creators[typeId];
        if (NULL != creator)
        {
            ret = creator->createInstance();
        }
        return ret;
    }

    set<FieldDes> TypeManager::getAllFields( const vector<int> & metaIDs, EXtTraderType eTradeType ) const
    {
        set<FieldDes> s;
        for (vector<int>::const_iterator cIter = metaIDs.begin(); cIter != metaIDs.end(); ++cIter)
        {
            getFieldIDsImpl(s, *cIter, eTradeType);
        }
        return s;
    }

    void TypeManager::getFieldIDsImpl( set<FieldDes> & s, int nMetaID, EXtTraderType eTradeType ) const
    {
        StructDes stDes = getStructDes(nMetaID);
        for (map<int, FieldDes>::const_iterator cIter = stDes.m_fields.begin(); cIter != stDes.m_fields.end(); ++cIter)
        {
            const FieldDes & fdDes = cIter->second;
            bool visible = getFieldVisibleByType(cIter->second, eTradeType);
            if (visible)
            {
                if (XT_DATA_TYPE_IDATA == fdDes.m_nType)
                {
                    getFieldIDsImpl(s, fdDes.m_nIDataId, eTradeType);
                }
                else
                {
                    s.insert(fdDes);
                }
            }
        }
    }

    bool TypeManager::getFieldVisibleByType( const FieldDes& fie, EXtTraderType eTradeType ) const
    {
#ifdef PV_STANDALONE
        if (fie.m_funcs.find("visibleDeploy") != fie.m_funcs.end())
        {
            return false;
        }
#endif // PV_STANDALONE
#ifdef PV_DEPLOY
        if (fie.m_funcs.find("visibleStandalone") != fie.m_funcs.end())
        {
            return false;
        }
#endif // PV_DEPLOY
        int idx = tradeTypeToIdx(fie.m_visible, eTradeType);
        return (idx >= 0) ? fie.m_visible[idx] : false;
    }

    string TypeManager::getFieldChsNameByType( const FieldDes& fie, EXtTraderType eTradeType )
    {
        int idx = tradeTypeToIdx(fie.m_strNames, eTradeType);
        return (idx >= 0) ? fie.m_strNames[idx] : "";
    }

    void TypeManager::registerEnum(string enumName, int enumItemValue, string enumItemName)
    {
        vector<string> names;
        boost::algorithm::split(names, enumItemName, boost::is_any_of(","));
        m_enumNames[enumName][enumItemValue] = names;
    }

    string TypeManager::getEnumItemName(string enumName, int enumItemValue, EXtTraderType eTradeType)
    {
        map<string, map<int, vector<string> > >::iterator iter = m_enumNames.find(enumName);
        if (iter != m_enumNames.end())
        {
            map<int, vector<string> >::iterator iter2 = iter->second.find(enumItemValue);
            if (iter2 != iter->second.end())
            {
                int idx = tradeTypeToIdx(iter2->second, eTradeType);
                return (idx >= 0) ? iter2->second[idx] : "";
            }
        }
        return "";
    }

    IDataPtr TypeManager::getLastIData(IDataPtr data, std::vector<int> param)
    {
        IDataPtr ret = data;
        for (std::vector<int>::iterator iter = param.begin(); iter != param.end(); iter++)
        {
            if (ret)
            {
                map<int, FieldDes>::const_iterator it = ret->getStructDes().m_fields.find(*iter);
                if (it != ret->getStructDes().m_fields.end() && it->second.m_nType == XT_DATA_TYPE_IDATA)
                {
                    IDataPtr tmp = ret->getIData(*iter);
                    if (tmp)
                    {
                        ret = tmp;
                    }
                    else
                    {
                        return ret;
                    }
                }
                else
                {
                    return ret;
                }
            }
            else
            {
                return ret;
            }
        }
        return ret;
    }
}
