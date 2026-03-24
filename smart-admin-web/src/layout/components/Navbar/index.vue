<template>
  <div class="navbar">
    <div class="left-menu">
      <hamburger :is-active="sidebar.opened" @toggle-click="toggleSidebar" />
      <breadcrumb />
    </div>
    <div class="right-menu">
      <el-switch
        v-model="isDark"
        inline-prompt
        active-icon="Moon"
        inactive-icon="Sunny"
        @change="toggleTheme"
      />
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
import { useAppStore } from '@/store/modules/app'
import { useUserStore } from '@/store/modules/user'
import Hamburger from '@/components/Hamburger/index.vue'
import Breadcrumb from '../Breadcrumb/index.vue'

const router = useRouter()
const appStore = useAppStore()
const userStore = useUserStore()

const sidebar = computed(() => appStore.sidebar)
const nickname = computed(() => userStore.nickname)
const avatar = computed(() => userStore.avatar)

const isDark = ref(appStore.theme === 'dark')

function toggleSidebar() {
  appStore.toggleSidebar()
}

function toggleTheme() {
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

    .el-switch {
      margin-right: 8px;

      :deep(.el-switch__core) {
        border-radius: 20px;
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
</style>
