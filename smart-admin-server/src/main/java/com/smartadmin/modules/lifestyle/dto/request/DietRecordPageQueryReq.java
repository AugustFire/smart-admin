package com.smartadmin.modules.lifestyle.dto.request;

import com.smartadmin.common.pojo.PageReq;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDate;

/**
 * 饮食记录分页查询请求
 */
@Data
@EqualsAndHashCode(callSuper = true)
@Schema(description = "饮食记录分页查询请求")
public class DietRecordPageQueryReq extends PageReq {

    @Schema(description = "记录日期", example = "2026-04-20")
    private LocalDate recordDate;

    @Schema(description = "开始日期", example = "2026-04-20")
    private LocalDate startDate;

    @Schema(description = "结束日期", example = "2026-04-20")
    private LocalDate endDate;

    @Schema(description = "餐食类型: breakfast/lunch/dinner/snack/drink", example = "breakfast")
    private String mealType;
}
