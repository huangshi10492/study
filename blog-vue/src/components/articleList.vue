<template>
  <n-list-item v-for="(item, key) in props.items" :key="key">
    <template #prefix>
      <div style="overflow: auto; display: flex; flex-direction: column; gap: 8px">
        <n-image
          v-if="item.picUrl"
          :width="(width > 1000 ? 1000 : width) * 0.24"
          :height="(width > 1000 ? 1000 : width) * 0.14"
          preview-disabled
          lazy
          :src="item.picUrl"
          :intersection-observer-options="{ root: '#image-scroll-container' }"
          rounded
          cursor-pointer
          @click="articleRouter(item.objectId)">
          <template #placeholder>
            <div
              bg-gray-300
              rounded
              flex
              items-center
              justify-center
              style="width: 24vw; height: 14vw; max-width: 240px; max-height: 140px">
              Loading
            </div>
          </template>
        </n-image>
      </div>
    </template>
    <n-thing>
      <template #header>
        <a
          class="text-4.3"
          tracking-wide
          no-underline
          duration-500
          hover:color-primary
          cursor-pointer
          @click="articleRouter(item.objectId)">
          {{ item.title }}
        </a>
      </template>
      <template #description>
        <div class="description minHidden" leading-loose mt-3>{{ item.description }}</div>
      </template>
      <template #footer>
        <div style="font-size: 13px" text-gray-500 flex items-center>
          <n-icon :size="16" m-1><i-ri:time-line /></n-icon>
          {{ item.createdAt.slice(0, 10) }}
          <span v-for="tag in item.tags" :key="tag.objectId" class="minHidden" truncate>
            <n-divider vertical />
            {{ tag.name }}
          </span>
        </div>
      </template>
    </n-thing>
  </n-list-item>
</template>
<script setup lang="ts">
type Props = {
  items: Array<articleListItem> | undefined
}
const props = defineProps<Props>()
const router = useRouter()
const { width } = useWindowSize()

const articleRouter = (articleId: string) => {
  router.push({
    path: '/article/' + articleId,
  })
}
</script>
<style scoped>
.description {
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
}
@media only screen and (max-width: 480px) {
  .minHidden {
    display: none;
  }
}
</style>
