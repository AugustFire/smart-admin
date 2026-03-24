export interface UserInfo {
  userId: number
  username: string
  nickname: string
  avatar: string
  email?: string
  phone?: string
  sex?: number
  roles?: string[]
  permissions?: string[]
}
