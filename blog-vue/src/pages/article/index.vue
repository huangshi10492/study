<template>
  <ArticleList :items="data" />
  <n-pagination v-model:page="page" :item-count="201" :page-size="10" size="large" show-quick-jumper />
</template>

<script setup lang="ts">
const data = ref()
const page = ref(1)
articleList(1).then((res) => {
  data.value = res.data
})
</script>

<style scoped></style>
