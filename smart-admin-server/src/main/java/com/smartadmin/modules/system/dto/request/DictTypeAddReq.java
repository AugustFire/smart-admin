package com.smartadmin.modules.system.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.io.Serializable;

/**
 * 新增字典类型请求
 */
@Data
@Schema(description = "新增字典类型请求")
public class DictTypeAddReq implements Serializable {

    private static final long serialVersionUID = 1L;

    @NotBlank(message = "字典名称不能为空")
    @Size(max = 30, message = "字典名称长度不能超过 30 个字符")
    @Schema(description = "字典名称", example = "用户性别")
    private String name;

    @NotBlank(message = "字典类型不能为空")
    @Size(max = 50, message = "字典类型长度不能超过 50 个字符")
    @Schema(description = "字典类型", example = "sys_user_sex")
    private String type;

    @Schema(description = "备注", example = "用户性别字典")
    private String remark;

    @Schema(description = "状态 0=禁用 1=正常", example = "1")
    private Integer status;
}