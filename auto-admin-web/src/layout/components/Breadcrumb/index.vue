<template>
  <el-breadcrumb class="app-breadcrumb" separator="/">
    <el-breadcrumb-item v-for="(item, index) in levelList" :key="item.path">
      <span
        v-if="item.redirect === 'noRedirect' || index === levelList.length - 1"
        class="no-redirect"
      >
        {{ (item.meta as any)?.title }}
      </span>
      <a v-else @click.prevent="handleLink(item)">{{ (item.meta as any)?.title }}</a>
    </el-breadcrumb-item>
  </el-breadcrumb>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { useRoute, useRouter, type RouteRecordRaw } from 'vue-router'

const route = useRoute()
const router = useRouter()

const levelList = ref<RouteRecordRaw[]>([])

function getBreadcrumb() {
  let matched = route.matched.filter((item) => item.meta && item.meta.title)
  const first = matched[0]

  if (!isDashboard(first)) {
    matched = [{ path: '/dashboard', meta: { title: '首页' } } as any, ...matched]
  }

  levelList.value = matched.filter((item) => item.meta && item.meta.title)
}

function isDashboard(route: RouteRecordRaw) {
  const name = route.name
  return name && typeof name === 'string' && name.toLowerCase() === 'dashboard'
}

function handleLink(item: RouteRecordRaw) {
  const { redirect, path } = item
  if (redirect) {
    router.push(redirect as string)
    return
  }
  router.push(path)
}

watch(
  () => route.path,
  () => {
    getBreadcrumb()
  },
  { immediate: true }
)
</script>

<style lang="scss" scoped>
.app-breadcrumb {
  display: inline-block;
  font-size: 14px;
  line-height: 1;

  .no-redirect {
    color: var(--text-secondary);
    cursor: text;
  }

  a {
    font-weight: 500;
    color: var(--text-regular);
    transition: color 0.2s ease;

    &:hover {
      color: var(--el-color-primary);
    }
  }

  :deep(.el-breadcrumb__separator) {
    color: var(--text-placeholder);
    margin: 0 8px;
  }
}
</style>
