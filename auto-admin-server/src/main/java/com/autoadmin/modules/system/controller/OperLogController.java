package com.autoadmin.modules.system.controller;

import com.autoadmin.common.Result;
import com.autoadmin.common.pojo.PageResp;
import com.autoadmin.modules.system.biz.LogBiz;
import com.autoadmin.modules.system.dto.request.OperLogQueryReq;
import com.autoadmin.modules.system.dto.response.OperLogResp;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 操作日志 Controller
 */
@RestController
@RequestMapping("/operlog")
@RequiredArgsConstructor
@Tag(name = "操作日志", description = "操作日志查询")
public class OperLogController {

    private final LogBiz logBiz;

    /**
     * 获取操作日志列表（分页）
     */
    @GetMapping("/page")
    @Operation(summary = "获取操作日志列表（分页）")
    public Result<PageResp<OperLogResp>> page(OperLogQueryReq req) {
        return Result.success(logBiz.pageOperLogs(req));
    }

    /**
     * 获取操作日志详情
     */
    @GetMapping("/{id}")
    @Operation(summary = "获取操作日志详情")
    public Result<OperLogResp> getById(@PathVariable Long id) {
        return Result.success(logBiz.getOperLogById(id));
    }

    /**
     * 删除操作日志
     */
    @DeleteMapping("/{id}")
    @Operation(summary = "删除操作日志")
    public Result<Void> delete(@PathVariable Long id) {
        logBiz.deleteOperLog(id);
        return Result.success();
    }

    /**
     * 清空所有操作日志
     */
    @DeleteMapping("/clear")
    @Operation(summary = "清空所有操作日志")
    public Result<Void> clear() {
        logBiz.clearOperLogs();
        return Result.success();
    }
}