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
          <el-tooltip
            v-for="tag in presetTags"
            :key="tag.value"
            :content="tag.description"
            placement="top"
            effect="light"
          >
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
      <div v-if="ideas.length === 0" class="empty-state">
        <el-empty description="暂无想法，记录你的第一个灵感吧">
          <template #image>
            <span style="font-size: 48px">💡</span>
          </template>
        </el-empty>
      </div>
      <div v-else-if="groupedIdeas.length === 0" class="empty-state">
        <el-empty description="未找到匹配的想法，试试其他筛选条件">
          <template #image>
            <span style="font-size: 48px">🔍</span>
          </template>
        </el-empty>
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
              @dblclick="handleOpenDetail(idea)"
            >
              <div class="card-glow" :style="{ background: `linear-gradient(135deg, ${getTagColor(getFirstTag(idea))}22 0%, transparent 60%)` }"></div>
              <div class="card-inner" :style="{ '--tag-color': getTagColor(getFirstTag(idea)) }">
                <div class="card-header">
                  <span class="card-emoji">{{ getTagEmoji(getFirstTag(idea)) }}</span>
                  <div class="card-actions">
                    <el-button class="card-action-btn" link type="primary" @click.stop="handleEdit(idea)">
                      <el-icon><Edit /></el-icon>
                    </el-button>
                    <el-button class="card-action-btn" link type="danger" @click.stop="handleDelete(idea)">
                      <el-icon><Delete /></el-icon>
                    </el-button>
                  </div>
                </div>
                <div class="card-content">
                  <span v-if="idea.content.length > 100 && !expandedIds.includes(idea.id)">
                    {{ idea.content.slice(0, 100) }}...
                    <span class="expand-btn" @click.stop="expandedIds.push(idea.id)">展开</span>
                  </span>
                  <span v-else>{{ idea.content }}</span>
                </div>
                <div v-if="getIdeaTags(idea).length" class="card-tags">
                  <el-tag
                    v-for="tag in getIdeaTags(idea)"
                    :key="tag"
                    size="small"
                    :style="{ background: getTagColor(tag) + '18', borderColor: getTagColor(tag) + '50', color: getTagColor(tag), fontWeight: 600 }"
                  >
                    {{ getTagLabel(tag) }}
                  </el-tag>
                </div>
                <div class="card-footer">
                  <span class="card-time">{{ formatTime(idea.createTime) }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 时间线视图 -->
    <div v-else class="timeline-view">
      <div v-if="ideas.length === 0" class="empty-state">
        <el-empty description="暂无想法，记录你的第一个灵感吧">
          <template #image>
            <span style="font-size: 48px">💡</span>
          </template>
        </el-empty>
      </div>
      <div v-else-if="groupedIdeas.length === 0" class="empty-state">
        <el-empty description="未找到匹配的想法，试试其他筛选条件">
          <template #image>
            <span style="font-size: 48px">🔍</span>
          </template>
        </el-empty>
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
                <div class="row-dot" :style="{ background: getTagColor(getFirstTag(idea)) }">
                  💡
                </div>
                <div v-if="idx < group.items.length - 1" class="row-connector"></div>
              </div>
              <div class="row-content">
                <div class="row-header">
                  <div class="row-tags">
                    <el-tag
                      v-for="tag in getIdeaTags(idea)"
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
                  <span class="row-time">{{ formatTime(idea.createTime) }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="520px"
      :close-on-click-modal="false"
      class="brainstorm-edit-dialog"
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
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitForm">保存</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 详情对话框 -->
    <el-dialog
      v-model="detailVisible"
      :title="'想法详情'"
      width="600px"
      :close-on-click-modal="false"
      class="detail-dialog"
    >
      <div class="detail-content">
        <p>{{ detailIdea?.content }}</p>
      </div>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, nextTick, watch } from 'vue'
import { ElMessage, ElMessageBox, type FormInstance, type FormRules } from 'element-plus'
import { Plus, Edit, Delete, Search, ArrowDown, Close } from '@element-plus/icons-vue'
import dayjs from 'dayjs'
import { getBrainstormPageApi, addBrainstormApi, updateBrainstormApi, deleteBrainstormApi, type BrainstormItem } from '@/api/lifestyle/brainstorm'
import { formatTags } from '@/utils/tag'

const loading = ref(false)
const dateRange = ref<string[]>([
  dayjs().subtract(7, 'day').format('YYYY-MM-DD'),
  dayjs().format('YYYY-MM-DD')
])
const searchKeyword = ref('')
const filterTag = ref('')
const viewMode = ref<'card' | 'timeline'>('card')
const quickInput = ref('')
const selectedTags = ref<string[]>([])
const dialogVisible = ref(false)
const isEdit = ref(false)
const isAdding = ref(false)
const editingId = ref<number | ''>('')
const formRef = ref<FormInstance>()
const ideas = ref<BrainstormItem[]>([])
const newlyAddedId = ref<number | ''>('')
const detailVisible = ref(false)
const detailIdea = ref<BrainstormItem | null>(null)
const expandedIds = ref<number[]>([])

const form = ref<{ content: string; tags: string[] }>({
  content: '',
  tags: [],
})

const rules: FormRules = {
  content: [{ required: true, message: '请输入内容', trigger: 'blur' }],
}

const presetTags = [
  { label: '工作', value: 'work', color: '#3b82f6', emoji: '💼', description: '与工作相关的事务' },
  { label: '生活', value: 'life', color: '#10b981', emoji: '🌱', description: '日常生活中的点滴' },
  { label: '学习', value: 'study', color: '#8b5cf6', emoji: '📚', description: '学习心得与计划' },
  { label: '创意', value: 'creative', color: '#f59e0b', emoji: '💡', description: '创意灵感与想法' },
  { label: '灵感', value: 'idea', color: '#ec4899', emoji: '✨', description: '突然想到的好点子' },
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

const tagEmojiMap = Object.fromEntries(presetTags.map(t => [t.value, t.emoji]))

function getTagEmoji(tag?: string) {
  return tag ? tagEmojiMap[tag] || '💡' : '💡'
}

function getIdeaTags(idea: BrainstormItem): string[] {
  return formatTags(idea.tags)
}

function getFirstTag(idea: BrainstormItem): string {
  const tags = getIdeaTags(idea)
  return tags[0] || ''
}

const filteredIdeas = computed(() => {
  let result = ideas.value

  if (searchKeyword.value) {
    const kw = searchKeyword.value.toLowerCase()
    result = result.filter(i => i.content.toLowerCase().includes(kw))
  }

  if (filterTag.value) {
    result = result.filter(i => i.tags && i.tags.includes(filterTag.value))
  }

  if (dateRange.value && dateRange.value.length === 2) {
    const [start, end] = dateRange.value
    result = result.filter(i => {
      const date = i.createTime.split('T')[0]
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
    const date = idea.createTime.split('T')[0]
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
  return ideas.value.filter(i => i.createTime.startsWith(today)).length
})

const weekCount = computed(() => {
  const weekStart = dayjs().startOf('week').format('YYYY-MM-DD')
  return ideas.value.filter(i => i.createTime >= weekStart).length
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

async function handleQuickAdd() {
  if (!quickInput.value.trim()) return

  isAdding.value = true

  try {
    const tagsStr = selectedTags.value.join(',')
    const { data } = await addBrainstormApi({
      content: quickInput.value.trim(),
      tags: tagsStr
    })
    // 重新加载数据
    await fetchData()
    quickInput.value = ''
    selectedTags.value = []
    ElMessage.success('灵感已记录 ✨')
  } catch (error) {
    console.error(error)
  } finally {
    isAdding.value = false
  }
}

function handleOpenDetail(idea: BrainstormItem) {
  detailIdea.value = idea
  detailVisible.value = true
}

function handleEditFromDetail() {
  if (!detailIdea.value) return
  detailVisible.value = false
  handleEdit(detailIdea.value)
}

function handleEdit(idea: BrainstormItem) {
  isEdit.value = true
  editingId.value = idea.id
  form.value = {
    content: idea.content,
    tags: formatTags(idea.tags),
  }
  dialogVisible.value = true
}

async function handleDelete(idea: BrainstormItem) {
  try {
    await ElMessageBox.confirm('确认删除这条想法吗？', '提示', { type: 'warning' })
    await deleteBrainstormApi(idea.id)
    await fetchData()
    ElMessage.success('删除成功')
  } catch (error) {
    if (error !== 'cancel') {
      console.error(error)
    }
  }
}

async function submitForm() {
  if (!formRef.value) return
  try {
    await formRef.value.validate()
    const tagsStr = form.value.tags.join(',')

    if (isEdit.value && editingId.value) {
      await updateBrainstormApi({
        id: editingId.value,
        content: form.value.content,
        tags: tagsStr
      })
      ElMessage.success('更新成功')
    } else {
      await addBrainstormApi({
        content: form.value.content,
        tags: tagsStr
      })
      ElMessage.success('添加成功')
    }
    dialogVisible.value = false
    await fetchData()
  } catch (error) {
    if (error !== 'cancel') {
      console.error(error)
    }
  }
}

async function fetchData() {
  loading.value = true
  try {
    const params: any = {
      pageNum: 1,
      pageSize: 1000,
    }
    if (dateRange.value && dateRange.value.length === 2) {
      params.startDate = dateRange.value[0]
      params.endDate = dateRange.value[1]
    }
    if (searchKeyword.value) {
      params.keyword = searchKeyword.value
    }
    if (filterTag.value) {
      params.tag = filterTag.value
    }
    const { data } = await getBrainstormPageApi(params)
    ideas.value = data.list || []
  } catch (error) {
    console.error(error)
  } finally {
    loading.value = false
  }
}

function handleQuery() {
  fetchData()
}

onMounted(() => {
  fetchData()
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
    border: 1px solid var(--border-color);
    background: transparent;
    transition: all 0.2s ease;

    &:hover {
      border-color: var(--el-color-primary);
    }

    &.is-checked {
      background: var(--el-color-primary);
      border-color: var(--el-color-primary);
      color: #fff;
    }
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

// 对话框通用样式
.dialog-header {
  display: flex;
  align-items: center;
  gap: 10px;

  .dialog-emoji {
    font-size: 22px;
  }

  .dialog-title {
    font-size: 16px;
    font-weight: 600;
    color: var(--text-primary);
  }
}

.detail-content {
  padding: 20px 0;
  font-size: 15px;
  line-height: 1.9;
  color: var(--text-primary);
  white-space: pre-wrap;
  word-break: break-word;
  min-height: 120px;

  p {
    margin: 0;
  }
}

.detail-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 16px;
  border-top: 1px solid var(--border-color-light);

  .detail-time {
    font-size: 13px;
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
    height: 4px;
    background: linear-gradient(90deg, var(--tag-color, var(--el-color-primary)), var(--el-color-success));
    opacity: 0;
    transition: opacity 0.3s ease;
  }

  &::after {
    content: '';
    position: absolute;
    top: -30px;
    right: -30px;
    width: 100px;
    height: 100px;
    border-radius: 50%;
    background: radial-gradient(circle, var(--tag-color, var(--el-color-primary-light-5)) 0%, transparent 70%);
    opacity: 0.15;
    transition: all 0.3s ease;
    pointer-events: none;
  }

  &:hover {
    transform: translateY(-6px) scale(1.02);
    box-shadow: 0 16px 32px rgba(0,0,0,0.12), 0 0 0 1px var(--tag-color, var(--el-color-primary-light-5));
    border-color: transparent;

    &::before {
      opacity: 1;
    }

    &::after {
      opacity: 0.25;
      transform: scale(1.5);
    }

    .card-actions {
      opacity: 1;
    }

    .card-emoji {
      transform: scale(1.15);
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
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 14px;

  .card-emoji {
    font-size: 28px;
    line-height: 1;
    transition: transform 0.3s ease;
    filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));
  }

  .card-actions {
    display: flex;
    gap: 2px;
    opacity: 0.5;
    transition: opacity 0.2s ease;

    &:hover {
      opacity: 1;
    }
  }

  .card-action-btn {
    padding: 4px;
    display: inline-flex;
    align-items: center;
    justify-content: center;

    .el-icon {
      display: flex;
      align-items: center;
      justify-content: center;
    }
  }
}

.card-content {
  font-size: 14px;
  color: var(--text-primary);
  line-height: 1.8;
  margin-bottom: 16px;
  white-space: pre-wrap;
  word-break: break-word;
  min-height: 50px;
  position: relative;
  padding-left: 16px;

  &::before {
    content: '"';
    position: absolute;
    left: 0;
    top: -4px;
    font-size: 24px;
    font-weight: 700;
    color: var(--tag-color, var(--el-color-primary));
    opacity: 0.3;
    font-family: Georgia, serif;
  }
}

.expand-btn {
  color: var(--el-color-primary);
  cursor: pointer;
  font-size: 12px;
  margin-left: 4px;
  &:hover {
    text-decoration: underline;
  }
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

// 详情弹窗
:deep(.detail-dialog.el-dialog) {
  .el-dialog__header {
    padding: 16px 20px;
    border-bottom: 1px solid var(--border-color);
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-right: 0;

    .el-dialog__title {
      font-size: 16px;
      font-weight: 600;
    }

    .el-dialog__headerbtn {
      position: static;
      top: auto;
      right: auto;
      font-size: 18px;

      .el-dialog__close {
        color: var(--text-secondary);
        transition: color 0.2s;

        &:hover {
          color: var(--el-color-primary);
        }
      }
    }
  }
}

// 编辑弹窗
:deep(.brainstorm-edit-dialog.el-dialog) {
  .el-dialog__header {
    padding: 16px 20px;
    border-bottom: 1px solid var(--border-color);
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-right: 0;

    .el-dialog__title {
      font-size: 16px;
      font-weight: 600;
    }

    .el-dialog__headerbtn {
      position: static;
      top: auto;
      right: auto;
      font-size: 18px;

      .el-dialog__close {
        color: var(--text-secondary);
        transition: color 0.2s;

        &:hover {
          color: var(--el-color-primary);
        }
      }
    }
  }
}
</style>
