// 文本收集 API - 前端静态版本，暂不使用
export interface TextCollectionItem {
  id: string
  title: string
  content: string
  categoryId?: string
  tags: string[]
  createdAt: string
  updatedAt: string
}

export interface TextCategory {
  id: string
  name: string
  parentId?: string
  children?: TextCategory[]
}

export interface TextCollectionQueryReq {
  keyword?: string
  categoryId?: string
  tag?: string
}
