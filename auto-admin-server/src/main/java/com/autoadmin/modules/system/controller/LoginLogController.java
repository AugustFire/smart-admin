package com.autoadmin.modules.system.controller;

import com.autoadmin.common.Result;
import com.autoadmin.common.pojo.PageResp;
import com.autoadmin.modules.system.biz.LogBiz;
import com.autoadmin.modules.system.dto.request.LoginLogQueryReq;
import com.autoadmin.modules.system.dto.response.LoginLogResp;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 登录日志 Controller
 */
@RestController
@RequestMapping("/loginlog")
@RequiredArgsConstructor
@Tag(name = "登录日志", description = "登录日志查询")
public class LoginLogController {

    private final LogBiz logBiz;

    /**
     * 获取登录日志列表（分页）
     */
    @GetMapping("/page")
    @Operation(summary = "获取登录日志列表（分页）")
    public Result<PageResp<LoginLogResp>> page(LoginLogQueryReq req) {
        return Result.success(logBiz.pageLoginLogs(req));
    }

    /**
     * 获取登录日志详情
     */
    @GetMapping("/{id}")
    @Operation(summary = "获取登录日志详情")
    public Result<LoginLogResp> getById(@PathVariable Long id) {
        return Result.success(logBiz.getLoginLogById(id));
    }

    /**
     * 删除登录日志
     */
    @DeleteMapping("/{id}")
    @Operation(summary = "删除登录日志")
    public Result<Void> delete(@PathVariable Long id) {
        logBiz.deleteLoginLog(id);
        return Result.success();
    }

    /**
     * 清空所有登录日志
     */
    @DeleteMapping("/clear")
    @Operation(summary = "清空所有登录日志")
    public Result<Void> clear() {
        logBiz.clearLoginLogs();
        return Result.success();
    }
}