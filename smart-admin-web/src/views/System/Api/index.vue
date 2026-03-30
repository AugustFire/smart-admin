<template>
  <div class="api-management">
    <!-- 左侧菜单树 -->
    <div class="left-sidebar" :class="{ collapsed: isSidebarCollapsed }">
      <div class="sidebar-header">
        <span v-if="!isSidebarCollapsed" class="title">菜单树</span>
        <el-button-group size="small">
          <el-button v-if="!isSidebarCollapsed" @click="handleExpandAll" title="展开全部">
            <el-icon><Plus /></el-icon>
          </el-button>
          <el-button v-if="!isSidebarCollapsed" @click="handleCollapseAll" title="收起全部">
            <el-icon><Minus /></el-icon>
          </el-button>
          <el-button @click="isSidebarCollapsed = !isSidebarCollapsed" :title="isSidebarCollapsed ? '展开侧栏' : '收起侧栏'">
            <el-icon>
              <DArrowLeft v-if="!isSidebarCollapsed" />
              <DArrowRight v-else />
            </el-icon>
          </el-button>
        </el-button-group>
      </div>

      <div v-if="!isSidebarCollapsed" class="sidebar-content">
        <el-input
          v-model="menuFilterText"
          placeholder="搜索菜单..."
          clearable
          prefix-icon="Search"
          class="search-input"
        />
        <div class="tree-wrapper">
          <el-tree
            ref="menuTreeRef"
            :data="menuTree"
            :props="{ children: 'children', label: 'name' }"
            :filter-node-method="filterMenuNode"
            node-key="id"
            highlight-current
            :default-expand-all="false"
            :expand-on-click-node="false"
            @node-click="handleMenuClick"
          >
            <template #default="{ node, data }">
              <div class="menu-node" :class="{ 'is-selected': selectedMenu?.id === data.id }">
                <el-icon v-if="data.type === 1" class="menu-icon"><Folder /></el-icon>
                <el-icon v-else-if="data.type === 2" class="menu-icon"><Document /></el-icon>
                <el-icon v-else class="menu-icon"><Checked /></el-icon>
                <span class="menu-name">{{ node.label }}</span>
                <span v-if="data.apiCount" class="api-count">{{ data.apiCount }}</span>
              </div>
            </template>
          </el-tree>
        </div>
      </div>
    </div>

    <!-- 右侧API列表 -->
    <div class="main-content">
      <div class="content-header">
        <div class="header-left">
          <el-breadcrumb separator="/">
            <el-breadcrumb-item>API管理</el-breadcrumb-item>
            <el-breadcrumb-item v-if="selectedMenu">
              {{ selectedMenu.name }}
              <el-icon class="clear-select" @click.stop="handleShowAllApis"><Close /></el-icon>
            </el-breadcrumb-item>
          </el-breadcrumb>
          <span class="total-count">共 {{ total }} 个接口</span>
        </div>
        <div class="header-right">
          <el-button v-if="selectedMenu" v-permission="['api:edit']" type="primary" @click="handleBindApi">
            <el-icon><Link /></el-icon>
            绑定接口
          </el-button>
          <el-button v-permission="['api:add']" type="success" @click="handleAdd">
            <el-icon><Plus /></el-icon>
            新增接口
          </el-button>
        </div>
      </div>

      <!-- 搜索栏 -->
      <div class="search-bar">
        <el-input
          v-model="queryParams.path"
          placeholder="搜索接口路径"
          clearable
          prefix-icon="Search"
          class="search-field"
          @keyup.enter="handleQuery"
        />
        <el-select
          v-model="queryParams.method"
          placeholder="请求方法"
          clearable
          class="method-select"
        >
          <el-option label="GET" value="GET">
            <el-tag type="info" size="small">GET</el-tag>
          </el-option>
          <el-option label="POST" value="POST">
            <el-tag type="success" size="small">POST</el-tag>
          </el-option>
          <el-option label="PUT" value="PUT">
            <el-tag type="warning" size="small">PUT</el-tag>
          </el-option>
          <el-option label="DELETE" value="DELETE">
            <el-tag type="danger" size="small">DELETE</el-tag>
          </el-option>
        </el-select>
        <el-button type="primary" @click="handleQuery">搜索</el-button>
        <el-button @click="handleReset">重置</el-button>
      </div>

      <!-- 表格 -->
      <div class="table-wrapper">
        <el-table
          v-loading="loading"
          :data="tableData"
          class="api-table"
          :cell-style="{ padding: '8px 0' }"
          size="small"
          stripe
        >
          <el-table-column prop="name" label="接口名称" min-width="100">
            <template #default="{ row }">
              <span class="api-name">{{ row.name || '-' }}</span>
            </template>
          </el-table-column>
          <el-table-column label="接口" min-width="180" show-overflow-tooltip>
            <template #default="{ row }">
              <div class="api-cell">
                <el-tag :type="getMethodType(row.method)" size="small" class="method-tag">{{ row.method }}</el-tag>
                <code class="api-path">{{ row.path }}</code>
                <el-icon class="copy-icon" @click="copyPath(row.path)" title="复制路径"><DocumentCopy /></el-icon>
              </div>
            </template>
          </el-table-column>
          <el-table-column label="绑定" width="70" align="center" v-if="!selectedMenu">
            <template #default="{ row }">
              <template v-if="row.menuIds?.length">
                <span class="bind-count">{{ row.menuIds.length }}</span>
              </template>
              <template v-else>
                <span class="unbind-text">-</span>
              </template>
            </template>
          </el-table-column>
          <el-table-column label="公开" width="60" align="center">
            <template #default="{ row }">
              <el-icon v-if="row.isPublic === 1" class="icon-public"><Unlock /></el-icon>
              <span v-else class="text-muted">-</span>
            </template>
          </el-table-column>
          <el-table-column label="状态" width="60" align="center">
            <template #default="{ row }">
              <el-icon v-if="row.status === 1" class="icon-success"><CircleCheck /></el-icon>
              <el-icon v-else class="icon-disabled"><CircleClose /></el-icon>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="140" align="center" fixed="right">
            <template #default="{ row }">
              <el-button v-permission="['api:edit']" link type="primary" size="small" @click="handleUpdate(row)">
                <el-icon><Edit /></el-icon>编辑
              </el-button>
              <el-button v-if="selectedMenu" v-permission="['api:edit']" link type="warning" size="small" @click="handleUnbind(row)">
                <el-icon><Link /></el-icon>解绑
              </el-button>
              <el-button v-else v-permission="['api:delete']" link type="danger" size="small" @click="handleDelete(row)">
                <el-icon><Delete /></el-icon>删除
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>

      <!-- 分页 -->
      <div class="pagination-wrapper">
        <el-pagination
          v-model:current-page="pageNum"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 50, 100]"
          :total="total"
          layout="total, sizes, prev, pager, next, jumper"
          background
          @size-change="handleQuery"
          @current-change="handleQuery"
        />
      </div>
    </div>

    <!-- 新增/编辑对话框 -->
    <el-dialog
      :title="dialogTitle"
      v-model="dialogVisible"
      width="520px"
      :close-on-click-modal="false"
    >
      <el-form ref="formRef" :model="form" :rules="rules" label-width="90px">
        <el-form-item label="接口名称" prop="name">
          <el-input v-model="form.name" placeholder="如：获取用户列表" />
        </el-form-item>
        <el-form-item label="接口路径" prop="path">
          <el-input v-model="form.path" placeholder="如：/api/user/list" />
        </el-form-item>
        <el-form-item label="请求方法" prop="method">
          <el-select v-model="form.method" placeholder="请选择" style="width: 100%">
            <el-option label="GET" value="GET" />
            <el-option label="POST" value="POST" />
            <el-option label="PUT" value="PUT" />
            <el-option label="DELETE" value="DELETE" />
          </el-select>
        </el-form-item>
        <el-form-item label="关联菜单" prop="menuIds">
          <el-tree-select
            v-model="form.menuIds"
            :data="menuTree"
            :props="{ children: 'children', label: 'name', value: 'id' }"
            placeholder="选择关联菜单（可多选）"
            multiple
            collapse-tags
            collapse-tags-tooltip
            clearable
            check-strictly
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="公开接口" prop="isPublic">
          <el-radio-group v-model="form.isPublic">
            <el-radio :label="1">是</el-radio>
            <el-radio :label="0">否</el-radio>
          </el-radio-group>
          <div class="form-tip">公开接口无需权限即可访问</div>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio :label="1">启用</el-radio>
            <el-radio :label="0">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" :rows="2" placeholder="备注信息" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </template>
    </el-dialog>

    <!-- 绑定接口对话框 -->
    <el-dialog title="绑定接口" v-model="bindDialogVisible" width="650px" :close-on-click-modal="false">
      <div class="bind-dialog">
        <div class="bind-info">
          <span>当前菜单：</span>
          <el-tag type="primary">{{ selectedMenu?.name }}</el-tag>
        </div>
        <el-input
          v-model="bindSearchKey"
          placeholder="搜索接口名称或路径"
          clearable
          prefix-icon="Search"
          style="margin-bottom: 12px"
        />
        <el-table
          ref="bindTableRef"
          v-loading="bindLoading"
          :data="filteredBindApis"
          max-height="380"
          @selection-change="handleBindSelectionChange"
        >
          <el-table-column type="selection" width="50" />
          <el-table-column prop="name" label="接口名称" min-width="140" />
          <el-table-column prop="path" label="路径" min-width="180">
            <template #default="{ row }">
              <code class="api-path-small">{{ row.path }}</code>
            </template>
          </el-table-column>
          <el-table-column prop="method" label="方法" width="80" align="center">
            <template #default="{ row }">
              <el-tag :type="getMethodType(row.method)" size="small" effect="plain">
                {{ row.method }}
              </el-tag>
            </template>
          </el-table-column>
        </el-table>
      </div>
      <template #footer>
        <el-button @click="bindDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitBind" :disabled="bindSelection.length === 0">
          绑定选中 ({{ bindSelection.length }})
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue'
import { ElMessage, ElMessageBox, type FormInstance, type FormRules } from 'element-plus'
import { Unlock, CircleCheck, CircleClose, Edit, Delete, Link, DocumentCopy } from '@element-plus/icons-vue'
import { getApiPageApi, addApiApi, updateApiApi, deleteApiApi } from '@/api/api'
import { getMenuTreeApi } from '@/api/menu'
import type { SysApi } from '@/types/api'

const loading = ref(false)
const dialogVisible = ref(false)
const dialogTitle = ref('')
const bindDialogVisible = ref(false)
const bindLoading = ref(false)
const bindSearchKey = ref('')
const bindSelection = ref<SysApi[]>([])
const isSidebarCollapsed = ref(false)

const formRef = ref<FormInstance>()
const menuTreeRef = ref()
const tableData = ref<SysApi[]>([])
const menuTree = ref<any[]>([])
const selectedMenu = ref<any>(null)
const allApis = ref<SysApi[]>([])
const menuFilterText = ref('')

const queryParams = ref({ path: '', method: '' })
const pageNum = ref(1)
const pageSize = ref(10)
const total = ref(0)

const form = ref<SysApi>({
  id: undefined,
  path: '',
  method: 'GET',
  name: '',
  isPublic: 0,
  menuIds: [],
  status: 1,
  remark: '',
})

const rules: FormRules = {
  path: [{ required: true, message: '请输入接口路径', trigger: 'blur' }],
  method: [{ required: true, message: '请选择请求方法', trigger: 'change' }],
  name: [{ required: true, message: '请输入接口名称', trigger: 'blur' }],
}

const filteredBindApis = computed(() => {
  const key = bindSearchKey.value.toLowerCase()
  const boundIds = tableData.value.map(a => a.id)
  return allApis.value.filter(api => {
    if (boundIds.includes(api.id)) return false
    if (key && !api.name?.toLowerCase().includes(key) && !api.path.toLowerCase().includes(key)) return false
    return true
  })
})

watch(menuFilterText, (val) => {
  menuTreeRef.value?.filter(val)
})

function filterMenuNode(value: string, data: any) {
  if (!value) return true
  return data.name.includes(value)
}

function getMethodType(method: string) {
  const typeMap: Record<string, string> = {
    GET: 'info',
    POST: 'success',
    PUT: 'warning',
    DELETE: 'danger',
  }
  return typeMap[method] || 'info'
}

function copyPath(path: string) {
  navigator.clipboard.writeText(path).then(() => {
    ElMessage.success('已复制: ' + path)
  }).catch(() => {
    ElMessage.error('复制失败')
  })
}

function handleExpandAll() {
  const nodes = menuTreeRef.value?.store?.nodesMap
  if (nodes) {
    Object.values(nodes).forEach((node: any) => {
      node.expanded = true
    })
  }
}

function handleCollapseAll() {
  const nodes = menuTreeRef.value?.store?.nodesMap
  if (nodes) {
    Object.values(nodes).forEach((node: any) => {
      node.expanded = false
    })
  }
}

async function loadMenuTree() {
  const { data } = await getMenuTreeApi()
  menuTree.value = data
  await loadApiCounts()
}

async function loadApiCounts() {
  const { data } = await getApiPageApi({ pageNum: 1, pageSize: 1000 })
  allApis.value = data.list

  const countMap: Record<number, number> = {}
  allApis.value.forEach(api => {
    api.menuIds?.forEach(menuId => {
      countMap[menuId] = (countMap[menuId] || 0) + 1
    })
  })

  const updateCount = (nodes: any[]) => {
    nodes.forEach(node => {
      node.apiCount = countMap[node.id] || 0
      if (node.children) updateCount(node.children)
    })
  }
  updateCount(menuTree.value)
}

function handleMenuClick(data: any) {
  selectedMenu.value = data
  pageNum.value = 1
  handleQuery()
}

function handleShowAllApis() {
  selectedMenu.value = null
  pageNum.value = 1
  handleQuery()
}

function handleQuery() {
  loading.value = true
  const params: any = {
    pageNum: pageNum.value,
    pageSize: pageSize.value,
    path: queryParams.value.path || undefined,
    method: queryParams.value.method || undefined,
  }
  if (selectedMenu.value) {
    params.menuId = selectedMenu.value.id
  }
  getApiPageApi(params).then(({ data }) => {
    tableData.value = data.list
    total.value = data.total
    loading.value = false
  })
}

function handleReset() {
  queryParams.value = { path: '', method: '' }
  pageNum.value = 1
  handleQuery()
}

function handleAdd() {
  dialogTitle.value = '新增接口'
  form.value = { id: undefined, path: '', method: 'GET', name: '', isPublic: 0, menuIds: selectedMenu.value ? [selectedMenu.value.id] : [], status: 1, remark: '' }
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
      loadApiCounts()
    })
  })
}

function handleUnbind(row: SysApi) {
  ElMessageBox.confirm(`确认将接口 "${row.name}" 从当前菜单解绑吗？`, '提示', { type: 'warning' }).then(async () => {
    const newMenuIds = row.menuIds?.filter(id => id !== selectedMenu.value.id) || []
    await updateApiApi({ ...row, menuIds: newMenuIds })
    ElMessage.success('解绑成功')
    handleQuery()
    loadApiCounts()
  })
}

function handleBindApi() {
  bindSelection.value = []
  bindSearchKey.value = ''
  bindDialogVisible.value = true
}

function handleBindSelectionChange(selection: SysApi[]) {
  bindSelection.value = selection
}

async function submitBind() {
  if (bindSelection.value.length === 0) return

  bindLoading.value = true
  try {
    const menuId = selectedMenu.value.id
    for (const api of bindSelection.value) {
      const newMenuIds = [...(api.menuIds || []), menuId]
      await updateApiApi({ ...api, menuIds: newMenuIds })
    }
    ElMessage.success('绑定成功')
    bindDialogVisible.value = false
    handleQuery()
    loadApiCounts()
  } finally {
    bindLoading.value = false
  }
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
      loadApiCounts()
    })
  })
}

onMounted(() => {
  loadMenuTree()
  handleQuery()
})
</script>

<style lang="scss" scoped>
.api-management {
  display: flex;
  height: calc(100vh - 84px);
  background: var(--app-main-bg-color);
  padding: 12px;
  gap: 12px;
}

// 左侧边栏
.left-sidebar {
  width: 240px;
  background: var(--bg-primary);
  border-radius: 6px;
  box-shadow: var(--card-shadow);
  display: flex;
  flex-direction: column;
  transition: width 0.3s ease;
  overflow: hidden;

  &.collapsed {
    width: 50px;
  }

  .sidebar-header {
    padding: 10px;
    border-bottom: 1px solid var(--border-color);
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-shrink: 0;

    .title {
      font-size: 14px;
      font-weight: 600;
      color: var(--text-primary);
    }
  }

  .sidebar-content {
    flex: 1;
    display: flex;
    flex-direction: column;
    overflow: hidden;

    .search-input {
      margin: 10px;
      width: calc(100% - 20px);
    }

    .tree-wrapper {
      flex: 1;
      overflow: auto;
      padding: 0 6px 6px;
    }
  }
}

.menu-node {
  display: flex;
  align-items: center;
  gap: 5px;
  padding: 2px 0;
  width: 100%;

  .menu-icon {
    font-size: 15px;
    color: var(--text-secondary);
  }

  .menu-name {
    flex: 1;
    font-size: 13px;
    color: var(--text-regular);
  }

  .api-count {
    font-size: 11px;
    color: var(--text-secondary);
    background: var(--bg-secondary);
    padding: 1px 6px;
    border-radius: 10px;
    min-width: 18px;
    text-align: center;
    font-weight: 500;
  }

  &.is-selected {
    .menu-name {
      color: var(--el-color-primary);
      font-weight: 500;
    }
  }
}

// 右侧主内容
.main-content {
  flex: 1;
  min-width: 0;
  background: var(--bg-primary);
  border-radius: 6px;
  box-shadow: var(--card-shadow);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.content-header {
  padding: 12px 16px;
  border-bottom: 1px solid var(--border-color);
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-shrink: 0;

  .header-left {
    display: flex;
    align-items: center;
    gap: 12px;

    .clear-select {
      margin-left: 4px;
      cursor: pointer;
      color: var(--text-secondary);
      font-size: 14px;
      &:hover {
        color: var(--el-color-primary);
      }
    }

    .total-count {
      font-size: 13px;
      color: var(--text-secondary);
    }
  }

  .header-right {
    display: flex;
    gap: 8px;
  }
}

.search-bar {
  padding: 10px 16px;
  border-bottom: 1px solid var(--border-color);
  display: flex;
  gap: 10px;
  flex-shrink: 0;

  .search-field {
    width: 200px;
  }

  .method-select {
    width: 110px;
  }
}

.table-wrapper {
  flex: 1;
  overflow: auto;
  padding: 0 16px;

  .api-table {
    :deep(.el-table__header th) {
      background: var(--bg-secondary);
      color: var(--text-primary);
      font-weight: 500;
      padding: 10px 0;
    }
  }

  .api-name {
    font-size: 13px;
    color: var(--text-primary);
  }

  .api-cell {
    display: flex;
    align-items: center;
    gap: 8px;

    .copy-icon {
      cursor: pointer;
      color: var(--text-secondary);
      font-size: 14px;
      opacity: 0;
      transition: all 0.2s ease;

      &:hover {
        color: var(--el-color-primary);
      }
    }

    &:hover .copy-icon {
      opacity: 1;
    }
  }

  .method-tag {
    font-family: 'Monaco', 'Menlo', 'Consolas', monospace;
    font-weight: 600;
    font-size: 11px;
    width: 45px;
    justify-content: center;
  }

  .api-path {
    background: var(--bg-secondary);
    padding: 2px 8px;
    border-radius: 4px;
    font-family: 'Monaco', 'Menlo', 'Consolas', monospace;
    font-size: 13px;
    color: var(--text-primary);
    font-weight: 500;
  }

  .text-muted {
    color: var(--text-placeholder);
  }

  .icon-public {
    color: #E6A23C;
    font-size: 16px;
  }

  .icon-success {
    color: #67C23A;
    font-size: 16px;
  }

  .icon-disabled {
    color: var(--text-secondary);
    font-size: 16px;
  }

  .unbind-text {
    color: var(--text-placeholder);
    font-size: 14px;
  }

  .bind-count {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-width: 20px;
    height: 20px;
    padding: 0 6px;
    border-radius: 10px;
    background: var(--el-color-primary);
    color: #fff;
    font-size: 12px;
    font-weight: 500;
  }
}

.pagination-wrapper {
  padding: 12px 16px;
  border-top: 1px solid var(--border-color);
  display: flex;
  justify-content: flex-end;
  flex-shrink: 0;
}

// 对话框样式
.bind-dialog {
  .bind-info {
    margin-bottom: 12px;
    padding: 10px 12px;
    background: var(--bg-secondary);
    border-radius: 6px;
    font-size: 14px;
    color: var(--text-regular);

    .el-tag {
      margin-left: 8px;
    }
  }

  .api-path-small {
    background: var(--bg-secondary);
    padding: 2px 6px;
    border-radius: 3px;
    font-family: 'Monaco', 'Menlo', monospace;
    font-size: 12px;
    color: var(--text-regular);
  }
}

.form-tip {
  font-size: 12px;
  color: var(--text-secondary);
  margin-top: 4px;
}

// 树节点样式优化
:deep(.el-tree-node__content) {
  height: 32px;
  border-radius: 4px;
  margin: 1px 0;
  position: relative;

  &:hover {
    background: var(--bg-secondary);
  }
}

:deep(.el-tree-node.is-current > .el-tree-node__content) {
  background: var(--el-color-primary-light-9);

  &::before {
    content: '';
    position: absolute;
    left: 0;
    top: 4px;
    bottom: 4px;
    width: 3px;
    background: var(--el-color-primary);
    border-radius: 0 2px 2px 0;
  }
}
</style>