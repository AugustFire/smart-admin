import { http } from '@/utils/request'

/**
 * 获取登录日志列表
 */
export function getLoginLogPageApi(params: any) {
  return http.get('/loginlog/page', { params })
}

/**
 * 清空登录日志
 */
export function clearLoginLogApi() {
  return http.delete('/loginlog/clear')
}

/**
 * 获取操作日志列表
 */
export function getOperLogPageApi(params: any) {
  return http.get('/operlog/page', { params })
}

/**
 * 清空操作日志
 */
export function clearOperLogApi() {
  return http.delete('/operlog/clear')
}
