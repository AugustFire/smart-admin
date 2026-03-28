<template>
  <el-dialog :title="isEdit ? '编辑数据表' : '新增数据表'" v-model="visible" width="500px" :close-on-click-modal="false">
    <el-form ref="formRef" :model="form" :rules="rules" label-width="80px">
      <el-form-item label="所属库">
        <el-tag>{{ databaseName }}</el-tag>
      </el-form-item>
      <el-form-item label="名称" prop="name">
        <el-input v-model="form.name" placeholder="请输入表名称" />
      </el-form-item>
      <el-form-item label="编码" prop="code">
        <el-input v-model="form.code" placeholder="请输入表编码，如 sys_user" :disabled="isEdit" />
      </el-form-item>
      <el-form-item label="描述" prop="description">
        <el-input v-model="form.description" type="textarea" :rows="3" placeholder="请输入描述" />
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
import { addTableApi, updateTableApi } from '@/api/datamodel'

const props = defineProps<{
  modelValue: boolean
  data?: any
  databaseId: number | null
  databaseName: string
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
  databaseId: null as number | null,
  name: '',
  code: '',
  description: '',
  sort: 0
})

const rules: FormRules = {
  name: [{ required: true, message: '请输入表名称', trigger: 'blur' }],
  code: [{ required: true, message: '请输入表编码', trigger: 'blur' }]
}

watch(() => [props.data, props.databaseId], ([val, dbId]) => {
  if (val) {
    form.value = { ...val }
  } else {
    form.value = {
      id: null,
      databaseId: dbId as number,
      name: '',
      code: '',
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
        await updateTableApi(form.value)
        ElMessage.success('编辑成功')
      } else {
        await addTableApi(form.value)
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
