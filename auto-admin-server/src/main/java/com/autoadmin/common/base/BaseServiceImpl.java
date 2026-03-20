package com.autoadmin.common.base;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * 基础服务实现类
 * 继承 MyBatis Plus ServiceImpl，提供通用 CRUD 实现
 *
 * @param <M> Mapper 类型
 * @param <T> 实体类型
 */
public abstract class BaseServiceImpl<M extends BaseMapper<T>, T> extends ServiceImpl<M, T> implements BaseService<T> {

    @Autowired
    protected M baseMapper;
}