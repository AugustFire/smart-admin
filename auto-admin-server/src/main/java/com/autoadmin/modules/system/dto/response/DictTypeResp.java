package com.autoadmin.modules.system.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 字典类型响应
 */
@Data
@Builder
@Schema(description = "字典类型响应")
public class DictTypeResp implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "字典 ID")
    private Long id;

    @Schema(description = "字典名称")
    private String name;

    @Schema(description = "字典类型")
    private String type;

    @Schema(description = "状态 0=禁用 1=正常")
    private Integer status;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    @Schema(description = "更新时间")
    private LocalDateTime updateTime;
}