package com.smartadmin.modules.lifestyle.controller;

import com.smartadmin.common.Result;
import com.smartadmin.common.annotation.OperLog;
import com.smartadmin.common.enums.BusinessType;
import com.smartadmin.common.pojo.PageResp;
import com.smartadmin.modules.lifestyle.biz.DietBiz;
import com.smartadmin.modules.lifestyle.dto.request.DietRecordAddReq;
import com.smartadmin.modules.lifestyle.dto.request.DietRecordPageQueryReq;
import com.smartadmin.modules.lifestyle.dto.request.DietRecordUpdateReq;
import com.smartadmin.modules.lifestyle.dto.response.DietRecordResp;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 饮食记录控制器
 */
@Tag(name = "饮食管理")
@RestController
@RequestMapping("/lifestyle/diet")
@RequiredArgsConstructor
public class DietController {

    private final DietBiz dietBiz;

    @Operation(summary = "分页查询饮食记录")
    @GetMapping("/page")
    public Result<PageResp<DietRecordResp>> page(DietRecordPageQueryReq req) {
        return Result.success(dietBiz.pageQuery(req));
    }

    @Operation(summary = "获取饮食记录详情")
    @GetMapping("/{id}")
    public Result<DietRecordResp> getById(@PathVariable Long id) {
        return Result.success(dietBiz.getById(id));
    }

    @Operation(summary = "新增饮食记录")
    @OperLog(title = "饮食记录", businessType = BusinessType.INSERT)
    @PostMapping("/add")
    public Result<Long> add(@Valid @RequestBody DietRecordAddReq req) {
        return Result.success(dietBiz.add(req));
    }

    @Operation(summary = "更新饮食记录")
    @OperLog(title = "饮食记录", businessType = BusinessType.UPDATE)
    @PostMapping("/update")
    public Result<Void> update(@Valid @RequestBody DietRecordUpdateReq req) {
        dietBiz.update(req);
        return Result.success();
    }

    @Operation(summary = "删除饮食记录")
    @OperLog(title = "饮食记录", businessType = BusinessType.DELETE)
    @PostMapping("/delete/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        dietBiz.delete(id);
        return Result.success();
    }

    @Operation(summary = "获取常用饮食库（食物名称联想）")
    @GetMapping("/history/foods")
    public Result<List<String>> getFoodHistory() {
        return Result.success(dietBiz.getFoodHistory());
    }

    @Operation(summary = "根据食物名称获取最近记录（用于自动填充）")
    @GetMapping("/history/food")
    public Result<DietRecordResp> getLatestByFoodName(@RequestParam String foodName) {
        return Result.success(dietBiz.getLatestByFoodName(foodName));
    }

    @Operation(summary = "根据餐食类型获取最近记录（用于选择餐食类型后自动填充）")
    @GetMapping("/history/meal")
    public Result<DietRecordResp> getLatestByMealType(@RequestParam String mealType) {
        return Result.success(dietBiz.getLatestByMealType(mealType));
    }
}
