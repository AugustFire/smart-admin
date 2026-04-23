<template>
  <div class="text-collection-container">
    <!-- 左侧边栏：文本列表 -->
    <aside class="sidebar" :style="{ width: sidebarWidth + 'px' }">
      <!-- 头部 -->
      <div class="sidebar-header">
        <span class="sidebar-title">文本库</span>
        <el-button type="primary" size="small" @click="handleNewText">
          <el-icon><Plus /></el-icon>
          新建
        </el-button>
      </div>

      <!-- 搜索 -->
      <div class="sidebar-search-wrapper">
        <el-input v-model="searchKeyword" placeholder="搜索..." size="small" clearable>
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
      </div>

      <!-- 分类筛选标签 -->
      <div class="category-tabs">
        <div class="category-tabs-scroll">
          <span
            class="category-tab"
            :class="{ active: !currentCategoryId }"
            @click="currentCategoryId = null"
          >
            全部
          </span>
          <span
            v-for="cat in flatCategories"
            :key="cat.id"
            class="category-tab"
            :class="{ active: currentCategoryId === cat.id }"
            @click="currentCategoryId = cat.id"
          >
            <span v-if="editingCategoryId !== cat.id" @click.stop="currentCategoryId = cat.id">{{ cat.name }}</span>
            <span v-else class="category-tab-edit-wrapper" @click.stop>
              <el-input
                v-model="editingCategoryName"
                size="small"
                class="category-tab-edit-input"
                @keyup.enter="saveCategoryEdit(cat)"
                @blur="saveCategoryEdit(cat)"
                ref="categoryEditInputRef"
                autofocus
              />
            </span>
            <el-icon class="category-tab-edit" @click.stop="startCategoryEdit(cat)"><Edit /></el-icon>
            <el-icon class="category-tab-delete" @click.stop="handleDeleteCategory(cat)"><Close /></el-icon>
          </span>
          <span class="category-tab category-tab-add" @click="showCategoryInput = true" v-if="!showCategoryInput">
            <el-icon><Plus /></el-icon>
          </span>
        </div>
        <!-- 新建分类输入 -->
        <div v-if="showCategoryInput" class="category-add-input">
          <el-input
            v-model="newCategoryName"
            placeholder="输入分类名"
            size="small"
            @keyup.enter="handleAddCategory"
            @blur="handleCategoryInputBlur"
            ref="categoryInputRef"
          />
        </div>
      </div>

      <!-- 文本列表 -->
      <div class="text-list" v-loading="loading">
        <div
          v-for="text in filteredTexts"
          :key="text.id"
          class="text-item"
          :class="{ active: currentTextId === text.id }"
          @click="handleSelectText(text)"
        >
          <div class="text-item-icon">
            <el-icon><Document /></el-icon>
          </div>
          <div class="text-item-content">
            <div class="text-item-title">{{ text.title || '无标题' }}</div>
            <div class="text-item-meta">
              <el-tag v-if="getCategoryName(text.categoryId)" size="small">{{ getCategoryName(text.categoryId) }}</el-tag>
              <span class="text-item-date">{{ formatDate(text.updateTime) }}</span>
            </div>
          </div>
          <el-button link type="danger" size="small" class="text-item-delete" @click.stop="handleDeleteText(text)">
            <el-icon><Delete /></el-icon>
          </el-button>
        </div>
        <div v-if="filteredTexts.length === 0" class="text-list-empty">
          <p class="text-list-empty-text">暂无文本</p>
          <el-button type="primary" size="small" @click="handleNewText">
            <el-icon><Plus /></el-icon>
            新建文本
          </el-button>
        </div>
      </div>
    </aside>

    <!-- 侧边栏调整拖柄 -->
    <div class="sidebar-resize-handle" @mousedown="startSidebarResize"></div>

    <!-- 右侧主区域：编辑器 -->
    <main class="main-content">
      <!-- 顶部工具栏 -->
      <div class="top-toolbar">
        <div class="toolbar-left">
          <span v-show="editingTitle" class="current-title-edit-wrapper">
            <el-input
              v-model="editingTitleValue"
              size="small"
              class="current-title-input"
              placeholder="输入文件名"
              @keyup.enter="saveTitleEdit"
              @blur="saveTitleEdit"
              ref="toolbarTitleInputRef"
              autofocus
            />
          </span>
          <span v-show="!editingTitle" class="current-title editable" @click="startTitleEdit">
            {{ currentTitle || '未命名' }}
          </span>
          <el-select
            v-model="textCategoryId"
            placeholder="选择分类"
            size="small"
            clearable
            class="category-select"
          >
            <el-option
              v-for="cat in flatCategories"
              :key="cat.id"
              :label="cat.name"
              :value="cat.id"
            />
          </el-select>
        </div>
        <div class="toolbar-right">
          <el-tooltip content="自动保存" placement="top" effect="light">
            <el-button :type="autoSaveEnabled ? 'primary' : 'default'" circle size="small" @click="toggleAutoSave">
              <el-icon><Timer /></el-icon>
            </el-button>
          </el-tooltip>
          <span v-if="lastSavedAt" class="auto-save-indicator">
            <span class="save-dot" :class="{ saving: isAutoSaving }"></span>
            {{ isAutoSaving ? '保存中...' : `已保存 ${lastSavedAt}` }}
          </span>
          <el-button type="primary" size="small" @click="handleSave" :disabled="!currentContent.trim()" :loading="saving">
            <el-icon><Document /></el-icon>
            保存
          </el-button>
          <el-divider direction="vertical" />
          <div class="view-mode-switch">
            <el-tooltip content="仅编辑" placement="top" effect="light">
              <el-button :type="editorMode === 'edit' ? 'primary' : 'default'" @click="editorMode = 'edit'">
                <el-icon><Edit /></el-icon>
              </el-button>
            </el-tooltip>
            <el-tooltip content="并排显示" placement="top" effect="light">
              <el-button :type="editorMode === 'split' ? 'primary' : 'default'" @click="editorMode = 'split'">
                <el-icon><Histogram /></el-icon>
              </el-button>
            </el-tooltip>
            <el-tooltip content="仅预览" placement="top" effect="light">
              <el-button :type="editorMode === 'preview' ? 'primary' : 'default'" @click="editorMode = 'preview'">
                <el-icon><View /></el-icon>
              </el-button>
            </el-tooltip>
          </div>
        </div>
      </div>

      <!-- 编辑器和预览 -->
      <div class="editor-wrapper">
        <div v-if="!currentTextId && !currentContent.trim() && !isCreatingNew" class="editor-empty">
          <div class="editor-empty-icon">
            <el-icon><Document /></el-icon>
          </div>
          <p class="editor-empty-text">选择一个文本或点击新建开始编辑</p>
          <el-button type="primary" @click="handleNewText">
            <el-icon><Plus /></el-icon>
            新建文本
          </el-button>
        </div>
        <template v-else>
        <div v-show="editorMode !== 'preview'" class="editor-pane" :style="editorPaneStyle">
          <MdEditor
            ref="editorRef"
            v-model="currentContent"
            :editor-id="editorId"
            :preview="false"
            :theme="themeStore.isDark ? 'dark' : 'light'"
            :toolbars="toolbars"
            placeholder="输入提示词文本，支持 Markdown 格式..."
            @save="handleSave"
          />
        </div>
        <div v-show="editorMode === 'split'" class="resize-handle" @mousedown="startResize"></div>
        <div v-show="editorMode !== 'edit'" class="preview-pane" :style="previewPaneStyle">
          <div class="preview-toolbar">
            <span class="preview-label">预览</span>
          </div>
          <div class="preview-scroll-container" :class="{ 'preview-mode': editorMode === 'preview' }">
            <MdPreview
              ref="previewRef"
              :model-value="currentContent"
              :editor-id="editorId"
              :theme="themeStore.isDark ? 'dark' : 'light'"
            />
          </div>
        </div>
        </template>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, onUnmounted, nextTick } from 'vue'
import { useThemeStore } from '@/store/modules/theme'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Delete, Search, Document, Histogram, View, Edit, Timer, Close, EditPen } from '@element-plus/icons-vue'
import { MdEditor, MdPreview } from 'md-editor-v3'
import type { ToolbarNames } from 'md-editor-v3'
import 'md-editor-v3/lib/style.css'
import 'md-editor-v3/lib/preview.css'
import { formatTags } from '@/utils/tag'
import dayjs from 'dayjs'
import type { TextCollectionItem, TextCategory } from '@/api/lifestyle/text-collection'
import {
  getTextCollectionPageApi,
  getTextCategoryFlatApi,
  addTextCollectionApi,
  updateTextCollectionApi,
  deleteTextCollectionApi,
  addTextCategoryApi,
  updateTextCategoryApi,
  deleteTextCategoryApi,
  type TextCollectionAddReq,
  type TextCollectionUpdateReq,
  type TextCategoryAddReq,
  type TextCollectionPageQueryReq,
} from '@/api/lifestyle/text-collection'

const editorId = 'text-collection-editor'
const themeStore = useThemeStore()

const searchKeyword = ref('')
const newCategoryName = ref('')
const showCategoryInput = ref(false)
const categoryInputRef = ref()
const autoSaveEnabled = ref(false)

const currentTextId = ref<number | null>(null)
const currentTitle = ref('')
const currentContent = ref('')
const isCreatingNew = ref(false)
const currentCategoryId = ref<number | null>(null) // 侧边栏筛选用
const textCategoryId = ref<number | null>(null) // 当前文本的分类
const currentTags = ref<string[]>([])

const texts = ref<TextCollectionItem[]>([])
const categories = ref<TextCategory[]>([])
const lastSavedAt = ref('')
const isAutoSaving = ref(false)
const editorMode = ref<'edit' | 'split' | 'preview'>('split')
const splitRatio = ref(50)
const editorRef = ref<InstanceType<typeof MdEditor>>()
const previewRef = ref<InstanceType<typeof MdPreview>>()
const loading = ref(false)
const saving = ref(false)
let isResizing = false
let isSidebarResizing = false
let autoSaveTimer: ReturnType<typeof setTimeout> | null = null
const sidebarWidth = ref(300)
const minSidebarWidth = 200
const maxSidebarWidth = 500

// 标题编辑状态
const editingTitleValue = ref('')
const titleInputRef = ref()

// 顶部工具栏标题编辑状态
const editingTitle = ref(false)
const toolbarTitleInputRef = ref()

// 分类编辑状态
const editingCategoryId = ref<number | null>(null)
const editingCategoryName = ref('')
const categoryEditInputRef = ref()

const toolbars: ToolbarNames[] = [
  'bold',
  'italic',
  'strikeThrough',
  'title',
  'sub',
  'sup',
  'quote',
  'unorderedList',
  'orderedList',
  'task',
  'codeRow',
  'code',
  'link',
  'image',
  'table',
  'mermaid',
  'katex',
  'revoke',
  'next',
  'splitLine',
  'format',
]

const filteredTexts = computed(() => {
  let result = texts.value
  if (currentCategoryId.value) {
    result = result.filter(t => t.categoryId === currentCategoryId.value)
  }
  if (searchKeyword.value) {
    const kw = searchKeyword.value.toLowerCase()
    result = result.filter(t =>
      t.title.toLowerCase().includes(kw) ||
      t.content.toLowerCase().includes(kw)
    )
  }
  return result
})

const flatCategories = computed(() => {
  // API returns flat list directly
  return categories.value
})

const editorPaneStyle = computed(() => {
  if (editorMode.value === 'edit') return { width: '100%' }
  if (editorMode.value === 'preview') return { width: '0', overflow: 'hidden' }
  return { width: `${splitRatio.value}%` }
})

const previewPaneStyle = computed(() => {
  if (editorMode.value === 'preview') return { width: '100%' }
  if (editorMode.value === 'edit') return { width: '0', overflow: 'hidden' }
  return { width: `${100 - splitRatio.value}%` }
})

function startResize(e: MouseEvent) {
  isResizing = true
  document.addEventListener('mousemove', doResize)
  document.addEventListener('mouseup', stopResize)
  e.preventDefault()
  // 防止拖拽时选中文本
  document.body.style.userSelect = 'none'
}

function doResize(e: MouseEvent) {
  if (!isResizing) return
  const wrapper = document.querySelector('.editor-wrapper') as HTMLElement
  if (!wrapper) return
  const rect = wrapper.getBoundingClientRect()
  const ratio = ((e.clientX - rect.left) / rect.width) * 100
  splitRatio.value = Math.min(Math.max(ratio, 20), 80)
}

function stopResize() {
  isResizing = false
  document.removeEventListener('mousemove', doResize)
  document.removeEventListener('mouseup', stopResize)
  document.body.style.userSelect = ''
}

function startSidebarResize(e: MouseEvent) {
  isSidebarResizing = true
  document.addEventListener('mousemove', doSidebarResize)
  document.addEventListener('mouseup', stopSidebarResize)
  e.preventDefault()
  // 防止拖拽时选中文本
  document.body.style.userSelect = 'none'
}

function doSidebarResize(e: MouseEvent) {
  if (!isSidebarResizing) return
  const container = document.querySelector('.text-collection-container') as HTMLElement
  if (!container) return
  const rect = container.getBoundingClientRect()
  const newWidth = e.clientX - rect.left
  sidebarWidth.value = Math.min(Math.max(newWidth, minSidebarWidth), maxSidebarWidth)
}

function stopSidebarResize() {
  isSidebarResizing = false
  document.removeEventListener('mousemove', doSidebarResize)
  document.removeEventListener('mouseup', stopSidebarResize)
  document.body.style.userSelect = ''
}

// 编辑器和预览滚动同步
let scrollSyncCleanupFn: (() => void) | null = null

function setupScrollSync() {
  // 先清理之前的监听器，避免内存泄漏
  if (scrollSyncCleanupFn) {
    scrollSyncCleanupFn()
    scrollSyncCleanupFn = null
  }

  if (editorMode.value !== 'split') return

  const editorEl = editorRef.value?.$el as HTMLElement
  const previewEl = previewRef.value?.$el as HTMLElement

  if (!editorEl || !previewEl) return

  // CodeMirror 的滚动容器是 .cm-scroller
  const editorScroller = editorEl.querySelector('.cm-scroller') as HTMLElement
  // 预览的滚动容器向上查找 .preview-scroll-container
  const previewScroller = previewEl.closest('.preview-scroll-container') as HTMLElement

  if (!editorScroller || !previewScroller) return

  let isScrolling = false

  const syncScroll = (source: HTMLElement, target: HTMLElement) => {
    if (isScrolling) return
    isScrolling = true

    requestAnimationFrame(() => {
      const sourceScrollable = source.scrollHeight - source.clientHeight
      const sourceRatio = source.scrollTop / (sourceScrollable || 1)

      // Clamp ratio between 0 and 1
      const clampedRatio = Math.max(0, Math.min(1, sourceRatio))

      if (clampedRatio >= 0.99) {
        target.scrollTop = target.scrollHeight - target.clientHeight
      } else if (clampedRatio <= 0.01) {
        target.scrollTop = 0
      } else {
        const targetScrollable = target.scrollHeight - target.clientHeight
        target.scrollTop = clampedRatio * targetScrollable
      }
      isScrolling = false
    })
  }

  const editorHandler = () => {
    if (editorMode.value === 'split') {
      syncScroll(editorScroller, previewScroller)
    }
  }

  const previewHandler = () => {
    if (editorMode.value === 'split') {
      syncScroll(previewScroller, editorScroller)
    }
  }

  editorScroller.addEventListener('scroll', editorHandler, { passive: true })
  previewScroller.addEventListener('scroll', previewHandler, { passive: true })

  scrollSyncCleanupFn = () => {
    editorScroller?.removeEventListener('scroll', editorHandler)
    previewScroller?.removeEventListener('scroll', previewHandler)
  }
}

function getTextTags(text: TextCollectionItem): string[] {
  return formatTags(text.tags)
}

function getCategoryName(categoryId?: number) {
  if (!categoryId) return ''
  const findCategory = (cats: TextCategory[]): TextCategory | undefined => {
    for (const cat of cats) {
      if (cat.id === categoryId) return cat
      if (cat.children) {
        const found = findCategory(cat.children)
        if (found) return found
      }
    }
  }
  return findCategory(categories.value)?.name || ''
}

function formatDate(dateStr: string | undefined) {
  if (!dateStr) return ''
  return dayjs(dateStr).format('MM-DD HH:mm')
}

async function handleAddCategory() {
  const name = newCategoryName.value.trim()
  if (!name) return

  try {
    await addTextCategoryApi({ name } as TextCategoryAddReq)
    await loadCategories()
    newCategoryName.value = ''
    showCategoryInput.value = false
    ElMessage.success('分类已创建')
  } catch (e) {
    console.error(e)
  }
}

function handleCategoryInputBlur() {
  if (!newCategoryName.value.trim()) {
    showCategoryInput.value = false
  }
}

async function handleDeleteCategory(data: TextCategory) {
  ElMessageBox.confirm(`确认删除分类「${data.name}」吗？该分类下的文本将变为无分类。`, '删除确认', {
    confirmButtonText: '删除',
    cancelButtonText: '取消',
    type: 'warning',
    confirmButtonClass: 'el-button--danger',
  }).then(async () => {
    try {
      await deleteTextCategoryApi(data.id)
      await loadCategories()
      if (currentCategoryId.value === data.id) {
        currentCategoryId.value = null
      }
      ElMessage.success('删除成功')
    } catch (e) {
      console.error(e)
    }
  }).catch(() => {})
}

function startCategoryEdit(cat: TextCategory) {
  editingCategoryId.value = cat.id
  editingCategoryName.value = cat.name
  nextTick(() => {
    categoryEditInputRef.value?.focus()
  })
}

async function saveCategoryEdit(cat: TextCategory) {
  if (!editingCategoryId.value) return
  const name = editingCategoryName.value.trim()
  if (!name) {
    editingCategoryId.value = null
    return
  }
  try {
    await updateTextCategoryApi({ id: cat.id, name })
    await loadCategories()
    editingCategoryId.value = null
    ElMessage.success('分类已更新')
  } catch (e) {
    console.error(e)
  }
}

function toggleAutoSave() {
  autoSaveEnabled.value = !autoSaveEnabled.value
  if (!autoSaveEnabled.value && autoSaveTimer) {
    clearTimeout(autoSaveTimer)
    autoSaveTimer = null
  }
}

function handleNewText() {
  isCreatingNew.value = true
  currentTextId.value = null
  currentTitle.value = ''
  currentContent.value = ''
  currentTags.value = []
  textCategoryId.value = currentCategoryId.value
  // 新建时立即进入标题编辑模式
  nextTick(() => {
    editingTitle.value = true
    editingTitleValue.value = ''
    toolbarTitleInputRef.value?.focus()
  })
}

function handleSelectText(text: TextCollectionItem) {
  isCreatingNew.value = false
  currentTextId.value = text.id
  currentTitle.value = text.title
  currentContent.value = text.content
  textCategoryId.value = text.categoryId || null
  currentTags.value = getTextTags(text)
}

function startTitleEdit() {
  editingTitle.value = true
  editingTitleValue.value = currentTitle.value || ''
  nextTick(() => {
    toolbarTitleInputRef.value?.focus()
  })
}

function saveTitleEdit() {
  if (editingTitle.value) {
    // 保存顶部工具栏标题
    editingTitle.value = false
    currentTitle.value = editingTitleValue.value.trim() || '无标题'
    if (currentTextId.value) {
      updateTextCollectionApi({
        id: currentTextId.value,
        title: currentTitle.value,
        content: currentContent.value,
        categoryId: textCategoryId.value,
        tags: currentTags.value.join(','),
      } as TextCollectionUpdateReq).catch(() => {
        ElMessage.error('标题保存失败')
      })
    }
    editingTitleValue.value = ''
  }
}

async function handleSave() {
  if (!currentContent.value.trim()) {
    ElMessage.warning('内容不能为空')
    return
  }

  saving.value = true
  try {
    if (currentTextId.value) {
      await updateTextCollectionApi({
        id: currentTextId.value,
        title: currentTitle.value,
        content: currentContent.value,
        categoryId: textCategoryId.value,
        tags: currentTags.value.join(','),
      } as TextCollectionUpdateReq)
    } else {
      const res = await addTextCollectionApi({
        title: currentTitle.value || '无标题',
        content: currentContent.value,
        categoryId: textCategoryId.value,
        tags: currentTags.value.join(','),
      } as TextCollectionAddReq)
      currentTextId.value = res.data
      isCreatingNew.value = false
    }
    await loadTexts()
    ElMessage.success('保存成功')
  } catch (e) {
    console.error(e)
    ElMessage.error('保存失败')
  } finally {
    saving.value = false
  }
}

// 自动保存（防抖 30 秒）
function triggerAutoSave() {
  if (autoSaveTimer) clearTimeout(autoSaveTimer)
  if (!currentContent.value.trim()) return

  autoSaveTimer = setTimeout(async () => {
    if (!currentContent.value.trim()) return

    isAutoSaving.value = true

    try {
      if (currentTextId.value) {
        await updateTextCollectionApi({
          id: currentTextId.value,
          title: currentTitle.value,
          content: currentContent.value,
          categoryId: textCategoryId.value,
          tags: currentTags.value.join(','),
        } as TextCollectionUpdateReq)
      } else {
        const res = await addTextCollectionApi({
          title: currentTitle.value || '无标题',
          content: currentContent.value,
          categoryId: textCategoryId.value,
          tags: currentTags.value.join(','),
        } as TextCollectionAddReq)
        currentTextId.value = res.data
        isCreatingNew.value = false
      }
      lastSavedAt.value = '刚刚'
      await loadTexts()
    } catch (e) {
      console.error(e)
      ElMessage.error('自动保存失败，请手动保存')
    } finally {
      isAutoSaving.value = false
    }

    // 2分钟后清除提示
    setTimeout(() => {
      if (lastSavedAt.value === '刚刚') {
        lastSavedAt.value = formatLastSaveTime(new Date())
      }
    }, 120000)
  }, 30000)
}

function formatLastSaveTime(date: Date) {
  const now = new Date()
  const diff = Math.floor((now.getTime() - date.getTime()) / 1000)
  if (diff < 60) return '刚刚'
  if (diff < 3600) return `${Math.floor(diff / 60)} 分钟前`
  return dayjs(date).format('HH:mm')
}

async function handleDeleteText(text: TextCollectionItem) {
  ElMessageBox.confirm(`确认删除「${text.title || '无标题'}」吗？删除后不可恢复。`, '删除确认', {
    confirmButtonText: '删除',
    cancelButtonText: '取消',
    type: 'warning',
    confirmButtonClass: 'el-button--danger',
  }).then(async () => {
    try {
      await deleteTextCollectionApi(text.id)
      await loadTexts()
      if (currentTextId.value === text.id) {
        isCreatingNew.value = false
        currentTextId.value = null
        currentTitle.value = ''
        currentContent.value = ''
      }
      ElMessage.success('删除成功')
    } catch (e) {
      console.error(e)
    }
  }).catch(() => {})
}

async function loadTexts() {
  loading.value = true
  try {
    const params: TextCollectionPageQueryReq = {}
    if (currentCategoryId.value) {
      params.categoryId = currentCategoryId.value
    }
    if (searchKeyword.value) {
      params.keyword = searchKeyword.value
    }
    const res = await getTextCollectionPageApi(params)
    texts.value = res.data.list || []
  } catch (e) {
    console.error(e)
  } finally {
    loading.value = false
  }
}

async function loadCategories() {
  try {
    const res = await getTextCategoryFlatApi()
    categories.value = res.data || []
  } catch (e) {
    console.error(e)
  }
}

// 监听内容变化触发自动保存
watch([currentContent, currentTitle], () => {
  if (autoSaveEnabled.value) {
    triggerAutoSave()
  }
})

onMounted(async () => {
  await Promise.all([loadTexts(), loadCategories()])
  // 使用 nextTick 确保 DOM 已完全渲染后再设置滚动同步
  nextTick(() => {
    setTimeout(() => {
      setupScrollSync()
    }, 100)
  })
})

// 监听模式切换，重新设置滚动同步
watch(editorMode, () => {
  nextTick(() => {
    setTimeout(() => {
      setupScrollSync()
    }, 100)
  })
})

// 监听内容变化，重新设置滚动同步
watch(currentContent, () => {
  nextTick(() => {
    setTimeout(() => {
      if (editorMode.value === 'split') {
        setupScrollSync()
      }
    }, 100)
  })
})

onUnmounted(() => {
  if (autoSaveTimer) {
    clearTimeout(autoSaveTimer)
    autoSaveTimer = null
  }
  if (scrollSyncCleanupFn) {
    scrollSyncCleanupFn()
    scrollSyncCleanupFn = null
  }
})
</script>

<style lang="scss" scoped>
.text-collection-container {
  display: flex;
  height: calc(100vh - 84px);
  background: var(--app-main-bg-color);
  overflow: hidden;
}

// 左侧边栏
.sidebar {
  flex-shrink: 0;
  background: var(--bg-primary);
  border-right: 1px solid var(--border-color);
  display: flex;
  flex-direction: column;
  overflow: hidden;
  min-width: 200px;
  max-width: 500px;
}

.sidebar-resize-handle {
  width: 4px;
  cursor: col-resize;
  background: transparent;
  transition: background 0.2s ease;
  flex-shrink: 0;

  &:hover {
    background: var(--el-color-primary);
  }
}

.sidebar-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px;
  border-bottom: 1px solid var(--border-color);

  .sidebar-title {
    font-size: 15px;
    font-weight: 600;
    color: var(--text-primary);
  }
}

.sidebar-search-wrapper {
  padding: 12px 16px;
  border-bottom: 1px solid var(--border-color);
}

.category-tabs {
  padding: 8px 16px;
  border-bottom: 1px solid var(--border-color);
}

.category-tabs-scroll {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}

.category-tab {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  padding: 4px 10px;
  border-radius: 16px;
  font-size: 12px;
  color: var(--text-secondary);
  background: var(--bg-secondary);
  cursor: pointer;
  transition: all 0.15s ease;
  outline: none;

  &:focus-visible {
    box-shadow: 0 0 0 2px var(--el-color-primary);
  }

  &:hover {
    background: var(--el-color-primary-light-9);
    color: var(--el-color-primary);
  }

  &.active {
    background: var(--el-color-primary);
    color: var(--bg-primary);
  }

  &-add {
    border: 1px dashed var(--border-color);
    background: transparent;

    &:hover {
      border-color: var(--el-color-primary);
      color: var(--el-color-primary);
    }
  }

  &-delete {
    font-size: 12px;
    margin-left: 2px;
    opacity: 0.5;
    cursor: pointer;
    padding: 2px;
    border-radius: 4px;
    transition: all 0.15s;

    &:hover {
      opacity: 1;
      color: var(--el-color-danger);
      background: var(--el-color-danger-light-9);
    }
  }

  &-edit {
    font-size: 12px;
    margin-left: 2px;
    opacity: 0.5;
    cursor: pointer;
    padding: 2px;
    border-radius: 4px;
    transition: all 0.15s;

    &:hover {
      opacity: 1;
      color: var(--el-color-primary);
      background: var(--el-color-primary-light-9);
    }
  }

  &-edit-wrapper {
    display: inline-flex;
    align-items: center;
  }

  &-edit-input {
    width: 80px;

    :deep(.el-input__wrapper) {
      padding: 2px 8px;
      border-radius: 12px;
    }

    :deep(.el-input__inner) {
      font-size: 12px;
    }
  }
}

.category-add-input {
  margin-top: 8px;

  :deep(.el-input__wrapper) {
    border-radius: 16px;
  }
}

.text-list {
  flex: 1;
  overflow-y: auto;
  padding: 8px;

  &::-webkit-scrollbar {
    width: 6px;
  }

  &::-webkit-scrollbar-thumb {
    background: var(--border-color);
    border-radius: 3px;
  }

  &::-webkit-scrollbar-track {
    background: transparent;
  }
}

.text-list-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
  padding: 40px 20px;
  color: var(--text-secondary);

  .text-list-empty-text {
    font-size: 13px;
    margin: 0;
  }
}

.text-item {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  padding: 12px;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.15s ease;
  margin-bottom: 4px;
  border: 1px solid transparent;
  outline: none;

  &:focus-visible {
    box-shadow: 0 0 0 2px var(--el-color-primary);
  }

  &:hover {
    background: var(--bg-secondary);

    .text-item-delete {
      opacity: 1;
    }
  }

  &.active {
    background: var(--el-color-primary-light-9);
    border-color: var(--el-color-primary-light-5);
  }

  html[data-theme='dark'] &.active {
    background: rgba(254, 64, 102, 0.15);
    border-color: rgba(254, 64, 102, 0.3);
  }
}

.text-item-icon {
  font-size: 18px;
  color: var(--el-color-primary);
  flex-shrink: 0;
  margin-top: 2px;
}

.text-item-content {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.text-item-title {
  font-size: 13px;
  font-weight: 500;
  color: var(--text-primary);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  cursor: text;

  &:hover {
    color: var(--el-color-primary);
  }
}

.text-item-title-edit {
  :deep(.el-input__wrapper) {
    padding: 2px 8px;
  }

  :deep(.el-input__inner) {
    font-size: 13px;
    font-weight: 500;
  }
}

.text-item-meta {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 11px;
  color: var(--text-secondary);

  :deep(.el-tag) {
    border-radius: 4px;
    padding: 0 4px;
    height: 16px;
    line-height: 14px;
  }
}

.text-item-date {
  opacity: 0.6;
}

.text-item-delete {
  opacity: 0;
  flex-shrink: 0;
  transition: opacity 0.15s ease;
}

// 右侧主区域
.main-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-width: 0;
  overflow: hidden;
}

// 顶部工具栏
.top-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  background: var(--bg-primary);
  border-bottom: 1px solid var(--border-color);
  gap: 12px;
  flex-shrink: 0;

  .toolbar-left {
    display: flex;
    align-items: center;
    gap: 12px;
    flex: 1;
    min-width: 0;

    .current-title {
      font-size: 16px;
      font-weight: 600;
      color: var(--text-primary);
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;

      &.editable {
        cursor: text;
        padding: 4px 8px;
        border-radius: 4px;
        transition: background 0.2s;

        &:hover {
          background: var(--el-color-primary-light-9);
          color: var(--el-color-primary);
        }
      }
    }

    .current-title-edit-wrapper {
      display: flex;
      align-items: center;
    }

    .current-title-input {
      width: 200px;

      :deep(.el-input__wrapper) {
        padding: 4px 8px;
        border-radius: 4px;
      }

      :deep(.el-input__inner) {
        font-size: 16px;
        font-weight: 600;
      }
    }
  }

  .category-select {
    width: 140px;
    margin-left: 12px;
  }

  .toolbar-right {
    display: flex;
    align-items: center;
    gap: 8px;
    flex-shrink: 0;
  }
}

.view-mode-switch {
  display: flex;
  align-items: center;
  gap: 0;

  :deep(.el-tooltip) {
    display: flex;
  }

  :deep(.el-button) {
    border: 1px solid var(--border-color);
    border-radius: 0;
    padding: 6px 12px;
    margin-left: -1px;

    &:first-child {
      border-radius: 6px 0 0 6px;
    }

    &:last-child {
      border-radius: 0 6px 6px 0;
    }

    &:hover {
      background: var(--el-color-primary-light-9);
      z-index: 1;
      position: relative;
    }

    &.el-button--primary {
      background: var(--el-color-primary);
      border-color: var(--el-color-primary);
      color: #fff;
      z-index: 1;
    }
  }
}

.auto-save-indicator {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 12px;
  color: var(--text-secondary);

  .save-dot {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background: var(--el-color-success);

    &.saving {
      background: var(--el-color-primary);
      animation: pulse 1s infinite;
    }
  }
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}

.editor-wrapper {
  flex: 1;
  display: flex;
  gap: 0;
  background: var(--bg-primary);
  border-radius: var(--card-radius);
  border: 1px solid var(--border-color);
  border-top: none;
  overflow: hidden;
  min-height: 0;
}

.editor-pane,
.preview-pane {
  display: flex;
  flex-direction: column;
  height: 100%;
  transition: width 0.3s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.3s ease;
  overflow: hidden;
  opacity: 1;
}

.preview-toolbar {
  padding: 8px 16px;
  border-bottom: 1px solid var(--border-color-light);
  background: var(--bg-secondary);
  border-left: 3px solid var(--el-color-primary-light-5);
  flex-shrink: 0;
  height: 40px;
  box-sizing: border-box;
  display: flex;
  align-items: center;

  .preview-label {
    font-size: 12px;
    color: var(--text-secondary);
    font-weight: 500;
  }
}

.editor-pane {
  :deep(.md-editor) {
    flex: 1;
    height: 100%;
    background-color: var(--bg-primary);
    border-color: var(--border-color);
    color: var(--text-primary);
    transition: background-color 0.3s ease, border-color 0.3s ease, color 0.3s ease;

    .md-editor-toolbar-wrapper {
      height: 40px;
      box-sizing: border-box;
      background: var(--bg-secondary);
      border-color: var(--border-color);
      transition: background-color 0.3s ease, border-color 0.3s ease;

      .md-editor-toolbar {
        color: var(--text-regular);
        transition: color 0.3s ease;
      }
    }

    .md-editor-main {
      flex: 1;
      overflow-y: auto;
      background: var(--bg-primary);
      transition: background-color 0.3s ease;

      .cm-editor {
        background-color: var(--bg-primary) !important;
        transition: background-color 0.3s ease;
      }

      .cm-scroller {
        background-color: var(--bg-primary) !important;
        transition: background-color 0.3s ease;
      }

      .cm-content {
        color: var(--text-primary) !important;
        caret-color: var(--text-primary);
        transition: color 0.3s ease;
      }
    }

    .md-editor-input {
      background: var(--bg-primary);
      color: var(--text-primary);
    }
  }
}

.editor-empty {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 16px;
  color: var(--text-secondary);

  .editor-empty-icon {
    font-size: 48px;
    color: var(--el-color-primary-light-5);
  }

  .editor-empty-text {
    font-size: 14px;
    margin: 0;
  }
}

.preview-scroll-container {
  flex: 1;
  min-height: 0;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  background: var(--bg-secondary);

  &.preview-mode {
    overflow-y: auto;
  }

  :deep(.md-editor-preview) {
    flex: 1;
    min-height: 0;
    box-sizing: border-box;
    overflow-y: auto;
    background: var(--bg-secondary);
    padding: 20px;
    color: var(--text-primary);

    h1, h2, h3, h4, h5, h6 {
      color: var(--text-primary);
    }

    code {
      background: var(--bg-primary);
      color: var(--el-color-primary);
      padding: 2px 6px;
      border-radius: 4px;
      font-size: 0.9em;
    }

    pre {
      background: var(--bg-primary) !important;
      padding: 0;
      border-radius: 8px;
      overflow: hidden;
      margin: 16px 0;

      code {
        display: block;
        background: transparent !important;
        padding: 16px;
        color: #374151 !important;
        font-size: 14px !important;
        line-height: 1.6;
        overflow-x: auto;
        white-space: pre;
        font-family: 'Fira Code', 'Cascadia Code', 'JetBrains Mono', Consolas, Monaco, 'Courier New', monospace;

        // md-editor-v3 代码块内容
        .md-editor-code-block {
          color: #374151 !important;
        }

        // 代码行号
        .line-number {
          color: #64748b !important;
          opacity: 1;
          user-select: none;
          min-width: 50px;
          padding-right: 20px;
          text-align: right;
          display: inline-block;
        }

        // Shell/Bash 语法高亮
        &.hljs,
        .hljs {
          color: #374151 !important;

          .hljs-keyword { color: #d946ef !important; }
          .hljs-string { color: #059669 !important; }
          .hljs-comment { color: #6b7280 !important; font-style: italic; }
          .hljs-number { color: #2563eb !important; }
          .hljs-variable { color: #ea580c !important; }
        }
      }
    }

    blockquote {
      border-left: 3px solid var(--el-color-primary);
      background: var(--bg-primary);
      margin: 16px 0;
      padding: 12px 16px;
      border-radius: 0 8px 8px 0;
      color: var(--text-regular);
    }

    a {
      color: var(--el-color-primary);
    }

    table {
      border-color: var(--border-color);

      th, td {
        border-color: var(--border-color);
        background: var(--bg-primary);
        color: var(--text-primary);
      }

      th {
        background: var(--bg-secondary);
      }
    }
  }

  // 深色模式代码块 - 使用 md-editor-dark 选择器
  :deep(.md-editor-dark) {
    .md-editor-preview pre code {
      color: #e2e8f0 !important;
      background: #0d1117 !important;

      .md-editor-code-block {
        color: #e2e8f0 !important;
      }

      .line-number {
        color: #6b7280 !important;
        opacity: 1;
      }

      // 深色模式 Shell/Bash 语法高亮
      &.hljs,
      .hljs {
        color: #e2e8f0 !important;

        .hljs-keyword { color: #c084fc !important; }
        .hljs-string { color: #4ade80 !important; }
        .hljs-comment { color: #6b7280 !important; font-style: italic; }
        .hljs-number { color: #60a5fa !important; }
        .hljs-variable { color: #fb923c !important; }
      }
    }
  }
}

.resize-handle {
  width: 4px;
  height: 100%;
  background: var(--border-color);
  cursor: col-resize;
  transition: background 0.2s ease, width 0.2s ease;
  flex-shrink: 0;

  &:hover {
    background: var(--el-color-primary);
  }

  &:active {
    background: var(--el-color-primary);
    width: 6px;
  }
}

// 移动端适配
@media (max-width: 768px) {
  .text-collection-container {
    flex-direction: column;
  }

  .sidebar {
    width: 100%;
    height: 40vh;
    border-right: none;
    border-bottom: 1px solid var(--border-color);
    min-width: unset;
    max-width: unset;
  }

  .sidebar-resize-handle {
    display: none;
  }

  .editor-toolbar {
    flex-wrap: wrap;

    .toolbar-left {
      width: 100%;
    }

    .title-input {
      width: 100%;
    }
  }
}
</style>
