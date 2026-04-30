<template>
  <div class="app-container">
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

    <!-- 数据概览 -->
    <div class="overview-section">
      <div class="overview-item" v-for="item in overview" :key="item.label">
        <div class="overview-value">{{ item.value }}</div>
        <div class="overview-label">{{ item.label }}</div>
      </div>
    </div>

    <!-- 双栏布局 -->
    <div class="main-grid">
      <!-- 快捷入口 -->
      <div class="panel">
        <div class="panel-header">
          <span class="panel-title">快捷操作</span>
        </div>
        <div class="shortcuts-list">
          <div
            class="shortcut-row"
            v-for="item in shortcuts"
            :key="item.name"
            @click="handleShortcut(item)"
          >
            <div class="shortcut-icon">
              <el-icon><component :is="item.icon" /></el-icon>
            </div>
            <span class="shortcut-name">{{ item.name }}</span>
            <el-icon class="shortcut-arrow"><ArrowRight /></el-icon>
          </div>
        </div>
      </div>

      <!-- 最新动态 -->
      <div class="panel">
        <div class="panel-header">
          <span class="panel-title">最新动态</span>
        </div>
        <div class="activity-list">
          <div class="activity-item" v-for="(item, index) in activities" :key="index">
            <div class="activity-time">{{ item.time }}</div>
            <div class="activity-title">{{ item.title }}</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/store/modules/user'
import { ArrowRight } from '@element-plus/icons-vue'

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

const quote = ref('每一天都是新的开始')

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

// 数据概览
const overview = ref([
  { label: '在线用户', value: '128' },
  { label: '今日访问', value: '3,842' },
  { label: '系统模块', value: '12' },
  { label: 'API 接口', value: '86' },
])

// 快捷入口
const shortcuts = ref([
  { name: '用户管理', icon: 'User', path: '/system/user' },
  { name: '角色管理', icon: 'Peoples', path: '/system/role' },
  { name: '菜单管理', icon: 'Menu', path: '/system/menu' },
  { name: 'API 管理', icon: 'Connection', path: '/system/api' },
  { name: '字典管理', icon: 'Collection', path: '/system/dict' },
  { name: '操作日志', icon: 'Document', path: '/system/operlog' },
])

// 最新动态
const activities = ref([
  { title: '管理员创建了新用户 zhangsan', time: '10:20' },
  { title: '管理员修改了角色权限配置', time: '09:15' },
  { title: '系统菜单配置已更新', time: '08:00' },
  { title: '数据库自动备份完成', time: '昨天' },
])

function handleShortcut(item: any) {
  router.push(item.path)
}
</script>

<style lang="scss" scoped>
// ============================================
// 全局容器
// ============================================
.app-container {
  padding: 20px;
  background-color: var(--app-main-bg-color);
  min-height: calc(100vh - 84px);
}

// ============================================
// 欢迎横幅 - 保持原样
// ============================================
.welcome-banner {
  position: relative;
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
  border-radius: 12px;
  padding: 32px 36px;
  margin-bottom: 20px;
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
      font-size: 26px;
      font-weight: 600;
      color: #fff;
      margin: 0 0 6px;
    }

    .subline {
      font-size: 14px;
      color: rgba(255,255,255,0.65);
      margin: 0;
    }
  }

  .date-info {
    text-align: right;
    color: #fff;

    .date {
      font-size: 13px;
      opacity: 0.75;
      margin-bottom: 2px;
    }

    .time {
      font-size: 28px;
      font-weight: 300;
      letter-spacing: 1px;
      font-variant-numeric: tabular-nums;
    }
  }
}

// ============================================
// 数据概览
// ============================================
.overview-section {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 12px;
  margin-bottom: 20px;
}

.overview-item {
  background: var(--bg-primary);
  border: 1px solid var(--border-color);
  border-radius: 10px;
  padding: 18px 20px;
  transition: box-shadow 0.2s ease;

  &:hover {
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
  }

  .overview-value {
    font-size: 22px;
    font-weight: 600;
    color: var(--text-primary);
    font-variant-numeric: tabular-nums;
    line-height: 1.2;
  }

  .overview-label {
    font-size: 13px;
    color: var(--text-secondary);
    margin-top: 4px;
  }
}

// ============================================
// 双栏布局
// ============================================
.main-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
}

.panel {
  background: var(--bg-primary);
  border: 1px solid var(--border-color);
  border-radius: 10px;
  padding: 0;
  overflow: hidden;
}

.panel-header {
  padding: 16px 20px;
  border-bottom: 1px solid var(--border-color-light);
  background: var(--bg-secondary);

  .panel-title {
    font-size: 14px;
    font-weight: 600;
    color: var(--text-primary);
  }
}

// ============================================
// 快捷入口
// ============================================
.shortcuts-list {
  padding: 8px 0;
}

.shortcut-row {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 20px;
  cursor: pointer;
  transition: background-color 0.15s ease;

  &:hover {
    background: var(--bg-secondary);

    .shortcut-arrow {
      opacity: 1;
      transform: translateX(2px);
    }
  }

  .shortcut-icon {
    width: 32px;
    height: 32px;
    border-radius: 8px;
    background: var(--el-color-primary-light-9);
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;

    .el-icon {
      font-size: 16px;
      color: var(--el-color-primary);
    }
  }

  .shortcut-name {
    flex: 1;
    font-size: 14px;
    color: var(--text-regular);
  }

  .shortcut-arrow {
    font-size: 14px;
    color: var(--text-placeholder);
    opacity: 0;
    transition: all 0.15s ease;
  }
}

// ============================================
// 最新动态
// ============================================
.activity-list {
  padding: 12px 20px;
}

.activity-item {
  display: flex;
  align-items: baseline;
  gap: 12px;
  padding: 10px 0;
  border-bottom: 1px dashed var(--border-color-light);

  &:last-child {
    border-bottom: none;
  }

  .activity-time {
    font-size: 12px;
    color: var(--text-placeholder);
    min-width: 48px;
    flex-shrink: 0;
  }

  .activity-title {
    font-size: 14px;
    color: var(--text-regular);
    line-height: 1.4;
  }
}

// ============================================
// 响应式
// ============================================
@media (max-width: 1200px) {
  .overview-section {
    grid-template-columns: repeat(2, 1fr);
  }

  .main-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .welcome-banner {
    padding: 24px;

    .banner-content {
      flex-direction: column;
      text-align: center;
      gap: 16px;
    }

    .welcome-text .greeting {
      font-size: 22px;
    }

    .date-info {
      text-align: center;
    }
  }

  .overview-section {
    grid-template-columns: 1fr 1fr;
    gap: 10px;
  }
}
</style>