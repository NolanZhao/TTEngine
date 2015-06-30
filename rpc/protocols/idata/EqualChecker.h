/********************************************************************
	company:    北京睿智融科控股有限公司
	fileName:	DefaultValueChecker.h
	author:		xujun    
	created:	2014/1/8   18:00	
	purpose:	默认值检测,注意, 此处的isEqual不通用
*********************************************************************/
#ifndef DefaultValueChecker_2014_1_8_H
#define DefaultValueChecker_2014_1_8_H

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "utils/mathex.h"

namespace ttservice
{
    template <typename T>
    inline bool isEqual(const T& rawValue, const T& defaultValue)
    {
        return rawValue == defaultValue;
    }

    template <>
    inline bool isEqual(const double& rawValue, const double& defaultValue)
    {
        return utils::isEqual(rawValue, defaultValue);
    }

    template <typename T>
    inline bool isEqual(const vector<T>& rawValue, const vector<T>& defaultValue)
    {
        bool ret = true;
        if (rawValue.empty() && defaultValue.empty())
        {
            ret = true;
        } else {
            ret = false;
        }
        return ret;
    }

    template <typename T>
    inline bool isEqual(const set<T>& rawValue, const set<T>& defaultValue)
    {
        bool ret = true;
        if (rawValue.empty() && defaultValue.empty())
        {
            ret = true;
        } else {
            return false;
        }
        return ret;
    }

    template <typename Key, typename Value>
    inline bool isEqual(const map<Key, Value>& rawValue, const map<Key, Value>& defaultValue)
    {
        bool ret = true;
        if (rawValue.empty() && defaultValue.empty())
        {
            ret = true;
        } else {
            return false;
        }
        return ret;
    }
}

#endif