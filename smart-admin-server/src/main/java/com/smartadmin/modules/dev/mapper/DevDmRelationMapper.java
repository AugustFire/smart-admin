package com.smartadmin.modules.dev.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.smartadmin.modules.dev.entity.DevDmRelation;
import org.apache.ibatis.annotations.Mapper;

/**
 * 数据模型-表关系信息表 Mapper
 */
@Mapper
public interface DevDmRelationMapper extends BaseMapper<DevDmRelation> {
}
