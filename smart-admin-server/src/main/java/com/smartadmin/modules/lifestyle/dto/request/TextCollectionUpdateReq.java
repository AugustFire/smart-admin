package com.smartadmin.modules.lifestyle.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 文本收藏更新请求
 */
@Data
@Schema(description = "文本收藏更新请求")
public class TextCollectionUpdateReq {

    @NotNull(message = "ID不能为空")
    @Schema(description = "主键ID")
    private Long id;

    @Schema(description = "分类ID")
    private Long categoryId;

    @Schema(description = "标题", example = "我的笔记")
    private String title;

    @NotBlank(message = "内容不能为空")
    @Schema(description = "内容(Markdown)", example = "# 标题\\n内容...")
    private String content;

    @Schema(description = "标签，多个逗号分隔", example = "work,idea")
    private String tags;
}
