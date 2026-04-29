<template>
  <div class="ai-chat-container">
    <ChatDrawer />
  </div>
</template>

<script setup lang="ts">
import ChatDrawer from './ChatDrawer.vue'
</script>

<style lang="scss" scoped>
.ai-chat-container {
  position: fixed;
  right: 24px;
  bottom: 24px;
  z-index: 2025;
}
</style>
