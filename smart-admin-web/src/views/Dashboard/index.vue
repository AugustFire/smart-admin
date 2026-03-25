<template>
  <div class="dashboard-container">
    <div class="welcome-banner">
      <div class="banner-content">
        <h1 class="welcome-title">欢迎回来，{{ nickname }}!</h1>
        <p class="welcome-subtitle">今天又是充满活力的一天，祝您工作愉快！</p>
      </div>
      <div class="banner-stats">
        <div class="stat-item">
          <div class="stat-icon primary-icon">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
              <circle cx="9" cy="7" r="4"/>
              <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
              <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
            </svg>
          </div>
          <div class="stat-info">
            <span class="stat-value">1</span>
            <span class="stat-label">在线用户</span>
          </div>
        </div>
        <div class="stat-item">
          <div class="stat-icon" style="background: linear-gradient(135deg, #10b981 0%, #059669 100%);">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <rect x="2" y="3" width="20" height="14" rx="2" ry="2"/>
              <line x1="8" y1="21" x2="16" y2="21"/>
              <line x1="12" y1="17" x2="12" y2="21"/>
            </svg>
          </div>
          <div class="stat-info">
            <span class="stat-value">6</span>
            <span class="stat-label">系统模块</span>
          </div>
        </div>
        <div class="stat-item">
          <div class="stat-icon" style="background: linear-gradient(135deg, #f97316 0%, #ea580c 100%);">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
            </svg>
          </div>
          <div class="stat-info">
            <span class="stat-value">99.9%</span>
            <span class="stat-label">系统正常</span>
          </div>
        </div>
      </div>
    </div>

    <div class="dashboard-content">
      <el-row :gutter="24">
        <el-col :span="24">
          <el-card class="tech-card">
            <template #header>
              <div class="card-header">
                <span class="card-title">技术栈</span>
                <el-tag type="info" size="small">v1.0.0</el-tag>
              </div>
            </template>
            <div class="tech-grid">
              <div class="tech-item" v-for="tech in techStack" :key="tech.name">
                <div class="tech-icon" :style="{ background: tech.gradient }">
                  <el-icon :size="24"><component :is="tech.icon" /></el-icon>
                </div>
                <div class="tech-info">
                  <span class="tech-name">{{ tech.name }}</span>
                  <el-tag :type="tech.tagType as any" size="small">{{ tech.version }}</el-tag>
                </div>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>

      <el-row :gutter="24" style="margin-top: 24px">
        <el-col :span="24">
          <el-card class="feature-card">
            <template #header>
              <div class="card-header">
                <span class="card-title">核心功能</span>
                <el-text size="small">已就绪</el-text>
              </div>
            </template>
            <el-table :data="features" style="width: 100%" :show-header="false">
              <el-table-column prop="name" label="功能名称" />
              <el-table-column prop="status" label="状态" width="120">
                <template #default="scope">
                  <el-tag :type="scope.row.status === '已完成' ? 'success' : 'warning'" size="small">
                    {{ scope.row.status }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column prop="description" label="描述" />
            </el-table>
          </el-card>
        </el-col>
      </el-row>

      <el-row :gutter="24" style="margin-top: 24px">
        <el-col :span="12">
          <el-card class="info-card">
            <template #header>
              <div class="card-header">
                <span class="card-title">快速入口</span>
              </div>
            </template>
            <div class="quick-links">
              <div class="quick-link-item" v-for="link in quickLinks" :key="link.name">
                <div class="quick-link-icon" :style="{ background: link.gradient }">
                  <el-icon :size="20"><component :is="link.icon" /></el-icon>
                </div>
                <span class="quick-link-name">{{ link.name }}</span>
              </div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="12">
          <el-card class="info-card">
            <template #header>
              <div class="card-header">
                <span class="card-title">系统信息</span>
              </div>
            </template>
            <el-descriptions :column="1" border size="default">
              <el-descriptions-item label="系统名称">Smart Admin</el-descriptions-item>
              <el-descriptions-item label="版本">v1.0.0</el-descriptions-item>
              <el-descriptions-item label="最后更新">2026-03-18</el-descriptions-item>
              <el-descriptions-item label="技术支持">Smart Admin Team</el-descriptions-item>
            </el-descriptions>
          </el-card>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { useUserStore } from '@/store/modules/user'
import { useThemeStore } from '@/store/modules/theme'

const userStore = useUserStore()
const themeStore = useThemeStore()
const nickname = computed(() => userStore.nickname)

const techStack = ref([
  { name: 'Vue', version: '3.4', icon: 'View', tagType: 'success', gradient: 'linear-gradient(135deg, #10b981 0%, #059669 100%)' },
  { name: 'TypeScript', version: '5.4', icon: 'Files', tagType: 'info', gradient: 'linear-gradient(135deg, #10b981 0%, #059669 100%)' },
  { name: 'Element Plus', version: '2.6', icon: 'Grid', tagType: 'warning', gradient: 'linear-gradient(135deg, #06b6d4 0%, #0891b2 100%)' },
  { name: 'Spring Boot', version: '3.2', icon: 'Monitor', tagType: 'danger', gradient: 'linear-gradient(135deg, #f59e0b 0%, #d97706 100%)' },
  { name: 'MyBatis Plus', version: '3.5', icon: 'Database', tagType: 'info', gradient: 'linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%)' },
  { name: 'MySQL', version: '8.0', icon: 'Coin', tagType: 'success', gradient: 'linear-gradient(135deg, #0ea5e9 0%, #0284c7 100%)' },
])

const features = ref([
  { name: '用户管理', status: '已完成', description: '用户 CRUD、重置密码、分配角色' },
  { name: '角色管理', status: '已完成', description: '角色 CRUD、分配菜单权限' },
  { name: '菜单管理', status: '已完成', description: '菜单树形管理、按钮管理、接口绑定' },
  { name: '字典管理', status: '已完成', description: '字典类型/数据 CRUD' },
  { name: '登录日志', status: '已完成', description: '登录记录查询' },
  { name: '操作日志', status: '已完成', description: '操作记录查询（AOP 记录）' },
])

const quickLinks = computed(() => [
  { name: '用户管理', icon: 'User', gradient: `linear-gradient(135deg, ${themeStore.themeColors.find(c => c.name === themeStore.currentColor)?.primary || '#FE4066'} 0%, ${themeStore.themeColors.find(c => c.name === themeStore.currentColor)?.primaryLight3 || '#fe6b87'} 100%)` },
  { name: '角色管理', icon: 'Peoples', gradient: 'linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%)' },
  { name: '菜单管理', icon: 'Menu', gradient: 'linear-gradient(135deg, #06b6d4 0%, #0891b2 100%)' },
  { name: '系统设置', icon: 'Setting', gradient: 'linear-gradient(135deg, #10b981 0%, #059669 100%)' },
])
</script>

<style lang="scss" scoped>
.dashboard-container {
  .welcome-banner {
    background: linear-gradient(135deg, var(--el-color-primary) 0%, var(--el-color-primary-light-3) 100%);
    border-radius: 16px;
    padding: 40px;
    color: #fff;
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
    margin-bottom: 24px;
    position: relative;
    overflow: hidden;

    &::before {
      content: '';
      position: absolute;
      top: -50%;
      right: -5%;
      width: 200px;
      height: 200px;
      background: rgba(255, 255, 255, 0.1);
      border-radius: 50%;
    }

    .banner-content {
      position: relative;
      z-index: 1;
      margin-bottom: 24px;

      .welcome-title {
        font-size: 32px;
        font-weight: 700;
        margin-bottom: 8px;
        text-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
      }

      .welcome-subtitle {
        font-size: 14px;
        opacity: 0.95;
      }
    }

    .banner-stats {
      position: relative;
      z-index: 1;
      display: flex;
      gap: 20px;

      .stat-item {
        display: flex;
        align-items: center;
        gap: 16px;
        padding: 20px 24px;
        background: rgba(255, 255, 255, 0.15);
        border-radius: 16px;
        backdrop-filter: blur(10px);
        flex: 1;
        transition: all 0.3s ease;
        border: 1px solid rgba(255, 255, 255, 0.2);

        &:hover {
          background: rgba(255, 255, 255, 0.25);
          transform: translateY(-4px);
          box-shadow: 0 12px 24px rgba(0, 0, 0, 0.2);
        }

        .stat-icon {
          display: flex;
          align-items: center;
          justify-content: center;
          width: 60px;
          height: 60px;
          border-radius: 16px;
          flex-shrink: 0;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);

          &.primary-icon {
            background: linear-gradient(135deg, var(--el-color-primary) 0%, var(--el-color-primary-light-3) 100%);
          }
        }

        .stat-info {
          display: flex;
          flex-direction: column;

          .stat-value {
            font-size: 28px;
            font-weight: 700;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
          }

          .stat-label {
            font-size: 13px;
            opacity: 0.9;
            margin-top: 4px;
          }
        }
      }
    }
  }

  .dashboard-content {
    .tech-card,
    .feature-card,
    .info-card {
      border-radius: 16px;
      overflow: hidden;
      border: 1px solid var(--border-color);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);

      .card-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 16px 20px;
        background: var(--bg-secondary);
        border-bottom: 1px solid var(--border-color);

        .card-title {
          font-size: 16px;
          font-weight: 600;
          color: var(--text-primary);
        }
      }
    }

    .tech-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
      gap: 20px;

      .tech-item {
        display: flex;
        align-items: center;
        gap: 16px;
        padding: 20px;
        background: var(--bg-primary);
        border-radius: 14px;
        border: 1px solid var(--border-color);
        transition: all 0.3s ease;

        &:hover {
          background: var(--bg-secondary);
          transform: translateY(-4px);
          box-shadow: 0 12px 24px rgba(0, 0, 0, 0.08);
          border-color: var(--el-color-primary);
        }

        .tech-icon {
          display: flex;
          align-items: center;
          justify-content: center;
          width: 56px;
          height: 56px;
          border-radius: 14px;
          flex-shrink: 0;
          color: #fff;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .tech-info {
          display: flex;
          flex-direction: column;
          gap: 6px;

          .tech-name {
            font-size: 16px;
            font-weight: 600;
            color: var(--text-primary);
          }
        }
      }
    }

    .feature-card {
      :deep(.el-table) {
        --el-table-tr-bg-color: transparent;
        --el-table-header-bg-color: transparent;

        .el-table__header th {
          background-color: var(--bg-secondary);
        }
      }
    }

    .quick-links {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 20px;

      .quick-link-item {
        display: flex;
        flex-direction: column;
        align-items: center;
        padding: 24px;
        background: var(--bg-primary);
        border-radius: 16px;
        border: 1px solid var(--border-color);
        cursor: pointer;
        transition: all 0.3s ease;

        &:hover {
          background: var(--bg-secondary);
          transform: translateY(-6px);
          box-shadow: 0 16px 32px rgba(0, 0, 0, 0.1);
          border-color: var(--el-color-primary);
        }

        .quick-link-icon {
          display: flex;
          align-items: center;
          justify-content: center;
          width: 56px;
          height: 56px;
          border-radius: 16px;
          margin-bottom: 12px;
          color: #fff;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .quick-link-name {
          font-size: 14px;
          color: var(--text-regular);
          font-weight: 500;
        }
      }
    }
  }
}

@media (max-width: 768px) {
  .welcome-banner .banner-stats {
    flex-direction: column;
  }

  .dashboard-content {
    .tech-grid {
      grid-template-columns: 1fr;
    }

    .quick-links {
      grid-template-columns: repeat(2, 1fr);
    }
  }
}
</style>
