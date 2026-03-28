package com.smartadmin.modules.dev.controller;

import com.smartadmin.common.Result;
import com.smartadmin.common.annotation.OperLog;
import com.smartadmin.common.enums.BusinessType;
import com.smartadmin.common.pojo.PageResp;
import com.smartadmin.modules.dev.biz.DataModelBiz;
import com.smartadmin.modules.dev.dto.request.*;
import com.smartadmin.modules.dev.dto.response.*;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 数据模型管理 Controller
 */
@RestController
@RequestMapping("/datamodel")
@RequiredArgsConstructor
@Tag(name = "数据模型管理", description = "数据库、数据表、字段、关系维护及E-R图展示")
public class DataModelController {

    private final DataModelBiz dataModelBiz;

    // ==================== 数据库管理 ====================

    @GetMapping("/database/page")
    @Operation(summary = "数据库分页查询")
    public Result<PageResp<DmDatabaseResp>> pageDatabases(DmDatabasePageQueryReq req) {
        return Result.success(dataModelBiz.pageDatabases(req));
    }

    @GetMapping("/database/list")
    @Operation(summary = "数据库列表")
    public Result<List<DmDatabaseResp>> listDatabases() {
        return Result.success(dataModelBiz.listDatabases());
    }

    @GetMapping("/database/{id}")
    @Operation(summary = "获取数据库详情")
    public Result<DmDatabaseResp> getDatabaseById(@PathVariable Long id) {
        return Result.success(dataModelBiz.getDatabaseById(id));
    }

    @PostMapping("/database")
    @OperLog(title = "数据模型-数据库", businessType = BusinessType.INSERT)
    @Operation(summary = "新增数据库")
    public Result<Long> addDatabase(@Valid @RequestBody DmDatabaseAddReq req) {
        Long id = dataModelBiz.addDatabase(req);
        return Result.success(id);
    }

    @PutMapping("/database")
    @OperLog(title = "数据模型-数据库", businessType = BusinessType.UPDATE)
    @Operation(summary = "编辑数据库")
    public Result<Void> updateDatabase(@Valid @RequestBody DmDatabaseUpdateReq req) {
        dataModelBiz.updateDatabase(req);
        return Result.success();
    }

    @DeleteMapping("/database/{id}")
    @OperLog(title = "数据模型-数据库", businessType = BusinessType.DELETE)
    @Operation(summary = "删除数据库")
    public Result<Void> deleteDatabase(@PathVariable Long id) {
        dataModelBiz.deleteDatabase(id);
        return Result.success();
    }

    // ==================== 数据表管理 ====================

    @GetMapping("/table/page")
    @Operation(summary = "数据表分页查询")
    public Result<PageResp<DmTableResp>> pageTables(DmTablePageQueryReq req) {
        return Result.success(dataModelBiz.pageTables(req));
    }

    @GetMapping("/table/list/{databaseId}")
    @Operation(summary = "某数据库下表列表")
    public Result<List<DmTableResp>> listTablesByDatabaseId(@PathVariable Long databaseId) {
        return Result.success(dataModelBiz.listTablesByDatabaseId(databaseId));
    }

    @GetMapping("/table/tree")
    @Operation(summary = "数据库-表树形结构")
    public Result<List<DmTableTreeResp>> getTableTree() {
        return Result.success(dataModelBiz.getTableTree());
    }

    @GetMapping("/table/{id}")
    @Operation(summary = "获取数据表详情")
    public Result<DmTableResp> getTableById(@PathVariable Long id) {
        return Result.success(dataModelBiz.getTableById(id));
    }

    @PostMapping("/table")
    @OperLog(title = "数据模型-数据表", businessType = BusinessType.INSERT)
    @Operation(summary = "新增数据表")
    public Result<Long> addTable(@Valid @RequestBody DmTableAddReq req) {
        Long id = dataModelBiz.addTable(req);
        return Result.success(id);
    }

    @PutMapping("/table")
    @OperLog(title = "数据模型-数据表", businessType = BusinessType.UPDATE)
    @Operation(summary = "编辑数据表")
    public Result<Void> updateTable(@Valid @RequestBody DmTableUpdateReq req) {
        dataModelBiz.updateTable(req);
        return Result.success();
    }

    @DeleteMapping("/table/{id}")
    @OperLog(title = "数据模型-数据表", businessType = BusinessType.DELETE)
    @Operation(summary = "删除数据表")
    public Result<Void> deleteTable(@PathVariable Long id) {
        dataModelBiz.deleteTable(id);
        return Result.success();
    }

    // ==================== 字段管理 ====================

    @GetMapping("/column/list/{tableId}")
    @Operation(summary = "字段列表")
    public Result<List<DmColumnResp>> listColumnsByTableId(@PathVariable Long tableId) {
        return Result.success(dataModelBiz.listColumnsByTableId(tableId));
    }

    @PostMapping("/column")
    @OperLog(title = "数据模型-字段", businessType = BusinessType.INSERT)
    @Operation(summary = "新增字段")
    public Result<Long> addColumn(@Valid @RequestBody DmColumnAddReq req) {
        Long id = dataModelBiz.addColumn(req);
        return Result.success(id);
    }

    @PutMapping("/column")
    @OperLog(title = "数据模型-字段", businessType = BusinessType.UPDATE)
    @Operation(summary = "编辑字段")
    public Result<Void> updateColumn(@Valid @RequestBody DmColumnUpdateReq req) {
        dataModelBiz.updateColumn(req);
        return Result.success();
    }

    @DeleteMapping("/column/{id}")
    @OperLog(title = "数据模型-字段", businessType = BusinessType.DELETE)
    @Operation(summary = "删除字段")
    public Result<Void> deleteColumn(@PathVariable Long id) {
        dataModelBiz.deleteColumn(id);
        return Result.success();
    }

    // ==================== 关系管理 ====================

    @GetMapping("/relation/list")
    @Operation(summary = "关系列表")
    public Result<List<DmRelationResp>> listRelations(@RequestParam Long databaseId) {
        return Result.success(dataModelBiz.listRelations(databaseId));
    }

    @PostMapping("/relation")
    @OperLog(title = "数据模型-关系", businessType = BusinessType.INSERT)
    @Operation(summary = "新增关系")
    public Result<Long> addRelation(@Valid @RequestBody DmRelationAddReq req) {
        Long id = dataModelBiz.addRelation(req);
        return Result.success(id);
    }

    @PutMapping("/relation")
    @OperLog(title = "数据模型-关系", businessType = BusinessType.UPDATE)
    @Operation(summary = "编辑关系")
    public Result<Void> updateRelation(@Valid @RequestBody DmRelationUpdateReq req) {
        dataModelBiz.updateRelation(req);
        return Result.success();
    }

    @DeleteMapping("/relation/{id}")
    @OperLog(title = "数据模型-关系", businessType = BusinessType.DELETE)
    @Operation(summary = "删除关系")
    public Result<Void> deleteRelation(@PathVariable Long id) {
        dataModelBiz.deleteRelation(id);
        return Result.success();
    }

    // ==================== E-R 图 ====================

    @GetMapping("/er-diagram/{databaseId}")
    @Operation(summary = "E-R图数据")
    public Result<DmERDiagramResp> getERDiagram(@PathVariable Long databaseId) {
        return Result.success(dataModelBiz.getERDiagram(databaseId));
    }
}
