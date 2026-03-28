<template>
  <el-dialog :title="isEdit ? '编辑关系' : '新增关系'" v-model="visible" width="600px">
    <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
      <el-divider>源表</el-divider>
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="源表" prop="sourceTableId">
            <el-cascader
              v-model="sourceTableValue"
              :options="treeData"
              :props="{ value: 'id', label: 'name', children: 'children', emitPath: false }"
              placeholder="选择表"
              style="width: 100%;"
              @change="handleSourceTableChange"
            />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="源字段" prop="sourceColumnId">
            <el-select v-model="form.sourceColumnId" placeholder="选择字段" style="width: 100%;">
              <el-option v-for="col in sourceColumns" :key="col.id" :label="`${col.name}(${col.code})`" :value="col.id" />
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>

      <el-divider>目标表</el-divider>
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="目标表" prop="targetTableId">
            <el-cascader
              v-model="targetTableValue"
              :options="treeData"
              :props="{ value: 'id', label: 'name', children: 'children', emitPath: false }"
              placeholder="选择表"
              style="width: 100%;"
              @change="handleTargetTableChange"
            />
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="目标字段" prop="targetColumnId">
            <el-select v-model="form.targetColumnId" placeholder="选择字段" style="width: 100%;">
              <el-option v-for="col in targetColumns" :key="col.id" :label="`${col.name}(${col.code})`" :value="col.id" />
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>

      <el-divider>关系类型</el-divider>
      <el-form-item label="关系类型" prop="relationType">
        <el-radio-group v-model="form.relationType">
          <el-radio label="ONE_TO_ONE">一对一</el-radio>
          <el-radio label="ONE_TO_MANY">一对多</el-radio>
          <el-radio label="MANY_TO_ONE">多对一</el-radio>
          <el-radio label="MANY_TO_MANY">多对多</el-radio>
        </el-radio-group>
      </el-form-item>

      <el-form-item label="描述" prop="description">
        <el-input v-model="form.description" type="textarea" :rows="2" placeholder="请输入关系描述" />
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
import { addRelationApi, updateRelationApi, getTableTreeApi, getColumnListApi } from '@/api/datamodel'

const props = defineProps<{
  modelValue: boolean
  data: any
  databaseId: number | null
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
const treeData = ref<any[]>([])
const sourceColumns = ref<any[]>([])
const targetColumns = ref<any[]>([])
const sourceTableValue = ref<number | null>(null)
const targetTableValue = ref<number | null>(null)

const form = ref({
  id: null as number | null,
  sourceTableId: null as number | null,
  sourceColumnId: null as number | null,
  targetTableId: null as number | null,
  targetColumnId: null as number | null,
  relationType: 'ONE_TO_MANY',
  description: ''
})

const rules: FormRules = {
  sourceTableId: [{ required: true, message: '请选择源表', trigger: 'change' }],
  sourceColumnId: [{ required: true, message: '请选择源字段', trigger: 'change' }],
  targetTableId: [{ required: true, message: '请选择目标表', trigger: 'change' }],
  targetColumnId: [{ required: true, message: '请选择目标字段', trigger: 'change' }],
  relationType: [{ required: true, message: '请选择关系类型', trigger: 'change' }]
}

watch(() => visible.value, async (val) => {
  if (val) {
    const { data } = await getTableTreeApi()
    treeData.value = data || []
  }
})

watch(() => props.data, (val) => {
  if (val) {
    form.value = { ...val }
    sourceTableValue.value = val.sourceTableId
    targetTableValue.value = val.targetTableId
    if (val.sourceTableId) loadColumns(val.sourceTableId, 'source')
    if (val.targetTableId) loadColumns(val.targetTableId, 'target')
  } else {
    form.value = {
      id: null,
      sourceTableId: null,
      sourceColumnId: null,
      targetTableId: null,
      targetColumnId: null,
      relationType: 'ONE_TO_MANY',
      description: ''
    }
    sourceTableValue.value = null
    targetTableValue.value = null
    sourceColumns.value = []
    targetColumns.value = []
  }
}, { immediate: true })

async function loadColumns(tableId: number, type: 'source' | 'target') {
  const { data } = await getColumnListApi(tableId)
  if (type === 'source') {
    sourceColumns.value = data || []
  } else {
    targetColumns.value = data || []
  }
}

function handleSourceTableChange(val: any) {
  form.value.sourceTableId = val as number
  form.value.sourceColumnId = null
  if (val) {
    loadColumns(val as number, 'source')
  }
}

function handleTargetTableChange(val: any) {
  form.value.targetTableId = val as number
  form.value.targetColumnId = null
  if (val) {
    loadColumns(val as number, 'target')
  }
}

async function submitForm() {
  if (!formRef.value) return
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    submitting.value = true
    try {
      if (isEdit.value) {
        await updateRelationApi(form.value)
      } else {
        await addRelationApi(form.value)
      }
      ElMessage.success(isEdit.value ? '编辑成功' : '新增成功')
      visible.value = false
      emit('success')
    } finally {
      submitting.value = false
    }
  })
}
</script>
