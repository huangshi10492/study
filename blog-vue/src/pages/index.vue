<template>
  <div xl:f-c-c>
    <n-list id="image-scroll-container" px-4 my-0 xl:w-300 w-auto>
      <template v-if="listLoading">
        <ListSkeleton />
      </template>
      <ArticleList v-else :items="(data as articleListItem[])" />
      <template #footer>
        <n-button v-if="buttonShow" py-5 w-full :disabled="loading" :loading="loading" @click="loadMore()">
          加载更多
        </n-button>
        <n-button v-else py-5 w-full disabled>没有更多内容了</n-button>
      </template>
    </n-list>
  </div>
</template>

<script setup lang="ts">
const data = ref<Array<articleListItem>>()
const loading = ref(false)
const listLoading = ref(true)
const buttonShow = ref(true)
var page = 1
articleList(page).then((res) => {
  data.value = [...res.data]
  listLoading.value = false
})
const loadMore = () => {
  loading.value = true
  articleList(++page).then((res) => {
    if (res.code == 200) {
      data.value?.push(...res.data)
    } else if (res.code == 300) {
      page--
      buttonShow.value = false
    } else {
      page--
    }
    loading.value = false
  })
}
title('主页')
</script>
<route lang="json">
{
  "meta": {
    "title": "主页"
  }
}
</route>
