<template>
  <div class="app-container">
    <el-card>
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
      <el-table v-loading="loading" :data="tableData" class="simple-table" stripe>
        <el-table-column prop="roleId" label="ID" width="80" />
        <el-table-column prop="name" label="角色名称" width="150" />
        <el-table-column prop="code" label="角色编码" width="150" />
        <el-table-column prop="sort" label="排序" width="80" />
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'danger'">
              {{ row.status === 1 ? '正常' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180" />
        <el-table-column label="操作" fixed="right" width="260">
          <template #default="{ row }">
            <div class="action-buttons">
              <el-button link type="primary" class="action-btn edit-btn" @click="handleUpdate(row)">编辑</el-button>
              <el-button link type="warning" class="action-btn permission-btn" @click="handleAssignPermission(row)">分配权限</el-button>
              <el-button link type="danger" class="action-btn delete-btn" @click="handleDelete(row)">删除</el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 新增/编辑对话框 -->
    <el-dialog :title="dialogTitle" v-model="dialogVisible" width="500px">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="角色名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入角色名称" />
        </el-form-item>
        <el-form-item label="角色编码" prop="code">
          <el-input v-model="form.code" :disabled="!!form.id" placeholder="请输入角色编码" />
        </el-form-item>
        <el-form-item label="排序" prop="sort">
          <el-input-number v-model="form.sort" :min="0" />
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

    <!-- 分配权限对话框 -->
    <el-dialog title="分配菜单权限" v-model="permissionVisible" width="500px" :close-on-click-modal="false">
      <div class="permission-tip">
        <el-icon><InfoFilled /></el-icon>
        <span>勾选菜单后，角色将自动获得该菜单关联的所有接口权限</span>
      </div>
      <el-tree
        ref="menuTreeRef"
        :data="menuTree"
        :props="{ children: 'children', label: 'name' }"
        show-checkbox
        node-key="id"
        :default-checked-keys="selectedMenuIds"
        class="menu-tree"
      />
      <template #footer>
        <el-button @click="permissionVisible = false">取消</el-button>
        <el-button type="primary" @click="submitPermission">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox, type FormInstance, type FormRules } from 'element-plus'
import {
  getRoleListApi,
  addRoleApi,
  updateRoleApi,
  deleteRoleApi,
  assignRoleMenusApi,
  getRoleMenuIdsApi,
} from '@/api/role'
import { getMenuTreeApi } from '@/api/menu'

interface MenuNode {
  id: number
  name: string
  children?: MenuNode[]
}

const loading = ref(false)
const tableData = ref([])
const dialogVisible = ref(false)
const dialogTitle = ref('')
const permissionVisible = ref(false)

const formRef = ref<FormInstance>()
const menuTreeRef = ref()

const form = ref<any>({
  id: null,
  name: '',
  code: '',
  sort: 0,
  status: 1,
})

const rules: FormRules = {
  name: [{ required: true, message: '请输入角色名称', trigger: 'blur' }],
  code: [{ required: true, message: '请输入角色编码', trigger: 'blur' }],
}

const menuTree = ref<MenuNode[]>([])
const selectedMenuIds = ref<number[]>([])
const currentRoleId = ref<number | null>(null)

function handleQuery() {
  loading.value = true
  getRoleListApi().then(({ data }) => {
    tableData.value = data
    loading.value = false
  })
}

function handleAdd() {
  dialogTitle.value = '新增角色'
  form.value = { id: null, name: '', code: '', sort: 0, status: 1 }
  dialogVisible.value = true
}

function handleUpdate(row: any) {
  dialogTitle.value = '编辑角色'
  form.value = { ...row, id: row.roleId }
  dialogVisible.value = true
}

function handleDelete(row: any) {
  ElMessageBox.confirm(`确认删除角色 "${row.name}" 吗？`, '提示', { type: 'warning' }).then(() => {
    deleteRoleApi(row.roleId).then(() => {
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
      submitData.roleId = form.value.id
    }
    const api = form.value.id ? updateRoleApi : addRoleApi
    api(submitData).then(() => {
      ElMessage.success('操作成功')
      dialogVisible.value = false
      handleQuery()
    })
  })
}

function handleAssignPermission(row: any) {
  currentRoleId.value = row.roleId
  permissionVisible.value = true

  // 获取菜单树
  getMenuTreeApi().then(({ data }) => {
    menuTree.value = data as MenuNode[]
  })

  // 获取已选菜单
  getRoleMenuIdsApi(row.roleId).then(({ data }) => {
    selectedMenuIds.value = data
  })
}

function submitPermission() {
  if (!currentRoleId.value) return

  const checkedKeys = (menuTreeRef.value?.getCheckedKeys() || []) as number[]
  const halfCheckedKeys = (menuTreeRef.value?.getHalfCheckedKeys() || []) as number[]
  const menuIds = [...checkedKeys, ...halfCheckedKeys]

  assignRoleMenusApi(currentRoleId.value, menuIds).then(() => {
    ElMessage.success('权限分配成功')
    permissionVisible.value = false
  })
}

onMounted(() => {
  handleQuery()
})
</script>

<style lang="scss" scoped>
.app-container {
  padding: 20px;
  background-color: #f5f7fa;
  min-height: calc(100vh - 84px);
}

:deep(.el-card) {
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.06);
  border: none;

  .el-card__body {
    padding: 20px;
  }
}

.simple-table {
  --el-table-tr-bg-color: transparent;
  --el-table-header-bg-color: transparent;

  :deep(.el-table__header) {
    th {
      background: #fafafa;
      border-bottom: 1px solid #e4e7ed;
      font-weight: 600;
    }
  }

  :deep(.el-table__row) {
    td {
      border-bottom: 1px solid #ebeef5;
    }

    &:hover td {
      background: #f5f7fa;
    }
  }

  :deep(.el-table__row--striped) {
    td {
      background: #fafafa;
    }
  }

  :deep(.el-table) {
    &::before {
      height: 0;
    }
  }
}

// 操作按钮样式
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
    text-decoration: none !important;

    &.edit-btn {
      background: rgba(64, 158, 255, 0.1);
      color: var(--el-color-primary);
      border: 1px solid rgba(64, 158, 255, 0.3);

      &:hover {
        background: var(--el-color-primary);
        color: #fff;
      }
    }

    &.permission-btn {
      background: rgba(230, 162, 60, 0.1);
      color: var(--el-color-warning);
      border: 1px solid rgba(230, 162, 60, 0.3);

      &:hover {
        background: var(--el-color-warning);
        color: #fff;
      }
    }

    &.delete-btn {
      background: rgba(245, 108, 108, 0.1);
      color: var(--el-color-danger);
      border: 1px solid rgba(245, 108, 108, 0.3);

      &:hover {
        background: var(--el-color-danger);
        color: #fff;
      }
    }
  }
}

.permission-tip {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 16px;
  background: #ecf5ff;
  border-radius: 6px;
  margin-bottom: 16px;
  color: #409eff;
  font-size: 13px;
}

.menu-tree {
  max-height: 400px;
  overflow-y: auto;
  border: 1px solid #ebeef5;
  border-radius: 6px;
  padding: 12px;

  :deep(.el-tree-node) {
    .el-tree-node__content {
      height: 36px;
      border-radius: 4px;

      &:hover {
        background: #f5f7fa;
      }
    }
  }
}
</style>