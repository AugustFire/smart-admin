import request from '@/utils/request'

const BASE_URL = '/lifestyle/text-collection'

// 数据结构定义
export interface TextCollectionItem {
  id: number
  userId: number
  categoryId?: number
  categoryName?: string
  title: string
  content: string
  tags: string
  createTime: string
  updateTime: string
}

export interface TextCategory {
  id: number
  parentId?: number
  name: string
  sort?: number
  createTime?: string
  updateTime?: string
  children?: TextCategory[]
}

export interface TextCollectionAddReq {
  categoryId?: number
  title?: string
  content: string
  tags?: string
}

export interface TextCollectionUpdateReq {
  id: number
  categoryId?: number
  title?: string
  content: string
  tags?: string
}

export interface TextCollectionPageQueryReq {
  pageNum?: number
  pageSize?: number
  keyword?: string
  categoryId?: number
  tag?: string
}

export interface TextCategoryAddReq {
  parentId?: number
  name: string
  sort?: number
}

export interface TextCategoryUpdateReq {
  id: number
  parentId?: number
  name: string
  sort?: number
}

// 响应类型定义
export interface PageResponse<T> {
  code: number
  data: {
    list: T[]
    total: number
  }
  message: string
}

export interface IdResponse {
  code: number
  data: number
  message: string
}

export interface ListResponse<T> {
  code: number
  data: T[]
  message: string
}

// 文本收藏 API
export function getTextCollectionPageApi(params: TextCollectionPageQueryReq) {
  return request.get<PageResponse<TextCollectionItem>>(`${BASE_URL}/page`, { params })
}

export function getTextCollectionByIdApi(id: number) {
  return request.get<PageResponse<TextCollectionItem>>(`${BASE_URL}/${id}`)
}

export function addTextCollectionApi(data: TextCollectionAddReq) {
  return request.post<IdResponse>(`${BASE_URL}/add`, data)
}

export function updateTextCollectionApi(data: TextCollectionUpdateReq) {
  return request.post<any>(`${BASE_URL}/update`, data)
}

export function deleteTextCollectionApi(id: number) {
  return request.post<any>(`${BASE_URL}/delete/${id}`)
}

// 文本分类 API
export function getTextCategoryListApi() {
  return request.get<ListResponse<TextCategory>>(`${BASE_URL}/category/list`)
}

export function getTextCategoryFlatApi() {
  return request.get<ListResponse<TextCategory>>(`${BASE_URL}/category/flat`)
}

export function addTextCategoryApi(data: TextCategoryAddReq) {
  return request.post<IdResponse>(`${BASE_URL}/category/add`, data)
}

export function updateTextCategoryApi(data: TextCategoryUpdateReq) {
  return request.post<any>(`${BASE_URL}/category/update`, data)
}

export function deleteTextCategoryApi(id: number) {
  return request.post<any>(`${BASE_URL}/category/delete/${id}`)
}
