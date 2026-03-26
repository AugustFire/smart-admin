<template>
  <div class="dashboard-container">
    <!-- 欢迎横幅 -->
    <div class="welcome-banner">
      <div class="banner-bg">
        <div class="glow glow-1"></div>
        <div class="glow glow-2"></div>
        <div class="grid-pattern"></div>
      </div>
      <div class="banner-content">
        <div class="welcome-text">
          <h1 class="greeting">{{ greeting }}，{{ nickname }}</h1>
          <p class="subline">{{ quote }}</p>
        </div>
        <div class="date-info">
          <div class="date">{{ dateStr }}</div>
          <div class="time">{{ timeStr }}</div>
        </div>
      </div>
    </div>

    <!-- 数据卡片 -->
    <div class="stats-grid">
      <div class="stat-card" v-for="(stat, index) in stats" :key="index">
        <div class="stat-icon" :style="{ background: stat.gradient }">
          <el-icon :size="26"><component :is="stat.icon" /></el-icon>
        </div>
        <div class="stat-content">
          <div class="stat-value">
            <span class="number">{{ stat.value }}</span>
            <span class="unit">{{ stat.unit }}</span>
          </div>
          <div class="stat-label">{{ stat.label }}</div>
        </div>
      </div>
    </div>

    <!-- 三栏布局 -->
    <div class="three-cols">
      <!-- 快捷入口 -->
      <div class="col-section">
        <div class="section-header">
          <h3>快捷入口</h3>
        </div>
        <div class="shortcuts-grid">
          <div class="shortcut-item" v-for="item in shortcuts" :key="item.name" @click="handleShortcut(item)">
            <div class="shortcut-icon" :style="{ background: item.gradient }">
              <el-icon :size="18"><component :is="item.icon" /></el-icon>
            </div>
            <span>{{ item.name }}</span>
          </div>
        </div>
      </div>

      <!-- 最新动态 -->
      <div class="col-section">
        <div class="section-header">
          <h3>最新动态</h3>
        </div>
        <div class="activity-list">
          <div class="activity-item" v-for="(activity, index) in activities" :key="index">
            <div class="activity-dot" :class="activity.type"></div>
            <div class="activity-content">
              <div class="activity-title">{{ activity.title }}</div>
              <div class="activity-time">{{ activity.time }}</div>
            </div>
          </div>
        </div>
      </div>

      <!-- 待办事项 -->
      <div class="col-section">
        <div class="section-header">
          <h3>待办事项</h3>
          <el-button type="primary" size="small" text>
            <el-icon><Plus /></el-icon>
          </el-button>
        </div>
        <div class="todo-list">
          <div class="todo-item" v-for="(todo, index) in todos" :key="index">
            <el-checkbox v-model="todo.done" size="small" />
            <span :class="{ done: todo.done }">{{ todo.text }}</span>
            <span class="priority-dot" :class="todo.priority"></span>
          </div>
        </div>
      </div>
    </div>

    <!-- 系统信息 -->
    <div class="system-info">
      <div class="info-item">
        <el-icon><Monitor /></el-icon>
        <span>Smart Admin Management System</span>
      </div>
      <div class="info-divider"></div>
      <div class="info-item">
        <el-icon><Calendar /></el-icon>
        <span>最后更新：2026-03-26</span>
      </div>
      <div class="info-divider"></div>
      <div class="info-item">
        <el-icon><Cpu /></el-icon>
        <span>系统运行正常</span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/store/modules/user'
import { Plus, Monitor, Calendar, Cpu } from '@element-plus/icons-vue'

const router = useRouter()
const userStore = useUserStore()
const nickname = computed(() => userStore.nickname)

// 时间相关
const timeStr = ref('')
const dateStr = ref('')
let timer: number

const greeting = computed(() => {
  const hour = new Date().getHours()
  if (hour < 6) return '夜深了'
  if (hour < 9) return '早上好'
  if (hour < 12) return '上午好'
  if (hour < 14) return '中午好'
  if (hour < 18) return '下午好'
  if (hour < 22) return '晚上好'
  return '夜深了'
})

const quotes = [
  '每一个不曾起舞的日子，都是对生命的辜负',
  '人生没有白走的路，每一步都算数',
  '把每一件简单的事做好就是不简单',
  '成功不是将来才有的，而是从决定去做的那一刻起',
  '行动是治愈恐惧的良药，而犹豫将不断滋养恐惧',
]
const quote = ref(quotes[Math.floor(Math.random() * quotes.length)])

function updateTime() {
  const now = new Date()
  timeStr.value = now.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit', second: '2-digit' })
  dateStr.value = now.toLocaleDateString('zh-CN', { year: 'numeric', month: 'long', day: 'numeric', weekday: 'long' })
}

onMounted(() => {
  updateTime()
  timer = window.setInterval(updateTime, 1000)
})

onUnmounted(() => {
  clearInterval(timer)
})

// 统计数据
const stats = ref([
  { label: '在线用户', value: '128', unit: '人', icon: 'User', gradient: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)' },
  { label: '今日访问', value: '3,842', unit: '次', icon: 'View', gradient: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)' },
  { label: '系统模块', value: '12', unit: '个', icon: 'Grid', gradient: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)' },
  { label: 'API 接口', value: '86', unit: '个', icon: 'Connection', gradient: 'linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)' },
])

// 快捷入口
const shortcuts = ref([
  { name: '用户管理', icon: 'User', path: '/system/user', gradient: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)' },
  { name: '角色管理', icon: 'Peoples', path: '/system/role', gradient: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)' },
  { name: '菜单管理', icon: 'Menu', path: '/system/menu', gradient: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)' },
  { name: 'API 管理', icon: 'Connection', path: '/system/api', gradient: 'linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)' },
  { name: '字典管理', icon: 'Collection', path: '/system/dict', gradient: 'linear-gradient(135deg, #fa709a 0%, #fee140 100%)' },
  { name: '操作日志', icon: 'Document', path: '/system/operlog', gradient: 'linear-gradient(135deg, #a8edea 0%, #fed6e3 100%)' },
])

// 最新动态
const activities = ref([
  { title: '管理员创建了新用户 zhangsan', time: '10 分钟前', type: 'success' },
  { title: '管理员修改了角色权限', time: '1 小时前', type: 'warning' },
  { title: '管理员更新了菜单配置', time: '2 小时前', type: 'info' },
  { title: '数据库自动备份完成', time: '今天 08:00', type: 'primary' },
])

// 待办事项
const todos = ref([
  { text: '审核新用户注册申请', done: false, priority: 'danger' },
  { text: '配置 API 接口权限', done: false, priority: 'warning' },
  { text: '更新系统操作文档', done: true, priority: 'info' },
  { text: '检查系统安全日志', done: false, priority: 'warning' },
])

function handleShortcut(item: any) {
  router.push(item.path)
}
</script>

<style lang="scss" scoped>
.dashboard-container {
  padding: 0;
}

// 欢迎横幅
.welcome-banner {
  position: relative;
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
  border-radius: 20px;
  padding: 40px 48px;
  margin-bottom: 24px;
  overflow: hidden;

  .banner-bg {
    position: absolute;
    inset: 0;
    pointer-events: none;

    .glow {
      position: absolute;
      border-radius: 50%;
      filter: blur(80px);
      opacity: 0.4;

      &.glow-1 {
        width: 400px;
        height: 400px;
        background: var(--el-color-primary);
        top: -200px;
        right: -100px;
      }

      &.glow-2 {
        width: 300px;
        height: 300px;
        background: #8b5cf6;
        bottom: -150px;
        left: 20%;
      }
    }

    .grid-pattern {
      position: absolute;
      inset: 0;
      background-image:
        linear-gradient(rgba(255,255,255,0.03) 1px, transparent 1px),
        linear-gradient(90deg, rgba(255,255,255,0.03) 1px, transparent 1px);
      background-size: 40px 40px;
    }
  }

  .banner-content {
    position: relative;
    z-index: 1;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .welcome-text {
    .greeting {
      font-size: 32px;
      font-weight: 700;
      color: #fff;
      margin: 0 0 8px;
    }

    .subline {
      font-size: 15px;
      color: rgba(255,255,255,0.7);
      margin: 0;
    }
  }

  .date-info {
    text-align: right;
    color: #fff;

    .date {
      font-size: 14px;
      opacity: 0.8;
      margin-bottom: 4px;
    }

    .time {
      font-size: 42px;
      font-weight: 300;
      letter-spacing: 2px;
      font-variant-numeric: tabular-nums;
    }
  }
}

// 统计卡片
.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-bottom: 24px;
}

.stat-card {
  background: var(--bg-primary);
  border-radius: 14px;
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 14px;
  border: 1px solid var(--border-color);
  transition: all 0.2s;

  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 16px rgba(0,0,0,0.06);
  }

  .stat-icon {
    width: 52px;
    height: 52px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #fff;
    flex-shrink: 0;
  }

  .stat-content {
    .stat-value {
      display: flex;
      align-items: baseline;
      gap: 4px;

      .number {
        font-size: 24px;
        font-weight: 700;
        color: var(--text-primary);
      }

      .unit {
        font-size: 12px;
        color: var(--text-secondary);
      }
    }

    .stat-label {
      font-size: 13px;
      color: var(--text-secondary);
      margin-top: 2px;
    }
  }
}

// 三栏布局
.three-cols {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  gap: 20px;
  margin-bottom: 24px;
}

.col-section {
  background: var(--bg-primary);
  border-radius: 14px;
  padding: 20px;
  border: 1px solid var(--border-color);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;

  h3 {
    font-size: 16px;
    font-weight: 600;
    color: var(--text-primary);
    margin: 0;
  }
}

// 快捷入口
.shortcuts-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 12px;
}

.shortcut-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 14px;
  background: var(--bg-secondary);
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.2s;

  &:hover {
    background: var(--bg-tertiary);
    transform: translateX(4px);
  }

  .shortcut-icon {
    width: 36px;
    height: 36px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #fff;
    flex-shrink: 0;
  }

  span {
    font-size: 13px;
    font-weight: 500;
    color: var(--text-regular);
  }
}

// 动态列表
.activity-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.activity-item {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  padding: 10px 0;
  border-bottom: 1px solid var(--border-color-light);

  &:last-child {
    border-bottom: none;
    padding-bottom: 0;
  }

  .activity-dot {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    margin-top: 6px;
    flex-shrink: 0;

    &.success { background: #10b981; }
    &.warning { background: #f59e0b; }
    &.info { background: #64748b; }
    &.primary { background: var(--el-color-primary); }
  }

  .activity-content {
    flex: 1;
    min-width: 0;

    .activity-title {
      font-size: 13px;
      color: var(--text-primary);
      line-height: 1.4;
    }

    .activity-time {
      font-size: 11px;
      color: var(--text-secondary);
      margin-top: 2px;
    }
  }
}

// 待办事项
.todo-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.todo-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 12px;
  background: var(--bg-secondary);
  border-radius: 8px;

  span {
    flex: 1;
    font-size: 13px;
    color: var(--text-primary);

    &.done {
      text-decoration: line-through;
      color: var(--text-secondary);
    }
  }

  .priority-dot {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    flex-shrink: 0;

    &.danger { background: #ef4444; }
    &.warning { background: #f59e0b; }
    &.info { background: #64748b; }
  }
}

// 系统信息
.system-info {
  display: flex;
  align-items: center;
  gap: 20px;
  padding: 14px 20px;
  background: var(--bg-primary);
  border-radius: 10px;
  border: 1px solid var(--border-color);

  .info-item {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 13px;
    color: var(--text-secondary);

    .el-icon {
      font-size: 15px;
      color: var(--el-color-primary);
    }
  }

  .info-divider {
    width: 1px;
    height: 14px;
    background: var(--border-color);
  }
}

@media (max-width: 1200px) {
  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
  }

  .three-cols {
    grid-template-columns: 1fr 1fr;
  }
}

@media (max-width: 768px) {
  .welcome-banner {
    padding: 28px;

    .banner-content {
      flex-direction: column;
      text-align: center;
    }

    .welcome-text .greeting {
      font-size: 26px;
    }

    .date-info {
      text-align: center;
      margin-top: 16px;

      .time {
        font-size: 32px;
      }
    }
  }

  .stats-grid {
    grid-template-columns: 1fr;
  }

  .three-cols {
    grid-template-columns: 1fr;
  }
}
</style>