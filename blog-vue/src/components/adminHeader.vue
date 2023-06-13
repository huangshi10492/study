<template>
  <div px-3 py-3 flex items-center>
    <n-button v-if="!adminStore.smallWidth" quaternary @click="adminStore.switchCollapsed">
      <template #icon>
        <n-icon :size="22">
          <i-ri:indent-increase v-if="adminStore.collapsed" />
          <i-ri:indent-decrease v-else />
        </n-icon>
      </template>
    </n-button>
    <n-breadcrumb mx-3 flex-auto>
      <template v-for="item in route.matched" :key="item.name">
        <n-breadcrumb-item v-if="item.name">
          {{ item.meta.title }}
        </n-breadcrumb-item>
      </template>
    </n-breadcrumb>
    <n-button mx-5 @click="loginOut()">登出</n-button>
  </div>
</template>

<script setup lang="ts">
import { useMessage } from 'naive-ui'

const adminStore = useAdminStore()
const webStore = useWebStore()
const router = useRouter()
const route = useRoute()
const message = useMessage()
const loginOut = () => {
  adminStore.loginOut()
  router.push('/admin/login')
}
if (adminStore.token) {
  adminInfo()
    .then((res) => {
      if (res.code == 200) {
        adminStore.isLogin = true
      }
    })
    .catch(() => {
      message.error('未登录')
      adminStore.isLogin = false
      adminStore.token = ''
      router.push('/admin/login')
    })
}
systemInfo().then((res) => {
  webStore.info = res.data
})
</script>
