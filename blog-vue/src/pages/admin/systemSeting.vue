<template>
  <n-spin :show="loading">
    <n-alert v-if="!webStore.info.confFile" title="Error" type="error">
      当前环境无法使用配置文件，请自行设置环境变量更改设置
    </n-alert>
    <n-tabs v-else type="line" animated>
      <n-tab-pane name="manager" tab="管理员设置">
        <n-form ref="managerFormRef" :model="data.manager" :rules="managerRules">
          <n-h3 pb-2 mb-3 b-b border-gray-300>修改用户名和密码</n-h3>
          <n-form-item-row label="用户名" path="name">
            <n-input v-model:value="data.manager.name" placeholder="输入用户名" max-w-100 />
          </n-form-item-row>
          <n-form-item-row label="密码" path="password">
            <n-input v-model:value="data.manager.password" type="password" placeholder="输入密码" max-w-100 />
          </n-form-item-row>
        </n-form>
        <n-button type="primary" @click="setManager">保存</n-button>
      </n-tab-pane>
      <n-tab-pane name="db" tab="数据库设置">
        <n-form ref="dbFormRef" :model="data.db" :rules="dbRules">
          <n-form-item-row label="数据库选择" path="dbType">
            <n-select v-model:value="data.db.dbType" :options="options" max-w-100 />
          </n-form-item-row>
          <template v-if="data.db.dbType != 'sqlite'">
            <n-form-item-row label="地址" path="host">
              <n-input v-model:value="data.db.host" max-w-100 />
            </n-form-item-row>
            <n-form-item-row label="端口" path="port">
              <n-input-number v-model:value="data.db.port" max-w-100 />
            </n-form-item-row>
            <n-form-item-row label="用户名" path="user">
              <n-input v-model:value="data.db.user" max-w-100 />
            </n-form-item-row>
            <n-form-item-row label="密码" path="password">
              <n-input v-model:value="data.db.password" max-w-100 />
            </n-form-item-row>
            <n-form-item-row label="数据库名称" path="dbname">
              <n-input v-model:value="data.db.dbname" max-w-100 />
            </n-form-item-row>
          </template>
        </n-form>
        <n-button type="primary" @click="setDB">保存</n-button>
      </n-tab-pane>
    </n-tabs>
  </n-spin>
</template>

<script setup lang="ts">
import { useMessage } from 'naive-ui'
import type { FormInst, FormRules } from 'naive-ui'

const message = useMessage()
const webStore = useWebStore()
const loading = ref(true)
const managerFormRef = ref<FormInst | null>()
const dbFormRef = ref<FormInst | null>()
const data: seting = reactive({
  db: {
    dbType: '',
    dbname: '',
    host: '',
    password: '',
    port: 0,
    user: '',
  },
  manager: {
    name: '',
    password: '',
  },
})
const options = [
  {
    label: 'pgsql',
    value: 'pgsql',
  },
  {
    label: 'mysql',
    value: 'mysql',
  },
  {
    label: 'sqlite',
    value: 'sqlite',
  },
]
const managerRules: FormRules = {
  name: {
    required: true,
    trigger: 'blur',
  },
  password: {
    required: true,
    message: '请输入密码',
    trigger: 'blur',
  },
}
const dbRules: FormRules = {
  dbname: {
    required: true,
    trigger: 'blur',
  },
  dbType: {
    required: true,
    trigger: 'blur',
  },
  host: {
    required: true,
    trigger: 'blur',
  },
  password: {
    required: true,
    trigger: 'blur',
  },
  port: {
    type: 'number',
    required: true,
    trigger: 'blur',
  },
  user: {
    required: true,
    trigger: 'blur',
  },
}
getSeting().then((res) => {
  Object.assign(data, res.data)
  loading.value = false
})
const setManager = (event: MouseEvent) => {
  event.preventDefault()
  managerFormRef.value?.validate((errors) => {
    if (errors) {
      message.error('输入错误，请重新验证')
    } else {
      setManagerSeting(data.manager).then((res) => {
        if (res.code == 200) {
          message.success('修改成功')
        } else {
          message.error(res.msg)
        }
      })
    }
  })
}
const setDB = (event: MouseEvent) => {
  event.preventDefault()
  dbFormRef.value?.validate((errors) => {
    if (errors) {
      message.error('输入错误，请重新验证')
    } else {
      setDBSeting(data.db).then((res) => {
        if (res.code == 200) {
          message.success('修改成功,重启后台程序后应用')
        } else {
          message.error(res.msg)
        }
      })
    }
  })
}
title('系统设置')
</script>

<style scoped></style>
<route lang="json">
{
  "meta": {
    "layout": "adminLayout",
    "title": "系统设置",
    "admin": true
  }
}
</route>
