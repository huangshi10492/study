<template>
  <div wh-full f-c-c>
    <n-card w-100>
      <n-form ref="loginFormRef" :model="loginForm" :rules="rules" size="large">
        <n-form-item label="用户名" path="name">
          <n-input v-model:value="loginForm.name" placeholder="输入用户名" />
        </n-form-item>
        <n-form-item label="密码" path="password">
          <n-input v-model:value="loginForm.password" type="password" placeholder="输入密码" @keydown.enter="login" />
        </n-form-item>
      </n-form>
      <n-button type="primary" block h-10 secondary strong :disabled="loading" :loading="loading" @click="login">
        登录
      </n-button>
    </n-card>
  </div>
</template>
<script setup lang="ts">
import { useMessage } from 'naive-ui'
import type { FormInst } from 'naive-ui'

const loginFormRef = ref<FormInst | null>(null)
const message = useMessage()
const adminStore = useAdminStore()
const router = useRouter()
const loading = ref(false)
if (adminStore.isLogin || adminStore.token) {
  router.push('/admin')
}
const loginForm: loginForm = reactive({
  name: 'admin',
  password: '123456',
})

const rules = {
  name: {
    required: true,
    message: '请输入姓名',
    trigger: 'blur',
  },
  password: {
    required: true,
    message: '请输入密码',
    trigger: 'blur',
  },
}
const login = () => {
  loginFormRef.value?.validate((errors) => {
    if (errors) {
      message.error('输入错误，请重新验证')
    } else {
      loading.value = true
      adminLogin(loginForm).then((res) => {
        if (res.code == 200) {
          message.success('登陆成功')
          adminStore.isLogin = true
          adminStore.token = res.data.token
          router.push('/admin')
        } else {
          message.error(res.msg)
        }
        loading.value = false
      })
    }
  })
}
title('管理员登录')
</script>
<route lang="json">
{
  "meta": {
    "layout": "loginLayout",
    "title": "管理员登录"
  }
}
</route>
