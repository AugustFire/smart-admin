<template>
  <div class="relation-manager">
    <!-- 顶部工具栏 -->
    <div class="toolbar">
      <div class="toolbar-left">
        <el-select v-model="currentDatabaseId" placeholder="选择数据库" clearable style="width: 180px;" @change="handleDatabaseChange">
          <el-option v-for="db in databaseList" :key="db.id" :label="db.name" :value="db.id" />
        </el-select>
        <el-divider direction="vertical" />
        <el-button type="primary" :icon="Plus" @click="handleAdd" :disabled="!currentDatabaseId">新增关系</el-button>
        <el-button :icon="Refresh" @click="refresh">刷新</el-button>
      </div>
    </div>

    <!-- 关系列表 -->
    <div class="table-container">
      <el-table :data="relationList" v-loading="loading" stripe border size="small">
        <el-table-column prop="name" label="关系名称" min-width="150" show-overflow-tooltip />
        <el-table-column label="源表" min-width="140">
          <template #default="{ row }">
            <div class="table-cell">
              <el-tag size="small" type="info">{{ row.sourceTableName }}</el-tag>
              <span class="field-name">{{ row.sourceColumnName }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="关系" width="100" align="center">
          <template #default="{ row }">
            <el-tag :type="getRelationType(row.relationType)" size="small">
              {{ getRelationLabel(row.relationType) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="目标表" min-width="140">
          <template #default="{ row }">
            <div class="table-cell">
              <el-tag size="small" type="info">{{ row.targetTableName }}</el-tag>
              <span class="field-name">{{ row.targetColumnName }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="description" label="描述" min-width="180" show-overflow-tooltip />
        <el-table-column label="操作" width="150" align="center" fixed="right">
          <template #default="{ row }">
            <el-button link type="primary" size="small" @click="handleEdit(row)">编辑</el-button>
            <el-button link type="danger" size="small" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 关系弹窗 -->
    <relation-form
      v-model="formVisible"
      :data="currentRelation"
      :table-list="tableList"
      :database-id="currentDatabaseId"
      @success="refresh"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Refresh } from '@element-plus/icons-vue'
import {
  getDatabaseListApi,
  getTableListApi,
  getRelationListApi,
  deleteRelationApi
} from '@/api/datamodel'
import RelationForm from './components/RelationForm.vue'

const databaseList = ref<any[]>([])
const tableList = ref<any[]>([])
const relationList = ref<any[]>([])
const currentDatabaseId = ref<number | null>(null)
const currentRelation = ref<any>(null)
const formVisible = ref(false)
const loading = ref(false)

onMounted(() => {
  loadDatabases()
})

async function loadDatabases() {
  const { data } = await getDatabaseListApi()
  databaseList.value = data || []
}

async function handleDatabaseChange(val: number | null) {
  if (val) {
    const { data } = await getTableListApi(val)
    tableList.value = data || []
    await refresh()
  } else {
    tableList.value = []
    relationList.value = []
  }
}

async function refresh() {
  if (!currentDatabaseId.value) {
    relationList.value = []
    return
  }
  loading.value = true
  try {
    const { data } = await getRelationListApi(currentDatabaseId.value)
    relationList.value = data || []
  } finally {
    loading.value = false
  }
}

function handleAdd() {
  currentRelation.value = null
  formVisible.value = true
}

function handleEdit(row: any) {
  currentRelation.value = row
  formVisible.value = true
}

async function handleDelete(row: any) {
  try {
    await ElMessageBox.confirm(`确认删除关系 "${row.name}" 吗？`, '提示', { type: 'warning' })
    await deleteRelationApi(row.id)
    ElMessage.success('删除成功')
    refresh()
  } catch (e) {}
}

function getRelationLabel(type: string) {
  const map: Record<string, string> = {
    'ONE_TO_ONE': '1:1',
    'ONE_TO_MANY': '1:N',
    'MANY_TO_ONE': 'N:1',
    'MANY_TO_MANY': 'N:M',
    '1:1': '1:1',
    '1:N': '1:N',
    'N:1': 'N:1',
    'N:M': 'N:M'
  }
  return map[type] || type
}

function getRelationType(type: string): 'success' | 'primary' | 'warning' | 'danger' | 'info' {
  const map: Record<string, 'success' | 'primary' | 'warning' | 'danger' | 'info'> = {
    'ONE_TO_ONE': 'success',
    'ONE_TO_MANY': 'primary',
    'MANY_TO_ONE': 'warning',
    'MANY_TO_MANY': 'danger',
    '1:1': 'success',
    '1:N': 'primary',
    'N:1': 'warning',
    'N:M': 'danger'
  }
  return map[type] || 'info'
}
</script>

<style lang="scss" scoped>
.relation-manager {
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

.table-container {
  flex: 1;
  padding: 16px;
  overflow: auto;
}

.table-cell {
  display: flex;
  flex-direction: column;
  gap: 4px;

  .field-name {
    font-size: 12px;
    color: #909399;
  }
}
</style>
