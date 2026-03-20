package com.autoadmin.modules.system.controller;

import com.autoadmin.common.Result;
import com.autoadmin.common.annotation.OperLog;
import com.autoadmin.common.enums.BusinessType;
import com.autoadmin.common.pojo.PageResp;
import com.autoadmin.modules.system.biz.ApiBiz;
import com.autoadmin.modules.system.dto.request.ApiAddReq;
import com.autoadmin.modules.system.dto.request.ApiPageQueryReq;
import com.autoadmin.modules.system.dto.request.ApiUpdateReq;
import com.autoadmin.modules.system.dto.response.ApiResp;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 接口资源管理 Controller
 */
@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
@Tag(name = "接口资源管理", description = "接口资源 CRUD 操作")
public class ApiController {

    private final ApiBiz apiBiz;

    /**
     * 分页查询接口列表
     */
    @GetMapping("/page")
    @Operation(summary = "分页查询接口列表")
    public Result<PageResp<ApiResp>> page(ApiPageQueryReq req) {
        return Result.success(apiBiz.pageApis(req));
    }

    /**
     * 获取接口详情
     */
    @GetMapping("/{id}")
    @Operation(summary = "获取接口详情")
    public Result<ApiResp> getById(@PathVariable Long id) {
        return Result.success(apiBiz.getById(id));
    }

    /**
     * 新增接口
     */
    @PostMapping
    @OperLog(title = "接口资源管理", businessType = BusinessType.INSERT)
    @Operation(summary = "新增接口")
    public Result<Long> add(@Valid @RequestBody ApiAddReq req) {
        return Result.success(apiBiz.addApi(req));
    }

    /**
     * 修改接口
     */
    @PutMapping
    @OperLog(title = "接口资源管理", businessType = BusinessType.UPDATE)
    @Operation(summary = "修改接口")
    public Result<Void> update(@Valid @RequestBody ApiUpdateReq req) {
        apiBiz.updateApi(req);
        return Result.success();
    }

    /**
     * 删除接口
     */
    @DeleteMapping("/{id}")
    @OperLog(title = "接口资源管理", businessType = BusinessType.DELETE)
    @Operation(summary = "删除接口")
    public Result<Void> delete(@PathVariable Long id) {
        apiBiz.deleteApi(id);
        return Result.success();
    }

    /**
     * 获取接口树（按菜单分组）
     */
    @GetMapping("/tree")
    @Operation(summary = "获取接口树")
    public Result<List<?>> getTree() {
        return Result.success(apiBiz.getApisWithMenuGrouping());
    }
}