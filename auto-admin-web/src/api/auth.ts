import { http } from '@/utils/request'

/**
 * 登录
 */
export function loginApi(data: { username: string; password: string }) {
  return http.post('/auth/login', data)
}

/**
 * 获取用户信息
 */
export function getUserInfoApi() {
  return http.get('/auth/userInfo')
}

/**
 * 获取用户菜单
 */
export function getUserMenusApi() {
  return http.get('/auth/userMenus')
}

/**
 * 登出
 */
export function logoutApi() {
  return http.post('/auth/logout')
}
