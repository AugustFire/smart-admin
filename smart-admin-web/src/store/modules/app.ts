import { defineStore } from 'pinia'

interface AppState {
  sidebar: {
    opened: boolean
    withoutAnimation: boolean
  }
  device: 'desktop' | 'mobile'
}

export const useAppStore = defineStore('app', {
  state: (): AppState => ({
    sidebar: {
      opened: true,
      withoutAnimation: false,
    },
    device: 'desktop',
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
  },

  persist: {
    key: 'app-store',
    storage: localStorage,
    paths: ['sidebar.opened'],
  },
})
