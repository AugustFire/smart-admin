import { http } from '@/utils/request'

/**
 * 获取菜单树
 */
export function getMenuTreeApi() {
  return http.get('/menu/tree')
}

/**
 * 获取菜单详情
 */
export function getMenuByIdApi(id: number) {
  return http.get(`/menu/${id}`)
}

/**
 * 新增菜单
 */
export function addMenuApi(data: any) {
  return http.post('/menu', data)
}

/**
 * 修改菜单
 */
export function updateMenuApi(data: any) {
  return http.put('/menu', data)
}

/**
 * 删除菜单
 */
export function deleteMenuApi(id: number) {
  return http.delete(`/menu/${id}`)
}

/**
 * 获取菜单选项列表（用于角色分配）
 */
export function getMenuOptionsApi() {
  return http.get('/menu/options')
}
