package com.autoadmin.common;

/**
 * 响应状态码常量
 */
public class ResultCode {

    /** 成功 */
    public static final int SUCCESS = 200;

    /** 未授权 */
    public static final int UNAUTHORIZED = 401;

    /** 禁止访问 */
    public static final int FORBIDDEN = 403;

    /** 未找到 */
    public static final int NOT_FOUND = 404;

    /** 服务器内部错误 */
    public static final int INTERNAL_ERROR = 500;

    /** 参数验证失败 */
    public static final int BAD_REQUEST = 400;

    /** Token 过期 */
    public static final int TOKEN_EXPIRED = 4001;

    /** Token 无效 */
    public static final int TOKEN_INVALID = 4002;

    /** 无权限 */
    public static final int PERMISSION_DENIED = 4003;
}
