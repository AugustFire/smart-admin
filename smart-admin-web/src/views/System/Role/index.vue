<template>
  <div class="app-container">
    <el-card>
      <!-- 搜索栏 -->
      <el-form :model="queryParams" inline>
        <el-form-item label="角色名称">
          <el-input v-model="queryParams.name" placeholder="请输入角色名称" clearable />
        </el-form-item>
        <el-form-item label="角色编码">
          <el-input v-model="queryParams.code" placeholder="请输入角色编码" clearable />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="queryParams.status" placeholder="全部" clearable>
            <el-option label="正常" :value="1" />
            <el-option label="禁用" :value="0" />
          </el-select>
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
          <el-button v-permission="['role:add']" type="primary" @click="handleAdd">
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
              <el-button v-permission="['role:edit']" link type="primary" class="action-btn edit-btn" @click="handleUpdate(row)">编辑</el-button>
              <el-button v-permission="['role:assign']" link type="warning" class="action-btn permission-btn" @click="handleAssignPermission(row)">分配权限</el-button>
              <el-button v-permission="['role:delete']" link type="danger" class="action-btn delete-btn" @click="handleDelete(row)">删除</el-button>
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
        check-strictly
        :default-checked-keys="selectedMenuIds"
        class="menu-tree"
        @check="handleCheck"
      >
        <template #default="{ data }">
          <span class="tree-node">
            <span>{{ data.name }}</span>
            <el-tag
              :type="menuTypeMap[data.type]?.type"
              size="small"
              effect="light"
              class="node-type-tag"
            >
              {{ menuTypeMap[data.type]?.label || '未知' }}
            </el-tag>
          </span>
        </template>
      </el-tree>
      <template #footer>
        <el-button @click="permissionVisible = false">取消</el-button>
        <el-button type="primary" @click="submitPermission">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox, type FormInstance, type FormRules } from 'element-plus'
import {
  getRolePageApi,
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
  type: number  // 1=目录 2=菜单 3=按钮
  parentId?: number
  children?: MenuNode[]
}

// 菜单类型映射（与菜单管理页面保持一致）
const menuTypeMap: Record<number, { label: string; type: '' | 'success' | 'warning' }> = {
  1: { label: '目录', type: '' },
  2: { label: '菜单', type: 'success' },
  3: { label: '按钮', type: 'warning' },
}

const loading = ref(false)
const tableData = ref([])
const total = ref(0)
const dialogVisible = ref(false)
const dialogTitle = ref('')
const permissionVisible = ref(false)

const formRef = ref<FormInstance>()
const menuTreeRef = ref()

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  name: '',
  code: '',
  status: undefined as number | undefined,
})

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
  getRolePageApi(queryParams).then(({ data }) => {
    tableData.value = data.list || []
    total.value = data.total || 0
    loading.value = false
  })
}

function resetQuery() {
  queryParams.name = ''
  queryParams.code = ''
  queryParams.status = undefined
  handleQuery()
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

    // 获取已选菜单
    getRoleMenuIdsApi(row.roleId).then(({ data }) => {
      selectedMenuIds.value = data || []
    })
  })
}

// 获取所有父节点ID
function getParentIds(tree: MenuNode[], targetId: number, parentIds: number[] = []): number[] {
  for (const node of tree) {
    if (node.id === targetId) {
      return parentIds
    }
    if (node.children && node.children.length > 0) {
      const result = getParentIds(node.children, targetId, [...parentIds, node.id])
      if (result.length > 0) {
        return result
      }
    }
  }
  return []
}

// 获取所有子节点ID
function getChildIds(node: MenuNode): number[] {
  const ids: number[] = []
  if (node.children && node.children.length > 0) {
    for (const child of node.children) {
      ids.push(child.id)
      ids.push(...getChildIds(child))
    }
  }
  return ids
}

// 处理勾选事件：勾选子节点时自动勾选父节点，取消父节点时自动取消子节点
function handleCheck(data: MenuNode, checkedInfo: { checkedKeys: number[] }) {
  const isChecked = checkedInfo.checkedKeys.includes(data.id)

  if (isChecked) {
    // 勾选子节点时，自动勾选所有父节点
    const parentIds = getParentIds(menuTree.value, data.id)
    parentIds.forEach(id => {
      if (!checkedInfo.checkedKeys.includes(id)) {
        menuTreeRef.value?.setChecked(id, true, false)
      }
    })
  } else {
    // 取消勾选父节点时，自动取消所有子节点
    const childIds = getChildIds(data)
    childIds.forEach(id => {
      if (checkedInfo.checkedKeys.includes(id)) {
        menuTreeRef.value?.setChecked(id, false, false)
      }
    })
  }
}

function submitPermission() {
  if (!currentRoleId.value) return

  const checkedKeys = (menuTreeRef.value?.getCheckedKeys() || []) as number[]

  assignRoleMenusApi(currentRoleId.value, checkedKeys).then(() => {
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
  background-color: var(--app-main-bg-color);
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

// ============================================
// 搜索表单
// ============================================
:deep(.el-form) {
  margin-bottom: 16px;

  .el-form-item {
    margin-right: 20px;

    .el-input {
      width: 180px;
    }

    .el-select {
      width: 120px;
    }
  }
}

// ============================================
// 表格样式
// ============================================
.simple-table {
  --el-table-tr-bg-color: transparent;
  --el-table-header-bg-color: transparent;

  :deep(.el-table__header) {
    th {
      background: var(--bg-secondary);
      border-bottom: 1px solid var(--border-color);
      font-weight: 600;
    }
  }

  :deep(.el-table__row) {
    td {
      border-bottom: 1px solid var(--border-color);
    }

    &:hover td {
      background: var(--bg-secondary);
    }
  }

  :deep(.el-table__row--striped) {
    td {
      background: var(--bg-secondary);
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
  background: var(--el-color-primary-light-9);
  border-radius: 6px;
  margin-bottom: 16px;
  color: var(--el-color-primary);
  font-size: 13px;
}

.menu-tree {
  max-height: 400px;
  overflow-y: auto;
  border: 1px solid var(--border-color);
  border-radius: 6px;
  padding: 12px;

  .tree-node {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex: 1;
    padding-right: 8px;

    .node-type-tag {
      margin-left: 8px;
      font-size: 11px;
      height: 20px;
      line-height: 18px;
      padding: 0 6px;
    }
  }

  :deep(.el-tree-node) {
    .el-tree-node__content {
      height: 36px;
      border-radius: 4px;

      &:hover {
        background: var(--bg-secondary);
      }
    }
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
  border-top: 1px solid var(--border-color);

  .el-pager li {
    border-radius: 4px;
    font-weight: 500;

    &.is-active {
      background: var(--el-color-primary);
      color: #fff;
    }

    &:hover:not(.is-active):not(.disabled) {
      background: var(--bg-secondary);
    }
  }
}
</style>