import { defineStore } from 'pinia'
import type { UserInfo } from '@/types/user'
import { loginApi, getUserInfoApi, logoutApi } from '@/api/auth'

interface UserState {
  token: string
  userInfo: UserInfo | null
  roles: string[]
  permissions: string[]
}

export const useUserStore = defineStore('user', {
  state: (): UserState => ({
    token: '',
    userInfo: null,
    roles: [],
    permissions: [],
  }),

  getters: {
    isLoggedIn: (state) => !!state.token,
    username: (state) => state.userInfo?.username || '',
    nickname: (state) => state.userInfo?.nickname || '',
    avatar: (state) => state.userInfo?.avatar || '',
  },

  actions: {
    setToken(token: string) {
      this.token = token
    },

    setUserInfo(userInfo: UserInfo) {
      this.userInfo = userInfo
    },

    setRoles(roles: string[]) {
      this.roles = roles
    },

    setPermissions(permissions: string[]) {
      this.permissions = permissions
    },

    // 登录
    async login(username: string, password: string) {
      const { data } = await loginApi({ username, password })
      this.setToken(data.token)
      this.setUserInfo({
        userId: data.userId,
        username: data.username,
        nickname: data.nickname,
        avatar: data.avatar,
      })
      return data
    },

    // 获取用户信息
    async getUserInfo() {
      const { data } = await getUserInfoApi()
      this.setUserInfo(data)
      this.setRoles(data.roles || [])
      this.setPermissions(data.permissions || [])
      return data
    },

    // 登出
    async logout() {
      try {
        await logoutApi()
      } catch (error) {
        console.error('登出失败:', error)
      } finally {
        this.reset()
      }
    },

    // 重置
    reset() {
      this.token = ''
      this.userInfo = null
      this.roles = []
      this.permissions = []
    },
  },

  persist: {
    key: 'user-store',
    storage: localStorage,
    paths: ['token', 'userInfo'],
  },
})
