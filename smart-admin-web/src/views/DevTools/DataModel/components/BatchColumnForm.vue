<template>
  <el-dialog
    :title="`批量编辑字段 - ${tableName}`"
    v-model="visible"
    width="90%"
    top="5vh"
    :close-on-click-modal="false"
    :close-on-press-escape="false"
    destroy-on-close
  >
    <div class="batch-editor">
      <!-- 工具栏 -->
      <div class="editor-toolbar">
        <el-button type="primary" :icon="Plus" size="default" @click="addRow">添加字段</el-button>
        <el-button
          type="danger"
          :icon="Delete"
          size="default"
          :disabled="!selectedRows.length"
          @click="deleteSelected"
        >
          删除选中 ({{ selectedRows.length }})
        </el-button>
        <span class="toolbar-info">
          共 <strong>{{ columnList.length }}</strong> 个字段
          <span v-if="duplicateCodes.length" class="error-hint">（存在 {{ duplicateCodes.length }} 个重复编码）</span>
        </span>
      </div>

      <!-- 表格 -->
      <el-table
        ref="tableRef"
        :data="columnList"
        size="default"
        border
        stripe
        max-height="55vh"
        style="width: 100%"
        @selection-change="handleSelectionChange"
      >
        <el-table-column type="selection" width="50" align="center" fixed="left" />
        <el-table-column label="#" width="50" align="center" fixed="left">
          <template #default="{ $index }">{{ $index + 1 }}</template>
        </el-table-column>

        <el-table-column label="字段名称" width="100" prop="name" fixed="left">
          <template #default="{ row }">
            <el-input v-model="row.name" size="default" placeholder="名称" @blur="handleNameBlur(row)" />
          </template>
        </el-table-column>

        <el-table-column label="字段编码" width="150" prop="code" fixed="left">
          <template #default="{ row }">
            <el-input
              v-model="row.code"
              size="default"
              placeholder="编码"
              :class="{ 'has-error': duplicateCodes.includes(row.code) && row.code }"
            />
          </template>
        </el-table-column>

        <el-table-column label="类型" width="110" prop="dataType">
          <template #default="{ row }">
            <el-select v-model="row.dataType" size="default" style="width: 100%;">
              <el-option v-for="type in dataTypeOptions" :key="type.value" :label="type.label" :value="type.value" />
            </el-select>
          </template>
        </el-table-column>

        <el-table-column label="长度" width="70" prop="length">
          <template #default="{ row }">
            <el-input-number v-model="row.length" size="default" :min="0" :controls="false" style="width: 100%" />
          </template>
        </el-table-column>

        <el-table-column label="属性" width="220" align="left">
          <template #default="{ row }">
            <div class="attr-checks">
              <el-checkbox v-model="row.isPrimary" :true-value="1" :false-value="0">PK</el-checkbox>
              <el-checkbox v-model="row.isNullable" :true-value="1" :false-value="0">NULL</el-checkbox>
              <el-checkbox v-model="row.isAutoIncrement" :true-value="1" :false-value="0">AI</el-checkbox>
              <el-checkbox v-model="row.isUnique" :true-value="1" :false-value="0">UQ</el-checkbox>
              <el-checkbox v-model="row.isForeign" :true-value="1" :false-value="0">FK</el-checkbox>
              <el-checkbox v-model="row.isCore" :true-value="1" :false-value="0">CORE</el-checkbox>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="索引" width="85" prop="indexType">
          <template #default="{ row }">
            <el-select v-model="row.indexType" size="default" style="width: 100%;">
              <el-option label="无" value="none" />
              <el-option label="普通" value="normal" />
              <el-option label="唯一" value="unique" />
              <el-option label="全文" value="fulltext" />
            </el-select>
          </template>
        </el-table-column>

        <el-table-column label="默认值" width="100" prop="defaultValue">
          <template #default="{ row }">
            <el-input v-model="row.defaultValue" size="default" placeholder="默认值" />
          </template>
        </el-table-column>

        <el-table-column label="排序" width="60" prop="sort">
          <template #default="{ row }">
            <el-input-number v-model="row.sort" size="default" :min="0" :controls="false" style="width: 100%" />
          </template>
        </el-table-column>

        <el-table-column label="描述" min-width="150" prop="description">
          <template #default="{ row }">
            <el-input v-model="row.description" size="default" placeholder="描述" />
          </template>
        </el-table-column>

        <el-table-column label="" width="50" align="center" fixed="right">
          <template #default="{ $index }">
            <el-button link type="danger" size="default" :icon="Delete" @click="deleteRow($index)" />
          </template>
        </el-table-column>
      </el-table>
    </div>

    <template #footer>
      <el-button size="default" @click="visible = false">取消</el-button>
      <el-button type="primary" size="default" @click="submitForm" :loading="submitting" :disabled="!isValid">
        保存
      </el-button>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { ref, computed, watch, nextTick } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Delete } from '@element-plus/icons-vue'
import { batchSaveColumnsApi } from '@/api/datamodel'

const props = defineProps<{
  modelValue: boolean
  tableId: number | null
  tableName: string
  databaseType?: string
  columns?: any[]
}>()

const emit = defineEmits<{
  'update:modelValue': [value: boolean]
  'success': []
}>()

const visible = computed({
  get: () => props.modelValue,
  set: (val: boolean) => emit('update:modelValue', val)
})

const tableRef = ref()
const columnList = ref<any[]>([])
const selectedRows = ref<any[]>([])
const submitting = ref(false)
const deleteIds = ref<number[]>([])

const dataTypeOptions = computed(() => {
  const commonTypes = [
    { label: 'bigint', value: 'bigint' },
    { label: 'varchar', value: 'varchar' },
    { label: 'int', value: 'int' },
    { label: 'text', value: 'text' },
    { label: 'decimal', value: 'decimal' },
    { label: 'datetime', value: 'datetime' },
    { label: 'date', value: 'date' },
    { label: 'time', value: 'time' },
    { label: 'boolean', value: 'boolean' },
    { label: 'tinyint', value: 'tinyint' },
    { label: 'json', value: 'json' }
  ]
  const mysqlTypes = [
    { label: 'smallint', value: 'smallint' },
    { label: 'float', value: 'float' },
    { label: 'double', value: 'double' },
    { label: 'char', value: 'char' },
    { label: 'blob', value: 'blob' }
  ]
  return props.databaseType === 'mysql' ? [...commonTypes, ...mysqlTypes] : commonTypes
})

const duplicateCodes = computed(() => {
  const codeCount: Record<string, number> = {}
  columnList.value.forEach(col => {
    if (col.code) codeCount[col.code] = (codeCount[col.code] || 0) + 1
  })
  return Object.entries(codeCount).filter(([_, count]) => count > 1).map(([code]) => code)
})

const isValid = computed(() => {
  if (columnList.value.length === 0) return false
  if (columnList.value.some(col => !col.name || !col.code)) return false
  if (duplicateCodes.value.length > 0) return false
  return true
})

watch(() => [props.modelValue, props.columns], ([val, cols]) => {
  if (val) {
    const columns = cols as any[] | undefined
    columnList.value = columns?.map((col: any, index: number) => ({ ...col, sort: col.sort || index + 1 })) || []
    deleteIds.value = []
    selectedRows.value = []
  }
}, { immediate: true })

function handleSelectionChange(selection: any[]) {
  selectedRows.value = selection
}

function addRow() {
  columnList.value.push({
    id: null, tableId: props.tableId, name: '', code: '', dataType: 'varchar', length: 255,
    isPrimary: 0, isForeign: 0, isNullable: 1, isCore: 1, isAutoIncrement: 0, isUnique: 0,
    indexType: 'none', defaultValue: '', description: '', sort: columnList.value.length + 1
  })
  nextTick(() => {
    const body = tableRef.value?.$el.querySelector('.el-table__body-wrapper')
    if (body) body.scrollTop = body.scrollHeight
  })
}

async function deleteRow(index: number) {
  try {
    const row = columnList.value[index]
    if (row.id) {
      await ElMessageBox.confirm(`确认删除字段「${row.name}」吗？`, '确认', { type: 'warning' })
      deleteIds.value.push(row.id)
    }
    columnList.value.splice(index, 1)
    columnList.value.forEach((col, i) => { col.sort = i + 1 })
  } catch (e) {}
}

async function deleteSelected() {
  if (!selectedRows.value.length) return
  try {
    if (selectedRows.value.some(row => row.id)) {
      await ElMessageBox.confirm(`确认删除选中的 ${selectedRows.value.length} 个字段吗？`, '确认', { type: 'warning' })
    }
    selectedRows.value.forEach(row => {
      if (row.id && !deleteIds.value.includes(row.id)) deleteIds.value.push(row.id)
    })
    columnList.value = columnList.value.filter(row => !selectedRows.value.includes(row))
    selectedRows.value = []
    columnList.value.forEach((col, i) => { col.sort = i + 1 })
  } catch (e) {}
}

function handleNameBlur(row: any) {
  if (row.name && !row.code) {
    row.code = row.name.toLowerCase().replace(/[^\w]/g, '_').replace(/_+/g, '_').replace(/^_|_$/g, '')
  }
}

async function submitForm() {
  if (!isValid.value) {
    if (duplicateCodes.value.length > 0) ElMessage.error(`存在重复编码: ${duplicateCodes.value.join(', ')}`)
    else ElMessage.error('请填写完整的字段名称和编码')
    return
  }
  if (!props.tableId) return
  submitting.value = true
  try {
    await batchSaveColumnsApi({
      tableId: props.tableId,
      columns: columnList.value.map(col => ({ ...col, tableId: props.tableId })),
      deleteIds: deleteIds.value
    })
    ElMessage.success('保存成功')
    visible.value = false
    emit('success')
  } finally {
    submitting.value = false
  }
}
</script>

<style lang="scss" scoped>
.batch-editor {
  .editor-toolbar {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 10px;

    .toolbar-info {
      margin-left: auto;
      font-size: 13px;
      color: var(--text-secondary);

      strong {
        color: var(--el-color-primary);
        font-weight: 600;
      }

      .error-hint {
        color: var(--el-color-danger);
        margin-left: 8px;
      }
    }
  }

  // 错误输入框样式
  :deep(.has-error .el-input__wrapper) {
    box-shadow: 0 0 0 1px var(--el-color-danger) inset;
  }

  // 表格单元格紧凑
  :deep(.el-table__cell) {
    padding: 4px 6px;
  }

  // 属性复选框
  .attr-checks {
    display: flex;
    gap: 4px;
    flex-wrap: nowrap;
    white-space: nowrap;

    :deep(.el-checkbox) {
      margin-right: 0;
      height: auto;
    }
    :deep(.el-checkbox__label) {
      font-size: 10px;
      font-weight: 600;
      padding-left: 3px;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    }
    :deep(.el-checkbox__inner) {
      width: 13px;
      height: 13px;
    }
  }
}
</style>