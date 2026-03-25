<template>
  <div class="navbar">
    <div class="left-menu">
      <hamburger :is-active="sidebar.opened" @toggle-click="toggleSidebar" />
      <breadcrumb />
    </div>
    <div class="right-menu">
      <div class="theme-switch" @click="toggleTheme">
        <el-icon class="theme-icon"><component :is="isDark ? 'Sunny' : 'Moon'" /></el-icon>
      </div>
      <el-popover placement="bottom" :width="280" trigger="click">
        <template #reference>
          <div class="skin-switch">
            <el-icon><Brush /></el-icon>
          </div>
        </template>
        <div class="color-picker">
          <div class="picker-title">主题配色</div>
          <div class="color-list">
            <div
              v-for="color in themeStore.themeColors"
              :key="color.name"
              class="color-item"
              :class="{ active: themeStore.currentColor === color.name }"
              @click="themeStore.setColorScheme(color.name)"
            >
              <div class="color-preview" :style="{ background: color.primary }"></div>
              <span class="color-label">{{ color.label }}</span>
              <el-icon v-if="themeStore.currentColor === color.name" class="color-check"><Check /></el-icon>
            </div>
          </div>
        </div>
      </el-popover>
      <el-dropdown trigger="click">
        <div class="avatar-wrapper">
          <el-avatar :size="36" :src="avatar" class="user-avatar">
            <el-icon :size="20"><User /></el-icon>
          </el-avatar>
          <span class="username">{{ nickname }}</span>
          <el-icon><ArrowDown /></el-icon>
        </div>
        <template #dropdown>
          <el-dropdown-menu>
            <el-dropdown-item @click="handleProfile">
              <el-icon><User /></el-icon>
              个人中心
            </el-dropdown-item>
            <el-dropdown-item divided @click="handleLogout">
              <el-icon><SwitchButton /></el-icon>
              退出登录
            </el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { useRouter } from 'vue-router'
import { Sunny, Moon, Brush, Check } from '@element-plus/icons-vue'
import { useAppStore } from '@/store/modules/app'
import { useUserStore } from '@/store/modules/user'
import { useThemeStore } from '@/store/modules/theme'
import Hamburger from '@/components/Hamburger/index.vue'
import Breadcrumb from '../Breadcrumb/index.vue'

const router = useRouter()
const appStore = useAppStore()
const userStore = useUserStore()
const themeStore = useThemeStore()

const sidebar = computed(() => appStore.sidebar)
const nickname = computed(() => userStore.nickname)
const avatar = computed(() => userStore.avatar)

const isDark = ref(appStore.theme === 'dark')

function toggleSidebar() {
  appStore.toggleSidebar()
}

function toggleTheme() {
  isDark.value = !isDark.value
  const theme = isDark.value ? 'dark' : 'light'
  appStore.setTheme(theme)
}

function handleProfile() {
  router.push('/profile')
}

async function handleLogout() {
  await userStore.logout()
  router.push('/login')
}
</script>

<style lang="scss" scoped>
.navbar {
  height: var(--navbar-height, 60px);
  overflow: hidden;
  position: relative;
  background: var(--navbar-bg-color);
  box-shadow: var(--navbar-shadow);
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 24px;
  backdrop-filter: blur(10px);
  border-bottom: 1px solid var(--border-color);

  .left-menu {
    display: flex;
    align-items: center;
    gap: 16px;

    :deep(.hamburger-container) {
      padding: 10px;
      border-radius: 10px;
      transition: all 0.3s ease;

      &:hover {
        background-color: var(--bg-tertiary);
        transform: scale(1.05);
      }
    }
  }

  .right-menu {
    display: flex;
    align-items: center;
    gap: 20px;

    .theme-switch {
      display: flex;
      align-items: center;
      justify-content: center;
      width: 36px;
      height: 36px;
      border-radius: 50%;
      background: var(--bg-secondary);
      cursor: pointer;
      transition: all 0.3s ease;
      border: 1px solid var(--border-color);

      &:hover {
        background: var(--bg-tertiary);
        transform: rotate(15deg);
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
      }

      .theme-icon {
        font-size: 18px;
        color: var(--el-color-primary);
        transition: all 0.3s ease;
      }
    }

    .skin-switch {
      display: flex;
      align-items: center;
      justify-content: center;
      width: 36px;
      height: 36px;
      border-radius: 50%;
      background: var(--bg-secondary);
      cursor: pointer;
      transition: all 0.3s ease;
      border: 1px solid var(--border-color);

      &:hover {
        background: var(--bg-tertiary);
        transform: scale(1.1);
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
      }

      .el-icon {
        font-size: 18px;
        color: var(--el-color-primary);
      }
    }

    .avatar-wrapper {
      display: flex;
      align-items: center;
      gap: 12px;
      cursor: pointer;
      padding: 8px 14px;
      border-radius: 12px;
      transition: all 0.3s ease;

      &:hover {
        background-color: var(--bg-tertiary);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
      }

      .el-avatar {
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
        border: 2px solid var(--el-color-primary-light-9);
        background: linear-gradient(135deg, var(--el-color-primary) 0%, var(--el-color-primary-light-3) 100%);
        color: #fff;
      }

      .username {
        font-size: 14px;
        font-weight: 500;
        color: var(--navbar-text-color);
      }

      .el-icon {
        font-size: 16px;
        color: var(--text-secondary);
        transition: transform 0.3s ease;
      }

      &:hover .el-icon {
        transform: translateY(2px);
      }
    }
  }
}

// 配色选择弹出框
.color-picker {
  .picker-title {
    font-size: 14px;
    font-weight: 600;
    color: var(--text-primary);
    margin-bottom: 12px;
    padding-bottom: 8px;
    border-bottom: 1px solid var(--border-color-light);
  }

  .color-list {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 8px;

    .color-item {
      display: flex;
      flex-direction: column;
      align-items: center;
      padding: 12px 8px;
      border-radius: 8px;
      cursor: pointer;
      transition: all 0.2s ease;
      position: relative;
      border: 2px solid transparent;

      &:hover {
        background: var(--bg-secondary);
      }

      &.active {
        border-color: var(--el-color-primary);
        background: var(--el-color-primary-light-9);
      }

      .color-preview {
        width: 28px;
        height: 28px;
        border-radius: 50%;
        margin-bottom: 6px;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
      }

      .color-label {
        font-size: 12px;
        color: var(--text-regular);
      }

      .color-check {
        position: absolute;
        top: 4px;
        right: 4px;
        font-size: 12px;
        color: var(--el-color-primary);
      }
    }
  }
}
</style>
