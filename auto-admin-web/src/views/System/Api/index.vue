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
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="name" label="接口名称" width="200" />
        <el-table-column prop="path" label="接口路径" width="250" />
        <el-table-column prop="method" label="请求方法" width="100">
          <template #default="{ row }">
            <el-tag :type="getMethodType(row.method) as any">
              {{ row.method }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="menuId" label="关联菜单" width="150">
          <template #default="{ row }">
            {{ row.menuId ? getMenuName(row.menuId) : '未关联' }}
          </template>
        </el-table-column>
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'danger'">
              {{ row.status === 1 ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="remark" label="备注" show-overflow-tooltip />
        <el-table-column label="操作" fixed="right" width="180">
          <template #default="{ row }">
            <div class="action-buttons">
              <el-button link type="primary" class="action-btn edit-btn" @click="handleUpdate(row)">编辑</el-button>
              <el-button link type="danger" class="action-btn delete-btn" @click="handleDelete(row)">删除</el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <el-pagination
        v-model:current-page="pageNum"
        v-model:page-size="pageSize"
        :page-sizes="[10, 20, 50]"
        :total="total"
        layout="total, sizes, prev, pager, next, jumper"
        style="margin-top: 16px; justify-content: flex-end"
        @size-change="handleQuery"
        @current-change="handleQuery"
      />
    </el-card>

    <!-- 新增/编辑对话框 -->
    <el-dialog :title="dialogTitle" v-model="dialogVisible" width="600px">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item label="接口名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入接口名称" />
        </el-form-item>
        <el-form-item label="接口路径" prop="path">
          <el-input v-model="form.path" placeholder="如：/api/user/list" />
        </el-form-item>
        <el-form-item label="请求方法" prop="method">
          <el-select v-model="form.method" placeholder="请选择请求方法">
            <el-option label="GET" value="GET" />
            <el-option label="POST" value="POST" />
            <el-option label="PUT" value="PUT" />
            <el-option label="DELETE" value="DELETE" />
          </el-select>
        </el-form-item>
        <el-form-item label="关联菜单" prop="menuId">
          <el-tree-select
            v-model="form.menuId"
            :data="menuTree"
            :props="{ children: 'children', label: 'name' }"
            placeholder="选择关联菜单（可选）"
            clearable
          />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio :label="1">启用</el-radio>
            <el-radio :label="0">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" :rows="3" placeholder="备注信息" />
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
import { getApiPageApi, addApiApi, updateApiApi, deleteApiApi } from '@/api/api'
import { getMenuTreeApi } from '@/api/menu'
import type { SysApi } from '@/types/api'

const loading = ref(false)
const dialogVisible = ref(false)
const dialogTitle = ref('')

const formRef = ref<FormInstance>()
const tableData = ref<SysApi[]>([])
const menuTree = ref<any[]>([])

// 分页参数
const pageNum = ref(1)
const pageSize = ref(10)
const total = ref(0)

const form = ref<SysApi>({
  id: undefined,
  path: '',
  method: 'GET',
  name: '',
  menuId: undefined,
  status: 1,
  remark: '',
})

const rules: FormRules = {
  path: [{ required: true, message: '请输入接口路径', trigger: 'blur' }],
  method: [{ required: true, message: '请选择请求方法', trigger: 'change' }],
}

const menuMap = ref<Map<number, string>>(new Map())

function getMethodType(method: string) {
  const typeMap: Record<string, string> = {
    GET: 'info',
    POST: 'success',
    PUT: 'warning',
    DELETE: 'danger',
  }
  return typeMap[method] || 'info'
}

function getMenuName(menuId: number) {
  return menuMap.value.get(menuId) || '未知'
}

function loadMenuTree() {
  getMenuTreeApi().then(({ data }) => {
    menuTree.value = data
    // 构建菜单名称映射
    const map = new Map<number, string>()
    const traverse = (nodes: any[]) => {
      nodes.forEach(node => {
        map.set(node.id, node.name)
        if (node.children && node.children.length > 0) {
          traverse(node.children)
        }
      })
    }
    traverse(data)
    menuMap.value = map
  })
}

function handleQuery() {
  loading.value = true
  getApiPageApi({ pageNum: pageNum.value, pageSize: pageSize.value }).then(({ data }) => {
    tableData.value = data.list
    total.value = data.total
    loading.value = false
  })
}

function handleAdd() {
  dialogTitle.value = '新增接口'
  form.value = { id: undefined, path: '', method: 'GET', name: '', menuId: undefined, status: 1, remark: '' }
  dialogVisible.value = true
}

function handleUpdate(row: SysApi) {
  dialogTitle.value = '编辑接口'
  form.value = { ...row }
  dialogVisible.value = true
}

function handleDelete(row: SysApi) {
  ElMessageBox.confirm(`确认删除接口 "${row.name}" 吗？`, '提示', { type: 'warning' }).then(() => {
    deleteApiApi(row.id!).then(() => {
      ElMessage.success('删除成功')
      handleQuery()
    })
  })
}

function submitForm() {
  if (!formRef.value) return
  formRef.value.validate((valid) => {
    if (!valid) return

    const api = form.value.id ? updateApiApi : addApiApi
    api(form.value).then(() => {
      ElMessage.success('操作成功')
      dialogVisible.value = false
      handleQuery()
    })
  })
}

onMounted(() => {
  loadMenuTree()
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