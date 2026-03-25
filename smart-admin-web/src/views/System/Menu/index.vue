<template>
  <div class="menu-management">
    <el-card class="menu-card">
      <!-- 顶部工具栏 -->
      <div class="toolbar">
        <div class="toolbar-left">
          <el-button v-permission="['menu:add']" type="primary" @click="handleAdd()">
            <el-icon><Plus /></el-icon>
            新增菜单
          </el-button>
        </div>
        <div class="toolbar-right">
          <el-button @click="handleExpandAll">
            <el-icon><Plus /></el-icon>
            展开全部
          </el-button>
          <el-button @click="handleCollapseAll">
            <el-icon><Minus /></el-icon>
            收起全部
          </el-button>
        </div>
      </div>

      <!-- 表格 -->
      <el-table
        v-loading="loading"
        :data="tableData"
        row-key="id"
        :expand-row-keys="expandedKeys"
        :tree-props="{ children: 'children', hasChildren: 'hasChildren' }"
        class="menu-table"
        :cell-style="{ padding: '6px 0' }"
        size="small"
      >
        <el-table-column prop="name" label="菜单名称" min-width="180">
          <template #default="{ row }">
            <div class="menu-name-cell">
              <el-icon v-if="row.type === 1" class="type-icon directory"><Folder /></el-icon>
              <el-icon v-else-if="row.type === 2" class="type-icon menu"><Document /></el-icon>
              <el-icon v-else class="type-icon button"><Checked /></el-icon>
              <span>{{ row.name }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="type" label="类型" width="70" align="center">
          <template #default="{ row }">
            <el-tag :type="getTypeTag(row.type)" size="small" effect="light">
              {{ getTypeLabel(row.type) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="path" label="路由路径" min-width="160">
          <template #default="{ row }">
            <div v-if="row.path" class="path-cell">
              <code class="path-code">{{ row.path }}</code>
              <el-icon class="copy-icon" @click="copyText(row.path)" title="复制"><DocumentCopy /></el-icon>
            </div>
            <span v-else class="text-muted">-</span>
          </template>
        </el-table-column>
        <el-table-column prop="permission" label="权限标识" min-width="120">
          <template #default="{ row }">
            <div v-if="row.permission" class="path-cell">
              <code class="permission-code">{{ row.permission }}</code>
              <el-icon class="copy-icon" @click="copyText(row.permission)" title="复制"><DocumentCopy /></el-icon>
            </div>
            <span v-else class="text-muted">-</span>
          </template>
        </el-table-column>
        <el-table-column prop="sort" label="排序" width="60" align="center">
          <template #default="{ row }">
            <span class="sort-num">{{ row.sort }}</span>
          </template>
        </el-table-column>
        <el-table-column label="可见" width="60" align="center">
          <template #default="{ row }">
            <el-switch
              v-model="row.visible"
              :active-value="1"
              :inactive-value="0"
              size="small"
              @change="handleVisibleChange(row)"
            />
          </template>
        </el-table-column>
        <el-table-column label="操作" width="140" align="center" fixed="right">
          <template #default="{ row }">
            <el-button v-permission="['menu:add']" link type="success" size="small" @click="handleAdd(row)">新增</el-button>
            <el-button v-permission="['menu:edit']" link type="primary" size="small" @click="handleUpdate(row)">编辑</el-button>
            <el-button v-permission="['menu:delete']" link type="danger" size="small" @click="handleDelete(row)">删除</el-button>
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
import { Plus, Minus, Edit, Delete, Folder, Document, Checked, DocumentCopy } from '@element-plus/icons-vue'
import { getMenuTreeApi, addMenuApi, updateMenuApi, deleteMenuApi, getRelatedApiCountApi } from '@/api/menu'

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

function handleExpandAll() {
  expandedKeys.value = getAllIds(tableData.value)
}

function handleCollapseAll() {
  expandedKeys.value = []
}

function getAllIds(data: any[]): string[] {
  const ids: string[] = []
  data.forEach(item => {
    ids.push(item.id)
    if (item.children && item.children.length > 0) {
      ids.push(...getAllIds(item.children))
    }
  })
  return ids
}

function handleVisibleChange(row: any) {
  updateMenuApi(row).then(() => {
    ElMessage.success('更新成功')
  })
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

async function handleDelete(row: any) {
  if (row.children && row.children.length > 0) {
    ElMessage.warning('存在子菜单，无法删除')
    return
  }

  // 获取关联的接口数量
  const { data: apiCount } = await getRelatedApiCountApi(row.id)

  let confirmMessage = `确认删除菜单 "${row.name}" 吗？`
  if (apiCount > 0) {
    confirmMessage = `该菜单关联 ${apiCount} 个接口，删除后接口将变为未分配状态。确认删除吗？`
  }

  ElMessageBox.confirm(confirmMessage, '提示', { type: 'warning' }).then(() => {
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

function copyText(text: string) {
  navigator.clipboard.writeText(text).then(() => {
    ElMessage.success('已复制')
  })
}

onMounted(() => {
  handleQuery()
})
</script>

<style lang="scss" scoped>
.menu-management {
  padding: 16px;
  min-height: calc(100vh - 84px);
  background: var(--app-main-bg-color);
}

.menu-card {
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  background: var(--bg-primary);

  :deep(.el-card__body) {
    padding: 0;
  }
}

.toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  border-bottom: 1px solid var(--border-color);
  background: var(--bg-primary);

  .toolbar-left, .toolbar-right {
    display: flex;
    gap: 8px;
  }
}

.menu-table {
  background: var(--bg-primary);

  :deep(.el-table__header th) {
    background: var(--bg-secondary) !important;
    color: var(--text-primary) !important;
    padding: 8px 0;
    font-size: 13px;
  }

  .menu-name-cell {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    font-size: 13px;
    vertical-align: middle;
    color: var(--text-regular);

    .type-icon {
      font-size: 14px;

      &.directory { color: #409EFF; }
      &.menu { color: #67C23A; }
      &.button { color: #E6A23C; }
    }
  }

  .path-cell {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    vertical-align: middle;

    .copy-icon {
      cursor: pointer;
      color: var(--text-secondary);
      font-size: 13px;
      opacity: 0;
      transition: all 0.2s;

      &:hover {
        color: var(--el-color-primary);
      }
    }

    &:hover .copy-icon {
      opacity: 1;
    }
  }

  .path-code, .permission-code {
    background: var(--bg-secondary);
    padding: 2px 8px;
    border-radius: 3px;
    font-family: 'Monaco', 'Menlo', 'Consolas', monospace;
    font-size: 12px;
    color: var(--text-regular);
    font-weight: 500;
  }

  .text-muted {
    color: var(--text-placeholder);
    font-size: 12px;
  }

  .sort-num {
    display: inline-block;
    background: var(--bg-secondary);
    padding: 1px 6px;
    border-radius: 8px;
    font-size: 11px;
    color: var(--text-secondary);
  }
}

:deep(.el-table__row) {
  background: var(--bg-primary);

  td {
    border-bottom: 1px solid var(--border-color);
    color: var(--text-regular);
    font-size: 13px;
  }

  &:hover > td {
    background: var(--bg-secondary) !important;
  }
}

:deep(.el-table__row--level-0) {
  > td:first-child {
    padding-left: 16px;
  }
}

// 子级缩进
:deep(.el-table__row--level-1) {
  > td:first-child {
    padding-left: 32px;
  }
}

:deep(.el-table__row--level-2) {
  > td:first-child {
    padding-left: 48px;
  }
}

// 折叠箭头样式优化
:deep(.el-table__expand-icon) {
  width: 16px;
  height: 16px;
  border-radius: 3px;
  background: var(--bg-secondary);
  transition: all 0.2s ease;
  margin-right: 4px;
  vertical-align: middle;

  .el-icon {
    font-size: 10px;
    color: var(--text-secondary);
    transition: transform 0.2s ease;
  }

  &:hover {
    background: var(--bg-tertiary);
  }

  // 展开状态
  &.el-table__expand-icon--expanded {
    .el-icon {
      transform: rotate(90deg);
    }
  }
}

// 空占位符（没有子节点的行）
:deep(.el-table__placeholder) {
  width: 20px;
  display: inline-block;
}
</style>
