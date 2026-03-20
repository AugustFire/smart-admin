<template>
  <div class="app-container">
    <el-card>
      <!-- 搜索栏 -->
      <el-form :model="queryParams" inline>
        <el-form-item label="用户名">
          <el-input v-model="queryParams.username" placeholder="请输入用户名" clearable />
        </el-form-item>
        <el-form-item label="手机号">
          <el-input v-model="queryParams.phone" placeholder="请输入手机号" clearable />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleQuery">
            <el-icon><Search /></el-icon>
            搜索
          </el-button>
          <el-button @click="resetQuery">
            <el-icon><Refresh /></el-icon>
            重置
          </el-button>
        </el-form-item>
      </el-form>

      <!-- 操作按钮 -->
      <el-row :gutter="10" style="margin-bottom: 16px">
        <el-col :span="1.5">
          <el-button type="primary" @click="handleAdd">
            <el-icon><Plus /></el-icon>
            新增
          </el-button>
        </el-col>
      </el-row>

      <!-- 表格 -->
      <el-table v-loading="loading" :data="tableData" class="simple-table">
        <el-table-column prop="userId" label="ID" width="80" />
        <el-table-column prop="username" label="用户名" width="120" />
        <el-table-column prop="nickname" label="昵称" width="120" />
        <el-table-column prop="email" label="邮箱" width="180" />
        <el-table-column prop="phone" label="手机号" width="120" />
        <el-table-column label="性别" width="80">
          <template #default="{ row }">
            <el-tag v-if="row.sex === 1" type="success">男</el-tag>
            <el-tag v-else-if="row.sex === 2" type="danger">女</el-tag>
            <el-tag v-else>未知</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="状态" width="80">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'danger'">
              {{ row.status === 1 ? '正常' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180" />
        <el-table-column label="操作" fixed="right" width="280">
          <template #default="{ row }">
            <div class="action-buttons">
              <el-button link type="primary" class="action-btn edit-btn" @click="handleUpdate(row)">编辑</el-button>
              <el-button link type="warning" class="action-btn pwd-btn" @click="handleResetPwd(row)">重置密码</el-button>
              <el-button link type="info" class="action-btn role-btn" @click="handleAssignRole(row)">分配角色</el-button>
              <el-button link type="danger" class="action-btn delete-btn" @click="handleDelete(row)">删除</el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <el-pagination
        v-model:current-page="queryParams.pageNum"
        v-model:page-size="queryParams.pageSize"
        :total="total"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="handleQuery"
        @current-change="handleQuery"
      />
    </el-card>

    <!-- 新增/编辑对话框 -->
    <el-dialog :title="dialogTitle" v-model="dialogVisible" width="500px">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="用户名" prop="username">
          <el-input v-model="form.username" :disabled="!!form.id" placeholder="请输入用户名" />
        </el-form-item>
        <el-form-item v-if="!form.id" label="密码" prop="password">
          <el-input v-model="form.password" type="password" placeholder="请输入密码" />
        </el-form-item>
        <el-form-item label="昵称" prop="nickname">
          <el-input v-model="form.nickname" placeholder="请输入昵称" />
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="form.email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
          <el-input v-model="form.phone" placeholder="请输入手机号" />
        </el-form-item>
        <el-form-item label="性别" prop="sex">
          <el-radio-group v-model="form.sex">
            <el-radio :label="0">未知</el-radio>
            <el-radio :label="1">男</el-radio>
            <el-radio :label="2">女</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio :label="1">正常</el-radio>
            <el-radio :label="0">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </template>
    </el-dialog>

    <!-- 重置密码对话框 -->
    <el-dialog title="重置密码" v-model="resetPwdVisible" width="400px">
      <el-form ref="resetPwdFormRef" :model="resetPwdForm" :rules="resetPwdRules" label-width="80px">
        <el-form-item label="新密码" prop="password">
          <el-input v-model="resetPwdForm.password" type="password" placeholder="请输入新密码" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="resetPwdVisible = false">取消</el-button>
        <el-button type="primary" @click="submitResetPwd">确定</el-button>
      </template>
    </el-dialog>

    <!-- 分配角色对话框 -->
    <el-dialog title="分配角色" v-model="assignRoleVisible" width="400px">
      <el-form label-width="80px">
        <el-checkbox-group v-model="selectedRoleIds">
          <el-checkbox
            v-for="role in roleList"
            :key="role.roleId"
            :label="role.roleId"
          >
            {{ role.name }}
          </el-checkbox>
        </el-checkbox-group>
      </el-form>
      <template #footer>
        <el-button @click="assignRoleVisible = false">取消</el-button>
        <el-button type="primary" @click="submitAssignRole">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import type { FormInstance, FormRules } from 'element-plus'
import {
  getUserPageApi,
  addUserApi,
  updateUserApi,
  deleteUserApi,
  resetUserPwdApi,
  assignUserRolesApi,
  getUserRoleIdsApi,
} from '@/api/user'
import { getRoleListApi } from '@/api/role'

const loading = ref(false)
const tableData = ref([])
const total = ref(0)
const dialogVisible = ref(false)
const dialogTitle = ref('')
const resetPwdVisible = ref(false)
const assignRoleVisible = ref(false)

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  username: '',
  phone: '',
})

const formRef = ref<FormInstance>()
const resetPwdFormRef = ref<FormInstance>()

const form = ref<any>({
  id: null,
  username: '',
  password: '',
  nickname: '',
  email: '',
  phone: '',
  sex: 0,
  status: 1,
})

const resetPwdForm = reactive({
  userId: null,
  password: '',
})

const rules: FormRules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  nickname: [{ required: true, message: '请输入昵称', trigger: 'blur' }],
  email: [{ type: 'email', message: '请输入正确的邮箱', trigger: 'blur' }],
  password: [
    {
      required: true,
      message: '请输入密码',
      trigger: 'blur',
      validator: (_rule, value, callback) => {
        if (!form.value.id && !value) {
          callback(new Error('请输入密码'))
        } else {
          callback()
        }
      },
    },
    { min: 6, message: '密码长度至少 6 位', trigger: 'blur' },
  ],
}

const resetPwdRules: FormRules = {
  password: [
    { required: true, message: '请输入新密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少 6 位', trigger: 'blur' },
  ],
}

const roleList = ref<any[]>([])
const selectedRoleIds = ref<number[]>([])
const currentUserId = ref<number | null>(null)

function handleQuery() {
  loading.value = true
  getUserPageApi(queryParams).then(({ data }) => {
    tableData.value = data.list || []
    total.value = data.total || 0
    loading.value = false
  })
}

function resetQuery() {
  queryParams.username = ''
  queryParams.phone = ''
  handleQuery()
}

function handleAdd() {
  dialogTitle.value = '新增用户'
  form.value = { id: null, username: '', password: '', nickname: '', email: '', phone: '', sex: 0, status: 1 }
  dialogVisible.value = true
}

function handleUpdate(row: any) {
  dialogTitle.value = '编辑用户'
  form.value = { ...row, password: '', id: row.userId }
  dialogVisible.value = true
}

function handleDelete(row: any) {
  ElMessageBox.confirm(`确认删除用户 "${row.username}" 吗？`, '提示', {
    type: 'warning',
  }).then(() => {
    deleteUserApi(row.userId).then(() => {
      ElMessage.success('删除成功')
      handleQuery()
    })
  })
}

function submitForm() {
  if (!formRef.value) return
  formRef.value.validate((valid) => {
    if (!valid) return

    const submitData = { ...form.value }
    if (form.value.id) {
      // 更新时需要 userId
      submitData.userId = form.value.id
    }
    const api = form.value.id ? updateUserApi : addUserApi
    api(submitData).then(() => {
      ElMessage.success('操作成功')
      dialogVisible.value = false
      handleQuery()
    })
  })
}

function handleResetPwd(row: any) {
  resetPwdVisible.value = true
  resetPwdForm.userId = row.userId
  resetPwdForm.password = ''
}

function submitResetPwd() {
  if (!resetPwdFormRef.value) return
  resetPwdFormRef.value.validate((valid) => {
    if (!valid) return

    resetUserPwdApi(resetPwdForm.userId!, resetPwdForm.password).then(() => {
      ElMessage.success('密码重置成功')
      resetPwdVisible.value = false
    })
  })
}

function handleAssignRole(row: any) {
  currentUserId.value = row.userId
  assignRoleVisible.value = true
  getRoleListApi().then(({ data }) => {
    roleList.value = data
    getUserRoleIdsApi(row.userId).then(({ data }) => {
      selectedRoleIds.value = data
    })
  })
}

function submitAssignRole() {
  if (!currentUserId.value) return
  assignUserRolesApi(currentUserId.value, selectedRoleIds.value).then(() => {
    ElMessage.success('分配成功')
    assignRoleVisible.value = false
  })
}

onMounted(() => {
  handleQuery()
})
</script>

<style lang="scss" scoped>
// ============================================
// 全局容器
// ============================================
.app-container {
  padding: 20px;
  background-color: #f5f7fa;
  min-height: calc(100vh - 84px);
}

// ============================================
// 卡片容器
// ============================================
:deep(.el-card) {
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.06);
  border: none;

  .el-card__body {
    padding: 20px;
  }
}

// ============================================
// 搜索表单
// ============================================
:deep(.el-form) {
  margin-bottom: 16px;

  .el-form-item {
    margin-right: 20px;
  }
}

// 主要操作按钮
:deep(.el-button--primary) {
  background: linear-gradient(135deg, #409eff 0%, #66b1ff 100%);
  border: none;
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.3);

  &:hover {
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(64, 158, 255, 0.4);
  }

  &:active {
    transform: translateY(0);
  }
}

// ============================================
// 表格样式
// ============================================
.simple-table {
  --el-table-tr-bg-color: transparent;
  --el-table-header-bg-color: transparent;
  --el-table-text-color: var(--el-text-color-regular);
  --el-table-header-text-color: var(--el-text-color-secondary);
  --el-table-row-hover-bg-color: #f5f7fa;

  :deep(.el-table__header) {
    th {
      background: #fafafa;
      border-bottom: 1px solid #e4e7ed;
      font-weight: 600;
      font-size: 14px;
      color: var(--el-text-color-secondary);
      padding: 12px 0;
    }
  }

  :deep(.el-table__row) {
    td {
      border-bottom: 1px solid #ebeef5;
      padding: 14px 0;
      color: var(--el-text-color-regular);
      font-size: 14px;
    }

    &:hover td {
      background: #f5f7fa;
    }
  }

  :deep(.el-table) {
    &::before {
      height: 0;
    }
  }

  // 状态标签
  :deep(.el-tag) {
    border-radius: 4px;
    padding: 2px 10px;
    font-size: 12px;
    font-weight: 500;
  }
}

// ============================================
// 分页样式
// ============================================
:deep(.el-pagination) {
  display: flex;
  justify-content: flex-end;
  margin-top: 20px;
  padding-top: 20px;
  border-top: 1px solid #ebeef5;

  .el-pager li {
    border-radius: 4px;
    font-weight: 500;

    &.is-active {
      background: var(--el-color-primary);
      color: #fff;
    }

    &:hover:not(.is-active):not(.disabled) {
      background: #f5f7fa;
    }
  }
}

// ============================================
// 表单样式
// ============================================
:deep(.el-form-item__label) {
  font-weight: 500;
  color: var(--el-text-color-regular);
}

:deep(.el-input__wrapper),
:deep(.el-textarea__wrapper) {
  border-radius: 6px;
  box-shadow: 0 0 0 1px #dcdfe6 inset;
  transition: all 0.2s ease;

  &:hover {
    box-shadow: 0 0 0 1px #c0c4cc inset;
  }

  &.is-focus {
    box-shadow: 0 0 0 1px #409eff inset;
  }
}

// ============================================
// 操作按钮样式 - 优化版
// ============================================
.action-buttons {
  display: inline-flex;
  align-items: center;
  gap: 8px;

  .action-btn {
    padding: 6px 12px;
    font-size: 13px;
    font-weight: 500;
    border-radius: 6px;
    transition: all 0.2s ease;
    position: relative;
    overflow: hidden;

    // 移除 link 按钮的下划线
    text-decoration: none !important;

    // 按钮基础样式 - 填充风格
    &.edit-btn {
      background: rgba(64, 158, 255, 0.1);
      color: var(--el-color-primary);
      border: 1px solid rgba(64, 158, 255, 0.3);

      &:hover {
        background: var(--el-color-primary);
        color: #fff;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(64, 158, 255, 0.35);
      }
    }

    &.pwd-btn {
      background: rgba(230, 162, 60, 0.1);
      color: var(--el-color-warning);
      border: 1px solid rgba(230, 162, 60, 0.3);

      &:hover {
        background: var(--el-color-warning);
        color: #fff;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(230, 162, 60, 0.35);
      }
    }

    &.role-btn {
      background: rgba(144, 147, 153, 0.1);
      color: #606266;
      border: 1px solid rgba(144, 147, 153, 0.3);

      &:hover {
        background: #606266;
        color: #fff;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(96, 98, 102, 0.35);
      }
    }

    &.delete-btn {
      background: rgba(245, 108, 108, 0.1);
      color: var(--el-color-danger);
      border: 1px solid rgba(245, 108, 108, 0.3);

      &:hover {
        background: var(--el-color-danger);
        color: #fff;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(245, 108, 108, 0.35);
      }
    }
  }
}
</style>
