package com.smartadmin.modules.system.service;

import com.smartadmin.common.base.BaseService;
import com.smartadmin.modules.system.entity.SysLoginLog;

/**
 * 登录日志服务接口
 */
public interface SysLoginLogService extends BaseService<SysLoginLog> {

    /**
     * 清空所有登录日志
     */
    default void clearAll() {
        lambdaUpdate().remove();
    }
}