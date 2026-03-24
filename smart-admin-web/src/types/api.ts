export interface SysApi {
  id?: number
  path: string
  method: string
  name?: string
  isPublic?: number
  menuIds?: number[]
  menuNames?: string[]
  status?: number
  remark?: string
  creator?: string
  createTime?: string
  updater?: string
  updateTime?: string
  deleted?: number
}
