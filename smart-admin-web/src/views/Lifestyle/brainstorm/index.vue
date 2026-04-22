<template>
  <div class="brainstorm-container">
    <!-- 顶部工具栏 -->
    <div class="top-bar">
      <div class="left">
        <DateRangePicker v-model="dateRange" @change="handleQuery" />
        <el-input
          v-model="searchKeyword"
          placeholder="搜索想法..."
          style="width: 200px"
          clearable
          @input="handleQuery"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
      </div>
      <div class="right">
        <el-dropdown trigger="click" @command="viewMode = $event">
          <el-button type="default">
            {{ viewLabels[viewMode] }}
            <el-icon style="margin-left: 4px"><ArrowDown /></el-icon>
          </el-button>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item command="card">卡片</el-dropdown-item>
              <el-dropdown-item command="timeline">时间线</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </div>

    <!-- 标语横幅 -->
    <div class="tip-banner">
      <span class="tip-icon">💡</span>
      <span class="tip-text">{{ randomTip }}</span>
    </div>

    <!-- 快速输入区 -->
    <div class="quick-input" :class="{ 'has-content': quickInput.trim() }">
      <div class="input-header">
        <el-icon class="input-icon"><Edit /></el-icon>
        <span class="input-hint">记录想法</span>
        <span class="input-shortcut">Ctrl/Command + Enter 快捷添加</span>
      </div>
      <el-input
        v-model="quickInput"
        type="textarea"
        :rows="3"
        placeholder="写下你的想法... 可以是灵感、疑问、计划或者任何想记录的内容"
        resize="none"
        @keydown.ctrl.enter.prevent="handleQuickAdd"
        @keydown.meta.enter.prevent="handleQuickAdd"
      />
      <div class="input-footer">
        <div class="tag-group">
          <el-tooltip v-for="tag in presetTags" :key="tag.value" :content="tag.description" placement="top">
            <el-check-tag
              :checked="selectedTags.includes(tag.value)"
              @change="toggleTag(tag.value)"
              :class="{ 'tag-active': selectedTags.includes(tag.value) }"
              :style="selectedTags.includes(tag.value) ? { '--tag-color': tag.color } : {}"
            >
              <span class="tag-dot" :style="{ background: tag.color }"></span>
              {{ tag.label }}
            </el-check-tag>
          </el-tooltip>
        </div>
        <el-button type="primary" @click="handleQuickAdd" :disabled="!quickInput.trim()" :loading="isAdding">
          <el-icon><Plus /></el-icon>
          添加
        </el-button>
      </div>
    </div>

    <!-- 统计栏 -->
    <div class="stats-bar">
      <div class="stat-chip">
        <span class="chip-num">{{ filteredIdeas.length }}</span>
        <span class="chip-label">条想法</span>
      </div>
      <div class="stat-divider"></div>
      <div class="stat-chip">
        <span class="chip-num">{{ todayCount }}</span>
        <span class="chip-label">今天</span>
      </div>
      <div class="stat-chip">
        <span class="chip-num">{{ weekCount }}</span>
        <span class="chip-label">本周</span>
      </div>
    </div>

    <!-- 标签筛选 -->
    <div class="filter-bar">
      <span class="filter-label">标签筛选:</span>
      <el-check-tag
        :checked="!filterTag"
        @change="filterTag = ''"
      >
        全部
      </el-check-tag>
      <el-check-tag
        v-for="tag in presetTags"
        :key="tag.value"
        :checked="filterTag === tag.value"
        @change="filterTag = tag.value"
      >
        {{ tag.label }}
      </el-check-tag>
    </div>

    <!-- 卡片视图 -->
    <div v-if="viewMode === 'card'" class="card-view">
      <div v-if="groupedIdeas.length === 0" class="empty-state">
        <el-empty description="暂无想法，记录你的第一个灵感吧" />
      </div>
      <div v-else class="card-groups">
        <div v-for="group in groupedIdeas" :key="group.label" class="card-group">
          <div class="group-header">
            <div class="group-date-wrap">
              <span class="group-icon">{{ group.icon }}</span>
              <span class="group-date">{{ group.label }}</span>
              <span class="group-total">{{ group.items.length }} 条</span>
            </div>
          </div>
          <div class="card-grid">
            <div
              v-for="idea in group.items"
              :key="idea.id"
              class="idea-card"
              :class="{ 'is-new': newlyAddedId === idea.id }"
            >
              <div class="card-glow" :style="{ background: `linear-gradient(135deg, ${getTagColor(idea.tags[0])}22 0%, transparent 60%)` }"></div>
              <div class="card-inner">
                <div class="card-content">{{ idea.content }}</div>
                <div v-if="idea.tags.length" class="card-tags">
                  <el-tag
                    v-for="tag in idea.tags"
                    :key="tag"
                    size="small"
                    :style="{ background: getTagColor(tag) + '20', borderColor: getTagColor(tag), color: getTagColor(tag) }"
                  >
                    {{ getTagLabel(tag) }}
                  </el-tag>
                </div>
                <div class="card-footer">
                  <span class="card-time">{{ formatTime(idea.createdAt) }}</span>
                  <div class="card-actions">
                    <el-button link type="primary" @click="handleEdit(idea)">
                      <el-icon><Edit /></el-icon>
                    </el-button>
                    <el-button link type="danger" @click="handleDelete(idea)">
                      <el-icon><Delete /></el-icon>
                    </el-button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 时间线视图 -->
    <div v-else class="timeline-view">
      <div v-if="groupedIdeas.length === 0" class="empty-state">
        <el-empty description="暂无想法，记录你的第一个灵感吧" />
      </div>
      <div v-else class="timeline-groups">
        <div v-for="group in groupedIdeas" :key="group.label" class="timeline-group">
          <div class="group-header">
            <div class="group-date-wrap">
              <span class="group-icon">{{ group.icon }}</span>
              <span class="group-date">{{ group.label }}</span>
              <span class="group-total">{{ group.items.length }} 条</span>
            </div>
          </div>
          <div class="group-items">
            <div
              v-for="(idea, idx) in group.items"
              :key="idea.id"
              class="timeline-row"
            >
              <div class="row-line">
                <div class="row-dot" :style="{ background: getTagColor(idea.tags[0]) }">
                  💡
                </div>
                <div v-if="idx < group.items.length - 1" class="row-connector"></div>
              </div>
              <div class="row-content">
                <div class="row-header">
                  <div class="row-tags">
                    <el-tag
                      v-for="tag in idea.tags"
                      :key="tag"
                      size="small"
                      :style="{ background: getTagColor(tag) + '20', borderColor: getTagColor(tag), color: getTagColor(tag) }"
                    >
                      {{ getTagLabel(tag) }}
                    </el-tag>
                  </div>
                  <div class="row-actions">
                    <el-button link type="primary" @click="handleEdit(idea)">
                      <el-icon><Edit /></el-icon>
                    </el-button>
                    <el-button link type="danger" @click="handleDelete(idea)">
                      <el-icon><Delete /></el-icon>
                    </el-button>
                  </div>
                </div>
                <div class="row-content-text">{{ idea.content }}</div>
                <div class="row-footer">
                  <span class="row-time">{{ formatTime(idea.createdAt) }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 编辑对话框 -->
    <el-dialog
      :title="dialogTitle"
      v-model="dialogVisible"
      width="520px"
      :close-on-click-modal="false"
      class="brainstorm-dialog"
    >
      <el-form ref="formRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="内容" prop="content">
          <el-input
            v-model="form.content"
            type="textarea"
            :rows="4"
            placeholder="记录你的想法..."
            show-word-limit
            maxlength="2000"
          />
        </el-form-item>
        <el-form-item label="标签" prop="tags">
          <div class="dialog-tag-group">
            <el-check-tag
              v-for="tag in presetTags"
              :key="tag.value"
              :checked="form.tags.includes(tag.value)"
              @change="toggleFormTag(tag.value)"
            >
              <span class="tag-dot" :style="{ background: tag.color }"></span>
              {{ tag.label }}
            </el-check-tag>
          </div>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button v-if="isEdit" type="danger" plain @click="handleDeleteFromDialog">
            <el-icon><Delete /></el-icon>
            删除
          </el-button>
          <div class="footer-right">
            <el-button @click="dialogVisible = false">取消</el-button>
            <el-button type="primary" @click="submitForm">保存</el-button>
          </div>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, nextTick } from 'vue'
import { ElMessage, ElMessageBox, type FormInstance, type FormRules } from 'element-plus'
import { Plus, Edit, Delete, Search, ArrowDown } from '@element-plus/icons-vue'
import dayjs from 'dayjs'
import type { BrainstormItem } from '@/api/lifestyle/brainstorm'
import DateRangePicker from '@/components/DateRangePicker/index.vue'

const STORAGE_KEY = 'brainstorm_ideas'

const dateRange = ref<string[]>([])
const searchKeyword = ref('')
const filterTag = ref('')
const viewMode = ref<'card' | 'timeline'>('card')
const quickInput = ref('')
const selectedTags = ref<string[]>([])
const dialogVisible = ref(false)
const isEdit = ref(false)
const isAdding = ref(false)
const editingId = ref('')
const formRef = ref<FormInstance>()
const ideas = ref<BrainstormItem[]>([])
const newlyAddedId = ref('')

const form = ref<{ content: string; tags: string[] }>({
  content: '',
  tags: [],
})

const rules: FormRules = {
  content: [{ required: true, message: '请输入内容', trigger: 'blur' }],
}

const presetTags = [
  { label: '工作', value: 'work', color: '#3b82f6', description: '与工作相关的事务' },
  { label: '生活', value: 'life', color: '#10b981', description: '日常生活中的点滴' },
  { label: '学习', value: 'study', color: '#8b5cf6', description: '学习心得与计划' },
  { label: '创意', value: 'creative', color: '#f59e0b', description: '创意灵感与想法' },
  { label: '灵感', value: 'idea', color: '#ec4899', description: '突然想到的好点子' },
]

const tagColorMap = Object.fromEntries(presetTags.map(t => [t.value, t.color]))

const viewLabels: Record<string, string> = {
  card: '卡片',
  timeline: '时间线',
}

const tips = [
  '记录生活中的每一个灵感闪光点 ✨',
  '想法不需要完美，先记下来再说 ✍️',
  '随时随地，记录你的思考碎片 📝',
  '好的想法往往出现在不经意间 🎯',
  '每天多记录一点，让思考更有条理 💭',
]

const randomTip = computed(() => tips[Math.floor(Math.random() * tips.length)])

const dialogTitle = computed(() => isEdit.value ? '编辑想法' : '添加想法')

const tagLabelMap = computed(() => {
  const map: Record<string, string> = {}
  presetTags.forEach(t => { map[t.value] = t.label })
  return map
})

function getTagColor(tag?: string) {
  return tag ? tagColorMap[tag] || '#999' : '#999'
}

function getTagLabel(tag?: string) {
  return tag ? tagLabelMap.value[tag] || tag : ''
}

const filteredIdeas = computed(() => {
  let result = ideas.value

  if (searchKeyword.value) {
    const kw = searchKeyword.value.toLowerCase()
    result = result.filter(i => i.content.toLowerCase().includes(kw))
  }

  if (filterTag.value) {
    result = result.filter(i => i.tags.includes(filterTag.value))
  }

  if (dateRange.value && dateRange.value.length === 2) {
    const [start, end] = dateRange.value
    result = result.filter(i => {
      const date = i.createdAt.split('T')[0]
      return date >= start && date <= end
    })
  }

  return result
})

const groupedIdeas = computed(() => {
  const today = dayjs().format('YYYY-MM-DD')
  const yesterday = dayjs().subtract(1, 'day').format('YYYY-MM-DD')
  const weekStart = dayjs().startOf('week').format('YYYY-MM-DD')
  const weekEnd = dayjs().endOf('week').format('YYYY-MM-DD')

  const groups: Record<string, { label: string; icon: string; items: BrainstormItem[] }> = {
    today: { label: '今天', icon: '📅', items: [] },
    yesterday: { label: '昨天', icon: '📆', items: [] },
    thisWeek: { label: '本周', icon: '📅', items: [] },
    earlier: { label: '更早', icon: '📚', items: [] },
  }

  for (const idea of filteredIdeas.value) {
    const date = idea.createdAt.split('T')[0]
    if (date === today) {
      groups.today.items.push(idea)
    } else if (date === yesterday) {
      groups.yesterday.items.push(idea)
    } else if (date >= weekStart && date <= weekEnd) {
      groups.thisWeek.items.push(idea)
    } else {
      groups.earlier.items.push(idea)
    }
  }

  return Object.values(groups).filter(g => g.items.length > 0)
})

const todayCount = computed(() => {
  const today = dayjs().format('YYYY-MM-DD')
  return ideas.value.filter(i => i.createdAt.startsWith(today)).length
})

const weekCount = computed(() => {
  const weekStart = dayjs().startOf('week').format('YYYY-MM-DD')
  return ideas.value.filter(i => i.createdAt >= weekStart).length
})

function formatTime(dateStr: string) {
  const d = dayjs(dateStr)
  const today = dayjs().format('YYYY-MM-DD')
  const date = d.format('YYYY-MM-DD')

  if (date === today) {
    return `今天 ${d.format('HH:mm')}`
  } else if (date === dayjs().subtract(1, 'day').format('YYYY-MM-DD')) {
    return `昨天 ${d.format('HH:mm')}`
  }
  return d.format('MM-DD HH:mm')
}

function toggleTag(tag: string) {
  const idx = selectedTags.value.indexOf(tag)
  if (idx >= 0) {
    selectedTags.value.splice(idx, 1)
  } else {
    selectedTags.value.push(tag)
  }
}

function toggleFormTag(tag: string) {
  const idx = form.value.tags.indexOf(tag)
  if (idx >= 0) {
    form.value.tags.splice(idx, 1)
  } else {
    form.value.tags.push(tag)
  }
}

function handleQuickAdd() {
  if (!quickInput.value.trim()) return

  isAdding.value = true

  const idea: BrainstormItem = {
    id: Date.now().toString(),
    content: quickInput.value.trim(),
    tags: [...selectedTags.value],
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  }

  ideas.value.unshift(idea)
  saveToStorage()
  quickInput.value = ''
  selectedTags.value = []

  // 滚动到顶部并高亮新卡片
  newlyAddedId.value = idea.id
  nextTick(() => {
    window.scrollTo({ top: 0, behavior: 'smooth' })
    setTimeout(() => {
      newlyAddedId.value = ''
    }, 2000)
  })

  setTimeout(() => {
    isAdding.value = false
    ElMessage.success('灵感已记录 ✨')
  }, 300)
}

function handleEdit(idea: BrainstormItem) {
  isEdit.value = true
  editingId.value = idea.id
  form.value = {
    content: idea.content,
    tags: [...idea.tags],
  }
  dialogVisible.value = true
}

function handleDelete(idea: BrainstormItem) {
  ElMessageBox.confirm('确认删除这条想法吗？', '提示', { type: 'warning' }).then(() => {
    ideas.value = ideas.value.filter(i => i.id !== idea.id)
    saveToStorage()
    ElMessage.success('删除成功')
  })
}

function submitForm() {
  if (!formRef.value) return
  formRef.value.validate((valid) => {
    if (!valid) return

    if (isEdit.value && editingId.value) {
      const idea = ideas.value.find(i => i.id === editingId.value)
      if (idea) {
        idea.content = form.value.content
        idea.tags = [...form.value.tags]
        idea.updatedAt = new Date().toISOString()
        saveToStorage()
        ElMessage.success('更新成功')
        dialogVisible.value = false
      }
    } else {
      const idea: BrainstormItem = {
        id: Date.now().toString(),
        content: form.value.content,
        tags: [...form.value.tags],
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
      }
      ideas.value.unshift(idea)
      saveToStorage()
      ElMessage.success('添加成功')
      dialogVisible.value = false
    }
  })
}

function handleDeleteFromDialog() {
  const idea = ideas.value.find(i => i.id === editingId.value)
  if (!idea) return

  ElMessageBox.confirm('确认删除这条想法吗？', '提示', { type: 'warning' }).then(() => {
    ideas.value = ideas.value.filter(i => i.id !== editingId.value)
    saveToStorage()
    dialogVisible.value = false
    ElMessage.success('已删除')
  })
}

function handleQuery() {
  // 筛选是响应式的，不需要额外操作
}

function loadFromStorage() {
  try {
    const data = localStorage.getItem(STORAGE_KEY)
    if (data) {
      ideas.value = JSON.parse(data)
    }
  } catch (e) {
    console.error(e)
  }
}

function saveToStorage() {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(ideas.value))
  } catch (e) {
    console.error(e)
  }
}

onMounted(() => {
  loadFromStorage()
})
</script>

<style lang="scss" scoped>
.brainstorm-container {
  padding: 20px;
  background: var(--app-main-bg-color);
  min-height: calc(100vh - 84px);
}

.top-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;

  .left, .right {
    display: flex;
    align-items: center;
    gap: 12px;
  }
}

.tip-banner {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px 20px;
  background: linear-gradient(135deg, var(--el-color-primary-light-9) 0%, var(--el-color-warning-light-9) 100%);
  border: 1px solid var(--el-color-primary-light-7);
  border-radius: var(--card-radius);
  margin-bottom: 16px;
  position: relative;
  overflow: hidden;

  &::before {
    content: '';
    position: absolute;
    top: 0;
    right: 0;
    width: 120px;
    height: 120px;
    background: radial-gradient(circle, var(--el-color-primary-light-5) 0%, transparent 70%);
    opacity: 0.3;
  }

  .tip-icon { font-size: 20px; flex-shrink: 0; }
  .tip-text {
    font-size: 14px;
    font-weight: 500;
    color: var(--el-color-primary);
    line-height: 1.5;
    position: relative;
  }
}

.quick-input {
  background: var(--bg-primary);
  border: 1px solid var(--border-color);
  border-radius: var(--card-radius);
  padding: 20px;
  margin-bottom: 16px;
  transition: all 0.3s ease;
  border-left: 3px solid var(--el-color-primary);

  &:focus-within {
    border-color: var(--el-color-primary);
    box-shadow: 0 0 0 3px var(--el-color-primary-light-8);
  }

  &.has-content {
    border-left-color: var(--el-color-success);
  }

  .input-header {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 12px;

    .input-icon {
      font-size: 16px;
      color: var(--el-color-primary);
    }

    .input-hint {
      font-size: 14px;
      font-weight: 600;
      color: var(--text-primary);
    }

    .input-shortcut {
      margin-left: auto;
      font-size: 12px;
      color: var(--text-secondary);
      background: var(--bg-secondary);
      padding: 2px 8px;
      border-radius: 4px;
    }
  }

  .input-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 12px;
  }
}

.tag-group {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;

  :deep(.el-check-tag) {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 6px 12px;
    border-radius: 16px;
    font-size: 13px;
    transition: all 0.2s ease;
    border: 1px solid var(--border-color);
    background: var(--bg-secondary);

    &:hover {
      border-color: var(--el-color-primary-light-5);
    }

    &.tag-active {
      border-color: var(--tag-color, var(--el-color-primary));
      background: color-mix(in srgb, var(--tag-color, var(--el-color-primary)) 10%, transparent);
    }

    .tag-dot {
      width: 8px;
      height: 8px;
      border-radius: 50%;
    }
  }
}

.dialog-tag-group {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;

  :deep(.el-check-tag) {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 6px 12px;
    border-radius: 16px;
    font-size: 13px;

    .tag-dot {
      width: 8px;
      height: 8px;
      border-radius: 50%;
    }
  }
}

.stats-bar {
  display: flex;
  align-items: center;
  gap: 24px;
  padding: 16px 24px;
  background: var(--bg-primary);
  border-radius: var(--card-radius);
  border: 1px solid var(--border-color);
  margin-bottom: 16px;

  .stat-chip {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 4px 12px;
    border-radius: 8px;
    transition: all 0.2s ease;

    &:hover {
      background: var(--bg-secondary);
    }

    .chip-num {
      font-size: 24px;
      font-weight: 700;
      color: var(--el-color-primary);
      font-feature-settings: 'tnum';
    }
    .chip-label {
      font-size: 13px;
      color: var(--text-secondary);
    }
  }

  .stat-divider {
    width: 1px;
    height: 32px;
    background: linear-gradient(to bottom, transparent, var(--border-color), transparent);
  }
}

.filter-bar {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 20px;
  padding: 12px 16px;
  background: var(--bg-primary);
  border-radius: var(--card-radius);
  border: 1px solid var(--border-color);

  .filter-label {
    font-size: 13px;
    font-weight: 500;
    color: var(--text-secondary);
    margin-right: 4px;
  }

  :deep(.el-check-tag) {
    padding: 4px 10px;
    font-size: 12px;
    border-radius: 12px;
  }
}

.empty-state {
  padding: 80px 0;
  text-align: center;

  :deep(.el-empty__image) {
    opacity: 0.6;
  }

  :deep(.el-empty__description) {
    font-size: 14px;
    color: var(--text-secondary);
  }
}

.card-groups {
  display: flex;
  flex-direction: column;
  gap: 32px;
}

.card-group {
  .group-header {
    margin-bottom: 16px;

    .group-date-wrap {
      display: inline-flex;
      align-items: center;
      gap: 12px;
      background: var(--bg-primary);
      border: 1px solid var(--border-color);
      border-radius: 24px;
      padding: 8px 20px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.04);

      .group-icon {
        font-size: 16px;
      }

      .group-date {
        font-size: 15px;
        font-weight: 600;
        color: var(--text-primary);
      }

      .group-total {
        font-size: 12px;
        color: var(--text-secondary);
        background: var(--bg-secondary);
        padding: 3px 10px;
        border-radius: 12px;
        font-weight: 500;
      }
    }
  }
}

.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 16px;
}

.idea-card {
  position: relative;
  border-radius: var(--card-radius);
  overflow: hidden;
  background: var(--bg-primary);
  border: 1px solid var(--border-color);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;

  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 3px;
    background: linear-gradient(90deg, var(--el-color-primary), var(--el-color-success));
    opacity: 0;
    transition: opacity 0.3s ease;
  }

  &:hover {
    transform: translateY(-4px);
    box-shadow: 0 12px 24px rgba(0,0,0,0.08);
    border-color: transparent;

    &::before {
      opacity: 1;
    }

    .card-actions {
      opacity: 1;
    }
  }

  &.is-new {
    animation: highlightNew 2s cubic-bezier(0.4, 0, 0.2, 1);
    border-color: var(--el-color-primary);

    &::before {
      opacity: 1;
    }
  }
}

@keyframes highlightNew {
  0% {
    background: var(--el-color-primary-light-9);
    transform: scale(1.02) translateY(0);
    box-shadow: 0 8px 20px rgba(64, 158, 255, 0.3);
  }
  50% {
    background: var(--el-color-primary-light-9);
    transform: scale(1.01) translateY(-2px);
  }
  100% {
    background: var(--bg-primary);
    transform: scale(1) translateY(0);
  }
}

.card-glow {
  position: absolute;
  top: 0;
  right: 0;
  width: 120px;
  height: 120px;
  border-radius: 0 0 0 100%;
  pointer-events: none;
  opacity: 0.6;
}

.card-inner {
  position: relative;
  z-index: 1;
  padding: 18px;
}

.card-content {
  font-size: 14px;
  color: var(--text-primary);
  line-height: 1.7;
  margin-bottom: 14px;
  display: -webkit-box;
  -webkit-line-clamp: 4;
  -webkit-box-orient: vertical;
  overflow: hidden;
  min-height: 56px;
}

.card-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin-bottom: 12px;

  :deep(.el-tag) {
    border-radius: 10px;
    padding: 0 8px;
    height: 22px;
    line-height: 20px;
    font-size: 11px;
    border: none;
    font-weight: 500;
  }
}

.card-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 12px;
  border-top: 1px solid var(--border-color-light);

  .card-time {
    font-size: 12px;
    color: var(--text-secondary);
    display: flex;
    align-items: center;
    gap: 4px;
  }

  .card-actions {
    display: flex;
    gap: 4px;
    opacity: 0;
    transition: opacity 0.2s ease;
  }
}

// 时间线视图
.timeline-view {
  .empty-state { padding: 80px 0; }
}

.timeline-groups {
  display: flex;
  flex-direction: column;
  gap: 32px;
}

.timeline-group {
  .group-header {
    margin-bottom: 16px;

    .group-date-wrap {
      display: inline-flex;
      align-items: center;
      gap: 12px;
      background: var(--bg-primary);
      border: 1px solid var(--border-color);
      border-radius: 24px;
      padding: 8px 20px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.04);

      .group-date {
        font-size: 15px;
        font-weight: 600;
        color: var(--text-primary);
      }

      .group-total {
        font-size: 12px;
        color: var(--text-secondary);
        background: var(--bg-secondary);
        padding: 3px 10px;
        border-radius: 12px;
      }
    }
  }
}

.group-items {
  padding-left: 20px;
}

.timeline-row {
  display: flex;
  gap: 20px;

  .row-line {
    display: flex;
    flex-direction: column;
    align-items: center;
    flex-shrink: 0;

    .row-dot {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 18px;
      color: var(--bg-primary);
      flex-shrink: 0;
      box-shadow: 0 4px 12px rgba(0,0,0,0.15);
      border: 3px solid var(--bg-primary);
    }

    .row-connector {
      width: 2px;
      flex: 1;
      min-height: 24px;
      background: linear-gradient(to bottom, var(--border-color), transparent);
      margin: 4px 0;
    }
  }

  .row-content {
    flex: 1;
    background: var(--bg-primary);
    border: 1px solid var(--border-color);
    border-radius: var(--card-radius);
    padding: 16px 18px;
    margin-bottom: 12px;
    transition: all 0.3s ease;

    &:hover {
      box-shadow: 0 8px 20px rgba(0,0,0,0.06);
      border-color: var(--el-color-primary-light-5);

      .row-actions {
        opacity: 1;
      }
    }
  }
}

.row-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;

  .row-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 6px;

    :deep(.el-tag) {
      border-radius: 10px;
      padding: 0 8px;
      height: 22px;
      line-height: 20px;
      font-size: 11px;
      border: none;
      font-weight: 500;
    }
  }

  .row-actions {
    display: flex;
    gap: 4px;
    opacity: 0;
    transition: opacity 0.2s ease;
  }
}

.row-content-text {
  font-size: 14px;
  color: var(--text-primary);
  line-height: 1.7;
  margin-bottom: 10px;
}

.row-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;

  .row-time {
    font-size: 12px;
    color: var(--text-secondary);
  }
}

// 响应式
@media (max-width: 768px) {
  .top-bar {
    flex-direction: column;
    gap: 12px;

    .left, .right {
      width: 100%;
      justify-content: center;
    }
  }

  .quick-input {
    .input-header {
      flex-wrap: wrap;

      .input-shortcut {
        margin-left: 0;
        width: 100%;
        text-align: center;
        margin-top: 8px;
      }
    }

    .input-footer {
      flex-direction: column;
      gap: 12px;

      .tag-group {
        width: 100%;
        justify-content: center;
      }
    }
  }

  .stats-bar {
    flex-wrap: wrap;
    justify-content: center;
    gap: 12px;
  }

  .filter-bar {
    flex-wrap: wrap;
    justify-content: center;
  }

  .card-grid {
    grid-template-columns: 1fr;
  }

  .timeline-row {
    .row-actions {
      opacity: 1;
    }
  }
}
</style>
