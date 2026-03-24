<template>
  <div class="hamburger-container" @click="toggleClick">
    <svg
      class="hamburger"
      :class="{ 'is-active': isActive }"
      viewBox="0 0 100 100"
      width="50"
      height="50"
    >
      <path
        class="line"
        d="M 20,29.603448 H 80"
        :style="{ transform: isActive ? 'translateY(15px)' : 'none' }"
      />
      <path
        class="line"
        d="M 20,50 H 80"
        :style="{ opacity: isActive ? 0 : 1, transform: isActive ? 'translateX(-60px)' : 'none' }"
      />
      <path
        class="line"
        d="M 20,70.396552 H 80"
        :style="{ transform: isActive ? 'translateY(-15px)' : 'none' }"
      />
    </svg>
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
.hamburger-container {
  padding: 8px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;

  // 在侧边栏内时使用浅色
  .sidebar-container & {
    .hamburger {
      .line {
        stroke: #c7d2fe;
      }
    }
  }
}

.hamburger {
  width: 24px;
  height: 24px;

  .line {
    fill: none;
    stroke: var(--hamburger-color, #3b82f6);
    stroke-width: 6;
    stroke-linecap: round;
    transition: all 0.3s ease-in-out;
  }
}
</style>
