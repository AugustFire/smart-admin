<template>
  <div class="login-page">
    <!-- 背景遮罩 -->
    <div class="bg-overlay"></div>

    <!-- 左侧品牌区 -->
    <div class="left-section">
      <a href="/" class="logo-link">
        <img src="/vite.svg" alt="logo" class="logo" />
      </a>

      <div class="brand-content">
        <h1 class="brand-title">Smart Admin</h1>
        <p class="brand-desc">
          {{ t('brandDesc') }}
        </p>
      </div>

      <div class="footer-links">
        <span>© 2026 Smart Admin. All rights reserved.</span>
      </div>
    </div>

    <!-- 右侧登录卡片 -->
    <div class="right-section">
      <div class="login-card">
        <!-- 语言切换 -->
        <div class="lang-switch">
          <span
            :class="{ active: lang === 'zh' }"
            @click="lang = 'zh'"
          >中文</span>
          <span class="divider">/</span>
          <span
            :class="{ active: lang === 'en' }"
            @click="lang = 'en'"
          >EN</span>
        </div>

        <h2 class="card-title">{{ t('loginTitle') }}</h2>

        <!-- 错误提示 -->
        <transition name="fade">
          <div v-if="errorMessage" class="error-msg">
            {{ errorMessage }}
          </div>
        </transition>

        <el-form
          ref="loginFormRef"
          :model="loginForm"
          :rules="loginRules"
          class="login-form"
        >
          <div class="form-item">
            <label>{{ t('username') }}</label>
            <el-form-item prop="username">
              <el-input
                v-model="loginForm.username"
                :placeholder="t('usernamePlaceholder')"
                :disabled="loading"
              />
            </el-form-item>
          </div>

          <div class="form-item">
            <label>{{ t('password') }}</label>
            <el-form-item prop="password">
              <el-input
                v-model="loginForm.password"
                type="password"
                :placeholder="t('passwordPlaceholder')"
                show-password
                :disabled="loading"
                @keyup.enter="handleLogin"
              />
            </el-form-item>
          </div>

          <el-button
            :loading="loading"
            type="primary"
            class="submit-btn"
            @click="handleLogin"
          >
            {{ loading ? t('loggingIn') : t('login') }}
          </el-button>
        </el-form>

        <div class="demo-tip">
          <span class="label">{{ t('demoAccount') }}</span>
          <span class="value">admin / admin123</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed } from 'vue'
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

// 语言切换
const lang = ref<'zh' | 'en'>('zh')

const i18n = {
  zh: {
    brandDesc: '一站式企业级管理后台解决方案，助力团队高效协作，提升工作效率。',
    loginTitle: '登录账户',
    username: '用户名',
    usernamePlaceholder: '请输入用户名',
    password: '密码',
    passwordPlaceholder: '请输入密码',
    login: '登录',
    loggingIn: '登录中...',
    demoAccount: '演示账号：',
    usernameRequired: '请输入用户名',
    passwordRequired: '请输入密码',
    passwordMin: '密码长度至少 6 位',
    loginSuccess: '登录成功',
    loginFailed: '登录失败，请检查用户名和密码',
  },
  en: {
    brandDesc: 'Enterprise management platform for efficient team collaboration.',
    loginTitle: 'Sign In',
    username: 'Username',
    usernamePlaceholder: 'Enter username',
    password: 'Password',
    passwordPlaceholder: 'Enter password',
    login: 'Sign In',
    loggingIn: 'Signing in...',
    demoAccount: 'Demo: ',
    usernameRequired: 'Username is required',
    passwordRequired: 'Password is required',
    passwordMin: 'Password must be at least 6 characters',
    loginSuccess: 'Login successful',
    loginFailed: 'Login failed, please check your credentials',
  },
}

const t = (key: string) => {
  return i18n[lang.value][key as keyof typeof i18n['zh']] || key
}

const loginForm = reactive({
  username: 'admin',
  password: 'admin123',
})

const loginRules = computed<FormRules>(() => ({
  username: [{ required: true, message: t('usernameRequired'), trigger: 'blur' }],
  password: [
    { required: true, message: t('passwordRequired'), trigger: 'blur' },
    { min: 6, message: t('passwordMin'), trigger: 'blur' },
  ],
}))

function handleLogin() {
  if (!loginFormRef.value) return

  errorMessage.value = ''

  loginFormRef.value.validate(async (valid) => {
    if (!valid) return

    loading.value = true
    try {
      await userStore.login(loginForm.username, loginForm.password)
      await userStore.getUserInfo()
      const { data: menus } = await getUserMenusApi()
      const dynamicRoutes = permissionStore.generateRoutes(menus || [])
      dynamicRoutes.forEach(route => router.addRoute('layout', route))
      ElMessage({ type: 'success', message: t('loginSuccess'), duration: 1500 })
      router.push('/')
    } catch (error: any) {
      loading.value = false
      errorMessage.value = error?.message || t('loginFailed')
    }
  })
}
</script>

<style lang="scss" scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  position: relative;
  background: url('https://images.unsplash.com/photo-1557683316-973673baf926?w=1920') center/cover no-repeat;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;

  // 暗色遮罩
  .bg-overlay {
    position: absolute;
    inset: 0;
    background: rgba(30, 30, 40, 0.75);
    z-index: 1;
  }

  // 左侧品牌区
  .left-section {
    position: relative;
    z-index: 2;
    flex: 1;
    display: flex;
    flex-direction: column;
    justify-content: center;
    padding: 60px 80px;
    color: #fff;

    .logo-link {
      position: absolute;
      top: 40px;
      left: 60px;

      .logo {
        width: 40px;
        height: 40px;
        filter: brightness(0) invert(1);
      }
    }

    .brand-content {
      max-width: 480px;

      .brand-title {
        font-size: 48px;
        font-weight: 700;
        margin: 0 0 24px;
        letter-spacing: -1px;
      }

      .brand-desc {
        font-size: 18px;
        line-height: 1.7;
        opacity: 0.85;
        margin: 0;
      }
    }

    .footer-links {
      position: absolute;
      bottom: 40px;
      left: 60px;
      font-size: 13px;
      opacity: 0.6;
    }
  }

  // 右侧登录区
  .right-section {
    position: relative;
    z-index: 2;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 40px;
    width: 520px;
    flex-shrink: 0;

    .login-card {
      width: 100%;
      max-width: 400px;
      background: #fff;
      border-radius: 24px;
      padding: 48px 40px;
      box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
      position: relative;

      .lang-switch {
        position: absolute;
        top: 20px;
        right: 24px;
        font-size: 13px;
        color: #999;

        span {
          cursor: pointer;
          transition: all 0.2s;

          &:hover {
            color: #666;
          }

          &.active {
            color: var(--el-color-primary);
            font-weight: 600;
          }
        }

        .divider {
          margin: 0 6px;
          cursor: default;
          color: #ddd;
        }
      }

      .card-title {
        font-size: 28px;
        font-weight: 600;
        color: #1a1a1a;
        margin: 0 0 32px;
      }

      .error-msg {
        padding: 12px 16px;
        margin-bottom: 20px;
        background: var(--el-color-primary-light-9);
        border: 1px solid var(--el-color-primary-light-7);
        border-radius: 8px;
        color: var(--el-color-primary);
        font-size: 14px;
      }

      .login-form {
        .form-item {
          margin-bottom: 20px;

          label {
            display: block;
            font-size: 14px;
            font-weight: 500;
            color: #353030;
            margin-bottom: 8px;
          }

          .el-form-item {
            margin-bottom: 0;
          }

          :deep(.el-input__wrapper) {
            border-radius: 8px;
            border: 1px solid #e0e0e0;
            box-shadow: none;
            padding: 6px 14px;
            transition: border-color 0.2s;

            &:hover {
              border-color: #bbb;
            }

            &.is-focus {
              border-color: var(--el-color-primary);
            }
          }

          :deep(.el-input__inner) {
            height: 44px;
            line-height: 44px;
            color: #353030;

            &::placeholder {
              color: #bbb;
            }
          }
        }

        .submit-btn {
          width: 100%;
          height: 50px;
          font-size: 16px;
          font-weight: 600;
          background: var(--el-color-primary);
          border: none;
          border-radius: 8px;
          margin-top: 12px;
          transition: all 0.2s;

          &:hover {
            background: var(--el-color-primary-light-3);
            transform: translateY(-1px);
          }

          &:active {
            transform: translateY(0);
          }
        }
      }

      .demo-tip {
        margin-top: 24px;
        padding-top: 20px;
        border-top: 1px solid #f0f0f0;
        font-size: 13px;
        text-align: center;

        .label {
          color: #999;
        }

        .value {
          color: var(--el-color-primary);
          font-weight: 500;
        }
      }
    }
  }
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

@media (max-width: 900px) {
  .login-page {
    flex-direction: column;
  }

  .left-section {
    padding: 100px 30px 40px;
    text-align: center;
    align-items: center;

    .logo-link {
      left: 50%;
      transform: translateX(-50%);
    }

    .brand-content {
      .brand-title {
        font-size: 32px;
      }

      .brand-desc {
        font-size: 15px;
      }
    }

    .footer-links {
      position: static;
      margin-top: 30px;
      left: auto;
    }
  }

  .right-section {
    width: 100%;
    padding: 20px;
  }
}

// 登录页始终使用浅色主题，不受系统主题影响
html[data-theme='dark'] .login-page {
  .right-section .login-card {
    background: #fff;

    .card-title {
      color: #1a1a1a;
    }

    .login-form .form-item {
      label {
        color: #353030;
      }

      :deep(.el-input__wrapper) {
        background: #fff;
        border-color: #e0e0e0;

        &:hover {
          border-color: #bbb;
        }

        &.is-focus {
          border-color: var(--el-color-primary);
        }
      }

      :deep(.el-input__inner) {
        color: #353030;

        &::placeholder {
          color: #bbb;
        }
      }
    }

    .demo-tip {
      border-top-color: #f0f0f0;

      .label {
        color: #999;
      }
    }
  }

  :deep(.el-input__wrapper) {
    background: #fff !important;
    box-shadow: none !important;
  }

  :deep(.el-input__inner) {
    color: #353030 !important;
  }
}
</style>