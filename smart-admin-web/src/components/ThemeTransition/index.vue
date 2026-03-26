<template>
  <Teleport to="body">
    <div
      v-if="themeStore.themeTransition"
      class="theme-transition-overlay"
      :style="overlayStyle"
    >
      <div class="circle-mask" :class="{ 'reverse': !themeStore.transitionToDark }"></div>
    </div>
  </Teleport>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useThemeStore } from '@/store/modules/theme'

const themeStore = useThemeStore()

// 以主题按钮为中心点
const overlayStyle = computed(() => {
  const { x, y } = themeStore.transitionCenter
  return {
    '--cx': `${x}px`,
    '--cy': `${y}px`,
  }
})
</script>

<style lang="scss" scoped>
.theme-transition-overlay {
  position: fixed;
  inset: 0;
  z-index: 99999;
  pointer-events: none;
}

.circle-mask {
  position: absolute;
  inset: 0;
  background: #0f172a;
  clip-path: circle(0px at var(--cx) var(--cy));
  animation: spread 0.7s cubic-bezier(0.4, 0, 0.2, 1) forwards;

  // 反向播放：深色 → 浅色
  &.reverse {
    animation: spread 0.7s cubic-bezier(0.4, 0, 0.2, 1) reverse forwards;
  }
}

@keyframes spread {
  0% {
    clip-path: circle(0px at var(--cx) var(--cy));
  }
  100% {
    clip-path: circle(150% at var(--cx) var(--cy));
  }
}
</style>