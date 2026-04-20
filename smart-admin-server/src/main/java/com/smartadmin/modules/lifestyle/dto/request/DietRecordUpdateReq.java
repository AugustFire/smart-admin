package com.smartadmin.modules.lifestyle.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalTime;

/**
 * 饮食记录更新请求
 */
@Data
@Schema(description = "饮食记录更新请求")
public class DietRecordUpdateReq {

    @NotNull(message = "ID不能为空")
    @Schema(description = "主键ID", example = "1")
    private Long id;

    @NotNull(message = "记录日期不能为空")
    @Schema(description = "记录日期", example = "2026-04-20")
    private LocalDate recordDate;

    @Schema(description = "用餐时间", example = "08:30")
    private LocalTime mealTime;

    @NotBlank(message = "餐食类型不能为空")
    @Schema(description = "餐食类型: breakfast/lunch/dinner/snack/drink", example = "breakfast")
    private String mealType;

    @NotBlank(message = "食物名称不能为空")
    @Schema(description = "食物名称", example = "鸡蛋灌饼")
    private String foodName;

    @Schema(description = "份量", example = "1份")
    private String portion;

    @Schema(description = "标签，多个逗号分隔", example = "健康,轻食")
    private String tags;

    @Schema(description = "心情: happy/good/so-so/binge/skip", example = "good")
    private String mood;

    @Schema(description = "描述/备注", example = "加了个肠")
    private String description;
}
