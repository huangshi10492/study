<template>
  <n-list-item v-for="n in 10" :key="n">
    <template #prefix>
      <div style="overflow: auto; display: flex; flex-direction: column; gap: 8px">
        <n-skeleton
          :width="(width > 1000 ? 1000 : width) * 0.24"
          :height="(width > 1000 ? 1000 : width) * 0.14"></n-skeleton>
      </div>
    </template>
    <n-skeleton text :repeat="2" my-2 />
    <div v-if="width > 480">
      <n-skeleton text :repeat="2" my-2 />
    </div>
  </n-list-item>
</template>
<script setup lang="ts">
const { width } = useWindowSize()
</script>
