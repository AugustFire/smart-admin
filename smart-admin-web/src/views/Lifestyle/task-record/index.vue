<template>
  <div class="task-record-container">
    <!-- 顶部工具栏 -->
    <div class="top-bar">
      <div class="left">
        <el-button type="primary" @click="handleAdd">
          <el-icon><Plus /></el-icon>
          新建任务
        </el-button>
      </div>
      <div class="right">
        <el-input
          v-model="searchKeyword"
          placeholder="搜索任务..."
          style="width: 200px"
          clearable
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
        <el-select v-model="filterStatus" placeholder="状态" style="width: 120px" clearable>
          <el-option label="全部" value="" />
          <el-option label="待办" value="todo" />
          <el-option label="进行中" value="in-progress" />
          <el-option label="已完成" value="done" />
        </el-select>
        <el-dropdown trigger="click" @command="viewMode = $event">
          <el-button type="default">
            {{ viewLabels[viewMode] }}
            <el-icon style="margin-left: 4px"><ArrowDown /></el-icon>
          </el-button>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item command="list">列表视图</el-dropdown-item>
              <el-dropdown-item command="gantt">甘特图视图</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </div>

    <!-- 统计概览 -->
    <div class="stats-bar">
      <div class="stat-chip" :class="{ active: !filterStatus }" @click="filterStatus = ''">
        <div class="stat-icon all">
          <el-icon><List /></el-icon>
        </div>
        <div class="stat-info">
          <span class="chip-num">{{ tasks.length }}</span>
          <span class="chip-label">全部任务</span>
        </div>
      </div>
      <div class="stat-divider"></div>
      <div class="stat-chip todo" :class="{ active: filterStatus === 'todo' }" @click="filterStatus = 'todo'">
        <div class="stat-icon">
          <el-icon><Clock /></el-icon>
        </div>
        <div class="stat-info">
          <span class="chip-num">{{ statusCounts.todo }}</span>
          <span class="chip-label">待完成</span>
        </div>
      </div>
      <div class="stat-chip progress" :class="{ active: filterStatus === 'in-progress' }" @click="filterStatus = 'in-progress'">
        <div class="stat-icon">
          <el-icon><Loading /></el-icon>
        </div>
        <div class="stat-info">
          <span class="chip-num">{{ statusCounts['in-progress'] }}</span>
          <span class="chip-label">进行中</span>
        </div>
      </div>
      <div class="stat-chip done" :class="{ active: filterStatus === 'done' }" @click="filterStatus = 'done'">
        <div class="stat-icon">
          <el-icon><CircleCheck /></el-icon>
        </div>
        <div class="stat-info">
          <span class="chip-num">{{ statusCounts.done }}</span>
          <span class="chip-label">已完成</span>
        </div>
      </div>
    </div>

    <!-- 视图切换提示 -->
    <div class="view-toggle">
      <el-radio-group v-model="viewMode">
        <el-radio-button value="list">
          <el-icon><List /></el-icon>
          列表视图
        </el-radio-button>
        <el-radio-button value="gantt">
          <el-icon><Histogram /></el-icon>
          甘特图视图
        </el-radio-button>
      </el-radio-group>
    </div>

    <!-- 列表视图 -->
    <div v-if="viewMode === 'list'" class="list-view">
      <div v-if="filteredTasks.length === 0" class="empty-state">
        <div class="empty-content">
          <el-icon class="empty-icon"><Document /></el-icon>
          <p class="empty-text">暂无任务</p>
          <p class="empty-hint">点击上方「新建任务」开始记录</p>
        </div>
      </div>
      <div v-else class="task-list">
        <div
          v-for="task in filteredTasks"
          :key="task.id"
          class="task-card"
          :class="[`status-${task.status}`]"
        >
          <div class="task-card-main">
            <div class="task-checkbox">
              <el-checkbox
                :model-value="task.status === 'done'"
                @change="handleToggleStatus(task)"
              />
            </div>
            <div class="task-info">
              <div class="task-title-row">
                <span class="task-title" :class="{ done: task.status === 'done' }">{{ task.title }}</span>
                <el-tag size="small" :type="task.status === 'done' ? 'success' : task.status === 'in-progress' ? 'primary' : 'info'" effect="plain">
                  {{ task.status === 'todo' ? '待办' : task.status === 'in-progress' ? '进行中' : '已完成' }}
                </el-tag>
              </div>
              <div class="task-meta-row">
                <span class="task-date">
                  <el-icon><Calendar /></el-icon>
                  {{ task.startDate }} ~ {{ task.endDate }}
                </span>
                <span v-if="task.tags?.length" class="task-tags">
                  <el-tag v-for="tag in task.tags.slice(0, 2)" :key="tag" size="small" effect="plain">{{ tag }}</el-tag>
                </span>
              </div>
            </div>
          </div>
          <div class="task-card-side">
            <div class="task-progress-mini">
              <el-progress
                :percentage="task.progress"
                :status="getProgressStatus(task.status)"
                :stroke-width="4"
                :show-text="false"
              />
              <span class="progress-text">{{ task.progress }}%</span>
            </div>
            <div class="task-actions">
              <el-button link type="primary" @click="handleEdit(task)">
                <el-icon><Edit /></el-icon>
              </el-button>
              <el-button link type="danger" @click="handleDelete(task)">
                <el-icon><Delete /></el-icon>
              </el-button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 甘特图视图 -->
    <div v-else class="gantt-view">
      <div v-if="filteredTasks.length === 0" class="empty-state">
        <el-empty description="暂无任务" />
      </div>
      <div v-else class="gantt-container">
        <div v-if="isDateRangeTruncated" class="gantt-warning">
          <el-icon><Warning /></el-icon>
          <span>日期范围已限制为60天，超出范围的任务将不显示</span>
        </div>
        <div class="gantt-scroll" ref="ganttScrollRef">
          <!-- 时间轴头部 -->
          <div class="gantt-timeline">
            <div class="timeline-left">
              <div class="timeline-header-title">任务名称</div>
            </div>
            <div class="timeline-dates" :style="{ gridTemplateColumns: `repeat(${timelineDates.length}, 40px)` }">
              <div
                v-for="date in timelineDates"
                :key="date"
                class="timeline-date"
                :class="{ today: date === todayStr }"
              >
                {{ formatDateShort(date) }}
              </div>
            </div>
          </div>
          <!-- 甘特图主体 -->
          <div class="gantt-body">
            <div
              v-for="task in filteredTasks"
              :key="task.id"
              class="gantt-row"
            >
              <div class="row-left">
                <el-checkbox
                  :model-value="task.status === 'done'"
                  @change="handleToggleStatus(task)"
                />
                <span class="row-title" :class="{ done: task.status === 'done' }">
                  {{ task.title }}
                </span>
              </div>
              <div class="row-bars" :style="{ gridTemplateColumns: `repeat(${timelineDates.length}, 40px)` }">
                <div
                  v-for="date in timelineDates"
                  :key="date"
                  class="bar-cell"
                  :class="{ today: date === todayStr }"
                />
                <!-- 任务条使用绝对定位 -->
                <div
                  class="gantt-bar"
                  :class="task.status"
                  :style="getGanttBarStyle(task)"
                >
                  <span class="bar-text">{{ task.progress }}%</span>
                </div>
              </div>
            </div>
          </div>
        </div>
        <!-- 进度指示 -->
        <div class="gantt-legend">
          <div class="legend-item">
            <span class="legend-bar todo"></span>
            <span>待办</span>
          </div>
          <div class="legend-item">
            <span class="legend-bar in-progress"></span>
            <span>进行中</span>
          </div>
          <div class="legend-item">
            <span class="legend-bar done"></span>
            <span>已完成</span>
          </div>
        </div>
      </div>
    </div>

    <!-- 新建/编辑对话框 -->
    <el-dialog
      :title="dialogTitle"
      v-model="dialogVisible"
      width="560px"
      :close-on-click-modal="false"
    >
      <el-form ref="formRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="任务标题" prop="title">
          <el-input v-model="form.title" placeholder="请输入任务标题" />
        </el-form-item>
        <el-form-item label="任务描述" prop="description">
          <el-input v-model="form.description" type="textarea" :rows="3" placeholder="请输入任务描述" />
        </el-form-item>
        <el-form-item label="开始日期" prop="startDate">
          <el-date-picker
            v-model="form.startDate"
            type="date"
            placeholder="选择开始日期"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="结束日期" prop="endDate">
          <el-date-picker
            v-model="form.endDate"
            type="date"
            placeholder="选择结束日期"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="进度" prop="progress">
          <el-slider v-model="form.progress" :min="0" :max="100" show-input />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio value="todo">待办</el-radio>
            <el-radio value="in-progress">进行中</el-radio>
            <el-radio value="done">已完成</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="标签" prop="tags">
          <el-input v-model="form.tagsInput" placeholder="多个标签用逗号分隔" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox, type FormInstance, type FormRules } from 'element-plus'
import { Plus, Edit, Delete, Search, List, Histogram, Calendar, ArrowDown, Warning, Clock, Loading, CircleCheck, Document } from '@element-plus/icons-vue'
import dayjs from 'dayjs'
import type { TaskItem } from '@/api/lifestyle/task-record'

const STORAGE_KEY = 'task_record_tasks'

const searchKeyword = ref('')
const filterStatus = ref('')
const viewMode = ref<'list' | 'gantt'>('list')
const dialogVisible = ref(false)
const isEdit = ref(false)
const formRef = ref<FormInstance>()
const tasks = ref<TaskItem[]>([])
const editingProgressId = ref('')
const editingProgressValue = ref(0)

const todayStr = dayjs().format('YYYY-MM-DD')

const form = ref<{
  id?: string
  title: string
  description: string
  startDate: string
  endDate: string
  progress: number
  status: 'todo' | 'in-progress' | 'done'
  tagsInput: string
}>({
  title: '',
  description: '',
  startDate: dayjs().format('YYYY-MM-DD'),
  endDate: dayjs().add(7, 'day').format('YYYY-MM-DD'),
  progress: 0,
  status: 'todo',
  tagsInput: '',
})

const rules: FormRules = {
  title: [{ required: true, message: '请输入任务标题', trigger: 'blur' }],
  startDate: [{ required: true, message: '请选择开始日期', trigger: 'change' }],
  endDate: [{ required: true, message: '请选择结束日期', trigger: 'change' }],
}

const viewLabels: Record<string, string> = {
  list: '列表视图',
  gantt: '甘特图视图',
}

// 计算时间轴日期范围（限制最多显示60天）
const MAX_DAYS = 60

const timelineDates = computed(() => {
  if (filteredTasks.value.length === 0) {
    const dates: string[] = []
    for (let i = -3; i <= 10; i++) {
      dates.push(dayjs().add(i, 'day').format('YYYY-MM-DD'))
    }
    return dates
  }

  const allDates = filteredTasks.value.flatMap(t => [t.startDate, t.endDate])
  const minDate = dayjs(Math.min(...allDates.map(d => dayjs(d).valueOf())))
  const maxDate = dayjs(Math.max(...allDates.map(d => dayjs(d).valueOf())))

  // 计算总天数
  const totalDays = maxDate.diff(minDate, 'day') + 1

  // 如果超过60天，从开始日期往后取60天
  let startDate = minDate.subtract(2, 'day')
  let endDate = maxDate.add(3, 'day')

  if (totalDays > MAX_DAYS) {
    // 今天之前显示"..."，从今天往前30天开始
    const today = dayjs()
    startDate = today.subtract(30, 'day')
    endDate = today.add(29, 'day')
  }

  const dates: string[] = []
  let current = startDate

  while (current.isBefore(endDate) || current.isSame(endDate, 'day')) {
    if (dates.length >= MAX_DAYS) break
    dates.push(current.format('YYYY-MM-DD'))
    current = current.add(1, 'day')
  }

  return dates
})

const dialogTitle = computed(() => isEdit.value ? '编辑任务' : '新建任务')

const statusCounts = computed(() => ({
  todo: tasks.value.filter(t => t.status === 'todo').length,
  'in-progress': tasks.value.filter(t => t.status === 'in-progress').length,
  done: tasks.value.filter(t => t.status === 'done').length,
}))

const filteredTasks = computed(() => {
  let result = tasks.value

  if (searchKeyword.value) {
    const kw = searchKeyword.value.toLowerCase()
    result = result.filter(t =>
      t.title.toLowerCase().includes(kw) ||
      t.description?.toLowerCase().includes(kw)
    )
  }

  if (filterStatus.value) {
    result = result.filter(t => t.status === filterStatus.value)
  }

  return result.sort((a, b) => {
    if (a.status === 'done' && b.status !== 'done') return 1
    if (a.status !== 'done' && b.status === 'done') return -1
    return dayjs(b.startDate).valueOf() - dayjs(a.startDate).valueOf()
  })
})

// 是否截断日期范围
const isDateRangeTruncated = computed(() => {
  if (filteredTasks.value.length === 0) return false

  const allDates = filteredTasks.value.flatMap(t => [t.startDate, t.endDate])
  const minDate = dayjs(Math.min(...allDates.map(d => dayjs(d).valueOf())))
  const maxDate = dayjs(Math.max(...allDates.map(d => dayjs(d).valueOf())))
  const totalDays = maxDate.diff(minDate, 'day') + 1

  return totalDays > MAX_DAYS
})

function getProgressStatus(taskStatus: string) {
  if (taskStatus === 'done') return 'success'
  if (taskStatus === 'in-progress') return 'primary'
  return 'info'
}

function isDateInRange(date: string, start: string, end: string) {
  return date >= start && date <= end
}

function getStartIndex(date: string) {
  const idx = timelineDates.value.indexOf(date)
  // 如果日期不在范围内，返回边界值
  if (idx === -1) {
    // 检查日期是否在范围之外
    const firstDate = timelineDates.value[0]
    const lastDate = timelineDates.value[timelineDates.value.length - 1]
    if (date < firstDate) return 0
    if (date > lastDate) return timelineDates.value.length - 1
  }
  return idx
}

function getGanttBarStyle(task: TaskItem) {
  const startIdx = getStartIndex(task.startDate)
  const endIdx = getStartIndex(task.endDate)

  // 如果任一日期无效，返回空样式
  if (startIdx === -1 || endIdx === -1) {
    return { display: 'none' }
  }

  const days = Math.max(endIdx - startIdx + 1, 1)

  return {
    left: `${startIdx * 40 + 8}px`,
    width: `${days * 40 - 16}px`,
  }
}

function formatDateShort(date: string) {
  const d = dayjs(date)
  return `${d.month() + 1}/${d.date()}`
}

function handleAdd() {
  isEdit.value = false
  form.value = {
    title: '',
    description: '',
    startDate: dayjs().format('YYYY-MM-DD'),
    endDate: dayjs().add(7, 'day').format('YYYY-MM-DD'),
    progress: 0,
    status: 'todo',
    tagsInput: '',
  }
  dialogVisible.value = true
}

function handleEdit(task: TaskItem) {
  isEdit.value = true
  form.value = {
    id: task.id,
    title: task.title,
    description: task.description || '',
    startDate: task.startDate,
    endDate: task.endDate,
    progress: task.progress,
    status: task.status,
    tagsInput: task.tags.join(', '),
  }
  dialogVisible.value = true
}

function handleDelete(task: TaskItem) {
  ElMessageBox.confirm(`确认删除任务「${task.title}」吗？`, '提示', { type: 'warning' }).then(() => {
    tasks.value = tasks.value.filter(t => t.id !== task.id)
    saveToStorage()
    ElMessage.success('删除成功')
  })
}

function handleToggleStatus(task: TaskItem) {
  if (task.status === 'done') {
    task.status = 'todo'
    task.progress = 0
    task.completedAt = undefined
  } else {
    task.status = 'done'
    task.progress = 100
    task.completedAt = new Date().toISOString()
  }
  saveToStorage()
}

function startEditProgress(task: TaskItem) {
  editingProgressId.value = task.id
  editingProgressValue.value = task.progress
}

function saveProgress(task: TaskItem) {
  if (editingProgressId.value !== task.id) return

  task.progress = editingProgressValue.value
  if (task.progress === 100 && task.status !== 'done') {
    task.status = 'done'
    task.completedAt = new Date().toISOString()
  } else if (task.progress < 100 && task.status === 'done') {
    task.status = 'in-progress'
    task.completedAt = undefined
  }

  saveToStorage()
  editingProgressId.value = ''
  ElMessage.success('进度已更新')
}

function submitForm() {
  if (!formRef.value) return
  formRef.value.validate((valid) => {
    if (!valid) return

    const tags = form.value.tagsInput
      .split(',')
      .map(t => t.trim())
      .filter(t => t)

    if (isEdit.value && form.value.id) {
      const task = tasks.value.find(t => t.id === form.value.id)
      if (task) {
        task.title = form.value.title
        task.description = form.value.description
        task.startDate = form.value.startDate
        task.endDate = form.value.endDate
        task.progress = form.value.progress
        task.status = form.value.status
        task.tags = tags
      }
    } else {
      const newTask: TaskItem = {
        id: Date.now().toString(),
        title: form.value.title,
        description: form.value.description,
        startDate: form.value.startDate,
        endDate: form.value.endDate,
        progress: form.value.progress,
        status: form.value.status,
        tags,
        createdAt: new Date().toISOString(),
      }
      tasks.value.push(newTask)
    }

    saveToStorage()
    dialogVisible.value = false
    ElMessage.success('保存成功')
  })
}

function loadFromStorage() {
  try {
    const data = localStorage.getItem(STORAGE_KEY)
    if (data) tasks.value = JSON.parse(data)
  } catch (e) {
    console.error(e)
  }
}

function saveToStorage() {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(tasks.value))
  } catch (e) {
    console.error(e)
  }
}

onMounted(() => {
  loadFromStorage()
})
</script>

<style lang="scss" scoped>
.task-record-container {
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

.stats-bar {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 16px 24px;
  background: var(--bg-primary);
  border-radius: var(--card-radius);
  border: 1px solid var(--border-color);
  margin-bottom: 16px;

  .stat-chip {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px 20px;
    border-radius: 12px;
    cursor: pointer;
    transition: all 0.3s ease;
    flex: 1;

    .stat-icon {
      width: 40px;
      height: 40px;
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 18px;
      color: #fff;
      transition: all 0.3s ease;

      &.all {
        background: linear-gradient(135deg, var(--el-color-primary) 0%, var(--el-color-primary-light-3) 100%);
      }

      &.todo {
        background: linear-gradient(135deg, var(--el-color-info) 0%, #606266 100%);
      }

      &.progress {
        background: linear-gradient(135deg, var(--el-color-primary) 0%, var(--el-color-primary-light-3) 100%);
      }

      &.done {
        background: linear-gradient(135deg, var(--el-color-success) 0%, #529b2e 100%);
      }
    }

    .stat-info {
      display: flex;
      flex-direction: column;
      gap: 2px;
    }

    .chip-num {
      font-size: 24px;
      font-weight: 700;
      color: var(--text-primary);
      font-feature-settings: 'tnum';
      line-height: 1;
    }

    .chip-label {
      font-size: 12px;
      color: var(--text-secondary);
    }

    &:hover {
      background: var(--bg-secondary);
    }

    &.active {
      background: var(--el-color-primary-light-9);
    }

    &.active.todo {
      background: var(--el-color-info-light);
      .stat-icon { transform: scale(1.05); }
    }
    &.active.progress {
      background: var(--el-color-primary-light-9);
      .stat-icon { transform: scale(1.05); }
    }
    &.active.done {
      background: var(--el-color-success-light);
      .stat-icon { transform: scale(1.05); }
    }
  }

  .stat-divider {
    width: 1px;
    height: 48px;
    background: linear-gradient(to bottom, transparent, var(--border-color), transparent);
  }
}

.view-toggle {
  display: flex;
  justify-content: center;
  margin-bottom: 16px;

  :deep(.el-radio-group) {
    background: var(--bg-primary);
    padding: 4px;
    border-radius: 24px;
    border: 1px solid var(--border-color);
  }

  :deep(.el-radio-button__inner) {
    display: flex;
    align-items: center;
    gap: 6px;
    padding: 8px 20px;
    border: none;
    border-radius: 20px;
    font-size: 13px;
    transition: all 0.2s ease;
  }

  :deep(.el-radio-button__original-radio:checked + .el-radio-button__inner) {
    background: var(--el-color-primary);
    color: #fff;
    box-shadow: 0 2px 8px rgba(64, 158, 255, 0.3);
  }
}

.empty-state {
  padding: 80px 0;
}

.empty-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;

  .empty-icon {
    font-size: 64px;
    color: var(--text-secondary);
    opacity: 0.3;
  }

  .empty-text {
    font-size: 16px;
    font-weight: 600;
    color: var(--text-primary);
    margin: 0;
  }

  .empty-hint {
    font-size: 13px;
    color: var(--text-secondary);
    margin: 0;
  }
}

// 列表视图
.task-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.task-card {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  padding: 14px 16px;
  background: var(--bg-primary);
  border: 1px solid var(--border-color);
  border-radius: var(--card-radius);
  transition: all 0.2s ease;
  position: relative;

  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 3px;
    height: 100%;
    border-radius: 3px 0 0 3px;
  }

  &.status-todo::before { background: var(--el-color-info); }
  &.status-in-progress::before { background: var(--el-color-primary); }
  &.status-done::before { background: var(--el-color-success); }

  &:hover {
    border-color: var(--el-color-primary-light-5);
    box-shadow: 0 4px 12px rgba(0,0,0,0.06);
  }

  &.status-done { opacity: 0.7; }
}

.task-card-main {
  display: flex;
  align-items: center;
  gap: 12px;
  flex: 1;
  min-width: 0;
}

.task-card-side {
  display: flex;
  align-items: center;
  gap: 16px;
  flex-shrink: 0;
}

.task-checkbox {
  flex-shrink: 0;
}

.task-info {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.task-title-row {
  display: flex;
  align-items: center;
  gap: 10px;
}

.task-meta-row {
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: 12px;
  color: var(--text-secondary);
}

.task-content {
  flex: 1;
  min-width: 0;
}

.task-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 8px;
  gap: 12px;

  .task-title {
    font-size: 16px;
    font-weight: 600;
    color: var(--text-primary);
    flex: 1;
    line-height: 1.4;

    &.done {
      text-decoration: line-through;
      color: var(--text-secondary);
    }
  }

  .task-status-badge {
    flex-shrink: 0;
    padding: 4px 10px;
    border-radius: 12px;
    font-size: 11px;
    font-weight: 600;

    &.todo {
      background: var(--el-color-info-light);
      color: var(--el-color-info);
    }

    &.in-progress {
      background: var(--el-color-primary-light-9);
      color: var(--el-color-primary);
    }

    &.done {
      background: var(--el-color-success-light);
      color: var(--el-color-success);
    }
  }
}

.task-desc {
  font-size: 13px;
  color: var(--text-secondary);
  margin-bottom: 10px;
  line-height: 1.6;
}

.task-meta {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 12px;
  flex-wrap: wrap;

  .task-date {
    display: flex;
    align-items: center;
    gap: 4px;
    font-size: 12px;
    color: var(--text-secondary);
    background: var(--bg-secondary);
    padding: 4px 10px;
    border-radius: 12px;
  }

  .task-tags {
    display: flex;
    gap: 6px;

    :deep(.el-tag) {
      border-radius: 10px;
      padding: 0 8px;
      height: 22px;
      line-height: 20px;
      font-size: 11px;
    }
  }
}

.task-progress {
  .progress-label {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 6px;

    .progress-title {
      font-size: 12px;
      color: var(--text-secondary);
    }

    .progress-value {
      cursor: pointer;
      display: flex;
      align-items: center;
      gap: 4px;
      font-size: 12px;
      font-weight: 600;
      color: var(--el-color-primary);
      padding: 3px 10px;
      border-radius: 10px;
      transition: all 0.2s ease;

      .edit-icon {
        font-size: 11px;
        opacity: 0;
        transition: opacity 0.2s ease;
      }

      &:hover {
        background: var(--el-color-primary-light-9);

        .edit-icon {
          opacity: 1;
        }
      }
    }
  }

  .progress-bar-wrap {
    :deep(.el-progress-bar__outer) {
      border-radius: 6px;
    }

    :deep(.el-progress-bar__inner) {
      border-radius: 6px;
      transition: width 0.4s ease;
    }
  }
}

.task-actions {
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  gap: 4px;
  opacity: 0;
  transition: opacity 0.2s ease;

  .task-card:hover & {
    opacity: 1;
  }
}

// 甘特图视图
.gantt-view {
  background: var(--bg-primary);
  border-radius: var(--card-radius);
  border: 1px solid var(--border-color);
  overflow: hidden;
}

.gantt-container {
  display: flex;
  flex-direction: column;
}

.gantt-warning {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 16px;
  background: var(--el-color-warning-light);
  color: var(--el-color-warning);
  font-size: 12px;
  border-bottom: 1px solid var(--el-color-warning);
}

.gantt-scroll {
  overflow-x: auto;
  display: flex;
  flex-direction: column;
}

.gantt-timeline {
  display: flex;
  border-bottom: 1px solid var(--border-color);
  background: var(--bg-secondary);
  position: sticky;
  top: 0;
  z-index: 2;

  .timeline-left {
    width: 220px;
    flex-shrink: 0;
    padding: 14px 20px;
    border-right: 1px solid var(--border-color);
    position: sticky;
    left: 0;
    background: var(--bg-secondary);
    z-index: 3;

    .timeline-header-title {
      font-size: 13px;
      font-weight: 600;
      color: var(--text-primary);
    }
  }

  .timeline-dates {
    display: grid;
  }

  .timeline-date {
    width: 40px;
    height: 48px;
    flex-shrink: 0;
    padding: 8px 4px;
    text-align: center;
    font-size: 11px;
    color: var(--text-secondary);
    border-right: 1px solid var(--border-color-light);
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s ease;

    &.today {
      background: var(--el-color-primary-light-9);
      color: var(--el-color-primary);
      font-weight: 600;
    }
  }
}

.gantt-body {
  .gantt-row {
    display: flex;
    border-bottom: 1px solid var(--border-color-light);
    min-height: 48px;
    transition: all 0.2s ease;

    &:last-child {
      border-bottom: none;
    }

    &:hover {
      background: var(--bg-secondary);

      .row-left {
        background: var(--bg-secondary);
      }
    }
  }

  .row-left {
    width: 220px;
    flex-shrink: 0;
    padding: 12px 20px;
    border-right: 1px solid var(--border-color);
    display: flex;
    align-items: center;
    gap: 10px;
    position: sticky;
    left: 0;
    background: var(--bg-primary);
    z-index: 1;

    .row-title {
      font-size: 13px;
      color: var(--text-primary);
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
      font-weight: 500;

      &.done {
        text-decoration: line-through;
        color: var(--text-secondary);
      }
    }
  }

  .row-bars {
    display: grid;
    position: relative;
    height: 48px;
  }

  .bar-cell {
    width: 40px;
    height: 48px;
    border-right: 1px solid var(--border-color-light);

    &.today {
      background: rgba(64, 158, 255, 0.08);
    }
  }

  .gantt-bar {
    position: absolute;
    top: 12px;
    height: 24px;
    border-radius: 6px;
    display: flex;
    align-items: center;
    padding: 0 10px;
    min-width: 35px;
    z-index: 1;
    transition: all 0.3s ease;
    cursor: pointer;

    &:hover {
      transform: scaleY(1.1);
      box-shadow: 0 2px 8px rgba(0,0,0,0.15);
    }

    &.todo {
      background: linear-gradient(90deg, #6b7280, #9ca3af);
    }

    &.in-progress {
      background: linear-gradient(90deg, #3b82f6, #60a5fa);
    }

    &.done {
      background: linear-gradient(90deg, #10b981, #34d399);
    }

    .bar-text {
      font-size: 11px;
      font-weight: 600;
      color: #fff;
      white-space: nowrap;
    }
  }
}

.gantt-legend {
  display: flex;
  gap: 24px;
  padding: 12px 20px;
  border-top: 1px solid var(--border-color);
  background: var(--bg-secondary);

  .legend-item {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 12px;
    color: var(--text-secondary);

    .legend-bar {
      width: 24px;
      height: 10px;
      border-radius: 3px;

      &.todo { background: linear-gradient(90deg, #6b7280, #9ca3af); }
      &.in-progress { background: linear-gradient(90deg, #3b82f6, #60a5fa); }
      &.done { background: linear-gradient(90deg, #10b981, #34d399); }
    }
  }
}

// 响应式
@media (max-width: 768px) {
  .stats-bar {
    flex-wrap: wrap;
    gap: 12px;

    .stat-chip {
      flex: 1 1 calc(50% - 6px);
      min-width: 140px;
    }

    .stat-divider {
      display: none;
    }
  }

  .task-card {
    flex-direction: column;
    gap: 12px;

    .task-actions {
      flex-direction: row;
      opacity: 1;
    }
  }

  .task-header {
    flex-direction: column;
    gap: 8px;
  }
}
</style>
