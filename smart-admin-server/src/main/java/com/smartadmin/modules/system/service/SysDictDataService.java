package com.smartadmin.modules.system.service;

import com.smartadmin.common.base.BaseService;
import com.smartadmin.modules.system.entity.SysDictData;

import java.util.List;

/**
 * 字典数据服务接口
 */
public interface SysDictDataService extends BaseService<SysDictData> {

    /**
     * 根据字典类型查询字典数据列表
     */
    default List<SysDictData> listByDictType(String dictType) {
        return lambdaQuery()
                .eq(SysDictData::getDictType, dictType)
                .orderByAsc(SysDictData::getSort)
                .list();
    }
}