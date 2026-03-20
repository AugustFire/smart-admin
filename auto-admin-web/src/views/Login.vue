<template>
  <div class="login-container">
    <div class="login-background">
      <div class="bg-circle circle-1"></div>
      <div class="bg-circle circle-2"></div>
      <div class="bg-circle circle-3"></div>
    </div>
    <div class="login-wrapper">
      <div class="login-content">
        <div class="login-left">
          <div class="logo-container">
            <img src="/vite.svg" alt="logo" class="logo" />
            <h1 class="app-title">Smart Admin</h1>
          </div>
          <p class="app-subtitle">基于 Vue 3 + Spring Boot 3 的管理后台系统</p>
          <div class="features">
            <div class="feature-item">
              <div class="feature-icon">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M12 2L2 7l10 5 10-5-10-5z"/>
                  <path d="M2 17l10 5 10-5"/>
                  <path d="M2 12l10 5 10-5"/>
                </svg>
              </div>
              <span>Vue 3.4 + TypeScript</span>
            </div>
            <div class="feature-item">
              <div class="feature-icon">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <rect x="2" y="3" width="20" height="14" rx="2" ry="2"/>
                  <line x1="8" y1="21" x2="16" y2="21"/>
                  <line x1="12" y1="17" x2="12" y2="21"/>
                </svg>
              </div>
              <span>Spring Boot 3.x</span>
            </div>
            <div class="feature-item">
              <div class="feature-icon">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <ellipse cx="12" cy="5" rx="9" ry="3"/>
                  <path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"/>
                  <path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"/>
                </svg>
              </div>
              <span>MySQL 8.0</span>
            </div>
          </div>
        </div>
        <div class="login-right">
          <div class="welcome-text">
            <h2 class="welcome-title">欢迎登录</h2>
            <p class="welcome-subtitle">请输入您的账号信息</p>
          </div>

          <!-- 错误提示区域 -->
          <transition name="slide-fade">
            <div v-if="errorMessage" class="error-banner">
              <el-icon class="error-icon"><Circle-Close-Filled /></el-icon>
              <span class="error-text">{{ errorMessage }}</span>
            </div>
          </transition>

          <el-form
            ref="loginFormRef"
            :model="loginForm"
            :rules="loginRules"
            class="login-form"
            auto-complete="on"
            label-position="left"
          >
            <el-form-item prop="username">
              <el-input
                v-model="loginForm.username"
                placeholder="请输入用户名"
                name="username"
                type="text"
                tabindex="1"
                auto-complete="on"
                size="large"
                :disabled="loading"
              >
                <template #prefix>
                  <el-icon><User /></el-icon>
                </template>
              </el-input>
            </el-form-item>

            <el-form-item prop="password">
              <el-input
                v-model="loginForm.password"
                type="password"
                placeholder="请输入密码"
                name="password"
                tabindex="2"
                auto-complete="on"
                size="large"
                show-password
                :disabled="loading"
                @keyup.enter="handleLogin"
              >
                <template #prefix>
                  <el-icon><Lock /></el-icon>
                </template>
              </el-input>
            </el-form-item>

            <el-button
              :loading="loading"
              type="primary"
              size="large"
              class="login-button"
              @click="handleLogin"
            >
              {{ loading ? '登录中...' : '登 录' }}
            </el-button>
          </el-form>
          <div class="tips">
            <span class="tip-label">默认账号：</span>
            <span class="tip-content">admin / admin123</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import type { FormInstance, FormRules } from 'element-plus'
import { useUserStore } from '@/store/modules/user'
import { usePermissionStore } from '@/store/modules/permission'
import { getUserMenusApi } from '@/api/auth'

const router = useRouter()
const userStore = useUserStore()
const permissionStore = usePermissionStore()

const loginFormRef = ref<FormInstance>()
const loading = ref(false)
const errorMessage = ref('')

const loginForm = reactive({
  username: 'admin',
  password: 'admin123',
})

const loginRules: FormRules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少 6 位', trigger: 'blur' },
  ],
}

function handleLogin() {
  if (!loginFormRef.value) return

  errorMessage.value = ''

  loginFormRef.value.validate(async (valid) => {
    if (!valid) return

    loading.value = true
    try {
      // 1. 登录获取 token
      await userStore.login(loginForm.username, loginForm.password)
      // 2. 获取用户信息
      await userStore.getUserInfo()
      // 3. 获取菜单并生成动态路由
      const { data: menus } = await getUserMenusApi()
      const dynamicRoutes = permissionStore.generateRoutes(menus || [])
      dynamicRoutes.forEach(route => router.addRoute('layout', route))
      // 4. 跳转首页
      ElMessage({ type: 'success', message: '登录成功', duration: 1500 })
      router.push('/')
    } catch (error: any) {
      loading.value = false
      errorMessage.value = error?.message || '登录失败，请检查用户名和密码'
    }
  })
}
</script>

<style lang="scss" scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #3b82f6 0%, #06b6d4 100%);
  position: relative;
  overflow: hidden;

  .login-background {
    position: absolute;
    width: 100%;
    height: 100%;
    overflow: hidden;

    .bg-circle {
      position: absolute;
      border-radius: 50%;
      background: rgba(255, 255, 255, 0.12);
      animation: float 20s infinite ease-in-out;

      &.circle-1 {
        width: 500px;
        height: 500px;
        left: -150px;
        top: -150px;
        animation-delay: 0s;
      }

      &.circle-2 {
        width: 400px;
        height: 400px;
        right: -100px;
        bottom: -100px;
        animation-delay: 7s;
      }

      &.circle-3 {
        width: 300px;
        height: 300px;
        right: 20%;
        top: 20%;
        animation-delay: 14s;
      }
    }
  }

  .login-wrapper {
    position: relative;
    z-index: 1;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 20px;

    .login-content {
      display: flex;
      width: 1000px;
      min-height: 600px;
      background: rgba(255, 255, 255, 0.98);
      backdrop-filter: blur(20px);
      border-radius: 24px;
      box-shadow: 0 40px 80px rgba(0, 0, 0, 0.25);
      overflow: hidden;
      border: 1px solid rgba(255, 255, 255, 0.3);

      .login-left {
        flex: 1;
        background: linear-gradient(135deg, rgba(59, 130, 246, 0.95) 0%, rgba(6, 182, 212, 0.95) 100%);
        padding: 60px 50px;
        color: #fff;
        display: flex;
        flex-direction: column;
        justify-content: center;
        position: relative;
        overflow: hidden;

        &::before {
          content: '';
          position: absolute;
          top: -50%;
          right: -20%;
          width: 300px;
          height: 300px;
          background: rgba(255, 255, 255, 0.1);
          border-radius: 50%;
        }

        .logo-container {
          display: flex;
          align-items: center;
          gap: 20px;
          margin-bottom: 32px;
          position: relative;
          z-index: 1;

          .logo {
            width: 56px;
            height: 56px;
            filter: brightness(0) invert(1);
          }

          .app-title {
            font-size: 36px;
            font-weight: 800;
            letter-spacing: 2px;
            text-shadow: 0 2px 12px rgba(0, 0, 0, 0.2);
          }
        }

        .app-subtitle {
          font-size: 15px;
          opacity: 0.9;
          margin-bottom: 48px;
          line-height: 1.8;
          position: relative;
          z-index: 1;
        }

        .features {
          display: flex;
          flex-direction: column;
          gap: 16px;
          position: relative;
          z-index: 1;

          .feature-item {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 18px 20px;
            background: rgba(255, 255, 255, 0.12);
            border-radius: 14px;
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.15);

            &:hover {
              background: rgba(255, 255, 255, 0.2);
              transform: translateX(10px);
              box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
            }

            .feature-icon {
              display: flex;
              align-items: center;
              justify-content: center;
              width: 48px;
              height: 48px;
              background: rgba(255, 255, 255, 0.25);
              border-radius: 12px;
              flex-shrink: 0;
            }

            span {
              font-size: 15px;
              font-weight: 600;
              letter-spacing: 0.5px;
            }
          }
        }
      }

      .login-right {
        flex: 1;
        padding: 60px 60px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        background: #fff;

        .welcome-text {
          margin-bottom: 40px;

          .welcome-title {
            font-size: 32px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 10px;
            background: linear-gradient(135deg, #3b82f6 0%, #06b6d4 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
          }

          .welcome-subtitle {
            font-size: 15px;
            color: #64748b;
          }
        }

        .login-form {
          .el-form-item {
            margin-bottom: 28px;
          }

          .el-input {
            :deep(.el-input__wrapper) {
              border-radius: 12px;
              padding: 12px 16px;
              box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
              border: 1px solid #e5e7eb;
              transition: all 0.3s ease;

              &:hover {
                border-color: var(--el-color-primary);
                box-shadow: 0 4px 16px rgba(59, 130, 246, 0.15);
              }

              &.is-focus {
                border-color: var(--el-color-primary);
                box-shadow: 0 0 0 4px var(--el-color-primary-light-9);
              }
            }
          }

          .login-button {
            width: 100%;
            height: 52px;
            font-size: 16px;
            font-weight: 600;
            background: linear-gradient(135deg, #3b82f6 0%, #06b6d4 100%);
            border: none;
            margin-top: 20px;
            border-radius: 12px;
            transition: all 0.3s ease;
            letter-spacing: 1px;

            &:hover {
              transform: translateY(-3px);
              box-shadow: 0 16px 32px rgba(59, 130, 246, 0.4);
            }

            &:active {
              transform: translateY(-1px);
            }
          }
        }

        .tips {
          margin-top: 28px;
          padding: 18px 20px;
          background: var(--bg-secondary);
          border-radius: 12px;
          font-size: 14px;
          display: flex;
          align-items: center;
          gap: 10px;
          border: 1px solid var(--border-color);

          .tip-label {
            color: var(--text-secondary);
            font-weight: 500;
          }

          .tip-content {
            color: var(--el-color-primary);
            font-weight: 600;
          }
        }

        // 错误提示横幅
        .error-banner {
          display: flex;
          align-items: center;
          gap: 10px;
          padding: 14px 18px;
          margin-bottom: 20px;
          background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%);
          border-radius: 10px;
          border: 1px solid #fecaca;
          box-shadow: 0 4px 12px rgba(239, 68, 68, 0.15);
          animation: shake 0.4s ease-in-out;

          .error-icon {
            font-size: 20px;
            color: #dc2626;
            flex-shrink: 0;
          }

          .error-text {
            flex: 1;
            color: #991b1b;
            font-size: 14px;
            font-weight: 500;
          }
        }
      }
    }
  }
}

@keyframes float {
  0%, 100% {
    transform: translate(0, 0) scale(1);
  }
  33% {
    transform: translate(30px, -30px) scale(1.05);
  }
  66% {
    transform: translate(-20px, 20px) scale(0.95);
  }
}

// 错误提示抖动动画
@keyframes shake {
  0%, 100% {
    transform: translateX(0);
  }
  10%, 30%, 50%, 70%, 90% {
    transform: translateX(-5px);
  }
  20%, 40%, 60%, 80% {
    transform: translateX(5px);
  }
}

// 淡入淡出动画
.slide-fade-enter-active {
  transition: all 0.3s ease-out;
}

.slide-fade-leave-active {
  transition: all 0.2s cubic-bezier(1, 0.5, 0.8, 1);
}

.slide-fade-enter-from,
.slide-fade-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}

@media (max-width: 900px) {
  .login-content {
    flex-direction: column !important;
    width: 100% !important;
    max-width: 450px !important;

    .login-left {
      padding: 40px 30px !important;

      .features {
        display: none !important;
      }
    }

    .login-right {
      padding: 40px 30px !important;
    }
  }
}
</style>
