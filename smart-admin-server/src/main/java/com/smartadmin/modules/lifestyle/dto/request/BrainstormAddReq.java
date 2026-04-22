package com.smartadmin.modules.lifestyle.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * 头脑风暴新增请求
 */
@Data
@Schema(description = "头脑风暴新增请求")
public class BrainstormAddReq {

    @NotBlank(message = "内容不能为空")
    @Schema(description = "想法内容", example = "这是一个好主意...")
    private String content;

    @Schema(description = "标签，多个逗号分隔", example = "work,idea")
    private String tags;
}
