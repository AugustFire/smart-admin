<template>
  <ThemeTransition />
  <router-view />
</template>

<script setup lang="ts">
import ThemeTransition from '@/components/ThemeTransition/index.vue'
</script>

<style lang="scss">
#app {
  width: 100%;
  height: 100%;
}
</style>
