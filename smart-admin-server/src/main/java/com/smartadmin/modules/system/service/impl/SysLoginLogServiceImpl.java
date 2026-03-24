package com.smartadmin.modules.system.service.impl;

import com.smartadmin.common.base.BaseServiceImpl;
import com.smartadmin.modules.system.entity.SysLoginLog;
import com.smartadmin.modules.system.mapper.SysLoginLogMapper;
import com.smartadmin.modules.system.service.SysLoginLogService;
import org.springframework.stereotype.Service;

/**
 * 登录日志服务实现
 */
@Service
public class SysLoginLogServiceImpl extends BaseServiceImpl<SysLoginLogMapper, SysLoginLog> implements SysLoginLogService {
}