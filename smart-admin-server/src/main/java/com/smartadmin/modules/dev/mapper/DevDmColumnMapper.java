package com.smartadmin.modules.dev.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.smartadmin.modules.dev.entity.DevDmColumn;
import org.apache.ibatis.annotations.Mapper;

/**
 * 数据模型-表字段信息表 Mapper
 */
@Mapper
public interface DevDmColumnMapper extends BaseMapper<DevDmColumn> {
}
