/**
 *  封装数据基础类
 *
 *  @author xujun
 *  @since  2013-1-13
 */
#ifndef _IData_2013_1_13_h__
#define _IData_2013_1_13_h__

#include "bson/src/bson.h"
#include "idata/DataDesc.h"
#include "utils/commonFunc.h"
#include "google/protobuf/io/coded_stream.h"

namespace ttservice
{
    using namespace ::google::protobuf::io;

    class IData;
    typedef boost::shared_ptr<IData> IDataPtr;

    class IDataCreator;
    typedef boost::shared_ptr<IDataCreator> IDataCreatorPtr;

    class  IData
    {
    public:
        virtual ~IData(){};

#define CMD_LIST() \
    CMD(Bool, bool, false)\
    CMD(Int, int, utils::getInvalidValue<int>())\
    CMD(Long, r_int64, utils::getInvalidValue<r_int64>())\
    CMD(Double, double, utils::getInvalidValue<double>())\
    CMD(String, string, "")\
    CMD(IData, IDataPtr, IDataPtr())\
    CMD(VBool, vector<bool>, vector<bool>())\
    CMD(VInt, vector<int>, vector<int>())\
    CMD(VLong, vector<r_int64>, vector<r_int64>())\
    CMD(VDouble, vector<double>, vector<double>())\
    CMD(VString, vector<string>, vector<string>())\
    CMD(VIData, vector<IDataPtr>, vector<IDataPtr>())\
/* CMD LIST END */

#define CMD(typeTag, typeStr, value) \
    inline typeStr get##typeTag(int nId) const {\
        int offset = getOffset(nId);\
        if (offset > 0) {\
            void* p = (char *)this + offset;\
            return *((typeStr *)(p));\
        } else {\
            return value;\
        }\
    };\
    inline void getData(int nId, typeStr& data) const {data = get##typeTag(nId);};\
    inline void setData(int nId, const typeStr& data) {\
        int offset = getOffset(nId);\
        if (offset > 0) {\
            void* p = (char *)this + offset;\
            *((typeStr *)p) = data;\
        }\
    };
    CMD_LIST();
#undef CMD

#define CMD(typeTag, typeStr) \
    CMD_LIST();
#undef CMD

        // 取得结构说明
        virtual const StructDes& getStructDes() const = 0;
        virtual IDataPtr copy() const = 0;
        virtual ostringstream& toStream(ostringstream& os) const= 0;

        //获取指定id的field描述，如果指针为空，则说明没有这个field
        const FieldDes& getFieldDes(int id) const;

        // 编解码
        void bsonValueFromObj(bson::bo obj) ;
        void bsonValueFromObj_v1(bson::bo::iterator& objIter);
        void bsonValueFromObj_v2(bson::bo::iterator& objIter);
        void appendElements(bson::bob& objBuilder) const;
        void appendElements_v2(bson::bob& objBuilder) const;
        void appendElementsWithNoTypeId(bson::bob& objBuilder) const;
        void appendElementsWithNoTypeId_v2(bson::bob& objBuilder) const;
        
        const map<int, FieldDes>& getFieldDes() const;
        int getBaseId() const;
        
        inline string toString() const 
        {
            bson::bob builder;
            this->appendElements(builder);
            return builder.obj().toString();
        }

        inline bson::bo toBson() const
        {
            bson::bob builder;
            this->appendElements(builder);
            return builder.obj();
        }

        // xujun(20131015) 新增内容为protobuf的Idata数据, 为了兼容portal以及脚本, 增加此函数
        virtual void appendElementsWithNoTypeIdWithBson(bson::bob& objBuilder) const;
        virtual bson::bo toBsonWithBson() const;

        // 用于数据排重
        inline string getKey() const 
        {
            ostringstream os;
            this->toStream(os);
            return os.str();
        };

        virtual int getOffset(int id) const;
        virtual bool isEqual(const IData* pRight) const;
    };
}

/* end*/

#endif // IData_h__