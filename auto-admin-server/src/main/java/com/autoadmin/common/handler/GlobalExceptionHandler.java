package com.autoadmin.common.handler;

import com.autoadmin.common.Result;
import com.autoadmin.common.exception.BusinessException;
import com.autoadmin.common.exception.AuthenticationException;
import com.autoadmin.common.exception.AuthorizationException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.validation.BindException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

/**
 * 全局异常处理器
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    /**
     * 业务异常
     */
    @ExceptionHandler(BusinessException.class)
    @ResponseStatus(HttpStatus.OK)
    public Result<?> handleBusinessException(BusinessException e) {
        log.warn("业务异常：{}", e.getMessage());
        return Result.error(e.getCode(), e.getMessage());
    }

    /**
     * 认证异常
     */
    @ExceptionHandler(AuthenticationException.class)
    @ResponseStatus(HttpStatus.UNAUTHORIZED)
    public Result<?> handleAuthenticationException(AuthenticationException e) {
        log.warn("认证异常：{}", e.getMessage());
        return Result.unauthorized(e.getMessage());
    }

    /**
     * 权限异常
     */
    @ExceptionHandler(AuthorizationException.class)
    @ResponseStatus(HttpStatus.FORBIDDEN)
    public Result<?> handleAuthorizationException(AuthorizationException e) {
        log.warn("权限异常：{}", e.getMessage());
        return Result.forbidden(e.getMessage());
    }

    /**
     * 请求参数验证异常
     */
    @ExceptionHandler({MethodArgumentNotValidException.class, BindException.class})
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Result<?> handleValidationException(Exception e) {
        String message;
        if (e instanceof MethodArgumentNotValidException) {
            MethodArgumentNotValidException ex = (MethodArgumentNotValidException) e;
            message = ex.getBindingResult().getFieldError() != null
                    ? ex.getBindingResult().getFieldError().getDefaultMessage()
                    : "参数验证失败";
        } else {
            BindException ex = (BindException) e;
            message = ex.getBindingResult().getFieldError() != null
                    ? ex.getBindingResult().getFieldError().getDefaultMessage()
                    : "参数验证失败";
        }
        log.warn("参数验证异常：{}", message);
        return Result.error(400, message);
    }

    /**
     * 请求方法不支持
     */
    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    @ResponseStatus(HttpStatus.METHOD_NOT_ALLOWED)
    public Result<?> handleHttpRequestMethodNotSupportedException(
            HttpRequestMethodNotSupportedException e) {
        log.warn("请求方法不支持：{}", e.getMessage());
        return Result.error(405, "不支持'" + e.getMethod() + "'请求方法");
    }

    /**
     * 系统异常
     */
    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public Result<?> handleException(Exception e) {
        log.error("系统异常：{}", e.getMessage(), e);
        return Result.error("系统异常，请联系管理员");
    }
}
