<template>
  <div v-if="!isHidden">
    <template v-if="hasOneShowingChild(item.children, item) && (!onlyOneChild?.children || onlyOneChild.noShowingChildren)">
      <el-menu-item :index="resolvePath((onlyOneChild as RouteItem).path)">
        <el-icon>
          <component :is="(onlyOneChild as RouteItem).meta?.icon || 'Menu'" />
        </el-icon>
        <template #title>
          <span>{{ (onlyOneChild as RouteItem).meta?.title }}</span>
        </template>
      </el-menu-item>
    </template>

    <el-sub-menu v-else :index="item.path">
      <template #title>
        <el-icon>
          <component :is="item.meta?.icon || 'Menu'" />
        </el-icon>
        <span>{{ item.meta?.title }}</span>
      </template>
      <sidebar-item
        v-for="child in visibleChildren"
        :key="child.path"
        :item="child"
        :base-path="resolvePath(child.path)"
      />
    </el-sub-menu>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { isExternal } from '@/utils/validate'

interface RouteItem {
  path: string
  name?: string
  meta?: {
    title?: string
    icon?: string
    type?: number
  }
  children?: RouteItem[]
  hidden?: boolean
  noShowingChildren?: boolean
}

const props = defineProps<{
  item: RouteItem
  basePath: string
}>()

const onlyOneChild = ref<RouteItem | null>(null)

// 判断是否隐藏（支持 item.hidden 或 item.meta.hidden）
const isHidden = computed(() => {
  return props.item.hidden || props.item.meta?.hidden
})

// 只显示目录和菜单类型
const visibleChildren = computed(() => {
  return (props.item.children || []).filter(
    child => !isChildHidden(child) && (child.meta?.type === 1 || child.meta?.type === 2)
  )
})

// 判断子路由是否隐藏
function isChildHidden(child: RouteItem) {
  return child.hidden || child.meta?.hidden
}

function hasOneShowingChild(children: RouteItem[] = [], parent: RouteItem) {
  const showingChildren = children.filter((item) => {
    // 只显示目录和菜单类型
    return !isChildHidden(item) && (item.meta?.type === 1 || item.meta?.type === 2)
  })

  if (showingChildren.length === 1) {
    onlyOneChild.value = showingChildren[0]
    onlyOneChild.value.path = resolvePath(showingChildren[0].path)
    return true
  }

  if (showingChildren.length === 0) {
    onlyOneChild.value = { ...parent, path: '', noShowingChildren: true } as any
    return true
  }

  return false
}

function resolvePath(routePath: string) {
  if (isExternal(routePath)) {
    return routePath
  }
  // 如果路由路径已经是绝对路径，直接使用
  if (routePath.startsWith('/')) {
    return routePath
  }
  if (isExternal(props.basePath)) {
    return props.basePath
  }
  return `${props.basePath}/${routePath}`.replace(/\/+/g, '/')
}
</script>

<style lang="scss" scoped>
// 子菜单项缩进样式
:deep(.el-sub-menu .el-menu-item) {
  padding-left: 48px !important;
}

// 二级子菜单进一步缩进
:deep(.el-sub-menu .el-sub-menu .el-menu-item) {
  padding-left: 68px !important;
}

// 折叠状态下隐藏文字
:deep(.el-menu--collapse) {
  .el-menu-item__text,
  .el-sub-menu__text {
    display: none !important;
  }

  .el-sub-menu__icon-arrow {
    display: none !important;
  }
}
</style>
