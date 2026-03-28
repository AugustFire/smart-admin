<template>
  <el-dialog :title="isEdit ? '编辑数据库' : '新增数据库'" v-model="visible" width="500px" :close-on-click-modal="false">
    <el-form ref="formRef" :model="form" :rules="rules" label-width="80px">
      <el-form-item label="名称" prop="name">
        <el-input v-model="form.name" placeholder="请输入数据库名称" />
      </el-form-item>
      <el-form-item label="编码" prop="code">
        <el-input v-model="form.code" placeholder="请输入数据库编码" :disabled="isEdit" />
      </el-form-item>
      <el-form-item label="类型" prop="type">
        <el-select v-model="form.type" placeholder="请选择数据库类型" style="width: 100%;">
          <el-option label="MySQL" value="mysql">
            <div style="display: flex; align-items: center; gap: 8px;">
              <span style="font-size: 16px;">🐬</span>
              <span>MySQL</span>
            </div>
          </el-option>
          <el-option label="SQL Server" value="sqlserver">
            <div style="display: flex; align-items: center; gap: 8px;">
              <span style="font-size: 16px;">🗄️</span>
              <span>SQL Server</span>
            </div>
          </el-option>
          <el-option label="PostgreSQL" value="postgresql">
            <div style="display: flex; align-items: center; gap: 8px;">
              <span style="font-size: 16px;">🐘</span>
              <span>PostgreSQL</span>
            </div>
          </el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="描述" prop="description">
        <el-input v-model="form.description" type="textarea" :rows="3" placeholder="请输入描述" />
      </el-form-item>
      <el-form-item label="排序" prop="sort">
        <el-input-number v-model="form.sort" :min="0" />
      </el-form-item>
      <el-form-item label="状态">
        <el-radio-group v-model="form.status">
          <el-radio :label="1">正常</el-radio>
          <el-radio :label="0">禁用</el-radio>
        </el-radio-group>
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
import { addDatabaseApi, updateDatabaseApi } from '@/api/datamodel'

const props = defineProps<{
  modelValue: boolean
  data?: any
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
  name: '',
  code: '',
  type: 'mysql',
  description: '',
  sort: 0,
  status: 1
})

const rules: FormRules = {
  name: [{ required: true, message: '请输入数据库名称', trigger: 'blur' }],
  code: [{ required: true, message: '请输入数据库编码', trigger: 'blur' }],
  type: [{ required: true, message: '请选择数据库类型', trigger: 'change' }]
}

watch(() => props.data, (val) => {
  if (val) {
    form.value = { ...val }
  } else {
    form.value = {
      id: null,
      name: '',
      code: '',
      type: 'mysql',
      description: '',
      sort: 0,
      status: 1
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
        await updateDatabaseApi(form.value)
        ElMessage.success('编辑成功')
      } else {
        await addDatabaseApi(form.value)
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
