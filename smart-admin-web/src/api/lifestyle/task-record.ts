// 任务记录 API - 前端静态版本，暂不使用
export interface TaskItem {
  id: string
  title: string
  description?: string
  status: 'todo' | 'in-progress' | 'done'
  progress: number
  startDate: string
  endDate: string
  projectId?: string
  tags: string[]
  createdAt: string
  completedAt?: string
}

export interface TaskProject {
  id: string
  name: string
  color: string
}

export interface TaskQueryReq {
  keyword?: string
  status?: string
  projectId?: string
  startDate?: string
  endDate?: string
}
