package com.smartadmin.modules.system.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.io.Serializable;

/**
 * 更新字典数据请求
 */
@Data
@Schema(description = "更新字典数据请求")
public class DictDataUpdateReq implements Serializable {

    private static final long serialVersionUID = 1L;

    @NotNull(message = "字典 ID 不能为空")
    @Schema(description = "字典 ID", example = "1")
    private Long id;

    @NotBlank(message = "字典标签不能为空")
    @Schema(description = "字典标签", example = "男")
    private String label;

    @NotBlank(message = "字典键值不能为空")
    @Schema(description = "字典键值", example = "1")
    private String value;

    @Schema(description = "排序", example = "1")
    private Integer sort;

    @Schema(description = "状态 0=禁用 1=正常", example = "1")
    private Integer status;

    @Schema(description = "样式属性", example = "")
    private String cssClass;

    @Schema(description = "表格回显样式", example = "primary")
    private String listClass;

    @Schema(description = "是否默认 0=否 1=是", example = "0")
    private Integer isDefault;

    @Schema(description = "备注", example = "")
    private String remark;
}