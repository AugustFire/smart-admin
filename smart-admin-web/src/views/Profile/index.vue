<template>
  <div class="profile-container">
    <!-- 顶部用户信息卡片 -->
    <div class="profile-header-card">
      <div class="header-content">
        <div class="avatar-wrapper">
          <el-avatar :size="120" :src="userStore.avatar" class="user-avatar" />
          <div class="avatar-glow"></div>
        </div>
        <div class="user-info">
          <h1 class="nickname">{{ userStore.nickname }}</h1>
          <p class="username">@{{ userStore.username }}</p>
          <div class="user-stats">
            <div class="stat-item">
              <el-icon><User /></el-icon>
              <span>个人用户</span>
            </div>
            <div class="stat-item">
              <el-icon><Star /></el-icon>
              <span>VIP 会员</span>
            </div>
            <div class="stat-item">
              <el-icon><Shield /></el-icon>
              <span>已认证</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="profile-content">
      <el-row :gutter="24">
        <!-- 左侧：个人信息 -->
        <el-col :span="14">
          <el-card class="info-card">
            <template #header>
              <div class="card-header">
                <el-icon><UserFilled /></el-icon>
                <span>个人信息</span>
              </div>
            </template>
            <el-form :model="userForm" label-width="90px" size="large">
              <el-row :gutter="16">
                <el-col :span="12">
                  <el-form-item label="用户名">
                    <el-input v-model="userForm.username" disabled class="disabled-input" />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="昵称">
                    <el-input v-model="userForm.nickname" placeholder="请输入昵称" />
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row :gutter="16">
                <el-col :span="12">
                  <el-form-item label="邮箱">
                    <el-input v-model="userForm.email" placeholder="请输入邮箱" />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="手机号">
                    <el-input v-model="userForm.phone" placeholder="请输入手机号" />
                  </el-form-item>
                </el-col>
              </el-row>
              <el-form-item label="性别">
                <el-radio-group v-model="userForm.sex" class="sex-radio">
                  <el-radio :label="0">
                    <el-icon><Switch /></el-icon>
                    <span>未知</span>
                  </el-radio>
                  <el-radio :label="1">
                    <el-icon><Male /></el-icon>
                    <span>男</span>
                  </el-radio>
                  <el-radio :label="2">
                    <el-icon><Female /></el-icon>
                    <span>女</span>
                  </el-radio>
                </el-radio-group>
              </el-form-item>
              <el-form-item>
                <el-button type="primary" size="large" @click="handleUpdateProfile">
                  <el-icon><Check /></el-icon>
                  保存修改
                </el-button>
              </el-form-item>
            </el-form>
          </el-card>
        </el-col>

        <!-- 右侧：修改密码 -->
        <el-col :span="10">
          <el-card class="password-card">
            <template #header>
              <div class="card-header">
                <el-icon><Lock /></el-icon>
                <span>安全设置</span>
              </div>
            </template>
            <el-form ref="pwdFormRef" :model="pwdForm" :rules="pwdRules" label-width="80px" size="large">
              <el-form-item label="旧密码" prop="oldPassword">
                <el-input v-model="pwdForm.oldPassword" type="password" placeholder="请输入旧密码" show-password />
              </el-form-item>
              <el-form-item label="新密码" prop="newPassword">
                <el-input v-model="pwdForm.newPassword" type="password" placeholder="请输入新密码" show-password />
              </el-form-item>
              <el-form-item label="确认密码" prop="confirmPassword">
                <el-input v-model="pwdForm.confirmPassword" type="password" placeholder="请确认新密码" show-password />
              </el-form-item>
              <el-form-item>
                <el-button type="primary" size="large" @click="handleUpdatePassword">
                  <el-icon><Refresh /></el-icon>
                  修改密码
                </el-button>
              </el-form-item>
            </el-form>
          </el-card>

          <!-- 快捷操作卡片 -->
          <el-card class="quick-actions-card" style="margin-top: 24px">
            <template #header>
              <div class="card-header">
                <el-icon><Grid /></el-icon>
                <span>快捷操作</span>
              </div>
            </template>
            <div class="quick-actions">
              <div class="quick-action-item">
                <div class="action-icon blue">
                  <el-icon><Key /></el-icon>
                </div>
                <span>绑定账号</span>
              </div>
              <div class="quick-action-item">
                <div class="action-icon green">
                  <el-icon><Bell /></el-icon>
                </div>
                <span>消息设置</span>
              </div>
              <div class="quick-action-item">
                <div class="action-icon purple">
                  <el-icon><Document /></el-icon>
                </div>
                <span>操作日志</span>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import type { FormInstance, FormRules } from 'element-plus'
import { useUserStore } from '@/store/modules/user'
import { getProfileApi, updateProfileApi, updatePasswordApi } from '@/api/profile'

const userStore = useUserStore()

const userForm = ref({
  id: null as number | null,
  username: '',
  nickname: '',
  email: '',
  phone: '',
  sex: 0,
})

const pwdFormRef = ref<FormInstance>()
const pwdForm = reactive({
  oldPassword: '',
  newPassword: '',
  confirmPassword: '',
})

const pwdRules: FormRules = {
  oldPassword: [{ required: true, message: '请输入旧密码', trigger: 'blur' }],
  newPassword: [
    { required: true, message: '请输入新密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少 6 位', trigger: 'blur' },
  ],
  confirmPassword: [
    { required: true, message: '请确认新密码', trigger: 'blur' },
    {
      validator: (_rule, value, callback) => {
        if (value !== pwdForm.newPassword) {
          callback(new Error('两次输入的密码不一致'))
        } else {
          callback()
        }
      },
      trigger: 'blur',
    },
  ],
}

function handleUpdateProfile() {
  updateProfileApi(userForm.value).then(() => {
    ElMessage.success('个人信息修改成功')
    // 更新 store 中的用户信息
    userStore.setUserInfo({
      userId: userStore.userInfo?.userId || 0,
      username: userForm.value.username,
      nickname: userForm.value.nickname,
      avatar: userStore.userInfo?.avatar || '',
    })
  })
}

function handleUpdatePassword() {
  if (!pwdFormRef.value) return
  pwdFormRef.value.validate((valid) => {
    if (!valid) return

    updatePasswordApi({
      oldPassword: pwdForm.oldPassword,
      newPassword: pwdForm.newPassword,
    }).then(() => {
      ElMessage.success('密码修改成功')
      pwdForm.oldPassword = ''
      pwdForm.newPassword = ''
      pwdForm.confirmPassword = ''
    })
  })
}

onMounted(() => {
  // 获取用户详细信息
  getProfileApi().then(({ data }) => {
    userForm.value = {
      id: data.id,
      username: data.username,
      nickname: data.nickname,
      email: data.email || '',
      phone: data.phone || '',
      sex: data.sex ?? 0,
    }
  })
})
</script>

<style lang="scss" scoped>
.profile-container {
  min-height: 100%;
  background-color: var(--app-main-bg-color);
  padding: 24px;

  // 顶部用户信息卡片
  .profile-header-card {
    background: linear-gradient(135deg, var(--el-color-primary) 0%, var(--el-color-primary-light-3) 100%);
    border-radius: 16px;
    padding: 40px;
    margin-bottom: 24px;
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
    position: relative;
    overflow: hidden;

    &::before {
      content: '';
      position: absolute;
      top: -50%;
      right: -10%;
      width: 300px;
      height: 300px;
      background: rgba(255, 255, 255, 0.1);
      border-radius: 50%;
    }

    &::after {
      content: '';
      position: absolute;
      bottom: -30%;
      left: 5%;
      width: 200px;
      height: 200px;
      background: rgba(255, 255, 255, 0.08);
      border-radius: 50%;
    }

    .header-content {
      display: flex;
      align-items: center;
      gap: 32px;
      position: relative;
      z-index: 1;

      .avatar-wrapper {
        position: relative;
        flex-shrink: 0;

        .user-avatar {
          border: 4px solid rgba(255, 255, 255, 0.3);
          box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
        }

        .avatar-glow {
          position: absolute;
          top: 50%;
          left: 50%;
          transform: translate(-50%, -50%);
          width: 140px;
          height: 140px;
          border-radius: 50%;
          background: radial-gradient(circle, rgba(255, 255, 255, 0.3) 0%, transparent 70%);
          animation: pulse 3s infinite ease-in-out;
        }
      }

      .user-info {
        color: #fff;

        .nickname {
          font-size: 32px;
          font-weight: 700;
          margin: 0 0 8px 0;
          text-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
        }

        .username {
          font-size: 16px;
          opacity: 0.9;
          margin: 0 0 20px 0;
        }

        .user-stats {
          display: flex;
          gap: 20px;

          .stat-item {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            background: rgba(255, 255, 255, 0.15);
            border-radius: 20px;
            backdrop-filter: blur(10px);
            font-size: 14px;
            font-weight: 500;

            .el-icon {
              font-size: 18px;
            }
          }
        }
      }
    }
  }

  .profile-content {
    padding: 0 4px;

    .info-card,
    .password-card,
    .quick-actions-card {
      border-radius: 16px;
      overflow: hidden;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
      border: 1px solid var(--border-color);

      .card-header {
        display: flex;
        align-items: center;
        gap: 10px;
        font-size: 16px;
        font-weight: 600;
        color: var(--text-primary);

        .el-icon {
          color: var(--el-color-primary);
          font-size: 20px;
        }
      }
    }

    // 表单样式
    :deep(.el-form-item) {
      margin-bottom: 20px;

      .el-form-item__label {
        font-weight: 500;
        color: var(--text-regular);
      }
    }

    :deep(.el-input__wrapper) {
      border-radius: 10px;
      box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
    }

    .disabled-input {
      :deep(.el-input__wrapper) {
        background-color: var(--bg-secondary);
      }
    }

    // 性别单选样式
    .sex-radio {
      display: flex;
      gap: 16px;

      .el-radio {
        display: flex;
        align-items: center;
        gap: 6px;
        padding: 10px 16px;
        border-radius: 10px;
        border: 1px solid var(--border-color);
        background-color: var(--bg-primary);
        transition: all 0.2s ease;
        margin-right: 0;
        height: 44px;

        &:hover {
          border-color: var(--el-color-primary);
          background-color: var(--el-color-primary-light-9);
        }

        &.is-checked {
          border-color: var(--el-color-primary);
          background-color: var(--el-color-primary-light-9);

          .el-radio__input {
            .el-radio__inner {
              background-color: var(--el-color-primary);
              border-color: var(--el-color-primary);
            }
          }
        }
      }
    }

    // 按钮样式
    :deep(.el-button--primary) {
      height: 44px;
      padding: 0 24px;
      font-size: 15px;
      font-weight: 500;
      border-radius: 10px;
      display: flex;
      align-items: center;
      gap: 8px;
      transition: all 0.2s ease;

      &:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(59, 130, 246, 0.35);
      }
    }

    // 快捷操作
    .quick-actions {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 16px;

      .quick-action-item {
        display: flex;
        flex-direction: column;
        align-items: center;
        padding: 20px 12px;
        border-radius: 12px;
        background: var(--bg-secondary);
        cursor: pointer;
        transition: all 0.3s ease;
        text-align: center;

        &:hover {
          transform: translateY(-4px);
          box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
          background: var(--bg-tertiary);
        }

        .action-icon {
          display: flex;
          align-items: center;
          justify-content: center;
          width: 48px;
          height: 48px;
          border-radius: 14px;
          margin-bottom: 12px;
          color: #fff;
          font-size: 24px;

          &.blue {
            background: linear-gradient(135deg, var(--el-color-primary) 0%, var(--el-color-primary-light-3) 100%);
          }

          &.green {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
          }

          &.purple {
            background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
          }
        }

        span {
          font-size: 13px;
          color: var(--text-regular);
          font-weight: 500;
        }
      }
    }
  }
}

@keyframes pulse {
  0%, 100% {
    transform: translate(-50%, -50%) scale(1);
    opacity: 0.5;
  }
  50% {
    transform: translate(-50%, -50%) scale(1.1);
    opacity: 0.8;
  }
}

// 暗黑主题适配
html[data-theme='dark'] {
  .profile-container {
    .profile-header-card {
      box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
    }

    .info-card,
    .password-card,
    .quick-actions-card,
    .theme-card {
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
    }

    .quick-actions .quick-action-item {
      &:hover {
        box-shadow: 0 12px 24px rgba(0, 0, 0, 0.3);
      }
    }
  }
}
</style>
