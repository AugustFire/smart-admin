package com.smartadmin.modules.lifestyle.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 文本收藏分类更新请求
 */
@Data
@Schema(description = "文本收藏分类更新请求")
public class TextCategoryUpdateReq {

    @NotNull(message = "ID不能为空")
    @Schema(description = "主键ID")
    private Long id;

    @Schema(description = "父分类ID")
    private Long parentId;

    @NotBlank(message = "分类名称不能为空")
    @Schema(description = "分类名称", example = "工作")
    private String name;

    @Schema(description = "排序")
    private Integer sort;
}
