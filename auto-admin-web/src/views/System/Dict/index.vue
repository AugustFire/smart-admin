<template>
  <div class="app-container">
    <el-row :gutter="20">
      <!-- 字典类型列表 -->
      <el-col :span="12">
        <el-card>
          <template #header>
            <span>字典类型</span>
            <el-button type="primary" size="small" @click="handleAddType" style="float: right">
              <el-icon><Plus /></el-icon>
              新增
            </el-button>
          </template>
          <el-table :data="typeList" class="simple-table" stripe highlight-current-row @current-change="handleTypeChange">
            <el-table-column prop="name" label="字典名称" />
            <el-table-column prop="type" label="字典类型" />
            <el-table-column label="状态" width="80">
              <template #default="{ row }">
                <el-tag :type="row.status === 1 ? 'success' : 'danger'">
                  {{ row.status === 1 ? '正常' : '禁用' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="150">
              <template #default="{ row }">
                <div class="action-buttons">
                  <el-button link type="primary" class="action-btn edit-btn" @click.stop="handleUpdateType(row)">编辑</el-button>
                  <el-button link type="danger" class="action-btn delete-btn" @click.stop="handleDeleteType(row)">删除</el-button>
                </div>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>

      <!-- 字典数据列表 -->
      <el-col :span="12">
        <el-card>
          <template #header>
            <span>字典数据 - {{ currentTypeName }}</span>
            <el-button
              type="primary"
              size="small"
              @click="handleAddData"
              :disabled="!currentType"
              style="float: right"
            >
              <el-icon><Plus /></el-icon>
              新增
            </el-button>
          </template>
          <el-table v-if="currentType" :data="dataList" class="simple-table" stripe>
            <el-table-column prop="label" label="字典标签" />
            <el-table-column prop="value" label="字典键值" />
            <el-table-column prop="sort" label="排序" width="60" />
            <el-table-column label="状态" width="80">
              <template #default="{ row }">
                <el-tag :type="row.status === 1 ? 'success' : 'danger'">
                  {{ row.status === 1 ? '正常' : '禁用' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="160">
              <template #default="{ row }">
                <div class="action-buttons">
                  <el-button link type="primary" class="action-btn edit-btn" @click="handleUpdateData(row)">编辑</el-button>
                  <el-button link type="danger" class="action-btn delete-btn" @click="handleDeleteData(row)">删除</el-button>
                </div>
              </template>
            </el-table-column>
          </el-table>
          <el-empty v-else description="请选择字典类型" />
        </el-card>
      </el-col>
    </el-row>

    <!-- 字典类型对话框 -->
    <el-dialog :title="typeDialogTitle" v-model="typeDialogVisible" width="500px">
      <el-form ref="typeFormRef" :model="typeForm" :rules="typeRules" label-width="80px">
        <el-form-item label="字典名称" prop="name">
          <el-input v-model="typeForm.name" placeholder="请输入字典名称" />
        </el-form-item>
        <el-form-item label="字典类型" prop="type">
          <el-input v-model="typeForm.type" placeholder="请输入字典类型，如：sys_user_sex" :disabled="!!typeForm.id" />
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="typeForm.remark" type="textarea" placeholder="请输入备注" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="typeForm.status">
            <el-radio :label="1">正常</el-radio>
            <el-radio :label="0">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="typeDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitTypeForm">确定</el-button>
      </template>
    </el-dialog>

    <!-- 字典数据对话框 -->
    <el-dialog :title="dataDialogTitle" v-model="dataDialogVisible" width="500px">
      <el-form ref="dataFormRef" :model="dataForm" :rules="dataRules" label-width="80px">
        <el-form-item label="字典标签" prop="label">
          <el-input v-model="dataForm.label" placeholder="请输入字典标签" />
        </el-form-item>
        <el-form-item label="字典键值" prop="value">
          <el-input v-model="dataForm.value" placeholder="请输入字典键值" />
        </el-form-item>
        <el-form-item label="排序" prop="sort">
          <el-input-number v-model="dataForm.sort" :min="0" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="dataForm.status">
            <el-radio :label="1">正常</el-radio>
            <el-radio :label="0">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dataDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitDataForm">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { ElMessage, ElMessageBox, type FormInstance, type FormRules } from 'element-plus'
import {
  getDictTypeListApi,
  getDictDataListApi,
  addDictTypeApi,
  updateDictTypeApi,
  deleteDictTypeApi,
  addDictDataApi,
  updateDictDataApi,
  deleteDictDataApi,
} from '@/api/dict'

const typeList = ref([])
const dataList = ref([])
const currentType = ref<any>(null)
const typeDialogVisible = ref(false)
const dataDialogVisible = ref(false)
const typeFormRef = ref<FormInstance>()
const dataFormRef = ref<FormInstance>()

const typeForm = ref<any>({ id: null, name: '', type: '', remark: '', status: 1 })
const dataForm = ref<any>({ id: null, dictType: '', label: '', value: '', sort: 0, status: 1 })

const typeRules: FormRules = {
  name: [{ required: true, message: '请输入字典名称', trigger: 'blur' }],
  type: [{ required: true, message: '请输入字典类型', trigger: 'blur' }],
}

const dataRules: FormRules = {
  label: [{ required: true, message: '请输入字典标签', trigger: 'blur' }],
  value: [{ required: true, message: '请输入字典键值', trigger: 'blur' }],
}

const currentTypeName = computed(() => currentType.value?.name || '')
const typeDialogTitle = computed(() => typeForm.value.id ? '编辑字典类型' : '新增字典类型')
const dataDialogTitle = computed(() => dataForm.value.id ? '编辑字典数据' : '新增字典数据')

function handleQuery() {
  getDictTypeListApi().then(({ data }) => {
    typeList.value = data
  })
}

function handleTypeChange(row: any) {
  currentType.value = row
  if (row) {
    getDictDataListApi(row.type).then(({ data }) => {
      dataList.value = data
    })
  } else {
    dataList.value = []
  }
}

function handleAddType() {
  typeForm.value = { id: null, name: '', type: '', remark: '', status: 1 }
  typeDialogVisible.value = true
}

function handleUpdateType(row: any) {
  typeForm.value = { ...row }
  typeDialogVisible.value = true
}

function handleDeleteType(row: any) {
  ElMessageBox.confirm(`确认删除字典类型 "${row.name}" 吗？`, '提示', { type: 'warning' }).then(() => {
    deleteDictTypeApi(row.id).then(() => {
      ElMessage.success('删除成功')
      handleQuery()
    })
  })
}

function submitTypeForm() {
  if (!typeFormRef.value) return
  typeFormRef.value.validate((valid) => {
    if (!valid) return

    const api = typeForm.value.id ? updateDictTypeApi : addDictTypeApi
    api(typeForm.value).then(() => {
      ElMessage.success('操作成功')
      typeDialogVisible.value = false
      handleQuery()
    })
  })
}

function handleAddData() {
  if (!currentType.value) return
  dataForm.value = { id: null, dictType: currentType.value.type, label: '', value: '', sort: 0, status: 1 }
  dataDialogVisible.value = true
}

function handleUpdateData(row: any) {
  dataForm.value = { ...row }
  dataDialogVisible.value = true
}

function handleDeleteData(row: any) {
  ElMessageBox.confirm(`确认删除字典数据 "${row.label}" 吗？`, '提示', { type: 'warning' }).then(() => {
    deleteDictDataApi(row.id).then(() => {
      ElMessage.success('删除成功')
      handleTypeChange(currentType.value)
    })
  })
}

function submitDataForm() {
  if (!dataFormRef.value) return
  dataFormRef.value.validate((valid) => {
    if (!valid) return

    const api = dataForm.value.id ? updateDictDataApi : addDictDataApi
    api(dataForm.value).then(() => {
      ElMessage.success('操作成功')
      dataDialogVisible.value = false
      handleTypeChange(currentType.value)
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
