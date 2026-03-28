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
              <el-option label="bigint" value="bigint" />
              <el-option label="varchar" value="varchar" />
              <el-option label="int" value="int" />
              <el-option label="tinyint" value="tinyint" />
              <el-option label="datetime" value="datetime" />
              <el-option label="text" value="text" />
              <el-option label="decimal" value="decimal" />
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
