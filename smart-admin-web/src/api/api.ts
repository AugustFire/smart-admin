import { http } from '@/utils/request'
import type { SysApi } from '@/types/api'

/**
 * 分页查询接口列表
 */
export function getApiPageApi(params?: any) {
  return http.get('/api/page', { params })
}

/**
 * 获取接口详情
 */
export function getApiByIdApi(id: number) {
  return http.get(`/api/${id}`)
}

/**
 * 新增接口
 */
export function addApiApi(data: SysApi) {
  return http.post('/api', data)
}

/**
 * 修改接口
 */
export function updateApiApi(data: SysApi) {
  return http.put('/api', data)
}

/**
 * 删除接口
 */
export function deleteApiApi(id: number) {
  return http.delete(`/api/${id}`)
}

/**
 * 获取接口树（按菜单分组）
 */
export function getApiTreeApi() {
  return http.get('/api/tree')
}
