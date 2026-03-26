package com.smartadmin.modules.system.dto.response;

import com.smartadmin.modules.system.dto.response.RoleInfo;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 用户信息响应
 */
@Data
@Builder(toBuilder = true)
@Schema(description = "用户信息响应")
public class UserResp {

    @Schema(description = "用户 ID")
    private Long userId;

    @Schema(description = "用户名")
    private String username;

    @Schema(description = "用户昵称")
    private String nickname;

    @Schema(description = "头像 URL")
    private String avatar;

    @Schema(description = "邮箱")
    private String email;

    @Schema(description = "手机号")
    private String phone;

    @Schema(description = "性别 0=未知 1=男 2=女")
    private Integer sex;

    @Schema(description = "状态 0=禁用 1=正常")
    private Integer status;

    @Schema(description = "角色列表")
    private List<RoleInfo> roles;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    @Schema(description = "更新时间")
    private LocalDateTime updateTime;
}