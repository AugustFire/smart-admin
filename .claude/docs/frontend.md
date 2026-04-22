# 前端开发规范

## 技术栈

- **框架**: Vue 3.4 + Composition API
- **构建**: Vite 5
- **UI库**: Element Plus 2.6
- **状态**: Pinia 2.1
- **语言**: TypeScript 5.4

## 项目结构

```
src/
├── api/                    # API 封装
│   ├── datamodel.ts        # 数据模型 API
│   └── lifestyle/          # 生活管理 API
│       ├── diet.ts         # 饮食记录
│       ├── brainstorm.ts   # 脑暴笔记
│       ├── task-record.ts  # 任务记录
│       └── text-collection.ts  # 文本收藏
├── components/             # 公共组件
│   └── DateRangePicker/    # 日期范围选择器
├── views/                  # 页面组件
│   ├── System/             # 系统管理模块
│   ├── DevTools/           # 开发工具模块
│   │   └── DataModel/      # 数据模型功能
│   │       ├── index.vue
│   │       ├── ModelManager.vue
│   │       ├── ERDiagram.vue
│   │       ├── RelationManager.vue
│   │       └── components/
│   │           ├── DatabaseForm.vue
│   │           ├── TableForm.vue
│   │           ├── ColumnForm.vue
│   │           └── RelationForm.vue
│   └── Lifestyle/          # 生活管理模块
│       ├── Diet/           # 饮食记录（卡片/时间线/日历视图）
│       ├── brainstorm/      # 脑暴笔记（卡片/时间线视图）
│       ├── task-record/     # 任务记录（列表/甘特图视图）
│       └── text-collection/ # 文本收藏（编辑/预览分离）
├── router/                 # 路由配置
├── store/                  # Pinia 状态
├── utils/                  # 工具函数
├── styles/                 # 全局样式
└── types/                  # TS 类型定义
```

## Vue 组件规范

### 组件命名

- **单文件组件**: 大驼峰 `ModelManager.vue`
- **组合式函数**: `useXxx`，如 `useFullscreen`

### 组件结构

```vue
<template>
  <!-- 模板 -->
</template>

<script setup lang="ts">
// 1. 导入（按类型分组）
import { ref, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import type { FormInstance } from 'element-plus'
import { getListApi } from '@/api/xxx'
import type { XxxResp } from '@/api/xxx'

// 2. 类型定义
interface TableItem {
  id: number
  name: string
}

// 3. Props / Emits
const props = defineProps<{
  modelValue: boolean
  data?: any
}>()

const emit = defineEmits<{
  'update:modelValue': [value: boolean]
  'success': []
}>()

// 4. 状态
const loading = ref(false)
const tableList = ref<TableItem[]>([])

// 5. 计算属性
const isEdit = computed(() => !!props.data)

// 6. 方法
async function fetchData() {
  loading.value = true
  try {
    const res = await getListApi()
    tableList.value = res.data
  } finally {
    loading.value = false
  }
}

// 7. 生命周期
onMounted(() => {
  fetchData()
})
</script>

<style lang="scss" scoped>
/* 样式 */
</style>
```

## API 封装规范

### API 文件结构

```typescript
// api/datamodel.ts
import request from '@/utils/request'

// 统一前缀
const BASE_URL = '/dev/datamodel'

// 列表查询 - GET
export function getDatabaseListApi() {
  return request.get(`${BASE_URL}/database/list`)
}

// 分页查询 - GET with params
export function getTablePageApi(params: TablePageQueryReq) {
  return request.get(`${BASE_URL}/table/page`, { params })
}

// 新增 - POST
export function addDatabaseApi(data: DatabaseAddReq) {
  return request.post(`${BASE_URL}/database/add`, data)
}

// 更新 - POST
export function updateDatabaseApi(data: DatabaseUpdateReq) {
  return request.post(`${BASE_URL}/database/update`, data)
}

// 删除 - POST
export function deleteDatabaseApi(id: number) {
  return request.post(`${BASE_URL}/database/delete/${id}`)
}
```

### 类型定义

```typescript
// api/types/datamodel.ts
export interface Database {
  id: number
  name: string
  code: string
  type: 'mysql' | 'sqlserver' | 'postgresql'
  description?: string
  sort: number
  status: number
}

export interface DatabaseAddReq {
  name: string
  code: string
  type: string
  description?: string
}
```

## 样式规范

### 颜色与主题规范

**禁止使用硬编码颜色值**，所有颜色必须使用 CSS 变量：

```scss
/* ❌ 错误：硬编码颜色 */
.my-component {
  color: #333;
  background: #fff;
  border-color: #e2e8f0;
}

/* ✅ 正确：使用 CSS 变量 */
.my-component {
  color: var(--text-regular);
  background: var(--bg-primary);
  border-color: var(--border-color);
}
```

**UI 风格必须与全局保持一致：**
- 使用项目定义的 CSS 变量（在 `src/styles/index.scss` 中定义）
- 支持亮色/暗黑主题自动切换
- 主题色为玫红色 `#FE4066`（`--el-color-primary`）
- 圆角、阴影使用变量 `--card-radius`、`--card-shadow`

### CSS 变量

使用项目定义的 CSS 变量，支持主题切换：

```scss
/* 亮色主题 */
--el-color-primary: #FE4066;           // 主题色-玫红色
--sidebar-bg-color: #ffffff;           // 侧边栏背景
--sidebar-active-bg-color: rgba(254, 64, 102, 0.1);
--text-primary: #0f172a;               // 主文字
--text-regular: #334155;               // 常规文字
--text-secondary: #64748b;             // 次要文字
--bg-primary: #ffffff;                 // 主背景
--bg-secondary: #f8fafc;               // 次背景
--border-color: #e2e8f0;               // 边框色

/* 暗黑主题 */
--sidebar-bg-color: #1e293b;
--text-primary: #f1f5f9;
--bg-primary: #1e293b;
```

### 常用样式模式

```scss
// 卡片样式
.card {
  background: var(--bg-primary);
  border-radius: var(--card-radius);  // 12px
  box-shadow: var(--card-shadow);
  border: 1px solid var(--border-color);
}

// 表格样式
.table-container {
  .el-table {
    border-radius: var(--card-radius);
    overflow: hidden;
  }
}

// 列表项样式
.list-item {
  display: flex;
  align-items: center;
  padding: 8px 12px;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s ease;

  &:hover {
    background: var(--bg-secondary);
  }

  &.is-selected {
    background: var(--el-color-primary-light-9);
    border-color: var(--el-color-primary-light-5);
  }
}
```

## Element Plus 组件使用

### 表单

```vue
<el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
  <el-row :gutter="20">
    <el-col :span="12">
      <el-form-item label="名称" prop="name">
        <el-input v-model="form.name" placeholder="请输入名称" />
      </el-form-item>
    </el-col>
    <el-col :span="12">
      <el-form-item label="类型" prop="type">
        <el-select v-model="form.type" placeholder="请选择" style="width: 100%;">
          <el-option label="MySQL" value="mysql" />
        </el-select>
      </el-form-item>
    </el-col>
  </el-row>
</el-form>
```

### 表格

```vue
<el-table :data="tableData" v-loading="loading" stripe border>
  <el-table-column prop="name" label="名称" min-width="120" />
  <el-table-column label="操作" width="120" fixed="right">
    <template #default="{ row }">
      <el-button type="primary" link @click="edit(row)">编辑</el-button>
      <el-button type="danger" link @click="delete(row)">删除</el-button>
    </template>
  </el-table-column>
</el-table>

<el-pagination
  v-model:current-page="pageNum"
  v-model:page-size="pageSize"
  :total="total"
  layout="total, sizes, prev, pager, next"
  @change="fetchData"
/>
```

### 对话框

```vue
<el-dialog
  :title="isEdit ? '编辑' : '新增'"
  v-model="visible"
  width="500px"
  :close-on-click-modal="false"
>
  <el-form>...</el-form>
  <template #footer>
    <el-button @click="visible = false">取消</el-button>
    <el-button type="primary" @click="submit" :loading="submitting">确定</el-button>
  </template>
</el-dialog>
```

## 数据模型组件规范

### ModelManager.vue

- 左侧数据库列表，右侧表列表（可展开显示字段）
- 表卡片头部显示：展开图标 + 表图标 + 表名 + 表编码 + 字段数 + 操作按钮
- 展开后显示字段表格

### ERDiagram.vue

- 左侧：表选择列表（复选框 + 图标 + 表名 + 表编码标签）
- 右侧：SVG 画布，支持拖拽、缩放、自动布局
- 顶部工具栏：数据库选择、显示全部/清空、自动布局、缩放、全屏
- 底部：表关系描述面板

### 表单组件规范

```vue
<!-- DatabaseForm.vue -->
<template>
  <el-dialog :title="isEdit ? '编辑数据库' : '新增数据库'" v-model="visible" width="500px">
    <el-form ref="formRef" :model="form" :rules="rules" label-width="80px">
      <el-form-item label="名称" prop="name">
        <el-input v-model="form.name" placeholder="请输入数据库名称" />
      </el-form-item>
      <el-form-item label="编码" prop="code">
        <el-input v-model="form.code" placeholder="请输入数据库编码" :disabled="isEdit" />
      </el-form-item>
      <el-form-item label="类型" prop="type">
        <el-select v-model="form.type" placeholder="请选择数据库类型" style="width: 100%;">
          <el-option label="MySQL" value="mysql" />
          <el-option label="SQL Server" value="sqlserver" />
          <el-option label="PostgreSQL" value="postgresql" />
        </el-select>
      </el-form-item>
    </el-form>
    <template #footer>
      <el-button @click="visible = false">取消</el-button>
      <el-button type="primary" @click="submitForm" :loading="submitting">确定</el-button>
    </template>
  </el-dialog>
</template>
```

## 常用命令

```bash
# 启动开发服务器
cd smart-admin-web && npm run dev

# 构建生产版本
npm run build

# 预览构建结果
npm run preview

# 代码检查
npm run lint
```

## 开发环境

| 服务 | 地址 | 备注 |
|------|------|------|
| 前端 | http://localhost:3000 | Vite 开发服务器（热更新，无需重启） |
| 后端 | http://localhost:8080 | Spring Boot |
| API 文档 | http://localhost:8080/doc.html | Knife4j |
