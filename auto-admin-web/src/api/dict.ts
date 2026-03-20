import { http } from '@/utils/request'

/**
 * 获取字典类型列表
 */
export function getDictTypeListApi() {
  return http.get('/dict/type/list')
}

/**
 * 获取字典类型详情
 */
export function getDictTypeByIdApi(id: number) {
  return http.get(`/dict/type/${id}`)
}

/**
 * 新增字典类型
 */
export function addDictTypeApi(data: any) {
  return http.post('/dict/type', data)
}

/**
 * 修改字典类型
 */
export function updateDictTypeApi(data: any) {
  return http.put('/dict/type', data)
}

/**
 * 删除字典类型
 */
export function deleteDictTypeApi(id: number) {
  return http.delete(`/dict/type/${id}`)
}

/**
 * 获取字典数据列表
 */
export function getDictDataListApi(dictType: string) {
  return http.get('/dict/data/list', { params: { dictType } })
}

/**
 * 新增字典数据
 */
export function addDictDataApi(data: any) {
  return http.post('/dict/data', data)
}

/**
 * 修改字典数据
 */
export function updateDictDataApi(data: any) {
  return http.put('/dict/data', data)
}

/**
 * 删除字典数据
 */
export function deleteDictDataApi(id: number) {
  return http.delete(`/dict/data/${id}`)
}
