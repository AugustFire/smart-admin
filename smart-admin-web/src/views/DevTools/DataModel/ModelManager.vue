<template>
  <div class="model-manager">
    <!-- 顶部工具栏 -->
    <div class="toolbar">
      <div class="toolbar-left">
        <el-select v-model="currentDatabaseId" placeholder="选择数据库" clearable style="width: 180px;" @change="handleDatabaseChange">
          <el-option v-for="db in databaseList" :key="db.id" :label="db.name" :value="db.id" />
        </el-select>
        <el-divider direction="vertical" />
        <el-button type="primary" :icon="Plus" @click="handleAddDatabase">新增数据库</el-button>
        <el-button type="primary" :icon="Plus" @click="handleAddTable" :disabled="!currentDatabaseId">新增数据表</el-button>
        <el-button type="primary" :icon="Plus" @click="handleAddRelation" :disabled="!currentDatabaseId">新增关系</el-button>
        <el-button :icon="Refresh" @click="refreshAll">刷新</el-button>
      </div>
    </div>

    <!-- 内部标签页 -->
    <div class="main-tabs">
      <div class="tab-header">
        <div class="tab-item" :class="{ active: innerTab === 'tables' }" @click="innerTab = 'tables'">
          <el-icon><Grid /></el-icon>
          <span>数据表</span>
        </div>
        <div class="tab-item" :class="{ active: innerTab === 'relations' }" @click="innerTab = 'relations'">
          <el-icon><Share /></el-icon>
          <span>表关系</span>
        </div>
      </div>

      <!-- 数据表面板 -->
      <div v-show="innerTab === 'tables'" class="tab-content">
        <!-- 左侧数据库列表 -->
        <div class="database-panel">
          <div class="panel-header">数据库列表</div>
          <div class="panel-content">
            <div v-if="databaseList.length === 0" class="empty-tip">暂无数据库</div>
            <div v-else class="database-list">
              <div
                v-for="db in databaseList"
                :key="db.id"
                class="database-item"
                :class="{ active: currentDatabaseId === db.id }"
                @click="selectDatabase(db.id)"
              >
                <el-icon class="db-icon"><Folder /></el-icon>
                <div class="db-info">
                  <span class="db-name">{{ db.name }}</span>
                  <span class="db-code">{{ db.code }}</span>
                </div>
                <div class="db-actions">
                  <el-button link type="primary" size="small" @click.stop="editDatabase(db)">
                    <el-icon><Edit /></el-icon>
                  </el-button>
                  <el-button link type="danger" size="small" @click.stop="deleteDatabase(db)">
                    <el-icon><Delete /></el-icon>
                  </el-button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 右侧表列表（可展开显示字段） -->
        <div class="table-panel">
          <div class="panel-header">
            <span>数据表列表</span>
            <el-tag v-if="currentDatabaseName" type="info" size="small">{{ currentDatabaseName }} ({{ currentDatabaseType }})</el-tag>
          </div>
          <div class="panel-content">
            <div v-if="!currentDatabaseId" class="empty-tip">请先选择数据库</div>
            <div v-else-if="tableList.length === 0" class="empty-tip">暂无数据表</div>
            <div v-else class="table-list">
              <div v-for="table in tableList" :key="table.id" class="table-item-wrapper">
                <!-- 表卡片头部 -->
                <div class="table-card-header" @click="toggleTableExpand(table)">
                  <div class="header-left">
                    <el-icon class="expand-icon" :class="{ expanded: expandedTables.has(table.id) }">
                      <ArrowRight />
                    </el-icon>
                    <el-icon class="table-icon"><Grid /></el-icon>
                    <span class="table-name">{{ table.name }}</span>
                    <span class="table-code">{{ table.code }}</span>
                  </div>
                  <div class="header-right">
                    <span class="field-count">{{ table.columnCount || 0 }} 字段</span>
                    <div class="table-actions">
                      <el-button link type="primary" size="small" @click.stop="editTable(table)">
                        <el-icon><Edit /></el-icon>
                      </el-button>
                      <el-button link type="danger" size="small" @click.stop="deleteTable(table)">
                        <el-icon><Delete /></el-icon>
                      </el-button>
                    </div>
                  </div>
                </div>

                <!-- 表字段列表（展开显示） -->
                <div v-if="expandedTables.has(table.id)" class="table-fields">
                  <div v-if="tableColumnsMap[table.id]?.length === 0" class="fields-empty">
                    <span>暂无字段</span>
                    <el-button type="primary" size="small" :icon="EditPen" @click="handleBatchEditColumn(table)">批量编辑</el-button>
                  </div>
                  <div v-else class="fields-content">
                    <div class="fields-toolbar">
                      <el-button size="small" :icon="EditPen" @click="handleBatchEditColumn(table)">批量编辑</el-button>
                      <span class="field-count-hint">共 {{ tableColumnsMap[table.id]?.length || 0 }} 个字段</span>
                    </div>
                    <el-table :data="tableColumnsMap[table.id]" size="small" border stripe max-height="280" style="width: 100%" class="field-table">
                      <el-table-column prop="name" label="字段名" width="100" />
                      <el-table-column prop="code" label="编码" width="110" />
                      <el-table-column label="类型" width="120">
                        <template #default="{ row }">
                          {{ row.dataType }}{{ row.length ? '(' + row.length + ')' : '' }}
                        </template>
                      </el-table-column>
                      <el-table-column label="属性" width="160" align="left">
                        <template #header>
                          <el-tooltip placement="top" effect="dark">
                            <template #content>
                              <div class="attr-tip">PK=主键 FK=外键 AI=自增 UQ=唯一 CORE=核心 NN=非空 IDX=索引</div>
                            </template>
                            <span class="attr-header">属性 <el-icon><InfoFilled /></el-icon></span>
                          </el-tooltip>
                        </template>
                        <template #default="{ row }">
                          <span v-if="row.isPrimary" class="attr-tag tag-pk">PK</span>
                          <span v-if="row.isForeign" class="attr-tag tag-fk">FK</span>
                          <span v-if="row.isAutoIncrement" class="attr-tag tag-ai">AI</span>
                          <span v-if="row.isUnique" class="attr-tag tag-uq">UQ</span>
                          <span v-if="row.isCore" class="attr-tag tag-core">CORE</span>
                          <span v-if="row.isNullable === 0" class="attr-tag tag-nn">NN</span>
                          <span v-if="row.indexType && row.indexType !== 'none'" class="attr-tag tag-idx">IDX</span>
                        </template>
                      </el-table-column>
                      <el-table-column prop="description" label="描述" min-width="120" show-overflow-tooltip />
                    </el-table>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 表关系面板 -->
      <div v-show="innerTab === 'relations'" class="tab-content relation-panel">
        <div v-if="!currentDatabaseId" class="empty-tip">请先选择数据库</div>
        <div v-else-if="relationList.length === 0" class="empty-tip">
          <p>暂无表关系</p>
          <el-button type="primary" :icon="Plus" @click="handleAddRelation">添加关系</el-button>
        </div>
        <div v-else class="relation-content">
          <div class="relation-toolbar">
            <el-button type="primary" :icon="Plus" @click="handleAddRelation">新增关系</el-button>
          </div>
          <el-table :data="relationList" size="small" border stripe style="width: 100%;">
            <el-table-column label="源表" min-width="180" show-overflow-tooltip>
              <template #default="{ row }">
                <div class="relation-cell-compact">
                  <span class="table-name-with-code">
                    {{ row.sourceTableName }}
                    <span class="code-separator">/</span>
                    <span class="code-part">{{ row.sourceTableCode }}</span>
                  </span>
                  <span class="relation-arrow">→</span>
                  <span class="field-code">{{ row.sourceColumnCode }}</span>
                </div>
              </template>
            </el-table-column>
            <el-table-column label="关系" width="65" align="center">
              <template #default="{ row }">
                <el-tag :type="getRelationType(row.relationType)" size="small">
                  {{ getRelationLabel(row.relationType) }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="目标表" min-width="180" show-overflow-tooltip>
              <template #default="{ row }">
                <div class="relation-cell-compact">
                  <span class="table-name-with-code">
                    {{ row.targetTableName }}
                    <span class="code-separator">/</span>
                    <span class="code-part">{{ row.targetTableCode }}</span>
                  </span>
                  <span class="relation-arrow">→</span>
                  <span class="field-code">{{ row.targetColumnCode }}</span>
                </div>
              </template>
            </el-table-column>
            <el-table-column prop="description" label="描述" min-width="120" show-overflow-tooltip />
            <el-table-column label="操作" width="100" align="center" fixed="right">
              <template #default="{ row }">
                <el-button link type="primary" size="small" @click="editRelation(row)">编辑</el-button>
                <el-button link type="danger" size="small" @click="deleteRelation(row)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </div>
    </div>

    <!-- 表单弹窗 -->
    <database-form v-model="databaseFormVisible" :data="currentDatabase" @success="refreshDatabases" />
    <table-form v-model="tableFormVisible" :data="currentTable" :database-id="currentDatabaseId" :database-name="currentDatabaseName" @success="refreshTables" />
    <relation-form v-model="relationFormVisible" :data="currentRelation" :table-list="tableList" :database-id="currentDatabaseId" @success="refreshRelations" />
    <batch-column-form
      v-model="batchColumnFormVisible"
      :table-id="currentTableId"
      :table-name="currentTableForBatch?.name || ''"
      :database-type="currentDatabaseType"
      :columns="currentTableForBatch ? tableColumnsMap[currentTableForBatch.id] : []"
      @success="refreshColumns"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Refresh, Folder, Grid, Edit, Delete, ArrowRight, Share, InfoFilled, EditPen } from '@element-plus/icons-vue'
import {
  getDatabaseListApi,
  getTableListApi,
  getColumnListApi,
  getRelationListApi,
  deleteDatabaseApi,
  deleteTableApi,
  deleteRelationApi
} from '@/api/datamodel'
import DatabaseForm from './components/DatabaseForm.vue'
import TableForm from './components/TableForm.vue'
import RelationForm from './components/RelationForm.vue'
import BatchColumnForm from './components/BatchColumnForm.vue'

// 内部标签页
const innerTab = ref('tables')

// 数据状态
const databaseList = ref<any[]>([])
const tableList = ref<any[]>([])
const relationList = ref<any[]>([])
const tableColumnsMap = reactive({} as Record<number, any[]>)

// 当前选中
const currentDatabaseId = ref<number | null>(null)
const currentDatabaseName = ref('')
const currentDatabaseType = ref('mysql')
const currentDatabase = ref<any>(null)
const currentTable = ref<any>(null)
const currentTableId = ref<number | null>(null)
const currentRelation = ref<any>(null)

// 展开状态
const expandedTables = reactive(new Set<number>())

// 弹窗状态
const databaseFormVisible = ref(false)
const tableFormVisible = ref(false)
const relationFormVisible = ref(false)
const batchColumnFormVisible = ref(false)

// 批量编辑当前表
const currentTableForBatch = ref<any>(null)

onMounted(() => {
  refreshDatabases()
})

// 刷新数据库列表
async function refreshDatabases() {
  const { data } = await getDatabaseListApi()
  databaseList.value = data || []
}

// 刷新表列表
async function refreshTables() {
  if (!currentDatabaseId.value) return
  const { data } = await getTableListApi(currentDatabaseId.value)
  tableList.value = data || []
  // 清空字段缓存
  for (const key in tableColumnsMap) {
    delete tableColumnsMap[key]
  }
  expandedTables.clear()
}

// 刷新字段列表
async function refreshColumns() {
  if (!currentTableId.value) return
  const { data } = await getColumnListApi(currentTableId.value)
  tableColumnsMap[currentTableId.value] = data || []
  // 更新表字段数量
  const table = tableList.value.find(t => t.id === currentTableId.value)
  if (table) {
    table.columnCount = data?.length || 0
  }
}

// 刷新关系列表
async function refreshRelations() {
  if (!currentDatabaseId.value) return
  const { data } = await getRelationListApi(currentDatabaseId.value)
  relationList.value = data || []
}

// 刷新全部
function refreshAll() {
  refreshDatabases()
  if (currentDatabaseId.value) {
    refreshTables()
    refreshRelations()
  }
}

// 选择数据库
function selectDatabase(id: number) {
  currentDatabaseId.value = id
  const db = databaseList.value.find(d => d.id === id)
  currentDatabaseName.value = db?.name || ''
  currentDatabaseType.value = db?.type || 'mysql'
  refreshTables()
  refreshRelations()
}

function handleDatabaseChange(val: number | null) {
  if (val) {
    selectDatabase(val)
  } else {
    currentDatabaseId.value = null
    currentDatabaseName.value = ''
    currentDatabaseType.value = 'mysql'
    tableList.value = []
    relationList.value = []
    expandedTables.clear()
  }
}

// 展开/折叠表
async function toggleTableExpand(table: any) {
  if (expandedTables.has(table.id)) {
    expandedTables.delete(table.id)
  } else {
    expandedTables.add(table.id)
    // 加载字段
    if (!tableColumnsMap[table.id]) {
      const { data } = await getColumnListApi(table.id)
      tableColumnsMap[table.id] = data || []
      table.columnCount = data?.length || 0
    }
  }
}

// 数据库操作
function handleAddDatabase() {
  currentDatabase.value = null
  databaseFormVisible.value = true
}

function editDatabase(db: any) {
  currentDatabase.value = db
  databaseFormVisible.value = true
}

async function deleteDatabase(db: any) {
  try {
    await ElMessageBox.confirm(`确认删除数据库 "${db.name}" 吗？`, '提示', { type: 'warning' })
    await deleteDatabaseApi(db.id)
    ElMessage.success('删除成功')
    if (currentDatabaseId.value === db.id) {
      currentDatabaseId.value = null
      currentDatabaseName.value = ''
      tableList.value = []
      relationList.value = []
    }
    refreshDatabases()
  } catch (e) {}
}

// 表操作
function handleAddTable() {
  currentTable.value = null
  tableFormVisible.value = true
}

function editTable(table: any) {
  currentTable.value = table
  tableFormVisible.value = true
}

async function deleteTable(table: any) {
  try {
    await ElMessageBox.confirm(`确认删除数据表 "${table.name}" 吗？`, '提示', { type: 'warning' })
    await deleteTableApi(table.id)
    ElMessage.success('删除成功')
    expandedTables.delete(table.id)
    delete tableColumnsMap[table.id]
    refreshTables()
    refreshRelations()
  } catch (e) {}
}

// 批量编辑字段
function handleBatchEditColumn(table: any) {
  currentTableId.value = table.id
  currentTableForBatch.value = table
  batchColumnFormVisible.value = true
}

// 关系操作
function handleAddRelation() {
  currentRelation.value = null
  relationFormVisible.value = true
}

function editRelation(rel: any) {
  currentRelation.value = rel
  relationFormVisible.value = true
}

async function deleteRelation(rel: any) {
  try {
    await ElMessageBox.confirm(`确认删除关系 "${rel.name}" 吗？`, '提示', { type: 'warning' })
    await deleteRelationApi(rel.id)
    ElMessage.success('删除成功')
    refreshRelations()
  } catch (e) {}
}

// 工具函数
function getRelationLabel(type: string) {
  const map: Record<string, string> = {
    'ONE_TO_ONE': '1:1', 'ONE_TO_MANY': '1:N', 'MANY_TO_ONE': 'N:1', 'MANY_TO_MANY': 'N:M',
    '1:1': '1:1', '1:N': '1:N', 'N:1': 'N:1', 'N:M': 'N:M'
  }
  return map[type] || type
}

function getRelationType(type: string): 'success' | 'primary' | 'warning' | 'danger' | 'info' {
  const map: Record<string, 'success' | 'primary' | 'warning' | 'danger' | 'info'> = {
    'ONE_TO_ONE': 'success', 'ONE_TO_MANY': 'primary', 'MANY_TO_ONE': 'warning', 'MANY_TO_MANY': 'danger',
    '1:1': 'success', '1:N': 'primary', 'N:1': 'warning', 'N:M': 'danger'
  }
  return map[type] || 'info'
}
</script>

<style lang="scss" scoped>
.model-manager {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.toolbar {
  padding: 12px 16px;
  border-bottom: 1px solid var(--border-color);
  display: flex;
  align-items: center;

  .toolbar-left {
    display: flex;
    align-items: center;
    gap: 8px;
  }
}

// 内部标签页
.main-tabs {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.tab-header {
  display: flex;
  border-bottom: 1px solid var(--border-color);
  padding: 0 16px;
  background: var(--bg-secondary);
}

.tab-item {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 12px 20px;
  cursor: pointer;
  font-size: 14px;
  color: var(--text-secondary);
  border-bottom: 2px solid transparent;
  transition: all 0.2s;

  &:hover {
    color: var(--el-color-primary);
  }

  &.active {
    color: var(--el-color-primary);
    border-bottom-color: var(--el-color-primary);
  }
}

.tab-content {
  flex: 1;
  display: flex;
  overflow: hidden;
}

// 左侧面板
.database-panel {
  width: 260px;
  border-right: 1px solid var(--border-color);
  display: flex;
  flex-direction: column;
  background: var(--bg-primary);
}

.panel-header {
  padding: 12px 16px;
  font-weight: 600;
  font-size: 14px;
  border-bottom: 1px solid var(--border-color);
  display: flex;
  align-items: center;
  gap: 8px;
}

.panel-content {
  flex: 1;
  overflow-y: auto;
  padding: 8px;
}

.empty-tip {
  text-align: center;
  color: var(--text-secondary);
  padding: 40px 20px;
  font-size: 14px;
}

.database-list {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.database-item {
  display: flex;
  align-items: center;
  padding: 10px 12px;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s ease;
  gap: 8px;
  margin-bottom: 4px;

  &:hover {
    background: var(--bg-secondary);
    transform: translateX(2px);
  }

  &.active {
    background: var(--el-color-primary-light-9);
    border-left: 3px solid var(--el-color-primary);
    box-shadow: 0 2px 8px rgba(254, 64, 102, 0.1);
  }

  .db-icon {
    color: var(--el-color-primary);
    font-size: 16px;
    transition: transform 0.2s ease;
  }

  &:hover .db-icon {
    transform: scale(1.1);
  }

  .db-info {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 2px;
    overflow: hidden;
    min-width: 0;
  }

  .db-name {
    font-size: 13px;
    font-weight: 500;
    color: var(--text-regular);
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .db-code {
    font-size: 11px;
    color: var(--text-secondary);
    background: var(--bg-tertiary);
    padding: 1px 6px;
    border-radius: 3px;
    font-family: 'SF Mono', Monaco, 'Cascadia Code', 'Roboto Mono', Consolas, 'Courier New', monospace;
    font-weight: 500;
    letter-spacing: 0.3px;
    display: inline-block;
    max-width: 100%;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .db-actions {
    display: flex;
    gap: 4px;
    opacity: 0;
    transition: opacity 0.2s ease;
  }

  &:hover .db-actions {
    opacity: 1;
  }
}

// 右侧表面板
.table-panel {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.table-list {
  flex: 1;
  overflow-y: auto;
  padding: 8px;
}

.table-item-wrapper {
  background: var(--bg-primary);
  border: 1px solid var(--border-color);
  border-radius: var(--card-radius);
  margin-bottom: 12px;
  overflow: hidden;
  box-shadow: var(--card-shadow);
  transition: all 0.3s ease;

  &:hover {
    box-shadow: var(--card-hover-shadow);
    border-color: var(--el-color-primary-light-5);
  }
}

.table-card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 14px 18px;
  cursor: pointer;
  transition: all 0.2s ease;

  &:hover {
    background: var(--bg-secondary);
  }

  .header-left {
    display: flex;
    align-items: center;
    gap: 10px;
  }

  .expand-icon {
    font-size: 12px;
    color: var(--text-secondary);
    transition: transform 0.25s cubic-bezier(0.4, 0, 0.2, 1);

    &.expanded {
      transform: rotate(90deg);
    }
  }

  .table-icon {
    color: var(--el-color-primary);
    font-size: 18px;
    transition: transform 0.2s ease;
  }

  &:hover .table-icon {
    transform: scale(1.1);
  }

  .table-name {
    font-weight: 600;
    font-size: 14px;
    color: var(--text-primary);
  }

  .table-code {
    font-size: 12px;
    color: var(--text-regular);
    font-family: 'SF Mono', Monaco, 'Cascadia Code', 'Roboto Mono', Consolas, 'Courier New', monospace;
    font-weight: 500;
    letter-spacing: 0.3px;
    background: var(--bg-tertiary);
    padding: 2px 8px;
    border-radius: 4px;
    border: 1px solid var(--border-color-light);
  }

  .header-right {
    display: flex;
    align-items: center;
    gap: 12px;
  }

  .field-count {
    font-size: 12px;
    color: var(--text-secondary);
    background: var(--bg-secondary);
    padding: 4px 10px;
    border-radius: 12px;
  }

  .table-actions {
    display: flex;
    gap: 4px;
    opacity: 0;
    transition: opacity 0.2s ease;
  }

  &:hover .table-actions {
    opacity: 1;
  }
}

.table-fields {
  border-top: 1px solid var(--border-color);
  padding: 12px 16px;
  background: var(--bg-secondary);

  .fields-empty {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 12px;
    padding: 20px;
    color: var(--text-secondary);
  }

  .fields-toolbar {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 8px;

    .field-count-hint {
      margin-left: auto;
      font-size: 13px;
      color: var(--text-secondary);
    }
  }

  // 表格样式 - 依赖全局样式，仅做必要调整
  .field-table {
    :deep(.el-table__cell) {
      padding: 6px 8px;
    }
  }

  .attr-header {
    cursor: help;
    .el-icon {
      font-size: 12px;
      vertical-align: middle;
      margin-left: 2px;
      color: var(--text-placeholder);
    }
  }

  // 属性标签 - 使用统一配色
  .attr-tag {
    display: inline-block;
    font-size: 10px;
    font-weight: 600;
    padding: 1px 4px;
    border-radius: 2px;
    margin-right: 2px;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;

    &.tag-pk {
      background: #fee2e2;
      color: #dc2626;
    }
    &.tag-fk {
      background: #fef3c7;
      color: #d97706;
    }
    &.tag-ai {
      background: #dbeafe;
      color: #2563eb;
    }
    &.tag-uq {
      background: #d1fae5;
      color: #059669;
    }
    &.tag-nn {
      background: #f1f5f9;
      color: #64748b;
    }
    &.tag-core {
      background: #fef9c3;
      color: #ca8a04;
    }
    &.tag-idx {
      background: #ede9fe;
      color: #7c3aed;
    }
  }
}

.attr-tip {
  font-size: 12px;
  line-height: 1.6;
}

// 关系面板
.relation-panel {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding: 16px;
  background: var(--bg-primary);

  .relation-toolbar {
    margin-bottom: 12px;
  }

  .relation-content {
    flex: 1;
    overflow: auto;
  }
}

.relation-cell {
  display: flex;
  flex-direction: column;
  gap: 4px;

  .table-code-text {
    font-size: 11px;
    color: var(--text-secondary);
    font-family: 'SF Mono', Monaco, 'Cascadia Code', 'Roboto Mono', Consolas, monospace;
    background: var(--bg-tertiary);
    padding: 1px 6px;
    border-radius: 3px;
    display: inline-block;
    width: fit-content;
  }

  .field-name {
    font-size: 12px;
    color: var(--el-color-primary);
    font-family: 'SF Mono', Monaco, 'Cascadia Code', 'Roboto Mono', Consolas, monospace;
  }
}

.relation-cell-compact {
  display: flex;
  align-items: center;
  gap: 6px;
  flex-wrap: nowrap;
  white-space: nowrap;
  overflow: hidden;

  .table-name-with-code {
    display: flex;
    align-items: center;
    gap: 4px;
    font-size: 13px;
    color: var(--text-primary);
    font-weight: 500;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;

    .code-separator {
      color: var(--text-placeholder);
      font-size: 12px;
      font-weight: 400;
      margin: 0 2px;
    }

    .code-part {
      font-size: 12px;
      color: var(--text-secondary);
      font-family: 'SF Mono', Monaco, 'Cascadia Code', 'Roboto Mono', Consolas, monospace;
      background: var(--bg-tertiary);
      padding: 1px 5px;
      border-radius: 3px;
      font-weight: 500;
    }
  }

  .relation-arrow {
    color: var(--text-placeholder);
    font-size: 12px;
    flex-shrink: 0;
  }

  .field-code {
    font-size: 12px;
    color: var(--el-color-primary);
    font-family: 'SF Mono', Monaco, 'Cascadia Code', 'Roboto Mono', Consolas, monospace;
    background: var(--el-color-primary-light-9);
    padding: 1px 6px;
    border-radius: 3px;
    flex-shrink: 0;
  }
}
</style>