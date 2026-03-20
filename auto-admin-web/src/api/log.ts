import { http } from '@/utils/request'

/**
 * 获取登录日志列表
 */
export function getLoginLogPageApi(params: any) {
  return http.get('/loginlog/page', { params })
}

/**
 * 获取操作日志列表
 */
export function getOperLogPageApi(params: any) {
  return http.get('/operlog/page', { params })
}
