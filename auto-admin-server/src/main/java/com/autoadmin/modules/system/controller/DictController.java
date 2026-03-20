package com.autoadmin.modules.system.controller;

import com.autoadmin.common.Result;
import com.autoadmin.common.annotation.OperLog;
import com.autoadmin.common.enums.BusinessType;
import com.autoadmin.modules.system.biz.DictBiz;
import com.autoadmin.modules.system.dto.request.DictDataAddReq;
import com.autoadmin.modules.system.dto.request.DictDataUpdateReq;
import com.autoadmin.modules.system.dto.request.DictTypeAddReq;
import com.autoadmin.modules.system.dto.request.DictTypeUpdateReq;
import com.autoadmin.modules.system.dto.response.DictDataResp;
import com.autoadmin.modules.system.dto.response.DictTypeResp;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 字典管理 Controller
 */
@RestController
@RequestMapping("/dict")
@RequiredArgsConstructor
@Tag(name = "字典管理", description = "字典 CRUD 操作")
public class DictController {

    private final DictBiz dictBiz;

    // ==================== 字典类型 ====================

    /**
     * 获取字典类型列表
     */
    @GetMapping("/type/list")
    @Operation(summary = "获取字典类型列表")
    public Result<List<DictTypeResp>> getTypeList() {
        return Result.success(dictBiz.listAllTypes());
    }

    /**
     * 获取字典类型详情
     */
    @GetMapping("/type/{id}")
    @Operation(summary = "获取字典类型详情")
    public Result<DictTypeResp> getTypeById(@PathVariable Long id) {
        return Result.success(dictBiz.getTypeById(id));
    }

    /**
     * 新增字典类型
     */
    @PostMapping("/type")
    @OperLog(title = "字典管理", businessType = BusinessType.INSERT)
    @Operation(summary = "新增字典类型")
    public Result<Long> addType(@Valid @RequestBody DictTypeAddReq req) {
        return Result.success(dictBiz.addType(req));
    }

    /**
     * 修改字典类型
     */
    @PutMapping("/type")
    @OperLog(title = "字典管理", businessType = BusinessType.UPDATE)
    @Operation(summary = "修改字典类型")
    public Result<Void> updateType(@Valid @RequestBody DictTypeUpdateReq req) {
        dictBiz.updateType(req);
        return Result.success();
    }

    /**
     * 删除字典类型
     */
    @DeleteMapping("/type/{id}")
    @OperLog(title = "字典管理", businessType = BusinessType.DELETE)
    @Operation(summary = "删除字典类型")
    public Result<Void> deleteType(@PathVariable Long id) {
        dictBiz.deleteType(id);
        return Result.success();
    }

    // ==================== 字典数据 ====================

    /**
     * 根据字典类型获取字典数据列表
     */
    @GetMapping("/data/list")
    @Operation(summary = "根据字典类型获取字典数据列表")
    public Result<List<DictDataResp>> getDataList(@RequestParam String dictType) {
        return Result.success(dictBiz.listDataByDictType(dictType));
    }

    /**
     * 获取字典数据详情
     */
    @GetMapping("/data/{id}")
    @Operation(summary = "获取字典数据详情")
    public Result<DictDataResp> getDataById(@PathVariable Long id) {
        return Result.success(dictBiz.getDataById(id));
    }

    /**
     * 新增字典数据
     */
    @PostMapping("/data")
    @OperLog(title = "字典管理", businessType = BusinessType.INSERT)
    @Operation(summary = "新增字典数据")
    public Result<Long> addData(@Valid @RequestBody DictDataAddReq req) {
        return Result.success(dictBiz.addData(req));
    }

    /**
     * 修改字典数据
     */
    @PutMapping("/data")
    @OperLog(title = "字典管理", businessType = BusinessType.UPDATE)
    @Operation(summary = "修改字典数据")
    public Result<Void> updateData(@Valid @RequestBody DictDataUpdateReq req) {
        dictBiz.updateData(req);
        return Result.success();
    }

    /**
     * 删除字典数据
     */
    @DeleteMapping("/data/{id}")
    @OperLog(title = "字典管理", businessType = BusinessType.DELETE)
    @Operation(summary = "删除字典数据")
    public Result<Void> deleteData(@PathVariable Long id) {
        dictBiz.deleteData(id);
        return Result.success();
    }
}