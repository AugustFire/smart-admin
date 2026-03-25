import { http } from '@/utils/request'

/**
 * 获取角色列表（分页）
 */
export function getRolePageApi(params: {
  pageNum: number
  pageSize: number
  name?: string
  code?: string
  status?: number
}) {
  return http.get('/role/page', { params })
}

/**
 * 获取所有角色列表
 */
export function getRoleListApi() {
  return http.get('/role/list')
}

/**
 * 获取角色详情
 */
export function getRoleByIdApi(id: number) {
  return http.get(`/role/${id}`)
}

/**
 * 新增角色
 */
export function addRoleApi(data: any) {
  return http.post('/role', data)
}

/**
 * 修改角色
 */
export function updateRoleApi(data: any) {
  return http.put('/role', data)
}

/**
 * 删除角色
 */
export function deleteRoleApi(id: number) {
  return http.delete(`/role/${id}`)
}

/**
 * 给角色分配菜单权限
 */
export function assignRoleMenusApi(roleId: number, menuIds: number[]) {
  return http.put('/role/assignMenus', { roleId, menuIds })
}

/**
 * 获取角色的菜单 ID 列表
 */
export function getRoleMenuIdsApi(roleId: number) {
  return http.get(`/role/menuIds/${roleId}`)
}