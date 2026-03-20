package com.autoadmin.modules.system.service;

import com.autoadmin.common.base.BaseService;
import com.autoadmin.modules.system.entity.SysLoginLog;

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