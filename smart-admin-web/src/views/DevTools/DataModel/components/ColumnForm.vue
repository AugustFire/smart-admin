<template>
  <el-dialog :title="isEdit ? '编辑字段' : '新增字段'" v-model="visible" width="600px" :close-on-click-modal="false">
    <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="字段名称" prop="name">
            <el-input v-model="form.name" placeholder="请输入字段名称" />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="字段编码" prop="code">
            <el-input v-model="form.code" placeholder="请输入字段编码" />
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="数据类型" prop="dataType">
            <el-select v-model="form.dataType" placeholder="请选择" style="width: 100%;">
              <el-option
                v-for="type in dataTypeOptions"
                :key="type.value"
                :label="type.label"
                :value="type.value"
              />
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="长度" prop="length">
            <el-input-number v-model="form.length" :min="0" style="width: 100%;" />
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="主键">
            <el-switch v-model="form.isPrimary" :active-value="1" :inactive-value="0" />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="外键">
            <el-switch v-model="form.isForeign" :active-value="1" :inactive-value="0" />
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="可空">
            <el-switch v-model="form.isNullable" :active-value="1" :inactive-value="0" />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="自增">
            <el-switch v-model="form.isAutoIncrement" :active-value="1" :inactive-value="0" />
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="唯一">
            <el-switch v-model="form.isUnique" :active-value="1" :inactive-value="0" />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="核心字段">
            <el-switch v-model="form.isCore" :active-value="1" :inactive-value="0" />
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="索引类型">
            <el-select v-model="form.indexType" placeholder="无索引" clearable style="width: 100%;">
              <el-option label="无索引" value="none" />
              <el-option label="普通索引" value="normal" />
              <el-option label="唯一索引" value="unique" />
              <el-option label="全文索引" value="fulltext" />
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="默认值">
            <el-input v-model="form.defaultValue" placeholder="如: 0, CURRENT_TIMESTAMP" clearable />
          </el-form-item>
        </el-col>
      </el-row>
      <el-form-item label="描述" prop="description">
        <el-input v-model="form.description" type="textarea" :rows="2" placeholder="请输入描述" />
      </el-form-item>
      <el-form-item label="排序" prop="sort">
        <el-input-number v-model="form.sort" :min="0" />
      </el-form-item>
    </el-form>
    <template #footer>
      <el-button @click="visible = false">取消</el-button>
      <el-button type="primary" @click="submitForm" :loading="submitting">确定</el-button>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { ElMessage } from 'element-plus'
import type { FormInstance, FormRules } from 'element-plus'
import { addColumnApi, updateColumnApi } from '@/api/datamodel'

const props = defineProps<{
  modelValue: boolean
  data?: any
  tableId?: number | null
  databaseType?: string
}>()

const emit = defineEmits<{
  'update:modelValue': [value: boolean]
  'success': []
}>()

const visible = computed({
  get: () => props.modelValue,
  set: (val: boolean) => emit('update:modelValue', val)
})

const isEdit = computed(() => !!props.data)
const submitting = ref(false)
const formRef = ref<FormInstance>()

// 根据数据库类型获取数据类型选项
const dataTypeOptions = computed(() => {
  const type = props.databaseType || 'mysql'

  // 通用类型
  const commonTypes = [
    { label: 'bigint', value: 'bigint' },
    { label: 'varchar', value: 'varchar' },
    { label: 'int / integer', value: 'int' },
    { label: 'text', value: 'text' },
    { label: 'decimal / numeric', value: 'decimal' },
    { label: 'datetime / timestamp', value: 'datetime' },
    { label: 'date', value: 'date' },
    { label: 'time', value: 'time' },
    { label: 'boolean', value: 'boolean' }
  ]

  // MySQL 特有
  const mysqlTypes = [
    { label: 'tinyint', value: 'tinyint' },
    { label: 'smallint', value: 'smallint' },
    { label: 'mediumint', value: 'mediumint' },
    { label: 'float', value: 'float' },
    { label: 'double', value: 'double' },
    { label: 'json', value: 'json' },
    { label: 'char', value: 'char' },
    { label: 'tinytext', value: 'tinytext' },
    { label: 'mediumtext', value: 'mediumtext' },
    { label: 'longtext', value: 'longtext' },
    { label: 'blob', value: 'blob' },
    { label: 'year', value: 'year' }
  ]

  // SQL Server 特有
  const sqlServerTypes = [
    { label: 'nvarchar', value: 'nvarchar' },
    { label: 'nchar', value: 'nchar' },
    { label: 'ntext', value: 'ntext' },
    { label: 'money', value: 'money' },
    { label: 'smallmoney', value: 'smallmoney' },
    { label: 'real', value: 'real' },
    { label: 'smalldatetime', value: 'smalldatetime' },
    { label: 'datetime2', value: 'datetime2' },
    { label: 'datetimeoffset', value: 'datetimeoffset' },
    { label: 'uniqueidentifier', value: 'uniqueidentifier' },
    { label: 'varbinary', value: 'varbinary' },
    { label: 'image', value: 'image' },
    { label: 'xml', value: 'xml' }
  ]

  // PostgreSQL 特有
  const postgresqlTypes = [
    { label: 'serial', value: 'serial' },
    { label: 'bigserial', value: 'bigserial' },
    { label: 'smallint', value: 'smallint' },
    { label: 'real', value: 'real' },
    { label: 'double precision', value: 'double precision' },
    { label: 'numeric', value: 'numeric' },
    { label: 'character', value: 'character' },
    { label: 'character varying', value: 'character varying' },
    { label: 'timestamp', value: 'timestamp' },
    { label: 'timestamptz', value: 'timestamptz' },
    { label: 'interval', value: 'interval' },
    { label: 'bytea', value: 'bytea' },
    { label: 'uuid', value: 'uuid' },
    { label: 'json', value: 'json' },
    { label: 'jsonb', value: 'jsonb' },
    { label: 'array', value: 'array' }
  ]

  if (type === 'sqlserver') {
    return [...commonTypes, ...sqlServerTypes]
  } else if (type === 'postgresql') {
    return [...commonTypes, ...postgresqlTypes]
  } else {
    return [...commonTypes, ...mysqlTypes]
  }
})

const form = ref({
  id: null as number | null,
  tableId: null as number | null,
  name: '',
  code: '',
  dataType: '',
  length: null as number | null,
  isPrimary: 0,
  isForeign: 0,
  isNullable: 1,
  isCore: 0,
  isAutoIncrement: 0,
  isUnique: 0,
  indexType: 'none',
  defaultValue: '',
  description: '',
  sort: 0
})

const rules: FormRules = {
  name: [{ required: true, message: '请输入字段名称', trigger: 'blur' }],
  code: [{ required: true, message: '请输入字段编码', trigger: 'blur' }]
}

watch(() => [props.data, props.tableId], ([val, tableId]) => {
  if (val) {
    form.value = { ...val }
  } else {
    form.value = {
      id: null,
      tableId: tableId ?? null,
      name: '',
      code: '',
      dataType: '',
      length: null,
      isPrimary: 0,
      isForeign: 0,
      isNullable: 1,
      isCore: 0,
      isAutoIncrement: 0,
      isUnique: 0,
      indexType: 'none',
      defaultValue: '',
      description: '',
      sort: 0
    }
  }
}, { immediate: true })

async function submitForm() {
  if (!formRef.value) return
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    submitting.value = true
    try {
      if (isEdit.value) {
        await updateColumnApi(form.value)
        ElMessage.success('编辑成功')
      } else {
        await addColumnApi(form.value)
        ElMessage.success('新增成功')
      }
      visible.value = false
      emit('success')
    } finally {
      submitting.value = false
    }
  })
}
</script>
