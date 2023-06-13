<template>
  <div class="px-2 py-3 flex">
    <router-link to="/" no-underline mx-5>
      <n-h2 m-0>
        <n-text type="primary" font-black> blog-go </n-text>
      </n-h2>
    </router-link>
    <n-menu v-model:value="activeKey" mode="horizontal" :options="menuOptions" flex-auto />
    <n-button v-if="!userStore.isLogin" mx-5 @click="showModal = true">登录</n-button>
    <n-button v-else mx-5 @click="userStore.loginOut()">登出</n-button>
    <n-modal v-model:show="showModal">
      <n-card w-100> <UserLogin @close-modal="showModal = false" /></n-card>
    </n-modal>
  </div>
</template>
<script setup lang="ts">
import type { MenuOption } from 'naive-ui'
import { RouterLink } from 'vue-router'
const activeKey = ref()
const menuOptions: MenuOption[] = []
const showModal = ref(false)
const userStore = useUserStore()

if (userStore.token) {
  userInfo().then((res) => {
    if (res.code == 200) {
      userStore.isLogin = true
    }
  })
}
</script>
