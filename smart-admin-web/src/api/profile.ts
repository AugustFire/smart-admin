import { http } from '@/utils/request'

/**
 * 获取当前用户信息
 */
export function getProfileApi() {
  return http.get('/profile')
}

/**
 * 修改个人信息
 */
export function updateProfileApi(data: any) {
  return http.put('/profile', data)
}

/**
 * 修改密码
 */
export function updatePasswordApi(data: { oldPassword: string; newPassword: string }) {
  return http.put('/profile/password', data)
}
