package com.autoadmin.modules.system.service.impl;

import com.autoadmin.common.base.BaseServiceImpl;
import com.autoadmin.modules.system.entity.SysLoginLog;
import com.autoadmin.modules.system.mapper.SysLoginLogMapper;
import com.autoadmin.modules.system.service.SysLoginLogService;
import org.springframework.stereotype.Service;

/**
 * 登录日志服务实现
 */
@Service
public class SysLoginLogServiceImpl extends BaseServiceImpl<SysLoginLogMapper, SysLoginLog> implements SysLoginLogService {
}