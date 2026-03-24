import { defineStore } from 'pinia'

interface AppState {
  sidebar: {
    opened: boolean
    withoutAnimation: boolean
  }
  device: 'desktop' | 'mobile'
  theme: 'light' | 'dark'
}

export const useAppStore = defineStore('app', {
  state: (): AppState => ({
    sidebar: {
      opened: true,
      withoutAnimation: false,
    },
    device: 'desktop',
    theme: 'light',
  }),

  getters: {
    sidebarOpened: (state) => state.sidebar.opened,
  },

  actions: {
    toggleSidebar() {
      this.sidebar.opened = !this.sidebar.opened
      this.sidebar.withoutAnimation = false
    },

    closeSidebar(withoutAnimation = false) {
      this.sidebar.opened = false
      this.sidebar.withoutAnimation = withoutAnimation
    },

    setDevice(device: 'desktop' | 'mobile') {
      this.device = device
    },

    setTheme(theme: 'light' | 'dark') {
      this.theme = theme
      document.documentElement.setAttribute('data-theme', theme)
    },

    // 初始化主题
    initTheme() {
      const savedTheme = localStorage.getItem('theme') as 'light' | 'dark' | null
      const theme = savedTheme || 'light'
      this.setTheme(theme)
    },
  },

  persist: {
    key: 'app-store',
    storage: localStorage,
    paths: ['sidebar.opened', 'theme'],
  },
})
