package com.autoadmin.modules.system.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 字典数据响应
 */
@Data
@Builder
@Schema(description = "字典数据响应")
public class DictDataResp implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "字典 ID")
    private Long id;

    @Schema(description = "字典类型")
    private String dictType;

    @Schema(description = "字典标签")
    private String label;

    @Schema(description = "字典键值")
    private String value;

    @Schema(description = "排序")
    private Integer sort;

    @Schema(description = "状态 0=禁用 1=正常")
    private Integer status;

    @Schema(description = "样式属性")
    private String cssClass;

    @Schema(description = "表格回显样式")
    private String listClass;

    @Schema(description = "是否默认 0=否 1=是")
    private Integer isDefault;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    @Schema(description = "更新时间")
    private LocalDateTime updateTime;
}