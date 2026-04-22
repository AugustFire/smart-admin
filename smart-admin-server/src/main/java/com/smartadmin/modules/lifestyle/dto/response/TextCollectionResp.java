package com.smartadmin.modules.lifestyle.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 文本收藏响应
 */
@Data
@Builder
@Schema(description = "文本收藏响应")
public class TextCollectionResp {

    @Schema(description = "主键ID")
    private Long id;

    @Schema(description = "用户ID")
    private Long userId;

    @Schema(description = "分类ID")
    private Long categoryId;

    @Schema(description = "分类名称")
    private String categoryName;

    @Schema(description = "标题")
    private String title;

    @Schema(description = "内容(Markdown)")
    private String content;

    @Schema(description = "标签，多个逗号分隔")
    private String tags;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    @Schema(description = "更新时间")
    private LocalDateTime updateTime;
}
