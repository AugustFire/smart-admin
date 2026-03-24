<template>
  <div class="sidebar-container">
    <div class="sidebar-logo-container" :class="{ 'is-collapsed': !sidebar.opened }">
      <router-link to="/" class="sidebar-logo-link">
        <img src="/vite.svg" alt="logo" class="logo" />
        <span class="title" v-if="sidebar.opened">Smart Admin</span>
      </router-link>
    </div>
    <el-scrollbar>
      <el-menu
        :default-active="activeMenu"
        :collapse="!sidebar.opened"
        :background-color="sidebarBgColor"
        :text-color="sidebarTextColor"
        :active-text-color="sidebarActiveTextColor"
        :unique-opened="false"
        :collapse-transition="true"
        mode="vertical"
        router
        class="sidebar-menu"
      >
        <sidebar-item
          v-for="route in permissionRoutes"
          :key="(route.path || route.name) as string"
          :item="route as any"
          :base-path="route.path"
        />
      </el-menu>
    </el-scrollbar>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { useAppStore } from '@/store/modules/app'
import { usePermissionStore } from '@/store/modules/permission'
import SidebarItem from './SidebarItem.vue'
import type { RouteRecordRaw } from 'vue-router'

const route = useRoute()
const appStore = useAppStore()
const permissionStore = usePermissionStore()

const sidebar = computed(() => appStore.sidebar)
const permissionRoutes = computed(() => permissionStore.routes as RouteRecordRaw[])
const activeMenu = computed(() => route.path)

const sidebarBgColor = 'var(--sidebar-bg-color)'
const sidebarTextColor = 'var(--sidebar-text-color)'
const sidebarActiveTextColor = 'var(--sidebar-active-text-color)'
</script>

<style lang="scss" scoped>
.sidebar-container {
  height: 100%;
  background: var(--sidebar-bg-gradient);
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.15);
  border-right: 1px solid var(--sidebar-border-color);

  // 在侧边栏内，汉堡按钮使用浅色
  :deep(.hamburger-color) {
    --hamburger-color: var(--sidebar-text-color);
  }

  .sidebar-logo-container {
    position: relative;
    width: 100%;
    height: var(--navbar-height);
    line-height: var(--navbar-height);
    background: var(--sidebar-logo-bg);
    text-align: center;
    overflow: hidden;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    transition: all 0.3s ease;
    border-bottom: 1px solid var(--sidebar-border-color);

    &.is-collapsed {
      background: var(--sidebar-bg-color);
    }

    .sidebar-logo-link {
      height: 100%;
      width: 100%;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 12px;
      text-decoration: none;

      .logo {
        width: 32px;
        height: 32px;
        flex-shrink: 0;
      }

      .title {
        font-size: 16px;
        color: var(--sidebar-text-color);
        font-weight: 600;
        letter-spacing: 0.5px;
        white-space: nowrap;
        transition: opacity 0.3s ease;
      }
    }
  }

  :deep(.el-scrollbar) {
    height: calc(100% - var(--navbar-height));
  }

  :deep(.el-menu) {
    border-right: none;
    background-color: transparent;
    padding: 6px 8px;
  }

  // 菜单项样式
  :deep(.el-menu-item) {
    height: 42px;
    margin: 2px 0;
    width: calc(100% - 8px);
    border-radius: 6px;
    color: var(--sidebar-text-color);
    transition: all 0.25s ease;
    padding: 0 12px !important;
    background: var(--sidebar-item-bg);
    border: 1px solid transparent;

    &:hover {
      background: var(--sidebar-hover-bg-color);
      color: var(--sidebar-text-color);
      transform: translateX(2px);
    }

    &.is-active {
      background: var(--sidebar-active-bg-color);
      color: var(--sidebar-active-text-color);
      border-left: 2px solid var(--el-color-primary);
      padding-left: 10px !important;
      box-shadow: 0 2px 8px rgba(99, 102, 241, 0.12);
    }

    // 折叠时隐藏文字
    .el-menu-item__text {
      transition: opacity 0.2s ease;
    }
  }

  // 子菜单标题样式
  :deep(.el-sub-menu__title) {
    height: 42px;
    margin: 2px 0;
    width: calc(100% - 8px);
    border-radius: 6px;
    color: var(--sidebar-text-color);
    transition: all 0.25s ease;
    padding: 0 12px !important;
    background: var(--sidebar-item-bg);
    border: 1px solid transparent;
    display: flex;
    align-items: center;
    justify-content: flex-start;
    position: relative;
    overflow: hidden;

    // 图标和文字容器
    > .el-icon {
      flex-shrink: 0;
      margin-right: 10px;
    }

    // 文字部分
    > span {
      flex: 1;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }

    &:hover {
      background: var(--sidebar-hover-bg-color);
      color: var(--sidebar-text-color);
      transform: translateX(2px);
    }
  }

  // 箭头图标样式 - 使用强选择器确保优先级
  :deep(.el-sub-menu__title .el-sub-menu__icon-arrow) {
    position: absolute !important;
    right: 12px !important;
    top: 50% !important;
    transform: translateY(-50%) rotate(0deg) !important;
    margin: 0 !important;
    left: auto !important;
    width: 14px !important;
    height: 14px !important;
    font-size: 12px !important;
    z-index: 10 !important;
    transition: transform 0.3s ease !important;
  }

  // 子菜单展开时旋转箭头
  :deep(.el-sub-menu.is-opened .el-sub-menu__title .el-sub-menu__icon-arrow) {
    transform: translateY(-50%) rotate(180deg) !important;
  }

  // 子菜单项样式
  :deep(.el-sub-menu .el-menu-item) {
    height: 38px;
    min-height: 38px;
    background: var(--sidebar-item-bg);
    margin: 2px 0;
    width: calc(100% - 8px);
    font-size: 13px;
    padding-left: 42px !important;
    border: 1px solid transparent;

    &:hover {
      background: var(--sidebar-hover-bg-color);
    }

    &.is-active {
      background: var(--sidebar-active-bg-color);
      color: var(--sidebar-active-text-color);
      border-left: 2px solid var(--el-color-primary);
    }
  }

  // 二级子菜单进一步缩进
  :deep(.el-sub-menu .el-sub-menu .el-menu-item) {
    padding-left: 68px !important;
  }

  // 折叠状态下的样式调整
  :deep(.el-menu--collapse) {
    .el-menu-item,
    .el-sub-menu__title {
      // 折叠时只显示图标
      width: 50px;
      height: 50px;
      margin: 4px 0;
      padding: 0 !important;
      display: flex;
      align-items: center;
      justify-content: center;

      .el-icon {
        margin: 0;
        font-size: 20px;
        flex-shrink: 0;
        display: flex;
        align-items: center;
        justify-content: center;
      }

      // 隐藏所有文字内容
      .el-menu-item__text,
      .el-sub-menu__text,
      span:not(.el-icon *) {
        display: none !important;
        visibility: hidden;
      }

      // 隐藏子菜单箭头
      .el-sub-menu__icon-arrow {
        display: none !important;
      }
    }

    // 子菜单展开时的处理
    .el-menu {
      .el-menu-item {
        width: calc(100% - 16px);
        height: 44px;
        margin: 4px 0;
        justify-content: flex-start;
        padding: 0 16px !important;

        .el-menu-item__text {
          display: inline;
        }
      }
    }
  }
}

// 暗黑主题下的侧边栏
html[data-theme='dark'] {
  .sidebar-container {
    // 深色主题下保持汉堡按钮可见
    :deep(.hamburger-color) {
      --hamburger-color: #c7d2fe;
    }
  }
}
</style>
