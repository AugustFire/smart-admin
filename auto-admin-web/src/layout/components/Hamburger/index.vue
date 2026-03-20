<template>
  <div
    style="display: inline-block; cursor: pointer"
    @click="toggleClick"
  >
    <el-icon :size="20">
      <Fold v-if="isActive" />
      <Expand v-else />
    </el-icon>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  isActive: boolean
}>()

const emit = defineEmits<{
  toggleClick: []
}>()

function toggleClick() {
  emit('toggleClick')
}
</script>

<style lang="scss" scoped>
.hamburger {
  vertical-align: middle;
  color: var(--navbar-text-color);
}
</style>
