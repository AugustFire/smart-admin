package com.autoadmin.common.exception;

/**
 * 权限异常 (无权限访问)
 */
public class AuthorizationException extends BusinessException {

    private static final long serialVersionUID = 1L;

    public AuthorizationException(String message) {
        super(403, message);
    }
}
