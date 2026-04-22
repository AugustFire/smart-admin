package com.smartadmin.modules.lifestyle.controller;

import com.smartadmin.common.Result;
import com.smartadmin.common.annotation.OperLog;
import com.smartadmin.common.enums.BusinessType;
import com.smartadmin.common.pojo.PageResp;
import com.smartadmin.modules.lifestyle.biz.BrainstormBiz;
import com.smartadmin.modules.lifestyle.dto.request.BrainstormAddReq;
import com.smartadmin.modules.lifestyle.dto.request.BrainstormPageQueryReq;
import com.smartadmin.modules.lifestyle.dto.request.BrainstormUpdateReq;
import com.smartadmin.modules.lifestyle.dto.response.BrainstormResp;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 头脑风暴控制器
 */
@Tag(name = "头脑风暴")
@RestController
@RequestMapping("/lifestyle/brainstorm")
@RequiredArgsConstructor
public class BrainstormController {

    private final BrainstormBiz brainstormBiz;

    @Operation(summary = "分页查询想法")
    @GetMapping("/page")
    public Result<PageResp<BrainstormResp>> page(BrainstormPageQueryReq req) {
        return Result.success(brainstormBiz.pageQuery(req));
    }

    @Operation(summary = "获取想法详情")
    @GetMapping("/{id}")
    public Result<BrainstormResp> getById(@PathVariable Long id) {
        return Result.success(brainstormBiz.getById(id));
    }

    @Operation(summary = "新增想法")
    @OperLog(title = "头脑风暴", businessType = BusinessType.INSERT)
    @PostMapping("/add")
    public Result<Long> add(@Valid @RequestBody BrainstormAddReq req) {
        return Result.success(brainstormBiz.add(req));
    }

    @Operation(summary = "更新想法")
    @OperLog(title = "头脑风暴", businessType = BusinessType.UPDATE)
    @PostMapping("/update")
    public Result<Void> update(@Valid @RequestBody BrainstormUpdateReq req) {
        brainstormBiz.update(req);
        return Result.success();
    }

    @Operation(summary = "删除想法")
    @OperLog(title = "头脑风暴", businessType = BusinessType.DELETE)
    @PostMapping("/delete/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        brainstormBiz.delete(id);
        return Result.success();
    }
}
