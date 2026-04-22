package com.smartadmin.modules.lifestyle.controller;

import com.smartadmin.common.Result;
import com.smartadmin.common.annotation.OperLog;
import com.smartadmin.common.enums.BusinessType;
import com.smartadmin.common.pojo.PageResp;
import com.smartadmin.modules.lifestyle.biz.TextCollectionBiz;
import com.smartadmin.modules.lifestyle.dto.request.TextCollectionAddReq;
import com.smartadmin.modules.lifestyle.dto.request.TextCollectionPageQueryReq;
import com.smartadmin.modules.lifestyle.dto.request.TextCollectionUpdateReq;
import com.smartadmin.modules.lifestyle.dto.request.TextCategoryAddReq;
import com.smartadmin.modules.lifestyle.dto.request.TextCategoryUpdateReq;
import com.smartadmin.modules.lifestyle.dto.response.TextCollectionResp;
import com.smartadmin.modules.lifestyle.dto.response.TextCategoryResp;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 文本收藏控制器
 */
@Tag(name = "文本收藏")
@RestController
@RequestMapping("/lifestyle/text-collection")
@RequiredArgsConstructor
public class TextCollectionController {

    private final TextCollectionBiz textCollectionBiz;

    // ==================== 文本收藏接口 ====================

    @Operation(summary = "分页查询文本")
    @GetMapping("/page")
    public Result<PageResp<TextCollectionResp>> pageText(TextCollectionPageQueryReq req) {
        return Result.success(textCollectionBiz.pageQueryText(req));
    }

    @Operation(summary = "获取文本详情")
    @GetMapping("/{id}")
    public Result<TextCollectionResp> getTextById(@PathVariable Long id) {
        return Result.success(textCollectionBiz.getTextById(id));
    }

    @Operation(summary = "新增文本")
    @OperLog(title = "文本收藏", businessType = BusinessType.INSERT)
    @PostMapping("/add")
    public Result<Long> addText(@Valid @RequestBody TextCollectionAddReq req) {
        return Result.success(textCollectionBiz.addText(req));
    }

    @Operation(summary = "更新文本")
    @OperLog(title = "文本收藏", businessType = BusinessType.UPDATE)
    @PostMapping("/update")
    public Result<Void> updateText(@Valid @RequestBody TextCollectionUpdateReq req) {
        textCollectionBiz.updateText(req);
        return Result.success();
    }

    @Operation(summary = "删除文本")
    @OperLog(title = "文本收藏", businessType = BusinessType.DELETE)
    @PostMapping("/delete/{id}")
    public Result<Void> deleteText(@PathVariable Long id) {
        textCollectionBiz.deleteText(id);
        return Result.success();
    }

    // ==================== 文本分类接口 ====================

    @Operation(summary = "获取分类列表（树形）")
    @GetMapping("/category/list")
    public Result<List<TextCategoryResp>> getCategoryTree() {
        return Result.success(textCollectionBiz.getCategoryTree());
    }

    @Operation(summary = "获取分类列表（扁平）")
    @GetMapping("/category/flat")
    public Result<List<TextCategoryResp>> getCategoryFlat() {
        return Result.success(textCollectionBiz.getCategoryList());
    }

    @Operation(summary = "新增分类")
    @OperLog(title = "文本收藏分类", businessType = BusinessType.INSERT)
    @PostMapping("/category/add")
    public Result<Long> addCategory(@Valid @RequestBody TextCategoryAddReq req) {
        return Result.success(textCollectionBiz.addCategory(req));
    }

    @Operation(summary = "更新分类")
    @OperLog(title = "文本收藏分类", businessType = BusinessType.UPDATE)
    @PostMapping("/category/update")
    public Result<Void> updateCategory(@Valid @RequestBody TextCategoryUpdateReq req) {
        textCollectionBiz.updateCategory(req);
        return Result.success();
    }

    @Operation(summary = "删除分类")
    @OperLog(title = "文本收藏分类", businessType = BusinessType.DELETE)
    @PostMapping("/category/delete/{id}")
    public Result<Void> deleteCategory(@PathVariable Long id) {
        textCollectionBiz.deleteCategory(id);
        return Result.success();
    }
}
