import { http } from '@/utils/request'

/**
 * 获取用户列表（分页）
 */
export function getUserPageApi(params: any) {
  return http.get('/user/page', { params })
}

/**
 * 获取用户详情
 */
export function getUserByIdApi(id: number) {
  return http.get(`/user/${id}`)
}

/**
 * 新增用户
 */
export function addUserApi(data: any) {
  return http.post('/user', data)
}

/**
 * 修改用户
 */
export function updateUserApi(data: any) {
  return http.put('/user', data)
}

/**
 * 删除用户
 */
export function deleteUserApi(id: number) {
  return http.delete(`/user/${id}`)
}

/**
 * 重置用户密码
 */
export function resetUserPwdApi(userId: number, password: string) {
  return http.put('/user/resetPwd', null, { params: { userId, password } })
}

/**
 * 给用户分配角色
 */
export function assignUserRolesApi(userId: number, roleIds: number[]) {
  return http.put('/user/assignRoles', roleIds, { params: { userId } })
}

/**
 * 获取用户的角色 ID 列表
 */
export function getUserRoleIdsApi(userId: number) {
  return http.get(`/user/roleIds/${userId}`)
}

/**
 * 获取角色列表
 */
export function getRoleListApi() {
  return http.get('/role/list')
}
