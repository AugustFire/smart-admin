import request from '@/utils/request'

const BASE_URL = '/lifestyle/diet'

export interface DietRecord {
  id: number
  userId: number
  recordDate: string
  mealTime?: string
  mealType: string
  mealTypeName: string
  foodName: string
  portion?: string
  tags?: string
  tagNames?: string
  mood?: string
  moodName?: string
  description?: string
  createTime: string
}

export interface DietRecordAddReq {
  recordDate: string
  mealTime?: string
  mealType: string
  foodName: string
  portion?: string
  tags?: string
  mood?: string
  description?: string
}

export interface DietRecordUpdateReq extends DietRecordAddReq {
  id: number
}

export interface DietRecordPageQueryReq {
  pageNum?: number
  pageSize?: number
  recordDate?: string
  startDate?: string
  endDate?: string
  mealType?: string
}

export function getDietPageApi(params: DietRecordPageQueryReq) {
  return request.get(`${BASE_URL}/page`, { params })
}

export function getDietByIdApi(id: number) {
  return request.get(`${BASE_URL}/${id}`)
}

export function addDietApi(data: DietRecordAddReq) {
  return request.post(`${BASE_URL}/add`, data)
}

export function updateDietApi(data: DietRecordUpdateReq) {
  return request.post(`${BASE_URL}/update`, data)
}

export function deleteDietApi(id: number) {
  return request.post(`${BASE_URL}/delete/${id}`)
}

export function getFoodHistoryApi() {
  return request.get(`${BASE_URL}/history/foods`)
}

export function getFoodLatestApi(foodName: string) {
  return request.get(`${BASE_URL}/history/food`, { params: { foodName } })
}

export function getMealLatestApi(mealType: string) {
  return request.get(`${BASE_URL}/history/meal`, { params: { mealType } })
}
