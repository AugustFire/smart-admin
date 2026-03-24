<template>
  <div class="app-wrapper" :class="classObj">
    <div v-if="device === 'mobile' && sidebar.opened" class="drawer-bg" @click="handleClickOutside" />
    <Sidebar />
    <div class="main-container">
      <div class="fixed-header">
        <Navbar />
        <TagsView />
      </div>
      <AppMain />
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useAppStore } from '@/store/modules/app'
import Sidebar from './components/Sidebar/index.vue'
import Navbar from './components/Navbar/index.vue'
import TagsView from './components/TagsView/index.vue'
import AppMain from './components/AppMain/index.vue'

const appStore = useAppStore()

const sidebar = computed(() => appStore.sidebar)
const device = computed(() => appStore.device)

const classObj = computed(() => ({
  hideSidebar: !sidebar.value.opened,
  openSidebar: sidebar.value.opened,
  mobile: device.value === 'mobile',
}))

function handleClickOutside() {
  appStore.closeSidebar()
}
</script>

<style lang="scss" scoped>
.app-wrapper {
  position: relative;
  height: 100%;
  width: 100%;

  &.openSidebar {
    position: fixed;
    top: 0;
  }
}

.drawer-bg {
  background: #000;
  opacity: 0.3;
  width: 100%;
  top: 0;
  height: 100%;
  position: absolute;
  z-index: 999;
}

.sidebar-container {
  transition: width 0.28s;
  width: var(--sidebar-width, 220px) !important;
  height: 100%;
  position: fixed;
  font-size: 0;
  top: 0;
  bottom: 0;
  left: 0;
  z-index: 1001;
  overflow: hidden;
}

.main-container {
  min-height: 100%;
  transition: margin-left 0.28s;
  margin-left: var(--sidebar-width, 220px);
  position: relative;
}

.hideSidebar {
  .sidebar-container {
    width: var(--sidebar-collapsed-width, 70px) !important;
  }

  .main-container {
    margin-left: var(--sidebar-collapsed-width, 70px);
  }
}

.mobile {
  .sidebar-container {
    transition: transform 0.28s;
    width: var(--sidebar-width, 220px) !important;
  }

  .main-container {
    margin-left: 0;
  }

  &.hideSidebar {
    .sidebar-container {
      pointer-events: none;
      transition-duration: 0.3s;
      transform: translate3d(-220px, 0, 0);
    }
  }
}

.fixed-header {
  position: fixed;
  top: 0;
  right: 0;
  z-index: 9;
  width: calc(100% - var(--sidebar-width, 220px));
  transition: width 0.28s;
}

.hideSidebar .fixed-header {
  width: calc(100% - var(--sidebar-collapsed-width, 70px));
}

.mobile .fixed-header {
  width: 100%;
}
</style>
