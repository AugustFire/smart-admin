package com.smartadmin.modules.system.service;

import com.smartadmin.common.base.BaseService;
import com.smartadmin.modules.system.entity.SysDictType;

/**
 * 字典类型服务接口
 */
public interface SysDictTypeService extends BaseService<SysDictType> {

    /**
     * 检查字典类型是否存在
     */
    default boolean existsByType(String type) {
        return lambdaQuery().eq(SysDictType::getType, type).exists();
    }

    /**
     * 检查字典类型是否存在（排除指定 ID）
     */
    default boolean existsByType(String type, Long excludeId) {
        return lambdaQuery()
                .eq(SysDictType::getType, type)
                .ne(SysDictType::getId, excludeId)
                .exists();
    }
}