package com.autoadmin.modules.system.service;

import com.autoadmin.common.base.BaseService;
import com.autoadmin.modules.system.entity.SysOperLog;

/**
 * 操作日志服务接口
 */
public interface SysOperLogService extends BaseService<SysOperLog> {

    /**
     * 清空所有操作日志
     */
    default void clearAll() {
        lambdaUpdate().remove();
    }
}