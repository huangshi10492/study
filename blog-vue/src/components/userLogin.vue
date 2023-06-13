<template>
  <n-tabs class="card-tabs" :value="tabValue" size="large" animated justify-content="space-evenly">
    <n-tab-pane name="login" tab="登录">
      <n-form ref="loginFormRef" :model="loginForm" :rules="rules" size="large">
        <n-form-item label="用户名" path="name">
          <n-input v-model:value="loginForm.name" placeholder="输入用户名" />
        </n-form-item>
        <n-form-item label="密码" path="password">
          <n-input v-model:value="loginForm.password" type="password" placeholder="输入密码" @keydown.enter="login" />
        </n-form-item>
      </n-form>
      <n-button type="primary" block h-10 secondary strong @click="login"> 登录 </n-button>
    </n-tab-pane>
    <n-tab-pane name="register" tab="注册">
      <n-form ref="registerFormRef" :model="registerForm" :rules="rules" size="large">
        <n-form-item-row label="用户名" path="name">
          <n-input v-model:value="registerForm.name" placeholder="输入用户名" />
        </n-form-item-row>
        <n-form-item-row label="密码" path="password">
          <n-input v-model:value="registerForm.password" type="password" placeholder="输入密码" />
        </n-form-item-row>
        <n-form-item-row label="重复密码" path="passwordAgain">
          <n-input
            v-model:value="registerForm.passwordAgain"
            type="password"
            placeholder="输入密码"
            @keydown.enter="register" />
        </n-form-item-row>
      </n-form>
      <n-button type="primary" block h-10 secondary strong @click="register"> 注册 </n-button>
    </n-tab-pane>
  </n-tabs>
</template>

<script setup lang="ts">
import { useMessage } from 'naive-ui'
import type { FormInst, FormItemRule, FormRules } from 'naive-ui'
import { userLogin, userRegister } from '@/api/other'

const emit = defineEmits(['closeModal'])
const loginFormRef = ref<FormInst | null>(null)
const registerFormRef = ref<FormInst | null>(null)
const message = useMessage()
const tabValue = ref()
const userStore = useUserStore()

const loginForm: loginForm = reactive({
  name: '',
  password: '',
})
const registerForm: loginForm = reactive({
  name: '',
  password: '',
})

function validatePasswordSame(rule: FormItemRule, value: string): boolean {
  return value === registerForm.password
}

const rules: FormRules = {
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
  passwordAgain: [
    {
      required: true,
      message: '请再次输入密码',
      trigger: ['input', 'blur'],
    },
    {
      validator: validatePasswordSame,
      message: '两次密码输入不一致',
      trigger: ['blur', 'password-input'],
    },
  ],
}
const login = () => {
  loginFormRef.value?.validate((errors) => {
    if (errors) {
      message.error('输入错误，请重新验证')
    } else {
      userLogin(loginForm).then((res) => {
        if (res.code == 200) {
          emit('closeModal')
          message.success('登陆成功')
          userStore.token = res.data.token
          userStore.isLogin = true
        } else {
          message.error(res.msg)
        }
      })
    }
  })
}
const register = () => {
  registerFormRef.value?.validate((errors) => {
    if (errors) {
      message.error('输入错误，请重新验证')
    } else {
      userRegister(registerForm).then((res) => {
        if (res.code == 200) {
          message.success('注册成功')
          loginForm.name = registerForm.name
          tabValue.value = 'login'
        } else {
          message.error(res.msg)
        }
      })
    }
  })
}
</script>
