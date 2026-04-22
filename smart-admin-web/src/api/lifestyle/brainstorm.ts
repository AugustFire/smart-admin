// 头脑风暴 API - 前端静态版本，暂不使用
export interface BrainstormItem {
  id: string
  content: string
  tags: string[]
  createdAt: string
  updatedAt: string
}

export interface BrainstormQueryReq {
  keyword?: string
  tag?: string
  startDate?: string
  endDate?: string
}
