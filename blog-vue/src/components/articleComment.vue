<template>
  <div text-base font-bold my-1 color-primary>{{ props.comment.owner }}</div>
  <div text-lg mx-2>{{ props.comment.content }}</div>
  <div text-sm my-1 flex items-center style="opacity: 0.8">
    {{ props.comment.createdAt.slice(0, 10) }}
    <n-button text mx-3 @click="toShowReply(props.comment)">回复<i-ri:message-3-line m-1 /> </n-button>
  </div>
  <div v-if="props.comment.replies?.length != 0" flex flex-row>
    <div w-1 m-2 bg-black style="opacity: 0.25" />
    <n-list class="reply" :show-divider="false">
      <n-list-item v-for="(replyData, key) in props.comment.replies" :key="key">
        <span text-base m-1 font-bold color-primary>
          {{ replyData.owner }}
        </span>
        回复
        <span text-base m-1 font-bold color-primary>
          {{ replyData.replyer }}
        </span>
        <div text-lg mx-2>{{ replyData.content }}</div>
        <div text-sm my-1 flex items-center style="opacity: 0.8">
          {{ replyData.createdAt.slice(0, 10) }}
          <n-button text mx-3 @click="toShowReply(replyData)">回复<i-ri:message-3-line m-1 /> </n-button>
        </div>
      </n-list-item>
    </n-list>
  </div>
  <div v-show="showReply">
    <n-card v-if="!userStore.isLogin" f-c-c>
      <div f-c-c flex-col>
        <div text-xl font-semibold>登录即可参与评论</div>
        <n-button mt-5 strong secondary round type="primary" @click="showModal = true">登录/注册</n-button>
      </div>
    </n-card>
    <template v-else>
      <n-input v-model:value="replyValue" type="textarea" :placeholder="'回复给 ' + placeholder" />
      <div flex justify-end>
        <n-button m-2 strong secondary round @click="showReply = false">取消</n-button>
        <n-button m-2 strong secondary round type="primary" @click="reply(props.comment)">发送</n-button>
      </div>
    </template>
  </div>
  <n-modal v-model:show="showModal">
    <n-card w-100> <UserLogin @close-modal="showModal = false" /></n-card>
  </n-modal>
</template>

<script setup lang="ts">
import { useMessage } from 'naive-ui'

type Props = {
  comment: comment
}
const props = defineProps<Props>()
const emit = defineEmits(['refresh'])
const replyValue = ref()
const placeholder = ref<string>()
const showReply = ref(false)
const showModal = ref(false)
const message = useMessage()
const userStore = useUserStore()

const toShowReply = (data: comment | reply) => {
  showReply.value = !showReply.value
  placeholder.value = data.owner
}

const reply = (item: comment) => {
  replyComment({
    content: replyValue.value,
    toCommentId: item.objectId,
    replyer: placeholder.value as string,
  }).then((res) => {
    if (res.code == 200) {
      message.success('回复成功')
      replyValue.value = ''
      emit('refresh')
    }
  })
}
</script>

<style scoped></style>
