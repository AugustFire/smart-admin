package com.smartadmin.modules.system.service.impl;

import com.smartadmin.common.base.BaseServiceImpl;
import com.smartadmin.modules.system.entity.SysOperLog;
import com.smartadmin.modules.system.mapper.SysOperLogMapper;
import com.smartadmin.modules.system.service.SysOperLogService;
import org.springframework.stereotype.Service;

/**
 * 操作日志服务实现
 */
@Service
public class SysOperLogServiceImpl extends BaseServiceImpl<SysOperLogMapper, SysOperLog> implements SysOperLogService {
}