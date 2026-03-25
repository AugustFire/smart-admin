<template>
  <div class="search-bar">
    <el-form :model="modelValue" inline>
      <slot />
      <el-form-item class="search-actions">
        <el-button type="primary" @click="$emit('search')">
          <el-icon><Search /></el-icon>
          搜索
        </el-button>
        <el-button @click="$emit('reset')">
          <el-icon><Refresh /></el-icon>
          重置
        </el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script setup lang="ts">
import { Search, Refresh } from '@element-plus/icons-vue'

defineProps<{
  modelValue: Record<string, any>
}>()

defineEmits<{
  search: []
  reset: []
  'update:modelValue': [value: Record<string, any>]
}>()
</script>

<style lang="scss" scoped>
.search-bar {
  margin-bottom: 16px;

  :deep(.el-form) {
    display: flex;
    flex-wrap: wrap;
    align-items: flex-start;

    .el-form-item {
      margin-right: 16px;
      margin-bottom: 12px;

      .el-input {
        width: 200px;
      }

      .el-select {
        width: 160px;
      }
    }

    .search-actions {
      margin-left: auto;
    }
  }
}
</style>