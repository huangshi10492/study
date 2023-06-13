<template>
  <Head>
    <title>{{ articleData.title + ' | ' + webStore.name }}</title>
  </Head>
  <div bg-center bg-cover text-white :style="picStyle">
    <div backdrop-filter min-h-50 f-c-c flex-col backdrop-brightness-75 p-10>
      <div text-3xl m-1 text-center>{{ articleData.title }}</div>
      <div f-c-c m-1 class="time1">
        <div>发表于：{{ articleData.createdAt.slice(0, 10) }}</div>
        <n-divider vertical />
        <div>修改于：{{ articleData.updatedAt.slice(0, 10) }}</div>
      </div>
      <div f-c-c flex-col m-1 hidden class="time2">
        <div>发表于：{{ articleData.createdAt.slice(0, 10) }}</div>
        <div>修改于：{{ articleData.updatedAt.slice(0, 10) }}</div>
      </div>
      <div v-if="articleData.tags" f-c-c m-1>
        <i-ri:price-tag-3-line pr-2 />
        <div v-for="(tag, key) in articleData.tags" :key="key" f-c-c>
          <template v-if="key != 0"> <n-divider vertical /></template>
          {{ tag.name }}
        </div>
      </div>
    </div>
  </div>
  <div m-auto max-w-300 py-10>
    <v-md-preview ref="preview" :text="articleData.content" />
    <n-affix class="todark" :bottom="100" :trigger-bottom="2000" right-10 bg-white shadow-md z-10>
      <n-popover trigger="click" :show-arrow="false" max-h-100 :scrollable="true" placement="top-end">
        <template #trigger>
          <n-button style="padding: 10px" size="large">
            <i-ri:menu-2-line font-size="20" />
          </n-button>
        </template>
        <div v-if="headerList.length == 0" text-center text-base>
          <n-icon :size="40"><i-twemoji:thinking-face font-lg /></n-icon><br />
          没有目录
        </div>
        <template v-for="(anchor, key) in headerList" v-else :key="key">
          <div
            :style="{ padding: `10px 10px 10px ${(anchor.left as number) +10}px` }"
            :class="{ active: active === key }"
            min-w-25
            @click="clickItem(anchor)">
            <a style="cursor: pointer">{{ anchor.id }}</a>
          </div>
        </template>
      </n-popover>
    </n-affix>
    <div>
      <div text-2xl font-semibold m-5>
        评论
        <n-card v-if="!userStore.isLogin" f-c-c my-3>
          <div f-c-c flex-col>
            <div text-xl>登录即可参与评论</div>
            <n-button mt-5 strong secondary round type="primary" @click="showModal = true">登录/注册</n-button>
          </div>
        </n-card>
        <template v-else>
          <n-input v-model:value="commentValue" my-2 type="textarea" />
          <div flex justify-end>
            <n-button strong secondary round type="primary" @click="comment()">发送</n-button>
          </div>
        </template>
      </div>
      <p v-if="commentList?.length == 0" text-center text-xl mx-5 f-c-c>
        暂无评论，快来发表第一篇评论吧
        <n-icon m-1 :size="24"><i-twemoji:face-savoring-food /></n-icon>
      </p>
      <n-list v-else px-5>
        <n-list-item v-for="(item, key) in commentList" :key="key">
          <ArticleComment :comment="(item as comment)" @refresh="refreshComment" />
        </n-list-item>
      </n-list>
    </div>
  </div>
  <n-modal v-model:show="showModal">
    <n-card w-100> <UserLogin @close-modal="showModal = false" /></n-card>
  </n-modal>
</template>

<script lang="ts">
import type { ComponentPublicInstance } from 'vue'
interface IInstance extends ComponentPublicInstance {
  getData(res: any): void
}
export default {
  beforeRouteEnter: function (to, from, next) {
    articleContent(to.params.articleId as string)
      .then((res) => {
        if (res.code == 200) {
          next((vm) => {
            const instance = vm as IInstance
            instance.getData(res)
          })
        } else {
          next({ path: '/404' })
        }
      })
      .catch(() => {
        next({ path: '/404' })
      })
  },
}
</script>

<script setup lang="ts">
import { Head } from '@vueuse/head'
import VMdPreview from '@kangc/v-md-editor/lib/preview'
import '@kangc/v-md-editor/lib/style/preview.css'
import githubTheme from '@kangc/v-md-editor/lib/theme/github.js'
import '@kangc/v-md-editor/lib/theme/style/github.css'
import hljs from 'highlight.js'
import markdownItAnchor from 'markdown-it-anchor'
import { useMessage } from 'naive-ui'

type Props = {
  articleId: string
}
type articleContent = {
  title: string
  content: string
  createdAt: string
  updatedAt: string
  tags?: tagItem[]
}
const props = defineProps<Props>()
const articleData = ref<articleContent>({
  title: '',
  content: '',
  createdAt: '',
  updatedAt: '',
})
const picStyle = ref()
const commentList = ref<comment[]>([])
const preview = ref()
const headerList: articleHeader[] = reactive([])
const active = ref()
const showModal = ref(false)
const commentValue = ref()
const message = useMessage()
const userStore = useUserStore()
const webStore = useWebStore()

const getData = (res: any) => {
  articleData.value = res.data
  picStyle.value = { backgroundImage: 'url(' + res.data.picUrl + ')' }
  commentList.value = res.data.comments
}
defineExpose({ getData })

const refreshComment = () => {
  articleContent(props.articleId).then((res) => {
    commentList.value = res.data.comments
  })
}

const comment = () => {
  addComment({ content: commentValue.value, toArticleId: props.articleId }).then((res) => {
    if (res.code == 200) {
      message.success('评论成功')
      refreshComment()
    } else {
      message.error(res.msg)
    }
  })
}

const headerCallback = (item: any) => {
  if (item.tag == 'h1' || item.tag == 'h2' || item.tag == 'h3') {
    let header: articleHeader = {}
    header.type = Number(item.tag.substr(1, 1))
    header.id = item.attrs[0][1]
    header.left = (header.type - 1) * 20
    headerList.push(header)
    onScroll()
  }
}

const clickItem = (item: articleHeader) => {
  const heading = preview.value.$el.querySelector(`[data-v-md-heading="${item.id}"]`)
  if (heading) {
    preview.value.scrollToTarget({
      target: heading,
      scrollContainer: window,
      top: 60,
    })
  }
}
VMdPreview.use(githubTheme, {
  Hljs: hljs,
  extend(md: any) {
    // md为 markdown-it 实例，可以在此处进行修改配置,并使用 plugin 进行语法扩展
    // md.set(option).use(plugin);
    md.use(markdownItAnchor, {
      permalinkSpace: false,
      callback: headerCallback,
    })
  },
})
const onScroll = () => {
  // 获取所有锚点元素
  const navContents: HTMLElement[] = preview.value.$el.querySelectorAll(
    'div.github-markdown-body > h1,div.github-markdown-body > h2,div.github-markdown-body > h3'
  )
  // 所有锚点元素的 offsetTop
  const offsetTopArr: number[] = []
  navContents.forEach((item) => {
    offsetTopArr.push(item.offsetTop)
  })
  // 获取当前文档流的 scrollTop
  const scrollTop = document.documentElement.scrollTop || document.body.scrollTop
  // 定义当前点亮的导航下标
  let navIndex = 0
  for (let n = 0; n < offsetTopArr.length; n++) {
    // 如果 scrollTop 大于等于第 n 个元素的 offsetTop 则说明 n-1 的内容已经完全不可见
    // 那么此时导航索引就应该是 n 了
    if (scrollTop >= offsetTopArr[n] - 30) {
      navIndex = n
    }
  }
  // 把下标赋值给 vue 的 data
  active.value = navIndex
}
onMounted(() => {
  window.addEventListener('scroll', onScroll)
})
onUnmounted(() => {
  window.removeEventListener('scroll', onScroll)
})
</script>

<style scoped>
.active {
  color: var(--primaryColor);
  background-color: #ddf1e6;
}
@media (prefers-color-scheme: dark) {
  .todark {
    background-color: #48484e;
  }
}
@media only screen and (max-width: 400px) {
  .time1 {
    display: none;
  }
  .time2 {
    display: block;
  }
}
</style>
