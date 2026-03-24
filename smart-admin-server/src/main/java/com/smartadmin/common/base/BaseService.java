package com.smartadmin.common.base;

import com.baomidou.mybatisplus.extension.service.IService;

/**
 * 基础服务接口
 * 继承 MyBatis Plus IService，提供通用 CRUD 操作
 *
 * @param <T> 实体类型
 */
public interface BaseService<T> extends IService<T> {

    /**
     * 根据 ID 获取实体，不存在则抛出异常
     *
     * @param id 主键
     * @return 实体
     */
    default T getByIdOrThrow(Long id) {
        T entity = getById(id);
        if (entity == null) {
            throw new RuntimeException("数据不存在");
        }
        return entity;
    }
}