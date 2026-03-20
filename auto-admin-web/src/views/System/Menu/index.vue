<template>
  <div class="app-container">
    <el-card>
      <el-row :gutter="10" style="margin-bottom: 16px">
        <el-col :span="1.5">
          <el-button type="primary" @click="handleAdd">
            <el-icon><Plus /></el-icon>
            新增
          </el-button>
        </el-col>
      </el-row>

      <el-table
        v-loading="loading"
        :data="tableData"
        row-key="id"
        :expand-row-keys="expandedKeys"
        :tree-props="{ children: 'children', hasChildren: 'hasChildren' }"
        class="simple-table"
        stripe
      >
        <el-table-column prop="name" label="菜单名称" width="180" />
        <el-table-column prop="icon" label="图标" width="80">
          <template #default="{ row }">
            <el-icon v-if="row.icon" :size="20">
              <component :is="row.icon" />
            </el-icon>
          </template>
        </el-table-column>
        <el-table-column prop="type" label="类型" width="80">
          <template #default="{ row }">
            <el-tag :type="getTypeTag(row.type)">
              {{ getTypeLabel(row.type) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="path" label="路由路径" width="150" />
        <el-table-column prop="component" label="组件路径" width="180" />
        <el-table-column prop="permission" label="权限标识" width="120" />
        <el-table-column prop="sort" label="排序" width="60" />
        <el-table-column label="可见性" width="80">
          <template #default="{ row }">
            <el-tag :type="row.visible === 1 ? 'success' : 'info'">
              {{ row.visible === 1 ? '显示' : '隐藏' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" fixed="right" width="200">
          <template #default="{ row }">
            <div class="action-buttons">
              <el-button link type="success" class="action-btn add-btn" @click="handleAdd(row)">新增</el-button>
              <el-button link type="primary" class="action-btn edit-btn" @click="handleUpdate(row)">编辑</el-button>
              <el-button link type="danger" class="action-btn delete-btn" @click="handleDelete(row)">删除</el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 新增/编辑对话框 -->
    <el-dialog :title="dialogTitle" v-model="dialogVisible" width="600px">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="父级菜单" prop="parentId">
          <el-tree-select
            v-model="form.parentId"
            :data="menuTree"
            :props="{ children: 'children', label: 'name' }"
            check-strictly
            placeholder="选择父级菜单"
          />
        </el-form-item>
        <el-form-item label="菜单名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入菜单名称" />
        </el-form-item>
        <el-form-item label="类型" prop="type">
          <el-radio-group v-model="form.type">
            <el-radio :label="1">目录</el-radio>
            <el-radio :label="2">菜单</el-radio>
            <el-radio :label="3">按钮</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="图标" prop="icon" v-if="form.type === 1 || form.type === 2">
          <el-input v-model="form.icon" placeholder="请输入图标名称，如：User" />
        </el-form-item>
        <el-form-item label="路由路径" prop="path" v-if="form.type === 1 || form.type === 2">
          <el-input v-model="form.path" placeholder="如：/system/user" />
        </el-form-item>
        <el-form-item label="组件路径" prop="component" v-if="form.type === 2">
          <el-input v-model="form.component" placeholder="如：system/user/index" />
        </el-form-item>
        <el-form-item label="权限标识" prop="permission" v-if="form.type === 3">
          <el-input v-model="form.permission" placeholder="如：user:add" />
        </el-form-item>
        <el-form-item label="排序" prop="sort">
          <el-input-number v-model="form.sort" :min="0" />
        </el-form-item>
        <el-form-item label="可见性" prop="visible">
          <el-radio-group v-model="form.visible">
            <el-radio :label="1">显示</el-radio>
            <el-radio :label="0">隐藏</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox, type FormInstance, type FormRules } from 'element-plus'
import { getMenuTreeApi, addMenuApi, updateMenuApi, deleteMenuApi } from '@/api/menu'

const loading = ref(false)
const tableData = ref([])
const menuTree = ref<any[]>([])
const expandedKeys = ref<string[]>([])
const dialogVisible = ref(false)
const dialogTitle = ref('')

const formRef = ref<FormInstance>()

const form = ref<any>({
  id: null,
  parentId: 0,
  name: '',
  type: 2,
  path: '',
  component: '',
  permission: '',
  icon: '',
  sort: 0,
  visible: 1,
  status: 1,
})

const rules: FormRules = {
  name: [{ required: true, message: '请输入菜单名称', trigger: 'blur' }],
  type: [{ required: true, message: '请选择类型', trigger: 'change' }],
}

function getTypeLabel(type: number) {
  const labels: Record<number, string> = { 1: '目录', 2: '菜单', 3: '按钮' }
  return labels[type] || ''
}

function getTypeTag(type: number) {
  const tags: Record<number, any> = { 1: '', 2: 'success', 3: 'warning' }
  return tags[type] || ''
}

function handleQuery() {
  loading.value = true
  getMenuTreeApi().then(({ data }) => {
    tableData.value = data
    menuTree.value = [{ id: 0, name: '顶级菜单', children: data }]
    expandedKeys.value = data.map((item: any) => item.id)
    loading.value = false
  })
}

function handleAdd(row?: any) {
  dialogTitle.value = '新增菜单'
  form.value = {
    id: null,
    parentId: row?.id || 0,
    name: '',
    type: row?.type === 1 ? 2 : 3,
    path: '',
    component: '',
    permission: '',
    icon: '',
    sort: 0,
    visible: 1,
    status: 1,
  }
  dialogVisible.value = true
}

function handleUpdate(row: any) {
  dialogTitle.value = '编辑菜单'
  form.value = { ...row }
  dialogVisible.value = true
}

function handleDelete(row: any) {
  if (row.children && row.children.length > 0) {
    ElMessage.warning('存在子菜单，无法删除')
    return
  }
  ElMessageBox.confirm(`确认删除菜单 "${row.name}" 吗？`, '提示', { type: 'warning' }).then(() => {
    deleteMenuApi(row.id).then(() => {
      ElMessage.success('删除成功')
      handleQuery()
    })
  })
}

function submitForm() {
  if (!formRef.value) return
  formRef.value.validate((valid) => {
    if (!valid) return

    const api = form.value.id ? updateMenuApi : addMenuApi
    api(form.value).then(() => {
      ElMessage.success('操作成功')
      dialogVisible.value = false
      handleQuery()
    })
  })
}

onMounted(() => {
  handleQuery()
})
</script>

<style lang="scss" scoped>
.app-container {
  padding: 20px;
}

// 简约表格样式 - 只有横线 + 斑马纹
.simple-table {
  --el-table-tr-bg-color: transparent;
  --el-table-header-bg-color: transparent;

  :deep(.el-table__header) {
    th {
      background: transparent;
      border-bottom: 1px solid #ebeef5;
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

  // 斑马纹
  :deep(.el-table__row--striped) {
    td {
      background: #fafafa;
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
}

// 操作按钮样式
.action-buttons {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;

  .action-btn {
    padding: 4px 10px;
    font-size: 13px;
    border-radius: 4px;
    transition: all 0.25s ease;
    border: 1px solid transparent;

    &:hover {
      transform: translateY(-1px);
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    }

    &.add-btn {
      border-color: var(--el-color-success);
      color: var(--el-color-success);

      &:hover {
        background: var(--el-color-success-light-9);
      }
    }

    &.edit-btn {
      border-color: var(--el-color-primary);
      color: var(--el-color-primary);

      &:hover {
        background: var(--el-color-primary-light-9);
      }
    }

    &.delete-btn {
      border-color: var(--el-color-danger);
      color: var(--el-color-danger);

      &:hover {
        background: var(--el-color-danger-light-9);
      }
    }
  }
}
</style>
