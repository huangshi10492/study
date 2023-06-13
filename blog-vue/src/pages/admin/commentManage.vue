<template>
  <n-spin :show="loading">
    <n-select v-model:value="articleValue" :loading="selectLoading" :options="options" @update:value="selectOption" />
    <n-collapse v-if="comments?.length != 0" my-5>
      <template v-for="item in comments" :key="item">
        <n-collapse-item :title="item.owner + '评论：' + item.content">
          <n-list :show-divider="false">
            <template v-for="reply in item.replies" :key="reply">
              <n-list-item>
                {{ reply.owner }} 回复 {{ reply.replyer }}： {{ reply.content }}
                <n-button float-right @click="delReply(reply.objectId)">删除</n-button>
              </n-list-item>
            </template>
          </n-list>
          <template #header-extra>
            <n-button @click="delComment(item.objectId)">删除</n-button>
          </template>
        </n-collapse-item>
      </template>
    </n-collapse>
    <n-empty v-else m-5> </n-empty>
  </n-spin>
</template>

<script setup lang="ts">
import { useMessage } from 'naive-ui'

const articleValue = ref()
const options = ref()
const comments = ref<comment[]>()
const loading = ref(false)
const selectLoading = ref(true)
const message = useMessage()
articleListAll().then((res) => {
  res.data.map(function (obj: any) {
    obj['label'] = obj['title'] // 分配新键
    obj['value'] = obj['objectId']
    obj['disabled'] = !obj['isPublish']
    delete obj['title'] // 删除旧键
    delete obj['objectId']
    return obj
  })
  options.value = res.data
  selectLoading.value = false
})
const selectOption = (value: string) => {
  loading.value = true
  articleContent(value).then((res) => {
    comments.value = res.data.comments
    loading.value = false
  })
}
const delComment = (commentId: string) => {
  deleteComment(commentId).then((res) => {
    message.success(res.msg)
    selectOption(articleValue.value)
  })
}
const delReply = (commentId: string) => {
  deleteReply(commentId).then((res) => {
    message.success(res.msg)
    selectOption(articleValue.value)
  })
}
title('评论管理')
</script>

<route lang="json">
{
  "meta": {
    "layout": "adminLayout",
    "title": "评论管理",
    "admin": true
  }
}
</route>
