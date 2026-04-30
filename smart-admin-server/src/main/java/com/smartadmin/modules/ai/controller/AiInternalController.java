package com.smartadmin.modules.ai.controller;

import com.smartadmin.common.Result;
import com.smartadmin.common.pojo.PageResp;
import com.smartadmin.modules.lifestyle.biz.DietBiz;
import com.smartadmin.modules.lifestyle.dto.request.DietRecordPageQueryReq;
import com.smartadmin.modules.lifestyle.dto.response.DietRecordResp;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

/**
 * AI 内部接口（供 Python AI 服务调用）
 */
@Tag(name = "AI 内部接口")
@RestController
@RequestMapping("/api/ai/internal")
@RequiredArgsConstructor
public class AiInternalController {

    private final DietBiz dietBiz;

    @Operation(summary = "查询用户饮食记录（AI内部接口）")
    @GetMapping("/diet/page")
    public Result<PageResp<DietRecordResp>> getDietRecords(
            @RequestParam Long userId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "100") Integer pageSize) {

        DietRecordPageQueryReq req = new DietRecordPageQueryReq();
        req.setPageNum(pageNum);
        req.setPageSize(pageSize);
        req.setStartDate(startDate);
        req.setEndDate(endDate);

        // 直接使用传入的 userId 查询，不从 UserContext 获取
        return Result.success(dietBiz.pageQueryWithUserId(userId, req));
    }
}
