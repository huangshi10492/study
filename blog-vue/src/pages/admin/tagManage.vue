<template>
  <n-button size="large" mb-3 @click="edit()">
    <template #icon>
      <i-ri:add-fill />
    </template>
    新建标签
  </n-button>
  <n-data-table
    :columns="columns"
    :data="data"
    :pagination="pagination"
    :bordered="false"
    :scroll-x="500"
    :loading="tableLoading" />
  <n-modal v-model:show="showeditModal" preset="card" title="编辑标签" w-100>
    <n-spin :show="modalLoading">
      <n-form ref="formRef" :model="formData">
        <n-form-item label="标签名" path="name">
          <n-input v-model:value="formData.name" />
        </n-form-item>
        <div flex>
          <div flex-auto></div>
          <n-button m-1 :disabled="saveLoading" :loading="saveLoading" @click="saveTag">保存</n-button>
          <n-button type="error" m-1 @click="showeditModal = false">取消</n-button>
        </div>
      </n-form>
    </n-spin>
  </n-modal>
</template>

<script setup lang="ts">
import { NButton, useMessage, useDialog } from 'naive-ui'
import type { FormInst, DataTableColumns } from 'naive-ui'

const message = useMessage()
const dialog = useDialog()
const pagination = false as const
const data = ref<tagItem[]>()
const formRef = ref<FormInst | null>(null)
const formData: tagForm = reactive({
  objectId: '',
  name: '',
})
const showeditModal = ref(false)
const tableLoading = ref(false)
const modalLoading = ref(false)
const saveLoading = ref(false)

const refresh = () => {
  showeditModal.value = false
  tableLoading.value = true
  tagList().then((res) => {
    data.value = res.data
    tableLoading.value = false
  })
}
refresh()
const edit = (value?: string) => {
  if (value) {
    modalLoading.value = true
    tagInfo(value as string).then((res) => {
      Object.assign(formData, res.data)
      modalLoading.value = false
    })
  } else {
    Object.assign(formData, {
      tagId: 0,
      name: '',
    })
  }
  showeditModal.value = true
}

const del = (row: tagItem) => {
  const d = dialog.warning({
    title: '是否删除',
    positiveText: '确定',
    negativeText: '取消',
    onPositiveClick: () => {
      d.loading = true
      return deleteTag(row.objectId).then((res) => {
        if (res.code == 200) {
          message.success('删除成功')
          refresh()
        } else {
          message.error(res.msg)
        }
      })
    },
  })
}

const saveTag = (event: MouseEvent) => {
  event.preventDefault()
  formRef.value?.validate((errors) => {
    if (errors) {
      message.error('输入错误，请重新验证')
    } else {
      if (!formData.objectId) {
        saveLoading.value = true
        addTag(formData.name).then((res) => {
          saveLoading.value = false
          if (res.code == 200) {
            message.success('添加成功')
            showeditModal.value = false
            refresh()
          } else {
            message.error(res.msg)
          }
        })
      } else {
        saveLoading.value = true
        editTag(formData).then((res) => {
          saveLoading.value = false
          if (res.code == 200) {
            message.success('修改成功')
            showeditModal.value = false
            refresh()
          } else {
            message.error(res.msg)
          }
        })
      }
    }
  })
}

const columns: DataTableColumns<tagItem> = [
  {
    title: '标签名',
    key: 'name',
  },
  {
    title: '操作',
    key: 'change',
    width: 200,
    render(row) {
      return h('div', [
        h(
          NButton,
          {
            style: 'margin:5px',
            strong: true,
            secondary: true,
            size: 'small',
            onClick: () => edit(row.objectId),
          },
          { default: () => '编辑' }
        ),
        h(
          NButton,
          {
            style: 'margin:5px',
            type: 'error',
            strong: true,
            secondary: true,
            size: 'small',
            onClick: () => del(row),
          },
          { default: () => '删除' }
        ),
      ])
    },
  },
]
title('标签管理')
</script>
<route lang="json">
{
  "meta": {
    "layout": "adminLayout",
    "title": "标签管理",
    "admin": true
  }
}
</route>
