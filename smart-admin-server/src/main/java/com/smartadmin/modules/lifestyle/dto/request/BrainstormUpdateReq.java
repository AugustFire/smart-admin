package com.smartadmin.modules.lifestyle.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 头脑风暴更新请求
 */
@Data
@Schema(description = "头脑风暴更新请求")
public class BrainstormUpdateReq {

    @NotNull(message = "ID不能为空")
    @Schema(description = "主键ID")
    private Long id;

    @NotBlank(message = "内容不能为空")
    @Schema(description = "想法内容", example = "这是一个好主意...")
    private String content;

    @Schema(description = "标签，多个逗号分隔", example = "work,idea")
    private String tags;
}
