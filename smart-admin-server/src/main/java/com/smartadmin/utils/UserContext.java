package com.smartadmin.utils;

/**
 * 用户上下文工具类
 * 基于 ThreadLocal 存储当前登录用户信息
 */
public class UserContext {

    private static final ThreadLocal<Long> USER_ID = new ThreadLocal<>();
    private static final ThreadLocal<String> USERNAME = new ThreadLocal<>();

    private UserContext() {
        // 工具类，禁止实例化
    }

    /**
     * 设置用户 ID
     */
    public static void setUserId(Long userId) {
        USER_ID.set(userId);
    }

    /**
     * 获取用户 ID
     */
    public static Long getUserId() {
        return USER_ID.get();
    }

    /**
     * 设置用户名
     */
    public static void setUsername(String username) {
        USERNAME.set(username);
    }

    /**
     * 获取用户名
     */
    public static String getUsername() {
        return USERNAME.get();
    }

    /**
     * 清理上下文（请求结束时调用，防止内存泄漏）
     */
    public static void clear() {
        USER_ID.remove();
        USERNAME.remove();
    }
}