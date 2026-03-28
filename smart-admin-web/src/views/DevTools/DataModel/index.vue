<template>
  <div class="app-container">
    <el-card class="data-model-card">
      <!-- 标签页切换 -->
      <el-tabs v-model="activeTab" type="border-card" class="model-tabs">
        <el-tab-pane label="模型管理" name="model">
          <ModelManager />
        </el-tab-pane>

        <el-tab-pane label="E-R 图" name="er">
          <ERDiagram />
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import ModelManager from './ModelManager.vue'
import ERDiagram from './ERDiagram.vue'

const activeTab = ref('model')
</script>

<style lang="scss" scoped>
.app-container {
  padding: 20px;
  background-color: var(--app-main-bg-color);
  min-height: calc(100vh - 84px);
}

.data-model-card {
  height: calc(100vh - 124px);

  :deep(.el-card__body) {
    height: 100%;
    padding: 0;
  }
}

.model-tabs {
  height: 100%;
  display: flex;
  flex-direction: column;

  :deep(.el-tabs__header) {
    margin-bottom: 0;
  }

  :deep(.el-tabs__content) {
    flex: 1;
    overflow: hidden;
    padding: 0;
  }

  :deep(.el-tab-pane) {
    height: 100%;
    overflow: hidden;
  }
}
</style>
