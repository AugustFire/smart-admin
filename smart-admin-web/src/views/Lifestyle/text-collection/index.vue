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
            @click="currentCategoryId = ''"
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
            {{ cat.name }}
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
      <div class="text-list">
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
            <!-- 标题：选中时可编辑 -->
            <div v-if="editingTitleTextId === text.id" class="text-item-title-edit" @click.stop>
              <el-input
                v-model="editingTitleValue"
                size="small"
                @keyup.enter="saveTitleEdit(text)"
                @blur="saveTitleEdit(text)"
                ref="titleInputRef"
                autofocus
              />
            </div>
            <div v-else class="text-item-title" @dblclick.stop="startTitleEdit(text)">
              {{ text.title || '无标题' }}
            </div>
            <div class="text-item-meta">
              <el-tag v-if="getCategoryName(text.categoryId)" size="small">{{ getCategoryName(text.categoryId) }}</el-tag>
              <span class="text-item-date">{{ formatDate(text.updatedAt) }}</span>
            </div>
          </div>
          <el-button link type="danger" size="small" class="text-item-delete" @click.stop="handleDeleteText(text)">
            <el-icon><Delete /></el-icon>
          </el-button>
        </div>
        <el-empty v-if="filteredTexts.length === 0" description="暂无文本" :image-size="60" />
      </div>
    </aside>

    <!-- 侧边栏调整拖柄 -->
    <div class="sidebar-resize-handle" @mousedown="startSidebarResize"></div>

    <!-- 右侧主区域：编辑器 -->
    <main class="main-content">
      <!-- 顶部工具栏 -->
      <div class="top-toolbar">
        <div class="toolbar-left">
          <span class="current-title">{{ currentTitle || '未命名' }}</span>
        </div>
        <div class="toolbar-right">
          <el-tooltip content="自动保存" placement="bottom">
            <el-button :type="autoSaveEnabled ? 'primary' : 'default'" circle size="small" @click="toggleAutoSave">
              <el-icon><Timer /></el-icon>
            </el-button>
          </el-tooltip>
          <span v-if="lastSavedAt" class="auto-save-indicator">
            <span class="save-dot" :class="{ saving: isAutoSaving }"></span>
            {{ isAutoSaving ? '保存中...' : `已保存 ${lastSavedAt}` }}
          </span>
          <el-button type="primary" size="small" @click="handleSave" :disabled="!currentContent.trim()">
            <el-icon><Document /></el-icon>
            保存
          </el-button>
          <el-divider direction="vertical" />
          <div class="view-mode-switch">
            <el-tooltip content="仅编辑" placement="top">
              <el-button :type="editorMode === 'edit' ? 'primary' : 'default'" size="small" @click="editorMode = 'edit'">
                <el-icon><Edit /></el-icon>
              </el-button>
            </el-tooltip>
            <el-tooltip content="并排显示" placement="top">
              <el-button :type="editorMode === 'split' ? 'primary' : 'default'" size="small" @click="editorMode = 'split'">
                <el-icon><Histogram /></el-icon>
              </el-button>
            </el-tooltip>
            <el-tooltip content="仅预览" placement="top">
              <el-button :type="editorMode === 'preview' ? 'primary' : 'default'" size="small" @click="editorMode = 'preview'">
                <el-icon><View /></el-icon>
              </el-button>
            </el-tooltip>
          </div>
        </div>
      </div>

      <!-- 编辑器和预览 -->
      <div class="editor-wrapper">
        <div v-show="editorMode !== 'preview'" class="editor-pane" :style="editorPaneStyle">
          <div class="editor-scroll-container">
            <MdEditor
              v-model="currentContent"
              :editor-id="editorId"
              :preview="false"
              :toolbars="toolbars"
              placeholder="输入提示词文本，支持 Markdown 格式..."
              @save="handleSave"
            />
          </div>
        </div>
        <div v-show="editorMode === 'split'" class="resize-handle" @mousedown="startResize"></div>
        <div v-show="editorMode !== 'edit'" class="preview-pane" :style="previewPaneStyle">
          <div class="preview-toolbar">
            <span class="preview-label">预览</span>
          </div>
          <div class="preview-scroll-container">
            <MdPreview
              :model-value="currentContent"
              :editor-id="editorId"
            />
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, onUnmounted, nextTick } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Delete, Search, Document, Histogram, View, Edit, Timer, Close } from '@element-plus/icons-vue'
import { MdEditor, MdPreview } from 'md-editor-v3'
import type { ToolbarNames } from 'md-editor-v3'
import 'md-editor-v3/lib/style.css'
import 'md-editor-v3/lib/preview.css'
import dayjs from 'dayjs'
import type { TextCollectionItem, TextCategory } from '@/api/lifestyle/text-collection'

const STORAGE_KEY_TEXTS = 'text_collection_texts'
const STORAGE_KEY_CATEGORIES = 'text_collection_categories'

const editorId = 'text-collection-editor'

const searchKeyword = ref('')
const newCategoryName = ref('')
const showCategoryInput = ref(false)
const categoryInputRef = ref()
const autoSaveEnabled = ref(false)

const currentTextId = ref('')
const currentTitle = ref('')
const currentContent = ref('')
const currentCategoryId = ref('')
const currentTags = ref<string[]>([])

const texts = ref<TextCollectionItem[]>([])
const categories = ref<TextCategory[]>([])
const lastSavedAt = ref('')
const isAutoSaving = ref(false)
const editorMode = ref<'edit' | 'split' | 'preview'>('split')
const splitRatio = ref(50)
let isResizing = false
let isSidebarResizing = false
let autoSaveTimer: ReturnType<typeof setTimeout> | null = null
const sidebarWidth = ref(300)
const minSidebarWidth = 200
const maxSidebarWidth = 500

// 标题编辑状态
const editingTitleTextId = ref('')
const editingTitleValue = ref('')
const titleInputRef = ref()

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
  const result: TextCategory[] = []
  const flatten = (cats: TextCategory[]) => {
    for (const cat of cats) {
      result.push(cat)
      if (cat.children) flatten(cat.children)
    }
  }
  flatten(categories.value)
  return result
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
}

function startSidebarResize(e: MouseEvent) {
  isSidebarResizing = true
  document.addEventListener('mousemove', doSidebarResize)
  document.addEventListener('mouseup', stopSidebarResize)
  e.preventDefault()
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
}

function getCategoryName(categoryId?: string) {
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

function formatDate(dateStr: string) {
  return dayjs(dateStr).format('MM-DD HH:mm')
}

function handleAddCategory() {
  const name = newCategoryName.value.trim()
  if (!name) return

  categories.value.push({
    id: Date.now().toString(),
    name,
    children: [],
  })
  saveCategories()
  newCategoryName.value = ''
  showCategoryInput.value = false
  ElMessage.success('分类已创建')
}

function handleCategoryInputBlur() {
  if (!newCategoryName.value.trim()) {
    showCategoryInput.value = false
  }
}

function handleDeleteCategory(data: TextCategory) {
  ElMessageBox.confirm(`确认删除分类「${data.name}」吗？`, '提示', { type: 'warning' }).then(() => {
    const deleteFromTree = (cats: TextCategory[]) => {
      const idx = cats.findIndex(c => c.id === data.id)
      if (idx >= 0) {
        cats.splice(idx, 1)
        return true
      }
      for (const cat of cats) {
        if (cat.children && deleteFromTree(cat.children)) return true
      }
      return false
    }
    deleteFromTree(categories.value)
    saveCategories()
    ElMessage.success('删除成功')
  })
}

function toggleAutoSave() {
  autoSaveEnabled.value = !autoSaveEnabled.value
  if (!autoSaveEnabled.value && autoSaveTimer) {
    clearTimeout(autoSaveTimer)
    autoSaveTimer = null
  }
}

function handleNewText() {
  currentTextId.value = ''
  currentTitle.value = ''
  currentContent.value = ''
  currentTags.value = []
  // Keep currentCategoryId if user is filtering - this helps organize new text
}

function handleSelectText(text: TextCollectionItem) {
  // 取消正在编辑的标题
  if (editingTitleTextId.value) {
    saveTitleEdit(texts.value.find(t => t.id === editingTitleTextId.value))
  }
  currentTextId.value = text.id
  currentTitle.value = text.title
  currentContent.value = text.content
  currentTags.value = text.tags || []
}

function startTitleEdit(text: TextCollectionItem) {
  editingTitleTextId.value = text.id
  editingTitleValue.value = text.title || ''
  nextTick(() => {
    titleInputRef.value?.focus()
  })
}

function saveTitleEdit(text?: TextCollectionItem) {
  if (!editingTitleTextId.value) return

  const targetText = text || texts.value.find(t => t.id === editingTitleTextId.value)
  if (targetText && editingTitleValue.value !== undefined) {
    targetText.title = editingTitleValue.value.trim() || '无标题'
    saveTexts()
  }
  editingTitleTextId.value = ''
  editingTitleValue.value = ''
}

function handleSave() {
  if (!currentContent.value.trim()) {
    ElMessage.warning('内容不能为空')
    return
  }

  if (currentTextId.value) {
    const text = texts.value.find(t => t.id === currentTextId.value)
    if (text) {
      text.title = currentTitle.value
      text.content = currentContent.value
      text.categoryId = currentCategoryId.value
      text.tags = currentTags.value
      text.updatedAt = new Date().toISOString()
    }
  } else {
    const newText: TextCollectionItem = {
      id: Date.now().toString(),
      title: currentTitle.value || '无标题',
      content: currentContent.value,
      categoryId: currentCategoryId.value,
      tags: currentTags.value,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    }
    texts.value.unshift(newText)
    currentTextId.value = newText.id
  }

  saveTexts()
  ElMessage.success('保存成功')
}

// 自动保存（防抖 30 秒）
function triggerAutoSave() {
  if (autoSaveTimer) clearTimeout(autoSaveTimer)
  if (!currentContent.value.trim()) return

  autoSaveTimer = setTimeout(() => {
    if (!currentContent.value.trim()) return

    isAutoSaving.value = true

    if (currentTextId.value) {
      const text = texts.value.find(t => t.id === currentTextId.value)
      if (text) {
        text.title = currentTitle.value
        text.content = currentContent.value
        text.categoryId = currentCategoryId.value
        text.tags = currentTags.value
        text.updatedAt = new Date().toISOString()
      }
    } else {
      const newText: TextCollectionItem = {
        id: Date.now().toString(),
        title: currentTitle.value || '无标题',
        content: currentContent.value,
        categoryId: currentCategoryId.value,
        tags: currentTags.value,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
      }
      texts.value.unshift(newText)
      currentTextId.value = newText.id
    }

    saveTexts()
    lastSavedAt.value = '刚刚'
    isAutoSaving.value = false

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

function handleDeleteText(text: TextCollectionItem) {
  ElMessageBox.confirm(`确认删除「${text.title || '无标题'}」吗？`, '提示', { type: 'warning' }).then(() => {
    texts.value = texts.value.filter(t => t.id !== text.id)
    if (currentTextId.value === text.id) {
      currentTextId.value = ''
      currentTitle.value = ''
      currentContent.value = ''
    }
    saveTexts()
    ElMessage.success('删除成功')
  })
}

function loadTexts() {
  try {
    const data = localStorage.getItem(STORAGE_KEY_TEXTS)
    if (data) texts.value = JSON.parse(data)
  } catch (e) {
    console.error(e)
  }
}

function saveTexts() {
  try {
    localStorage.setItem(STORAGE_KEY_TEXTS, JSON.stringify(texts.value))
  } catch (e) {
    console.error(e)
  }
}

function loadCategories() {
  try {
    const data = localStorage.getItem(STORAGE_KEY_CATEGORIES)
    if (data) categories.value = JSON.parse(data)
  } catch (e) {
    console.error(e)
  }
}

function saveCategories() {
  try {
    localStorage.setItem(STORAGE_KEY_CATEGORIES, JSON.stringify(categories.value))
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

onMounted(() => {
  loadTexts()
  loadCategories()
})

onUnmounted(() => {
  if (autoSaveTimer) {
    clearTimeout(autoSaveTimer)
    autoSaveTimer = null
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
    font-size: 10px;
    margin-left: 2px;
    opacity: 0.6;

    &:hover {
      opacity: 1;
      color: var(--el-color-danger);
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
    }
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
  background: var(--bg-secondary);
  border-radius: 20px;
  padding: 2px;

  :deep(.el-button) {
    border: none;
    border-radius: 0;
    padding: 6px 10px;
    background: transparent;

    &:first-child {
      border-radius: 18px 0 0 18px;
    }

    &:last-child {
      border-radius: 0 18px 18px 0;
    }

    &:not(:first-child):not(:last-child) {
      border-radius: 0;
    }

    &:hover {
      background: var(--el-color-primary-light-9);
    }

    &.el-button--primary {
      background: var(--el-color-primary);
      color: var(--bg-primary);
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
  transition: width 0.1s ease;
  overflow: hidden;
}

.preview-toolbar {
  padding: 8px 16px;
  border-bottom: 1px solid var(--border-color-light);
  background: var(--bg-secondary);
  flex-shrink: 0;

  .preview-label {
    font-size: 12px;
    color: var(--text-secondary);
    font-weight: 500;
  }
}

.editor-scroll-container {
  flex: 1;
  min-height: 0;
  overflow-y: auto;
  display: flex;
  flex-direction: column;

  :deep(.md-editor) {
    flex: 1;
    height: 100%;
  }
}

.preview-scroll-container {
  flex: 1;
  min-height: 0;
  overflow-y: auto;
  display: flex;
  flex-direction: column;

  :deep(.md-editor-preview) {
    flex: 1;
  }
}

.resize-handle {
  width: 4px;
  height: 100%;
  background: var(--border-color);
  cursor: col-resize;
  transition: background 0.2s ease;
  flex-shrink: 0;

  &:hover {
    background: var(--el-color-primary);
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
