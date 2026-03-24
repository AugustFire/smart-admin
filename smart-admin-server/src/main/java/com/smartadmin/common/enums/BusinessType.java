package com.smartadmin.common.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 业务类型
 */
@Getter
@AllArgsConstructor
public enum BusinessType {

    /** 其他 */
    OTHER(0, "其他"),

    /** 新增 */
    INSERT(1, "新增"),

    /** 修改 */
    UPDATE(2, "修改"),

    /** 删除 */
    DELETE(3, "删除"),

    /** 查询 */
    SELECT(4, "查询"),

    /** 导出 */
    EXPORT(5, "导出"),

    /** 导入 */
    IMPORT(6, "导入"),

    /** 授权 */
    ASSIGN(7, "授权"),

    /** 登录 */
    LOGIN(8, "登录"),

    /** 登出 */
    LOGOUT(9, "登出");

    private final Integer value;
    private final String label;

    public static BusinessType valueOf(Integer value) {
        for (BusinessType type : values()) {
            if (type.getValue().equals(value)) {
                return type;
            }
        }
        return OTHER;
    }
}
