package com.autoadmin.modules.system.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 给角色分配菜单请求
 */
@Data
@Schema(description = "给角色分配菜单请求")
public class RoleAssignMenuReq implements Serializable {

    private static final long serialVersionUID = 1L;

    @NotNull(message = "角色 ID 不能为空")
    @Schema(description = "角色 ID", example = "1")
    private Long roleId;

    @NotEmpty(message = "菜单 ID 列表不能为空")
    @Schema(description = "菜单 ID 列表")
    private List<Long> menuIds;
}