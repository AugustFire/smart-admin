import request from '@/utils/request'

const BASE_URL = '/lifestyle/brainstorm'

// 数据结构定义
export interface BrainstormItem {
  id: number
  userId: number
  content: string
  tags: string
  createTime: string
  updateTime: string
}

export interface BrainstormAddReq {
  content: string
  tags?: string
}

export interface BrainstormUpdateReq {
  id: number
  content: string
  tags?: string
}

export interface BrainstormPageQueryReq {
  pageNum?: number
  pageSize?: number
  keyword?: string
  tag?: string
  startDate?: string
  endDate?: string
}

// API 函数
export function getBrainstormPageApi(params: BrainstormPageQueryReq) {
  return request.get<any>(`${BASE_URL}/page`, { params })
}

export function addBrainstormApi(data: BrainstormAddReq) {
  return request.post<any>(`${BASE_URL}/add`, data)
}

export function updateBrainstormApi(data: BrainstormUpdateReq) {
  return request.post<any>(`${BASE_URL}/update`, data)
}

export function deleteBrainstormApi(id: number) {
  return request.post<any>(`${BASE_URL}/delete/${id}`)
}
