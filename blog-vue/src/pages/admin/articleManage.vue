<template>
  <n-button size="large" mb-3 @click="edit()">
    <template #icon>
      <i-ri:add-fill />
    </template>
    新建文章
  </n-button>
  <n-data-table
    :columns="columns"
    :data="data"
    :pagination="{
      pageSize: 10,
    }"
    :bordered="false"
    :scroll-x="800"
    :loading="loading" />
  <n-modal v-model:show="showeditModal" preset="card" title="编辑文章" :close-on-esc="false" :closable="false">
    <ArticleEdit :article-id="articleId" @close-modal="refresh()" />
  </n-modal>
  <n-modal v-model:show="showPicModal">
    <img :src="previewPic" max-w-200 />
  </n-modal>
</template>

<script setup lang="ts">
import { NButton, NSwitch, useMessage, useDialog } from 'naive-ui'
import type { DataTableColumns } from 'naive-ui'

const message = useMessage()
const dialog = useDialog()
const data = ref<Array<articleListItem>>()
const articleId = ref()
const showeditModal = ref(false)
const showPicModal = ref(false)
const previewPic = ref('')
const loading = ref(false)

const refresh = () => {
  showeditModal.value = false
  loading.value = true
  articleListAll().then((res) => {
    data.value = res.data
    loading.value = false
  })
}
refresh()
const edit = (value?: string) => {
  articleId.value = value
  showeditModal.value = true
}

const del = (row: articleListItem) => {
  const d = dialog.warning({
    title: '是否删除',
    positiveText: '确定',
    negativeText: '取消',
    onPositiveClick: () => {
      d.loading = true
      return deleteArticle(row.objectId).then((res) => {
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

const change = (row: articleListItem, value: boolean) => {
  const d = dialog.warning({
    title: '是否切换发布状态',
    positiveText: '确定',
    negativeText: '取消',
    onPositiveClick: () => {
      d.loading = true
      return changePublish(row.objectId, value).then((res) => {
        if (res.code == 200) {
          message.success('修改成功')
          refresh()
        } else {
          message.error(res.msg)
        }
      })
    },
  })
}

const showPic = (picUrl: string) => {
  previewPic.value = picUrl
  showPicModal.value = true
}

const columns: DataTableColumns<articleListItem> = [
  {
    title: 'Title',
    key: 'title',
  },
  {
    title: '封面',
    key: 'picUrl',
    render(row) {
      if (row.picUrl) {
        return h(
          NButton,
          {
            size: 'small',
            onClick: () => {
              showPic(row.picUrl as string)
            },
          },
          { default: () => '查看图片' }
        )
      } else {
        return '无图片'
      }
    },
  },
  {
    title: '创建时间',
    key: 'createdTime',
    render(row) {
      return row.createdAt.slice(0, 10)
    },
  },
  {
    title: '发布状态',
    key: 'isPublish',
    render(row) {
      return h(NSwitch, {
        value: row.isPublish,
        onUpdateValue: (value) => {
          change(row, value)
        },
      })
    },
  },
  {
    title: '操作',
    key: 'change',
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
title('文章管理')
</script>
<route lang="json">
{
  "meta": {
    "layout": "adminLayout",
    "title": "文章管理",
    "admin": true
  }
}
</route>
