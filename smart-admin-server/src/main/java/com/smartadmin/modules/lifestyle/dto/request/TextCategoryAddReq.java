package com.smartadmin.modules.lifestyle.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * 文本收藏分类新增请求
 */
@Data
@Schema(description = "文本收藏分类新增请求")
public class TextCategoryAddReq {

    @Schema(description = "父分类ID")
    private Long parentId;

    @NotBlank(message = "分类名称不能为空")
    @Schema(description = "分类名称", example = "工作")
    private String name;

    @Schema(description = "排序")
    private Integer sort;
}
