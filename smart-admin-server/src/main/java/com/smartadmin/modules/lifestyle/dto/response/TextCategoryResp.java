package com.smartadmin.modules.lifestyle.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 文本收藏分类响应
 */
@Data
@Builder
@Schema(description = "文本收藏分类响应")
public class TextCategoryResp {

    @Schema(description = "主键ID")
    private Long id;

    @Schema(description = "父分类ID")
    private Long parentId;

    @Schema(description = "分类名称")
    private String name;

    @Schema(description = "排序")
    private Integer sort;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    @Schema(description = "更新时间")
    private LocalDateTime updateTime;

    @Schema(description = "子分类")
    private List<TextCategoryResp> children;
}
