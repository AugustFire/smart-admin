import { defineStore } from 'pinia'
import { ref, watch } from 'vue'

export interface ThemeColor {
  name: string
  label: string
  primary: string
  primaryLight3: string
  primaryLight5: string
  primaryLight7: string
  primaryLight9: string
}

// 预设配色方案
export const themeColors: ThemeColor[] = [
  {
    name: 'rose',
    label: '玫瑰红',
    primary: '#FE4066',
    primaryLight3: '#fe6b87',
    primaryLight5: '#fe96a8',
    primaryLight7: '#fec1cb',
    primaryLight9: '#fff0f3',
  },
  {
    name: 'blue',
    label: '天空蓝',
    primary: '#3b82f6',
    primaryLight3: '#60a5fa',
    primaryLight5: '#93c5fd',
    primaryLight7: '#bfdbfe',
    primaryLight9: '#eff6ff',
  },
  {
    name: 'green',
    label: '翡翠绿',
    primary: '#10b981',
    primaryLight3: '#34d399',
    primaryLight5: '#6ee7b7',
    primaryLight7: '#a7f3d0',
    primaryLight9: '#ecfdf5',
  },
  {
    name: 'purple',
    label: '紫罗兰',
    primary: '#8b5cf6',
    primaryLight3: '#a78bfa',
    primaryLight5: '#c4b5fd',
    primaryLight7: '#ddd6fe',
    primaryLight9: '#f5f3ff',
  },
  {
    name: 'orange',
    label: '活力橙',
    primary: '#f97316',
    primaryLight3: '#fb923c',
    primaryLight5: '#fdba74',
    primaryLight7: '#fed7aa',
    primaryLight9: '#fff7ed',
  },
]

export const useThemeStore = defineStore('theme', () => {
  const currentColor = ref<string>(localStorage.getItem('themeColor') || 'rose')
  const isDark = ref(localStorage.getItem('theme') === 'dark')
  const themeTransition = ref(false)
  const transitionToDark = ref(false)
  const transitionCenter = ref({ x: 0, y: 0 })

  // 设置动画中心点
  function setTransitionCenter(x: number, y: number) {
    transitionCenter.value = { x, y }
  }

  // 应用配色方案
  function applyColorScheme(color: ThemeColor) {
    const root = document.documentElement
    root.style.setProperty('--el-color-primary', color.primary)
    root.style.setProperty('--el-color-primary-light-3', color.primaryLight3)
    root.style.setProperty('--el-color-primary-light-5', color.primaryLight5)
    root.style.setProperty('--el-color-primary-light-7', color.primaryLight7)
    root.style.setProperty('--el-color-primary-light-9', color.primaryLight9)

    // 更新侧边栏激活颜色
    root.style.setProperty('--sidebar-active-text-color', color.primary)
    root.style.setProperty('--sidebar-active-bg-color', `${color.primary}1a`)
    root.style.setProperty('--sidebar-hover-bg-color', `${color.primary}14`)

    // 更新汉堡按钮颜色
    root.style.setProperty('--hamburger-color', color.primary)
  }

  // 设置配色方案
  function setColorScheme(colorName: string) {
    const color = themeColors.find(c => c.name === colorName)
    if (color) {
      currentColor.value = colorName
      localStorage.setItem('themeColor', colorName)
      applyColorScheme(color)
    }
  }

  // 切换主题（带动画）
  async function toggleThemeWithAnimation() {
    const willBeDark = !isDark.value
    transitionToDark.value = willBeDark
    themeTransition.value = true

    if (willBeDark) {
      // 浅色 → 深色：深色圆扩散，完成后切换主题
      await new Promise(resolve => setTimeout(resolve, 700))

      isDark.value = true
      document.documentElement.setAttribute('data-theme', 'dark')
      localStorage.setItem('theme', 'dark')
    } else {
      // 深色 → 浅色：先切换主题，深色圆收缩
      isDark.value = false
      document.documentElement.setAttribute('data-theme', 'light')
      localStorage.setItem('theme', 'light')

      await new Promise(resolve => setTimeout(resolve, 700))
    }

    themeTransition.value = false
  }

  // 初始化时应用保存的配色
  const savedColor = themeColors.find(c => c.name === currentColor.value)
  if (savedColor) {
    applyColorScheme(savedColor)
  }

  // 初始化时应用保存的主题
  if (isDark.value) {
    document.documentElement.setAttribute('data-theme', 'dark')
  }

  return {
    currentColor,
    isDark,
    themeTransition,
    transitionToDark,
    transitionCenter,
    setTransitionCenter,
    setColorScheme,
    toggleThemeWithAnimation,
    themeColors,
  }
})