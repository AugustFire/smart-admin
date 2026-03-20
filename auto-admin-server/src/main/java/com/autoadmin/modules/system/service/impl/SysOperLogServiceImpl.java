package com.autoadmin.modules.system.service.impl;

import com.autoadmin.common.base.BaseServiceImpl;
import com.autoadmin.modules.system.entity.SysOperLog;
import com.autoadmin.modules.system.mapper.SysOperLogMapper;
import com.autoadmin.modules.system.service.SysOperLogService;
import org.springframework.stereotype.Service;

/**
 * 操作日志服务实现
 */
@Service
public class SysOperLogServiceImpl extends BaseServiceImpl<SysOperLogMapper, SysOperLog> implements SysOperLogService {
}