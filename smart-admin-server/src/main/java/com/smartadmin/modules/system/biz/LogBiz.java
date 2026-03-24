package com.smartadmin.modules.system.biz;

import com.smartadmin.common.pojo.PageResp;
import com.smartadmin.modules.system.dto.request.LoginLogQueryReq;
import com.smartadmin.modules.system.dto.request.OperLogQueryReq;
import com.smartadmin.modules.system.dto.response.LoginLogResp;
import com.smartadmin.modules.system.dto.response.OperLogResp;
import com.smartadmin.modules.system.entity.SysLoginLog;
import com.smartadmin.modules.system.entity.SysOperLog;
import com.smartadmin.modules.system.service.SysLoginLogService;
import com.smartadmin.modules.system.service.SysOperLogService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 日志管理业务类
 */
@Component
@RequiredArgsConstructor
public class LogBiz {

    private final SysLoginLogService loginLogService;
    private final SysOperLogService operLogService;

    // ==================== 登录日志 ====================

    /**
     * 分页查询登录日志
     */
    public PageResp<LoginLogResp> pageLoginLogs(LoginLogQueryReq req) {
        LambdaQueryWrapper<SysLoginLog> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(req.getUsername() != null && !req.getUsername().isEmpty(),
                        SysLoginLog::getUsername, req.getUsername())
                .eq(req.getLoginStatus() != null, SysLoginLog::getLoginStatus, req.getLoginStatus())
                .ge(req.getStartTime() != null, SysLoginLog::getLoginTime, req.getStartTime())
                .le(req.getEndTime() != null, SysLoginLog::getLoginTime, req.getEndTime())
                .orderByDesc(SysLoginLog::getLoginTime);

        Page<SysLoginLog> page = loginLogService.page(
                new Page<>(req.getPageNum(), req.getPageSize()),
                wrapper
        );

        List<LoginLogResp> list = page.getRecords().stream()
                .map(this::convertLoginLogToResp)
                .collect(Collectors.toList());

        return PageResp.of(list, page.getTotal(), req.getPageNum(), req.getPageSize());
    }

    /**
     * 获取登录日志详情
     */
    public LoginLogResp getLoginLogById(Long id) {
        SysLoginLog log = loginLogService.getByIdOrThrow(id);
        return convertLoginLogToResp(log);
    }

    /**
     * 删除登录日志
     */
    @Transactional(rollbackFor = Exception.class)
    public void deleteLoginLog(Long id) {
        loginLogService.removeById(id);
    }

    /**
     * 清空所有登录日志
     */
    @Transactional(rollbackFor = Exception.class)
    public void clearLoginLogs() {
        loginLogService.clearAll();
    }

    // ==================== 操作日志 ====================

    /**
     * 分页查询操作日志
     */
    public PageResp<OperLogResp> pageOperLogs(OperLogQueryReq req) {
        LambdaQueryWrapper<SysOperLog> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(req.getTitle() != null && !req.getTitle().isEmpty(), SysOperLog::getTitle, req.getTitle())
                .like(req.getOperName() != null && !req.getOperName().isEmpty(), SysOperLog::getOperName, req.getOperName())
                .eq(req.getBusinessType() != null, SysOperLog::getBusinessType, req.getBusinessType())
                .eq(req.getStatus() != null, SysOperLog::getStatus, req.getStatus())
                .ge(req.getStartTime() != null, SysOperLog::getOperTime, req.getStartTime())
                .le(req.getEndTime() != null, SysOperLog::getOperTime, req.getEndTime())
                .orderByDesc(SysOperLog::getOperTime);

        Page<SysOperLog> page = operLogService.page(
                new Page<>(req.getPageNum(), req.getPageSize()),
                wrapper
        );

        List<OperLogResp> list = page.getRecords().stream()
                .map(this::convertOperLogToResp)
                .collect(Collectors.toList());

        return PageResp.of(list, page.getTotal(), req.getPageNum(), req.getPageSize());
    }

    /**
     * 获取操作日志详情
     */
    public OperLogResp getOperLogById(Long id) {
        SysOperLog log = operLogService.getByIdOrThrow(id);
        return convertOperLogToResp(log);
    }

    /**
     * 删除操作日志
     */
    @Transactional(rollbackFor = Exception.class)
    public void deleteOperLog(Long id) {
        operLogService.removeById(id);
    }

    /**
     * 清空所有操作日志
     */
    @Transactional(rollbackFor = Exception.class)
    public void clearOperLogs() {
        operLogService.clearAll();
    }

    private LoginLogResp convertLoginLogToResp(SysLoginLog entity) {
        return LoginLogResp.builder()
                .id(entity.getId())
                .username(entity.getUsername())
                .loginStatus(entity.getLoginStatus())
                .ipAddress(entity.getIp())
                .loginLocation(entity.getAddress())
                .browser(entity.getBrowser())
                .os(entity.getOs())
                .msg(entity.getMsg())
                .loginTime(entity.getLoginTime())
                .build();
    }

    private OperLogResp convertOperLogToResp(SysOperLog entity) {
        return OperLogResp.builder()
                .operId(entity.getId())
                .title(entity.getTitle())
                .businessType(entity.getBusinessType())
                .method(entity.getMethod())
                .operName(entity.getOperName())
                .deptName(entity.getDeptName())
                .operUrl(entity.getOperUrl())
                .operIp(entity.getOperIp())
                .operLocation(entity.getOperLocation())
                .operParam(entity.getOperParam())
                .jsonResult(entity.getJsonResult())
                .status(entity.getStatus())
                .errorMsg(entity.getErrorMsg())
                .operTime(entity.getOperTime())
                .costTime(entity.getCostTime())
                .build();
    }
}