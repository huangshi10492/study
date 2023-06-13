<template>
  <router-link h-12 f-c-c no-underline pt-3 max-w-200px to="/">
    <n-h2 v-if="!adminStore.collapsed" m-0>
      <n-text type="primary" truncate> blog-go </n-text>
    </n-h2>
    <n-icon v-else :size="24" color="green">
      <i-ri:vuejs-line />
    </n-icon>
  </router-link>
  <n-menu
    accordion
    :options="menuOptions"
    :collapsed-width="64"
    :value="(currentRoute.path as string)"
    :collapsed="adminStore.collapsed" />

  <n-affix class="todark" :bottom="0" :trigger-bottom="2000">
    <n-button v-if="adminStore.smallWidth" quaternary absolute bottom-0 @click="adminStore.switchCollapsed">
      <template #icon>
        <n-icon :size="22">
          <i-ri:indent-increase v-if="adminStore.collapsed" />
          <i-ri:indent-decrease v-else />
        </n-icon>
      </template>
    </n-button>
  </n-affix>
</template>

<script setup lang="ts">
import renderMenu from '@/utils/render'
const router = useRouter()
const adminStore = useAdminStore()
const { currentRoute } = router
const menuOptions = ref()
menuOptions.value = renderMenu([
  { label: '仪表盘', path: '/admin', icon: 'ri:dashboard-3-line' },
  { label: '文章管理', path: '/admin/articleManage', icon: 'ri:article-line' },
  { label: '标签管理', path: '/admin/tagManage', icon: 'ri:price-tag-3-line' },
  { label: '评论管理', path: '/admin/commentManage', icon: 'ri:message-3-line' },
  { label: '系统设置', path: '/admin/systemSeting', icon: 'ri:settings-4-line' },
])
</script>

<style scoped></style>
