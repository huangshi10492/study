<template>
  <n-config-provider :locale="zhCN" :date-locale="dateZhCN" :theme="theme" h-full>
    <n-loading-bar-provider>
      <n-dialog-provider>
        <n-message-provider>
          <router-view />
        </n-message-provider>
      </n-dialog-provider>
    </n-loading-bar-provider>
  </n-config-provider>
  <n-space v-if="webStore.isLoading">
    <n-spin fixed w-5 h-5 right-2 top-2 size="small" />
  </n-space>
</template>

<script setup lang="ts">
import { zhCN, dateZhCN, useOsTheme, darkTheme } from 'naive-ui'
const webStore = useWebStore()
const osThemeRef = useOsTheme()
const theme = computed(() => (osThemeRef.value === 'dark' ? darkTheme : null))
</script>
<style>
html,
body,
#app {
  height: 100%;
}
/* router view transition fade-slide */
.fade-slide-leave-active,
.fade-slide-enter-active {
  transition: all 0.3s;
}

.fade-slide-enter-from {
  opacity: 0;
  transform: translateX(20px);
}

.fade-slide-leave-to {
  opacity: 0;
  transform: translateX(-20px);
}
</style>
