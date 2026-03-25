<template>
  <div class="app-container">
    <el-card>
      <el-form :model="queryParams" inline>
        <el-form-item label="模块标题">
          <el-input v-model="queryParams.title" placeholder="请输入模块标题" clearable />
        </el-form-item>
        <el-form-item label="操作人员">
          <el-input v-model="queryParams.operName" placeholder="请输入操作人员" clearable />
        </el-form-item>
        <el-form-item label="操作状态">
          <el-select v-model="queryParams.status" placeholder="请选择" clearable>
            <el-option label="成功" :value="1" />
            <el-option label="失败" :value="0" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleQuery">
            <el-icon><Search /></el-icon>
            搜索
          </el-button>
          <el-button @click="resetQuery">
            <el-icon><Refresh /></el-icon>
            重置
          </el-button>
        </el-form-item>
      </el-form>

      <el-table v-loading="loading" :data="tableData" class="simple-table" stripe>
        <el-table-column prop="operId" label="ID" width="80" />
        <el-table-column prop="title" label="模块标题" width="150" />
        <el-table-column label="业务类型" width="100">
          <template #default="{ row }">
            <el-tag :type="getBusinessTypeTag(row.businessType)">
              {{ getBusinessTypeLabel(row.businessType) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="operName" label="操作人员" width="120" />
        <el-table-column prop="operUrl" label="请求 URL" width="200" />
        <el-table-column prop="operIp" label="操作 IP" width="140" />
        <el-table-column label="状态" width="80">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'danger'">
              {{ row.status === 1 ? '成功' : '失败' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="operTime" label="操作时间" width="180" />
        <el-table-column label="操作" fixed="right" width="120">
          <template #default="{ row }">
            <div class="action-buttons">
              <el-button link type="info" class="action-btn detail-btn" @click="handleDetail(row)">详情</el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>

      <el-pagination
        v-model:current-page="queryParams.pageNum"
        v-model:page-size="queryParams.pageSize"
        :total="total"
        layout="total, sizes, prev, pager, next, jumper"
        style="margin-top: 16px"
        @size-change="handleQuery"
        @current-change="handleQuery"
      />
    </el-card>

    <!-- 详情对话框 -->
    <el-dialog title="操作日志详情" v-model="detailVisible" width="700px">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="模块标题">{{ detail.title }}</el-descriptions-item>
        <el-descriptions-item label="业务类型">
          {{ getBusinessTypeLabel(detail.businessType) }}
        </el-descriptions-item>
        <el-descriptions-item label="请求方法">{{ detail.method }}</el-descriptions-item>
        <el-descriptions-item label="操作人员">{{ detail.operName }}</el-descriptions-item>
        <el-descriptions-item label="请求 URL" :span="2">{{ detail.operUrl }}</el-descriptions-item>
        <el-descriptions-item label="操作 IP">{{ detail.operIp }}</el-descriptions-item>
        <el-descriptions-item label="操作地点">{{ detail.operLocation }}</el-descriptions-item>
        <el-descriptions-item label="请求参数" :span="2">
          <el-input type="textarea" :rows="4" :model-value="detail.operParam" readonly />
        </el-descriptions-item>
        <el-descriptions-item label="返回结果" :span="2">
          <el-input type="textarea" :rows="4" :model-value="detail.jsonResult" readonly />
        </el-descriptions-item>
        <el-descriptions-item label="状态">
          {{ detail.status === 1 ? '成功' : '失败' }}
        </el-descriptions-item>
        <el-descriptions-item label="消耗时间">{{ detail.costTime }}ms</el-descriptions-item>
        <el-descriptions-item label="错误消息" :span="2" v-if="detail.errorMsg">
          {{ detail.errorMsg }}
        </el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { getOperLogPageApi } from '@/api/log'

const loading = ref(false)
const tableData = ref([])
const total = ref(0)
const detailVisible = ref(false)
const detail = ref<any>({})

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  title: '',
  operName: '',
  status: null as number | null,
})

const businessTypeLabels: Record<number, string> = {
  0: '其他',
  1: '新增',
  2: '修改',
  3: '删除',
  4: '查询',
  5: '导出',
  6: '导入',
  7: '授权',
  8: '登录',
  9: '登出',
}

function getBusinessTypeLabel(type: number) {
  return businessTypeLabels[type] || '其他'
}

function getBusinessTypeTag(type: number) {
  const tags: Record<number, any> = { 1: 'success', 2: 'warning', 3: 'danger', 4: 'info' }
  return tags[type] || ''
}

function handleQuery() {
  loading.value = true
  getOperLogPageApi(queryParams).then(({ data }) => {
    tableData.value = data.list || []
    total.value = data.total || 0
    loading.value = false
  })
}

function resetQuery() {
  queryParams.title = ''
  queryParams.operName = ''
  queryParams.status = null
  handleQuery()
}

function handleDetail(row: any) {
  detail.value = { ...row }
  detailVisible.value = true
}

onMounted(() => {
  handleQuery()
})
</script>

<style lang="scss" scoped>
.app-container {
  padding: 20px;
  background: var(--app-main-bg-color);
  min-height: calc(100vh - 84px);
}

// 简约表格样式 - 只有横线 + 斑马纹
.simple-table {
  --el-table-tr-bg-color: transparent;
  --el-table-header-bg-color: transparent;

  :deep(.el-table__header) {
    th {
      background: var(--bg-secondary);
      border-bottom: 1px solid var(--border-color);
    }
  }

  :deep(.el-table__row) {
    td {
      border-bottom: 1px solid var(--border-color);
    }

    &:hover td {
      background: var(--bg-secondary);
    }
  }

  // 斑马纹
  :deep(.el-table__row--striped) {
    td {
      background: var(--bg-secondary);
    }

    &:hover td {
      background: var(--bg-tertiary);
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

    &.detail-btn {
      border-color: var(--border-color);
      color: var(--text-secondary);

      &:hover {
        background: var(--bg-secondary);
        border-color: var(--text-secondary);
        color: var(--text-regular);
      }
    }
  }
}

:deep(.el-form-item) {
  .el-input {
    width: 180px;
  }

  .el-select {
    width: 120px;
  }
}
</style>
