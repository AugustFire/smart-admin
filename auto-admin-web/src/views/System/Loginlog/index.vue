<template>
  <div class="app-container">
    <el-card>
      <el-form :model="queryParams" inline>
        <el-form-item label="用户名">
          <el-input v-model="queryParams.username" placeholder="请输入用户名" clearable />
        </el-form-item>
        <el-form-item label="登录状态">
          <el-select v-model="queryParams.loginStatus" placeholder="请选择" clearable>
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
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="username" label="用户名" width="120" />
        <el-table-column label="登录状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.loginStatus === 1 ? 'success' : 'danger'">
              {{ row.loginStatus === 1 ? '成功' : '失败' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="ipAddress" label="登录 IP" width="140" />
        <el-table-column prop="loginLocation" label="登录地点" width="180" />
        <el-table-column prop="browser" label="浏览器" width="150" />
        <el-table-column prop="os" label="操作系统" width="150" />
        <el-table-column prop="loginTime" label="登录时间" width="180" />
        <el-table-column prop="msg" label="提示信息" />
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
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { getLoginLogPageApi } from '@/api/log'

const loading = ref(false)
const tableData = ref([])
const total = ref(0)

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  username: '',
  loginStatus: null as number | null,
})

function handleQuery() {
  loading.value = true
  getLoginLogPageApi(queryParams).then(({ data }) => {
    tableData.value = data.list || []
    total.value = data.total || 0
    loading.value = false
  })
}

function resetQuery() {
  queryParams.username = ''
  queryParams.loginStatus = null
  handleQuery()
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
</style>
