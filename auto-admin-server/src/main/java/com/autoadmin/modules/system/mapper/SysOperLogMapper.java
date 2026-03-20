package com.autoadmin.modules.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.autoadmin.modules.system.entity.SysOperLog;
import org.apache.ibatis.annotations.Mapper;

/**
 * 操作日志 Mapper
 */
@Mapper
public interface SysOperLogMapper extends BaseMapper<SysOperLog> {
}