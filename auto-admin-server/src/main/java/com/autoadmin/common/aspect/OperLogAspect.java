package com.autoadmin.common.aspect;

import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONUtil;
import com.autoadmin.common.exception.BusinessException;
import com.autoadmin.modules.system.entity.SysOperLog;
import com.autoadmin.modules.system.mapper.SysOperLogMapper;
import com.autoadmin.utils.ServletUtils;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;
import org.springframework.validation.BindingResult;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

import java.lang.reflect.Method;
import java.util.Map;

/**
 * 操作日志切面
 */
@Slf4j
@Aspect
@Component
public class OperLogAspect {

    private final SysOperLogMapper operLogMapper;

    public OperLogAspect(SysOperLogMapper operLogMapper) {
        this.operLogMapper = operLogMapper;
    }

    @Pointcut("@annotation(com.autoadmin.common.annotation.OperLog)")
    public void operLogPointcut() {
    }

    @Around("operLogPointcut()")
    public Object around(ProceedingJoinPoint point) throws Throwable {
        long startTime = System.currentTimeMillis();

        // 获取请求
        ServletRequestAttributes attributes =
                (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attributes == null) {
            return point.proceed();
        }

        HttpServletRequest request = attributes.getRequest();

        // 获取注解信息
        MethodSignature signature = (MethodSignature) point.getSignature();
        Method method = signature.getMethod();
        com.autoadmin.common.annotation.OperLog operLog =
                method.getAnnotation(com.autoadmin.common.annotation.OperLog.class);

        // 构建操作日志对象
        SysOperLog operLogEntity = new SysOperLog();
        operLogEntity.setTitle(operLog.title());
        operLogEntity.setBusinessType(operLog.businessType().getValue());
        operLogEntity.setMethod(point.getTarget().getClass().getName() + "." + method.getName() + "()");
        operLogEntity.setRequestMethod(request.getMethod());
        operLogEntity.setOperUrl(request.getRequestURI());
        operLogEntity.setOperIp(ServletUtils.getClientIP(request));
        operLogEntity.setOperParam(getRequestParams(point));

        Object result = null;
        try {
            // 执行方法
            result = point.proceed();
            operLogEntity.setStatus(1);
        } catch (Exception e) {
            operLogEntity.setStatus(0);
            operLogEntity.setErrorMsg(StrUtil.sub(e.getMessage(), 0, 2000));
            throw e;
        } finally {
            // 计算执行时间
            long costTime = System.currentTimeMillis() - startTime;
            operLogEntity.setCostTime(costTime);

            // 设置返回结果
            if (result != null) {
                operLogEntity.setJsonResult(StrUtil.sub(JSONUtil.toJsonStr(result), 0, 2000));
            }

            // 异步保存日志 (这里同步保存，后续可改为异步)
            try {
                operLogMapper.insert(operLogEntity);
            } catch (Exception e) {
                log.warn("保存操作日志失败：{}", e.getMessage());
            }
        }

        return result;
    }

    /**
     * 获取请求参数
     */
    private String getRequestParams(ProceedingJoinPoint point) {
        Object[] args = point.getArgs();
        if (args == null || args.length == 0) {
            return "";
        }

        StringBuilder sb = new StringBuilder();
        for (Object arg : args) {
            if (arg instanceof ServletUtils ||
                arg instanceof HttpServletRequest ||
                arg instanceof BindingResult) {
                continue;
            }
            if (arg instanceof MultipartFile) {
                MultipartFile file = (MultipartFile) arg;
                sb.append(file.getName()).append(":").append(file.getOriginalFilename()).append(";");
            } else {
                try {
                    String json = JSONUtil.toJsonStr(arg);
                    sb.append(json).append(";");
                } catch (Exception e) {
                    sb.append(arg.toString()).append(";");
                }
            }
        }
        return StrUtil.sub(sb.toString(), 0, 2000);
    }
}
