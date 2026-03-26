<template>
  <div class="tags-view-container">
    <el-scrollbar class="tags-view-wrapper">
      <div class="tags-view-inner">
        <router-link
          v-for="tag in visitedViews"
          :key="tag.path"
          :to="{ path: tag.path, query: tag.query }"
          class="tags-view-item"
          :class="{ active: isActive(tag) }"
          @contextmenu.prevent="handleContextMenu($event, tag)"
        >
          {{ tag.title || tag.meta?.title || '未命名' }}
          <el-icon v-if="!isOnlyOneTag(tag) && !tag.affix" class="close-icon" @click.prevent.stop="closeSelectedTag(tag)">
            <Close />
          </el-icon>
        </router-link>
      </div>
    </el-scrollbar>

    <!-- 右键菜单 -->
    <div
      v-if="contextMenuVisible"
      class="context-menu"
      :style="{ left: contextMenuLeft + 'px', top: contextMenuTop + 'px' }"
      @click="closeContextMenu"
    >
      <el-menu :ellipsis="false" class="context-menu-wrapper">
        <el-menu-item index="1" @click="handleRefresh">
          <el-icon><Refresh /></el-icon>
          刷新
        </el-menu-item>
        <el-menu-item index="2" @click="handleCloseOthers">
          <el-icon><Close /></el-icon>
          关闭其他
        </el-menu-item>
        <el-menu-item index="3" @click="handleCloseLeft">
          <el-icon><DArrowLeft /></el-icon>
          关闭左侧
        </el-menu-item>
        <el-menu-item index="4" @click="handleCloseRight">
          <el-icon><DArrowRight /></el-icon>
          关闭右侧
        </el-menu-item>
        <div class="context-menu-divider" />
        <el-menu-item index="5" @click="handleCloseAll">
          <el-icon><FolderDelete /></el-icon>
          关闭所有
        </el-menu-item>
      </el-menu>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, watch, ref, onMounted, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useTagsViewStore } from '@/store/modules/tagsView'
import { Refresh, Close, DArrowLeft, DArrowRight, FolderDelete } from '@element-plus/icons-vue'

const route = useRoute()
const router = useRouter()
const tagsViewStore = useTagsViewStore()

interface TagType {
  path: string
  title?: string
  name?: string
  fullPath?: string
  affix?: boolean
  query?: any
  meta?: {
    affix?: boolean
    title?: string
  }
}

const visitedViews = computed(() => tagsViewStore.visitedViews as TagType[])

// 右键菜单相关
const contextMenuVisible = ref(false)
const contextMenuLeft = ref(0)
const contextMenuTop = ref(0)
const selectedTag = ref<TagType | null>(null)

function isActive(tag: any) {
  return tag.path === route.path
}

// 判断是否只有一个标签（非 affix 的标签）
function isOnlyOneTag(currentTag: TagType) {
  const nonAffixTags = visitedViews.value.filter(tag => !tag.affix)
  return nonAffixTags.length === 1 && currentTag.path === nonAffixTags[0]?.path
}

function handleContextMenu(e: MouseEvent, tag: TagType) {
  e.preventDefault()
  e.stopPropagation()
  selectedTag.value = tag
  contextMenuLeft.value = e.clientX
  contextMenuTop.value = e.clientY
  contextMenuVisible.value = true
}

function closeContextMenu() {
  contextMenuVisible.value = false
  selectedTag.value = null
}

function handleRefresh() {
  if (selectedTag.value) {
    router.replace({ path: selectedTag.value.path, query: selectedTag.value.query })
  }
  closeContextMenu()
}

function handleCloseOthers() {
  if (selectedTag.value) {
    tagsViewStore.delOthersViewsAsync(selectedTag.value)
    router.push(selectedTag.value.path)
  }
  closeContextMenu()
}

function handleCloseLeft() {
  if (selectedTag.value) {
    const currentIndex = visitedViews.value.findIndex(tag => tag.path === selectedTag.value!.path)
    const tagsToDelete = visitedViews.value.slice(0, currentIndex).filter(tag => !tag.affix)
    tagsToDelete.forEach(tag => tagsViewStore.delVisitedView(tag))
    router.push(selectedTag.value.path)
  }
  closeContextMenu()
}

function handleCloseRight() {
  if (selectedTag.value) {
    const currentIndex = visitedViews.value.findIndex(tag => tag.path === selectedTag.value!.path)
    const tagsToDelete = visitedViews.value.slice(currentIndex + 1).filter(tag => !tag.affix)
    tagsToDelete.forEach(tag => tagsViewStore.delVisitedView(tag))
    router.push(selectedTag.value.path)
  }
  closeContextMenu()
}

function handleCloseAll() {
  const affixTag = visitedViews.value.find(tag => tag.affix)
  tagsViewStore.delAllViewsAsync()
  if (affixTag) {
    router.push(affixTag.path)
  } else {
    router.push('/')
  }
  closeContextMenu()
}

function addTags() {
  if (route.name) {
    tagsViewStore.addView({
      ...route,
      title: route.meta.title || '未命名页面',
    })
  }
}

function closeSelectedTag(view: TagType) {
  tagsViewStore.delView(view).then(({ visitedViews }: any) => {
    if (isActive(view)) {
      toLastView(visitedViews, view)
    }
  })
}

function toLastView(visitedViews: TagType[], _view: TagType) {
  const latestView = visitedViews.slice(-1)[0]
  if (latestView) {
    router.push(latestView.path)
  } else {
    // 如果没有其他标签，跳转到 affix 标签或首页
    const affixTag = visitedViews.find((tag: TagType) => tag.affix)
    if (affixTag) {
      router.push(affixTag.path)
    } else {
      router.push('/')
    }
  }
}

// 点击页面其他地方关闭右键菜单
watch(
  () => route.path,
  () => {
    addTags()
    closeContextMenu()
  },
  { immediate: true }
)

// 监听全局点击事件，点击其他地方关闭右键菜单
onMounted(() => {
  document.addEventListener('click', closeContextMenu)
})

onUnmounted(() => {
  document.removeEventListener('click', closeContextMenu)
})
</script>

<style lang="scss" scoped>
.tags-view-container {
  height: var(--tags-height);
  width: 100%;
  background: linear-gradient(180deg, var(--tags-bg-color) 0%, #f8fafc 100%);
  border-bottom: 1px solid var(--tags-border-color);
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.04), 0 2px 8px rgba(0, 0, 0, 0.02);
  position: relative;

  // 顶部光效
  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 1px;
    background: linear-gradient(90deg, transparent 0%, rgba(254, 64, 102, 0.1) 50%, transparent 100%);
  }

  :deep(.el-scrollbar) {
    height: 100%;
    width: 100%;

    .el-scrollbar__wrap {
      overflow-x: auto;
      overflow-y: hidden;
    }

    .el-scrollbar__content {
      height: 100%;
      min-width: 100%;
      display: flex;
      align-items: stretch;
    }
  }

  .tags-view-wrapper {
    padding: 0 16px;
    display: flex;
    align-items: stretch;
    height: 100%;
    white-space: nowrap;

    .tags-view-inner {
      display: flex;
      align-items: stretch;
      gap: 0;
      height: 100%;
      width: 100%;
      padding: 8px 0;
    }

    .tags-view-item {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      position: relative;
      cursor: pointer;
      height: 100%;
      min-height: 34px;
      min-width: 90px;
      max-width: 130px;
      line-height: 1;
      border: 1px solid transparent;
      color: var(--text-regular);
      background: var(--bg-secondary);
      padding: 0 14px;
      font-size: 13px;
      border-radius: 6px;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      text-decoration: none;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      flex-shrink: 0;

      // 选中指示器（底部横条）
      &::before {
        content: '';
        position: absolute;
        bottom: 0;
        left: 50%;
        width: 0;
        height: 3px;
        background: var(--el-color-primary);
        border-radius: 3px 3px 0 0;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        transform: translateX(-50%);
      }

      &:hover {
        color: var(--el-color-primary);
        background: var(--el-color-primary-light-9);
        border-color: var(--el-color-primary-light-5);
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(254, 64, 102, 0.15);

        .close-icon {
          opacity: 1;
          transform: scale(1) rotate(0deg);
        }
      }

      &:active {
        transform: translateY(0) scale(0.98);
        box-shadow: 0 2px 6px rgba(254, 64, 102, 0.1);
      }

      &.active {
        background: var(--el-color-primary);
        color: #fff;
        border-color: var(--el-color-primary);
        font-weight: 500;
        transform: translateY(-1px);

        &::before {
          width: 100%;
          background: rgba(255, 255, 255, 0.5);
        }

        &:hover {
          background: var(--el-color-primary-light-3);
          transform: translateY(-2px);
        }

        .close-icon {
          opacity: 1;
          color: rgba(255, 255, 255, 0.9);

          &:hover {
            background-color: rgba(255, 255, 255, 0.25);
            color: #fff;
            transform: scale(1.1) rotate(90deg);
          }
        }
      }

      .close-icon {
        width: 18px;
        height: 18px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        margin-left: 6px;
        border-radius: 50%;
        transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
        font-size: 11px;
        flex-shrink: 0;
        opacity: 0.6;
        transform: scale(0.9);

        &:hover {
          background-color: rgba(0, 0, 0, 0.08);
          color: var(--text-primary);
          transform: scale(1.1) rotate(90deg);
        }
      }
    }
  }

  // 右键菜单样式
  .context-menu {
    position: fixed;
    z-index: 9999;
    background: #fff;
    border-radius: 8px;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
    padding: 4px 0;
    min-width: 140px;

    .context-menu-wrapper {
      border: none;
      background: transparent;

      .el-menu-item {
        height: 36px;
        line-height: 36px;
        font-size: 13px;
        padding: 0 16px;
        display: flex;
        align-items: center;
        gap: 8px;

        &:hover {
          background-color: #f5f7fa;
        }

        .el-icon {
          font-size: 14px;
        }
      }

      .context-menu-divider {
        height: 1px;
        background-color: #ebeef5;
        margin: 4px 0;
      }
    }
  }
}

// 暗黑主题
html[data-theme='dark'] {
  .tags-view-container {
    background: linear-gradient(180deg, var(--tags-bg-color) 0%, #1e293b 100%);
    box-shadow: 0 1px 4px rgba(0, 0, 0, 0.15), 0 2px 8px rgba(0, 0, 0, 0.1);

    &::before {
      background: linear-gradient(90deg, transparent 0%, rgba(254, 64, 102, 0.15) 50%, transparent 100%);
    }

    .tags-view-wrapper {
      .tags-view-item {
        background: rgba(255, 255, 255, 0.03);
        border-color: rgba(255, 255, 255, 0.05);

        &:hover {
          background: rgba(254, 64, 102, 0.15);
          border-color: rgba(254, 64, 102, 0.3);
          box-shadow: 0 4px 12px rgba(254, 64, 102, 0.2);
        }

        &.active {
          background: var(--el-color-primary);
          border-color: var(--el-color-primary);

          &:hover {
            background: var(--el-color-primary-light-3);
          }
        }
      }
    }

    // 暗黑主题下的右键菜单
    .context-menu {
      background: #1e293b;
      box-shadow: 0 4px 16px rgba(0, 0, 0, 0.3);

      .context-menu-wrapper {
        .el-menu-item {
          &:hover {
            background-color: #334155;
          }
        }

        .el-menu-divider {
          background-color: #475569;
        }
      }
    }
  }
}
</style>
