package com.smartadmin.modules.lifestyle.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

/**
 * 饮食记录响应
 */
@Data
@Schema(description = "饮食记录响应")
public class DietRecordResp {

    @Schema(description = "主键ID", example = "1")
    private Long id;

    @Schema(description = "用户ID", example = "1")
    private Long userId;

    @Schema(description = "记录日期", example = "2026-04-20")
    private LocalDate recordDate;

    @Schema(description = "用餐时间", example = "08:30")
    private LocalTime mealTime;

    @Schema(description = "餐食类型", example = "breakfast")
    private String mealType;

    @Schema(description = "餐食类型名称", example = "早餐")
    private String mealTypeName;

    @Schema(description = "食物名称", example = "鸡蛋灌饼")
    private String foodName;

    @Schema(description = "份量", example = "1份")
    private String portion;

    @Schema(description = "标签列表", example = "健康,轻食")
    private String tags;

    @Schema(description = "标签名称列表", example = "健康、轻食")
    private String tagNames;

    @Schema(description = "心情", example = "good")
    private String mood;

    @Schema(description = "心情名称", example = "🙂")
    private String moodName;

    @Schema(description = "描述/备注", example = "加了个肠")
    private String description;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;
}
