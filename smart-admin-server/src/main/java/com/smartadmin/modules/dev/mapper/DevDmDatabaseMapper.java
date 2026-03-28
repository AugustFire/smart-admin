package com.smartadmin.modules.dev.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.smartadmin.modules.dev.entity.DevDmDatabase;
import org.apache.ibatis.annotations.Mapper;

/**
 * 数据模型-数据库信息表 Mapper
 */
@Mapper
public interface DevDmDatabaseMapper extends BaseMapper<DevDmDatabase> {
}
