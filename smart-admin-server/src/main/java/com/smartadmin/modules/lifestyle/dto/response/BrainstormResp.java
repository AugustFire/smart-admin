package com.smartadmin.modules.lifestyle.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 头脑风暴响应
 */
@Data
@Builder
@Schema(description = "头脑风暴响应")
public class BrainstormResp {

    @Schema(description = "主键ID")
    private Long id;

    @Schema(description = "用户ID")
    private Long userId;

    @Schema(description = "想法内容")
    private String content;

    @Schema(description = "标签，多个逗号分隔")
    private String tags;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    @Schema(description = "更新时间")
    private LocalDateTime updateTime;
}
