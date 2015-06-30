/**
 *  类型管理器
 *
 *  @author xujun
 *  @since  2013-1-15
 */
#ifndef _TypeManager_2013_1_15_h__
#define _TypeManager_2013_1_15_h__

#include "bson/src/bson.h"
#include "idata/IData.h"
#include "idata/DataDesc.h"
#include <boost/shared_ptr.hpp>
#include "utils/STLHelper.h"
#include "idata/IDataCreator.h"

namespace ttservice
{
    class TypeManager
    {
    public:
        static TypeManager* instance();

        // 注册构造器
        void registerType(const StructDes& sd, IDataCreatorPtr creator);

        // 解码
        IDataPtr parse(bson::bo data);

        // 根据题意peId构造
        IDataPtr create(const int& typeId);

        // 数据字典
        const map<int, StructDes>& getStructDesMap() {return m_structes;};
        vector<StructDes> getStructDes() {return utils::values(m_structes);};
        const StructDes& getStructDes(int id) const {return utils::getMapValueConstRef(m_structes, id);};

        set<FieldDes> getAllFields(const vector<int> & metaIDs, EXtTraderType eTradeType) const;

        void registerEnum(string enumName, int enumItemValue, string enumItemName);
        string getEnumItemName(string enumName, int enumItemValue, EXtTraderType eTradeType);//第三个参数含义是对应的是期货、股票还是以后的其他内容
        string getFieldChsNameByType(const FieldDes& fie, EXtTraderType eTradeType);
        bool getFieldVisibleByType(const FieldDes& fie, EXtTraderType eTradeType) const;

        //如果一个idata下面有若干层idata，通过这个函数获取vector指定的路径的最后一层idata
        IDataPtr getLastIData(IDataPtr, std::vector<int>);

    private:
        map<int, IDataCreatorPtr> m_creators;
        map<int, StructDes> m_structes;
        map<std::string, map<int, vector<std::string> > > m_enumNames; //结构为 枚举名  枚举数值 vector是数值对应中文，从期货开始，第二位是股票

        void getFieldIDsImpl(set<FieldDes> & s, int nMetaID, EXtTraderType eTradeType) const;
    };

}

#endif // TypeManager_h__