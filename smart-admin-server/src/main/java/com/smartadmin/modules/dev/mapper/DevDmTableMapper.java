package com.smartadmin.modules.dev.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.smartadmin.modules.dev.entity.DevDmTable;
import org.apache.ibatis.annotations.Mapper;

/**
 * 数据模型-数据表信息表 Mapper
 */
@Mapper
public interface DevDmTableMapper extends BaseMapper<DevDmTable> {
}
