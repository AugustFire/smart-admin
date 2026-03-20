package com.autoadmin.common.exception;

/**
 * 认证异常 (Token 无效、过期等)
 */
public class AuthenticationException extends BusinessException {

    private static final long serialVersionUID = 1L;

    public AuthenticationException(String message) {
        super(401, message);
    }
}
