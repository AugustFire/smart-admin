<template>
  <div class="diet-container">
    <!-- 顶部工具栏 -->
    <div class="top-bar">
      <div class="left">
        <DateRangePicker v-model="dateRange" @change="handleQuery" />
        <el-button type="primary" @click="handleQuery">
          <el-icon><Search /></el-icon>
        </el-button>
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
              <el-dropdown-item command="calendar">日历</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
        <el-button @click="handleExport">
          <el-icon><Download /></el-icon>
        </el-button>
      </div>
    </div>

    <!-- 标语横幅 -->
    <div class="tip-banner">
      <span class="tip-icon">💡</span>
      <span class="tip-text">{{ randomTip }}</span>
    </div>

    <!-- 统计栏 -->
    <div class="stats-bar">
      <div class="stat-chip">
        <span class="chip-num">{{ records.length }}</span>
        <span class="chip-label">条记录</span>
      </div>
      <div class="stat-divider"></div>
      <div v-for="meal in mealTypes" :key="meal.value" class="stat-chip">
        <span class="chip-emoji">{{ getMealEmoji(meal.value) }}</span>
        <span class="chip-num">{{ getMealRecords(meal.value).length }}</span>
      </div>
    </div>

    <!-- 卡片视图 -->
    <div v-if="viewMode === 'card'" class="card-view">
      <div class="card-grid">
        <div class="diet-card add-card" @click="handleAdd">
          <div class="add-inner">
            <el-icon class="add-icon"><Plus /></el-icon>
            <span class="add-text">添加记录</span>
          </div>
        </div>
        <div
          v-for="record in records"
          :key="record.id"
          class="diet-card"
        >
          <div class="card-glow" :style="{ background: `linear-gradient(135deg, ${getMealColor(record.mealType)}22 0%, transparent 60%)` }"></div>
          <div class="card-inner">
            <div class="card-top">
              <div class="meal-icon" :style="{ background: getMealColor(record.mealType) }">
                {{ getMealEmoji(record.mealType) }}
              </div>
              <div class="meal-meta">
                <span class="meal-name">{{ record.mealTypeName }}</span>
                <span class="meal-time">{{ record.recordDate }} {{ formatTime(record.mealTime) }}</span>
              </div>
              <span class="mood-emoji">{{ record.moodName }}</span>
            </div>
            <div class="card-food">
              <span class="food-name">{{ record.foodName }}</span>
              <span v-if="record.portion" class="food-portion">{{ record.portion }}</span>
            </div>
            <div v-if="record.tagNames" class="card-tags">
              <el-tag v-for="tag in (record.tagNames || '').split('、')" :key="tag" size="small" effect="plain" :type="getTagType(tag)">{{ tag }}</el-tag>
            </div>
            <div class="card-footer">
              <el-button link type="primary" @click="handleEdit(record)">
                <el-icon><Edit /></el-icon>
              </el-button>
              <el-button link type="danger" @click="handleDelete(record)">
                <el-icon><Delete /></el-icon>
              </el-button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 时间线视图 -->
    <div v-else-if="viewMode === 'timeline'" class="timeline-view">
      <div v-if="groupedRecords.length === 0" class="empty-state">
        <el-empty description="暂无记录，点击上方添加" />
      </div>
      <div v-else class="timeline-groups">
        <div v-for="group in groupedRecords" :key="group.date" class="timeline-group">
          <div class="group-header">
            <div class="group-date-wrap">
              <span class="group-date">{{ formatGroupDate(group.date) }}</span>
              <span class="group-total">{{ group.records.length }} 条</span>
            </div>
          </div>
          <div class="group-items">
            <div
              v-for="(record, idx) in group.records"
              :key="record.id"
              class="timeline-row"
            >
              <div class="row-line">
                <div class="row-dot" :style="{ background: getMealColor(record.mealType) }">
                  {{ getMealEmoji(record.mealType) }}
                </div>
                <div v-if="idx < group.records.length - 1" class="row-connector"></div>
              </div>
              <div class="row-content">
                <div class="row-header">
                  <div class="row-left">
                    <span class="row-type" :style="{ color: getMealColor(record.mealType) }">{{ record.mealTypeName }}</span>
                    <span class="row-time">{{ formatTime(record.mealTime) }}</span>
                    <span class="row-mood">{{ record.moodName }}</span>
                  </div>
                  <div class="row-actions">
                    <el-button link type="primary" @click="handleEdit(record)">
                      <el-icon><Edit /></el-icon>
                    </el-button>
                    <el-button link type="danger" @click="handleDelete(record)">
                      <el-icon><Delete /></el-icon>
                    </el-button>
                  </div>
                </div>
                <div class="row-food">
                  <span class="food-name">{{ record.foodName }}</span>
                  <span v-if="record.portion" class="food-portion">{{ record.portion }}</span>
                </div>
                <div v-if="record.tagNames" class="row-tags">
                  <el-tag v-for="tag in (record.tagNames || '').split('、')" :key="tag" size="small" effect="plain" :type="getTagType(tag)">{{ tag }}</el-tag>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 日历视图 -->
    <div v-else-if="viewMode === 'calendar'" class="calendar-view">
      <div class="calendar-toolbar">
        <el-button-group>
          <el-button size="small" @click="prevCalendar">
            <el-icon><ArrowLeft /></el-icon>
          </el-button>
          <el-button size="small" @click="nextCalendar">
            <el-icon><ArrowRight /></el-icon>
          </el-button>
        </el-button-group>
        <span class="calendar-title">{{ calendarTitle }}</span>
        <el-button-group>
          <el-button :type="calendarViewMode === 'week' ? 'primary' : 'default'" size="small" @click="calendarViewMode = 'week'">周</el-button>
          <el-button :type="calendarViewMode === 'month' ? 'primary' : 'default'" size="small" @click="calendarViewMode = 'month'">月</el-button>
        </el-button-group>
        <el-button size="small" @click="goToToday">今天</el-button>
      </div>

      <!-- 周视图 -->
      <div v-if="calendarViewMode === 'week'" class="week-grid">
        <div class="week-header">
          <div v-for="(label, i) in weekLabels" :key="i" class="week-label">{{ label }}</div>
        </div>
        <div class="week-cells">
          <div
            v-for="cell in weekCells"
            :key="cell.date"
            class="week-cell"
            :class="{ 'is-today': cell.isToday, 'has-data': cell.count > 0 }"
            @click="cell.count > 0 && selectDate(cell.date)"
          >
            <div class="week-cell-top">
              <span class="week-day-num">{{ cell.day }}</span>
              <span v-if="cell.count > 0" class="week-badge">{{ cell.count }}</span>
            </div>
            <div class="week-emojis">
              <span v-for="meal in cell.meals" :key="meal.type">{{ getMealEmoji(meal.type) }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- 月视图 -->
      <div v-else class="month-grid">
        <div class="week-header">
          <div v-for="day in weekdays" :key="day" class="week-label">{{ day }}</div>
        </div>
        <div class="month-cells">
          <div
            v-for="cell in calendarCells"
            :key="cell.date"
            class="month-cell"
            :class="{ 'is-today': cell.isToday, 'is-other': !cell.isCurrentMonth, 'has-data': cell.count > 0 }"
            @click="cell.count > 0 && selectDate(cell.date)"
          >
            <span class="cell-num">{{ cell.day }}</span>
            <div v-if="cell.count > 0" class="cell-dots">
              <span v-for="meal in cell.meals.slice(0,3)" :key="meal.type" class="cell-dot" :style="{ background: getMealColor(meal.type) }"></span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 添加/编辑对话框 -->
    <el-dialog
      :title="dialogTitle"
      v-model="dialogVisible"
      width="520px"
      :close-on-click-modal="false"
    >
      <el-form ref="formRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="日期" prop="recordDate">
          <el-date-picker
            v-model="form.recordDate"
            type="date"
            placeholder="选择日期"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="时间" prop="mealTime">
          <el-time-select
            v-model="form.mealTime"
            placeholder="选择时间"
            style="width: 100%"
            start="00:00"
            step="00:15"
            end="23:45"
          />
        </el-form-item>
        <el-form-item label="餐食类型" prop="mealType">
          <el-select v-model="form.mealType" placeholder="请选择" style="width: 100%">
            <el-option
              v-for="meal in mealTypes"
              :key="meal.value"
              :label="meal.label"
              :value="meal.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="食物名称" prop="foodName">
          <el-autocomplete
            v-model="form.foodName"
            :fetch-suggestions="queryFoodHistory"
            placeholder="输入或选择"
            style="width: 100%"
            :trigger-on-focus="false"
            @select="handleFoodSelect"
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
          </el-autocomplete>
        </el-form-item>
        <el-form-item label="份量" prop="portion">
          <el-input v-model="form.portion" placeholder="如: 1份、2碗、半碗" />
        </el-form-item>
        <el-form-item label="标签" prop="tags">
          <div class="tag-group">
            <el-check-tag
              v-for="tag in availableTags"
              :key="tag.value"
              :checked="form.tags?.includes(tag.value)"
              @change="toggleTag(tag.value)"
            >
              {{ tag.label }}
            </el-check-tag>
          </div>
        </el-form-item>
        <el-form-item label="心情" prop="mood">
          <div class="mood-selector">
            <el-tooltip v-for="m in moods" :key="m.value" :content="m.label" placement="top">
              <el-button
                :type="form.mood === m.value ? 'primary' : 'default'"
                circle
                @click="form.mood = m.value"
              >
                {{ m.emoji }}
              </el-button>
            </el-tooltip>
          </div>
        </el-form-item>
        <el-form-item label="备注" prop="description">
          <el-input v-model="form.description" type="textarea" :rows="2" placeholder="备注信息" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm" :loading="submitting">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import dayjs from 'dayjs'
import { ElMessage, ElMessageBox, type FormInstance, type FormRules } from 'element-plus'
import { Plus, Edit, Delete, Search, Grid, Clock, Calendar, Download, ArrowLeft, ArrowRight, ArrowDown } from '@element-plus/icons-vue'
import * as XLSX from 'xlsx'
import {
  getDietPageApi,
  addDietApi,
  updateDietApi,
  deleteDietApi,
  getFoodHistoryApi,
  getFoodLatestApi,
  getMealLatestApi,
  type DietRecord,
  type DietRecordAddReq,
} from '@/api/lifestyle/diet'
import DateRangePicker from '@/components/DateRangePicker/index.vue'

const dateRange = ref<string[]>([
  dayjs().subtract(7, 'day').format('YYYY-MM-DD'),
  dayjs().format('YYYY-MM-DD')
])
const records = ref<DietRecord[]>([])
const dialogVisible = ref(false)
const submitting = ref(false)
const formRef = ref<FormInstance>()
const isEdit = ref(false)
const viewMode = ref<'card' | 'timeline' | 'calendar'>('card')
const foodHistory = ref<string[]>([])

const viewLabels: Record<string, string> = {
  card: '卡片',
  timeline: '时间线',
  calendar: '日历',
}

const calendarDate = ref(new Date())
const calendarViewMode = ref<'month' | 'week'>('month')
const weekdays = ['日', '一', '二', '三', '四', '五', '六']
const weekLabels = ['周一', '周二', '周三', '周四', '周五', '周六', '周日']

const form = ref<DietRecordAddReq & { id?: number }>({
  recordDate: '',
  mealTime: '',
  mealType: '',
  foodName: '',
  portion: '',
  tags: '',
  mood: '',
  description: '',
})

watch(() => form.value.mealType, async (newMealType) => {
  if (newMealType && !isEdit.value) {
    try {
      const { data } = await getMealLatestApi(newMealType)
      if (data) {
        form.value.foodName = data.foodName || ''
        form.value.portion = data.portion || ''
        form.value.tags = data.tags || ''
      }
    } catch (e) { /* ignore */ }
  }
})

const rules: FormRules = {
  recordDate: [{ required: true, message: '请选择日期', trigger: 'change' }],
  mealType: [{ required: true, message: '请选择餐食类型', trigger: 'change' }],
  foodName: [{ required: true, message: '请输入食物名称', trigger: 'blur' }],
}

const mealTypes = [
  { label: '早餐', value: 'breakfast' },
  { label: '午餐', value: 'lunch' },
  { label: '晚餐', value: 'dinner' },
  { label: '宵夜', value: 'snack' },
  { label: '饮料', value: 'drink' },
]

const availableTags = [
  { label: '健康', value: 'healthy' },
  { label: '轻食', value: 'light' },
  { label: '高糖', value: 'high-sugar' },
  { label: '油炸', value: 'oily' },
  { label: '辣', value: 'spicy' },
  { label: '清淡', value: 'bland' },
]

const tagNameToTypeMap: Record<string, string> = {
  '健康': 'success',
  '轻食': 'primary',
  '高糖': 'danger',
  '油炸': 'warning',
  '辣': 'warning',
  '清淡': 'info',
}

function getTagType(tagName: string): string {
  return tagNameToTypeMap[tagName] || ''
}

const moods = [
  { label: '吃得很满足', value: 'happy', emoji: '😄' },
  { label: '还不错', value: 'good', emoji: '🙂' },
  { label: '一般般', value: 'so-so', emoji: '😐' },
  { label: '吃多了', value: 'binge', emoji: '😣' },
  { label: '不太舒服', value: 'skip', emoji: '🤢' },
]

const mealEmojiMap: Record<string, string> = {
  breakfast: '🍳', lunch: '🍱', dinner: '🍲', snack: '🌙', drink: '🥤',
}

const mealColorMap: Record<string, string> = {
  breakfast: '#f59e0b', lunch: '#3b82f6', dinner: '#8b5cf6', snack: '#ec4899', drink: '#10b981',
}

const dietTips = [
  '每餐七八分饱，健康又苗条~',
  '细嚼慢咽，让大脑及时收到饱的信号',
  '多吃蔬菜水果，补充膳食纤维',
  '少油少盐，清淡饮食更健康',
  '睡前2小时尽量不要吃东西',
  '多喝水，少喝含糖饮料',
  '早餐一定要吃，开启一天新陈代谢',
  '控制主食量，粗细粮搭配更好',
  '吃饭先喝汤，垫垫肚子防暴食',
  '别等到饿了才吃，预防暴饮暴食',
  '心情不好时别用吃来发泄',
  '每口食物咀嚼20次以上',
]

const randomTip = computed(() => dietTips[Math.floor(Math.random() * dietTips.length)])

const dialogTitle = computed(() => isEdit.value ? '编辑记录' : '新增记录')

const calendarTitle = computed(() => {
  const d = calendarDate.value
  if (calendarViewMode.value === 'week') {
    const weekStart = getWeekStart(d)
    const weekEnd = new Date(weekStart)
    weekEnd.setDate(weekEnd.getDate() + 6)
    return `${weekStart.getMonth() + 1}月${weekStart.getDate()}日 - ${weekEnd.getMonth() + 1}月${weekEnd.getDate()}日`
  }
  return `${d.getFullYear()}年${d.getMonth() + 1}月`
})

const calendarCells = computed(() => {
  const year = calendarDate.value.getFullYear()
  const month = calendarDate.value.getMonth()
  const firstDay = new Date(year, month, 1)
  const lastDay = new Date(year, month + 1, 0)
  const startPadding = firstDay.getDay()
  const totalDays = lastDay.getDate()
  const cells: any[] = []
  const today = new Date()
  const todayStr = `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, '0')}-${String(today.getDate()).padStart(2, '0')}`
  for (let i = 0; i < startPadding; i++) {
    const d = new Date(year, month, -startPadding + i + 1)
    cells.push({ date: '', day: d.getDate(), isCurrentMonth: false, isToday: false, count: 0, meals: [] })
  }
  for (let i = 1; i <= totalDays; i++) {
    const dateStr = `${year}-${String(month + 1).padStart(2, '0')}-${String(i).padStart(2, '0')}`
    const dayRecords = records.value.filter(r => r.recordDate === dateStr)
    const mealCounts: any[] = []
    for (const meal of ['breakfast', 'lunch', 'dinner', 'snack', 'drink']) {
      const count = dayRecords.filter(r => r.mealType === meal).length
      if (count > 0) mealCounts.push({ type: meal, count })
    }
    cells.push({ date: dateStr, day: i, isCurrentMonth: true, isToday: dateStr === todayStr, count: dayRecords.length, meals: mealCounts })
  }
  const remaining = 42 - cells.length
  for (let i = 1; i <= remaining; i++) {
    cells.push({ date: '', day: i, isCurrentMonth: false, isToday: false, count: 0, meals: [] })
  }
  return cells
})

const weekCells = computed(() => {
  const weekStart = getWeekStart(calendarDate.value)
  const today = new Date()
  const todayStr = `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, '0')}-${String(today.getDate()).padStart(2, '0')}`
  const cells: any[] = []
  for (let i = 0; i < 7; i++) {
    const d = new Date(weekStart)
    d.setDate(d.getDate() + i)
    const dateStr = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
    const dayRecords = records.value.filter(r => r.recordDate === dateStr)
    const mealCounts: any[] = []
    for (const meal of ['breakfast', 'lunch', 'dinner', 'snack', 'drink']) {
      const count = dayRecords.filter(r => r.mealType === meal).length
      if (count > 0) mealCounts.push({ type: meal })
    }
    cells.push({ date: dateStr, day: d.getDate(), isToday: dateStr === todayStr, count: dayRecords.length, meals: mealCounts })
  }
  return cells
})

const groupedRecords = computed(() => {
  const groups: Record<string, any> = {}
  for (const record of records.value) {
    if (!groups[record.recordDate]) {
      groups[record.recordDate] = { date: record.recordDate, records: [] }
    }
    groups[record.recordDate].records.push(record)
  }
  return Object.values(groups).sort((a: any, b: any) => b.date.localeCompare(a.date))
})

function getWeekStart(date: Date): Date {
  const d = new Date(date)
  const day = d.getDay()
  const diff = d.getDate() - day + (day === 0 ? -6 : 1)
  return new Date(d.setDate(diff))
}

function getMealRecords(mealType: string) {
  return records.value.filter((r) => r.mealType === mealType)
}

function getMealColor(mealType: string) {
  return mealColorMap[mealType] || 'var(--el-color-info)'
}

function getMealEmoji(mealType: string) {
  return mealEmojiMap[mealType] || '🍽️'
}

function formatTime(timeStr: string | undefined) {
  if (!timeStr) return ''
  return timeStr.length <= 5 ? timeStr : timeStr.substring(0, 5)
}

function formatGroupDate(dateStr: string) {
  const d = new Date(dateStr)
  const month = d.getMonth() + 1
  const day = d.getDate()
  const weekday = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'][d.getDay()]
  return `${month}月${day}日 ${weekday}`
}

function getToday() {
  return new Date().toISOString().split('T')[0]
}

function getNowTime() {
  const now = new Date()
  return `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`
}

async function fetchData() {
  try {
    const params: any = {}
    if (dateRange.value && dateRange.value.length === 2) {
      params.startDate = dateRange.value[0]
      params.endDate = dateRange.value[1]
    }
    const { data } = await getDietPageApi(params)
    records.value = data.list || []
  } catch (e) {
    console.error(e)
  }
}

async function fetchFoodHistory() {
  try {
    const { data } = await getFoodHistoryApi()
    foodHistory.value = data || []
  } catch (e) {
    console.error(e)
  }
}

async function queryFoodHistory(queryStr: string, cb: (results: any[]) => void) {
  if (!queryStr) {
    cb(foodHistory.value.map(name => ({ value: name })))
  } else {
    const filtered = foodHistory.value.filter(name => name.includes(queryStr))
    cb(filtered.map(name => ({ value: name })))
  }
}

async function handleFoodSelect(item: any) {
  try {
    const { data } = await getFoodLatestApi(item.value)
    if (data) {
      form.value.portion = data.portion || ''
      form.value.tags = data.tags || ''
    }
  } catch (e) { /* ignore */ }
}

function toggleTag(tagValue: string) {
  const current = form.value.tags ? form.value.tags.split(',').filter(t => t) : []
  const idx = current.indexOf(tagValue)
  if (idx >= 0) current.splice(idx, 1)
  else current.push(tagValue)
  form.value.tags = current.join(',')
}

function handleQuery() {
  fetchData()
}

function prevCalendar() {
  const d = new Date(calendarDate.value)
  if (calendarViewMode.value === 'week') d.setDate(d.getDate() - 7)
  else d.setMonth(d.getMonth() - 1)
  calendarDate.value = d
  fetchCalendarData()
}

function nextCalendar() {
  const d = new Date(calendarDate.value)
  if (calendarViewMode.value === 'week') d.setDate(d.getDate() + 7)
  else d.setMonth(d.getMonth() + 1)
  calendarDate.value = d
  fetchCalendarData()
}

function goToToday() {
  calendarDate.value = new Date()
  calendarViewMode.value = 'month'
  const today = getToday()
  dateRange.value = [today, today]
  fetchData()
}

function selectDate(date: string) {
  dateRange.value = [date, date]
  viewMode.value = 'card'
  fetchData()
}

function fetchCalendarData() {
  const year = calendarDate.value.getFullYear()
  const month = calendarDate.value.getMonth()
  const startDate = `${year}-${String(month + 1).padStart(2, '0')}-01`
  const lastDay = new Date(year, month + 1, 0).getDate()
  const endDate = `${year}-${String(month + 1).padStart(2, '0')}-${lastDay}`
  dateRange.value = [startDate, endDate]
  fetchData()
}

function handleAdd() {
  isEdit.value = false
  form.value = {
    recordDate: getToday(),
    mealTime: getNowTime(),
    mealType: '',
    foodName: '',
    portion: '',
    tags: '',
    mood: '',
    description: '',
  }
  dialogVisible.value = true
}

function handleEdit(record: DietRecord) {
  isEdit.value = true
  form.value = {
    id: record.id,
    recordDate: record.recordDate,
    mealTime: record.mealTime ? formatTime(record.mealTime) : '',
    mealType: record.mealType,
    foodName: record.foodName,
    portion: record.portion || '',
    tags: record.tags || '',
    mood: record.mood || '',
    description: record.description || '',
  }
  dialogVisible.value = true
}

function handleDelete(record: DietRecord) {
  ElMessageBox.confirm(`确认删除「${record.foodName}」吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
    width: '320px',
    closeOnClickModal: false,
  }).then(() => {
    deleteDietApi(record.id).then(() => {
      ElMessage.success('删除成功')
      fetchData()
    })
  })
}

function submitForm() {
  if (!formRef.value) return
  formRef.value.validate((valid) => {
    if (!valid) return
    submitting.value = true
    const api = isEdit.value ? updateDietApi : addDietApi
    api(form.value as any)
      .then(() => {
        ElMessage.success('操作成功')
        dialogVisible.value = false
        fetchData()
        fetchFoodHistory()
      })
      .finally(() => { submitting.value = false })
  })
}

function handleExport() {
  if (records.value.length === 0) {
    ElMessage.warning('暂无数据可导出')
    return
  }
  const exportData = records.value.map(r => ({
    '日期': r.recordDate,
    '时间': formatTime(r.mealTime),
    '餐食': r.mealTypeName,
    '食物': r.foodName,
    '份量': r.portion || '',
    '标签': r.tagNames || '',
    '心情': r.moodName || '',
    '备注': r.description || '',
  }))
  const ws = XLSX.utils.json_to_sheet(exportData)
  const wb = XLSX.utils.book_new()
  XLSX.utils.book_append_sheet(wb, ws, '饮食记录')
  XLSX.writeFile(wb, `饮食记录_${getToday()}.xlsx`)
  ElMessage.success('导出成功')
}

onMounted(() => {
  const today = getToday()
  dateRange.value = [dayjs().subtract(7, 'day').format('YYYY-MM-DD'), today]
  fetchData()
  fetchFoodHistory()
})
</script>

<style lang="scss" scoped>
.diet-container {
  padding: 20px;
  background: var(--app-main-bg-color);
  min-height: calc(100vh - 84px);
}

// 顶部工具栏
.top-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;

  .left, .right {
    display: flex;
    align-items: center;
    gap: 8px;
  }
}

// 标语横幅
.tip-banner {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 14px 20px;
  background: var(--el-color-warning-light);
  border: 1px solid var(--el-color-warning);
  border-radius: var(--card-radius);
  margin-bottom: 16px;

  .tip-icon { font-size: 18px; flex-shrink: 0; }
  .tip-text {
    font-size: 14px;
    font-weight: 600;
    color: var(--el-color-warning);
    line-height: 1.4;
  }
}

// 统计栏
.stats-bar {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 14px 20px;
  background: var(--bg-primary);
  border-radius: var(--card-radius);
  border: 1px solid var(--border-color);
  margin-bottom: 20px;

  .stat-chip {
    display: flex;
    align-items: center;
    gap: 6px;

    .chip-emoji { font-size: 18px; }
    .chip-num { font-size: 20px; font-weight: 700; color: var(--el-color-primary); }
    .chip-label { font-size: 13px; color: var(--text-secondary); }
  }

  .stat-divider {
    width: 1px;
    height: 24px;
    background: var(--border-color);
  }
}

// 卡片视图
.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: 16px;
}

.diet-card {
  position: relative;
  border-radius: var(--card-radius);
  overflow: hidden;
  background: var(--bg-primary);
  border: 1px solid var(--border-color);
  transition: box-shadow 0.3s ease;
  min-height: 160px;
  display: flex;
  flex-direction: column;

  &:hover {
    transform: translateY(-3px);
    box-shadow: var(--card-hover-shadow);
    border-color: transparent;
  }
}

.add-card {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 160px;
  border: 2px dashed var(--border-color);
  border-radius: var(--card-radius);
  background: transparent;
  cursor: pointer;
  transition: all 0.2s;

  &:hover {
    border-color: var(--el-color-primary);
    background: var(--el-color-primary-light-9);
    transform: none;
    box-shadow: none;

    .add-inner {
      .add-icon, .add-text { color: var(--el-color-primary); }
    }
  }

  .add-inner {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;

    .add-icon {
      font-size: 28px;
      color: var(--text-secondary);
    }

    .add-text {
      font-size: 13px;
      color: var(--text-secondary);
    }
  }

  &:hover .add-inner {
    .add-icon, .add-text { color: var(--el-color-primary); }
  }
}

.card-glow {
  position: absolute;
  top: 0;
  right: 0;
  width: 100px;
  height: 100px;
  border-radius: 0 0 0 100%;
  pointer-events: none;
}

.card-inner {
  position: relative;
  z-index: 1;
  padding: 16px;
  display: flex;
  flex-direction: column;
  flex: 1;
}

.card-top {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 12px;

  .meal-icon {
    width: 38px;
    height: 38px;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 18px;
    color: #fff;
    flex-shrink: 0;
  }

  .meal-meta {
    flex: 1;
    min-width: 0;

    .meal-name {
      display: block;
      font-size: 13px;
      font-weight: 600;
      color: var(--text-primary);
    }

    .meal-time {
      display: block;
      font-size: 11px;
      color: var(--text-secondary);
      margin-top: 2px;
    }
  }

  .mood-emoji { font-size: 22px; }
}

.card-food {
  margin-bottom: 10px;

  .food-name {
    font-size: 16px;
    font-weight: 700;
    color: var(--text-primary);
    display: block;
  }

  .food-portion {
    font-size: 13px;
    color: var(--text-secondary);
    margin-top: 2px;
    display: block;
  }
}

.card-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
  margin-bottom: 10px;
}

.card-footer {
  display: flex;
  gap: 4px;
  padding-top: 10px;
  border-top: 1px solid var(--border-color-light);
  margin-top: auto;
}

// 时间线视图
.timeline-view {
  .empty-state { padding: 60px 0; }
}

.timeline-groups {
  display: flex;
  flex-direction: column;
  gap: 28px;
}

.timeline-group {
  .group-header {
    margin-bottom: 12px;

    .group-date-wrap {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      background: var(--bg-primary);
      border: 1px solid var(--border-color);
      border-radius: 20px;
      padding: 6px 16px;

      .group-date {
        font-size: 15px;
        font-weight: 600;
        color: var(--text-primary);
      }

      .group-total {
        font-size: 12px;
        color: var(--text-secondary);
        background: var(--bg-secondary);
        padding: 2px 8px;
        border-radius: 10px;
      }
    }
  }
}

.group-items {
  padding-left: 16px;
}

.timeline-row {
  display: flex;
  gap: 16px;

  .row-line {
    display: flex;
    flex-direction: column;
    align-items: center;
    flex-shrink: 0;

    .row-dot {
      width: 36px;
      height: 36px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 16px;
      color: #fff;
      flex-shrink: 0;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .row-connector {
      width: 2px;
      flex: 1;
      min-height: 20px;
      background: var(--border-color);
      margin: 4px 0;
    }
  }

  .row-content {
    flex: 1;
    background: var(--bg-primary);
    border: 1px solid var(--border-color);
    border-radius: var(--card-radius);
    padding: 14px 16px;
    margin-bottom: 12px;
    transition: box-shadow 0.3s ease;

    &:hover {
      box-shadow: var(--card-shadow);
    }
  }
}

.row-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;

  .row-left {
    display: flex;
    align-items: center;
    gap: 10px;

    .row-type {
      font-size: 13px;
      font-weight: 600;
    }

    .row-time {
      font-size: 12px;
      color: var(--text-secondary);
    }

    .row-mood {
      font-size: 16px;
    }
  }

  .row-actions {
    display: flex;
    gap: 2px;
  }
}

.row-food {
  margin-bottom: 8px;

  .food-name {
    font-size: 15px;
    font-weight: 600;
    color: var(--text-primary);
    margin-right: 8px;
  }

  .food-portion {
    font-size: 13px;
    color: var(--text-secondary);
  }
}

.row-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
}

// 日历视图
.calendar-view {
  background: var(--bg-primary);
  border-radius: var(--card-radius);
  border: 1px solid var(--border-color);
  padding: 20px;
}

.calendar-toolbar {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  margin-bottom: 20px;

  .calendar-title {
    font-size: 16px;
    font-weight: 600;
    color: var(--text-primary);
    min-width: 120px;
    text-align: center;
  }
}

.week-header {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  margin-bottom: 8px;

  .week-label {
    text-align: center;
    font-size: 12px;
    color: var(--text-secondary);
    padding: 6px 0;
  }
}

.week-cells {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 8px;
}

.week-cell {
  border-radius: var(--card-radius);
  padding: 12px 8px;
  background: var(--bg-secondary);
  text-align: center;
  min-height: 88px;
  transition: all 0.2s;

  &.is-today {
    background: var(--el-color-primary-light-9);
    border: 2px solid var(--el-color-primary);
  }

  &.has-data {
    cursor: pointer;
    &:hover { background: var(--el-color-primary-light-8); }
  }

  .week-cell-top {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    margin-bottom: 8px;

    .week-day-num {
      font-size: 15px;
      font-weight: 600;
      color: var(--text-primary);
    }

    .week-badge {
      font-size: 10px;
      background: var(--el-color-primary);
      color: #fff;
      border-radius: 8px;
      padding: 0 5px;
      min-width: 18px;
    }
  }

  .week-emojis {
    font-size: 16px;
    display: flex;
    justify-content: center;
    gap: 2px;
    flex-wrap: wrap;
  }
}

.month-cells {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 4px;
}

.month-cell {
  min-height: 64px;
  border-radius: 8px;
  padding: 6px;
  background: var(--bg-secondary);
  text-align: center;
  transition: all 0.2s;

  &.is-today {
    background: var(--el-color-primary-light-9);
    border: 1px solid var(--el-color-primary-light-5);

    .cell-num { color: var(--el-color-primary); font-weight: 700; }
  }

  &.is-other { opacity: 0.35; }

  &.has-data { cursor: pointer; &:hover { background: var(--el-color-primary-light-8); } }

  .cell-num {
    font-size: 13px;
    font-weight: 500;
    color: var(--text-primary);
    display: block;
    margin-bottom: 4px;
  }

  .cell-dots {
    display: flex;
    justify-content: center;
    gap: 2px;
    flex-wrap: wrap;
  }

  .cell-dot {
    width: 6px;
    height: 6px;
    border-radius: 50%;
  }
}

// 表单
.tag-group {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.mood-selector {
  display: flex;
  gap: 8px;

  :deep(.el-button) {
    font-size: 18px;
    padding: 6px;
    &.el-button--primary { transform: scale(1.1); }
  }
}

// 对话框
:deep(.el-dialog) {
  .el-dialog__header {
    padding: 16px 20px;
    border-bottom: 1px solid var(--border-color);
    display: flex;
    align-items: center;
    justify-content: space-between;

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
