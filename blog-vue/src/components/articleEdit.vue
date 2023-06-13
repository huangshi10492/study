<template>
  <n-spin :show="loading">
    <n-form ref="formRef" :model="formData">
      <n-form-item label="标题" path="title">
        <n-input v-model:value="formData.title" />
      </n-form-item>
      <n-form-item label="封面" path="picUrl">
        <n-upload
          v-model:file-list="fileList"
          :max="1"
          :on-finish="onFinish"
          :action="uploadAction"
          list-type="image-card"
          :headers="{ Authorization: 'Bearer ' + token }" />
      </n-form-item>
      <n-form-item label="标签" path="tag">
        <template v-for="item in formData.tags" :key="item">
          <n-tag m-1 round closable @close="removeTag(item.objectId)">{{ item.name }}</n-tag>
        </template>
        <n-popover trigger="manual" :show="tagPopover" :show-arrow="false" scrollable w-50 h-50>
          <template #trigger>
            <n-button m-1 size="small" round @click="tagPopover = !tagPopover">
              <i-ri:add-fill />
            </n-button>
          </template>
          <div flex flex-col>
            <n-input-group>
              <n-input v-model:value="tagName" />
              <n-button px-2 @click="addNewTag()"><i-ri:add-fill /></n-button>
            </n-input-group>
            <template v-for="item in tagListData" :key="item">
              <n-button quaternary @click="putTag(item)">
                <n-ellipsis>
                  {{ item.name }}
                </n-ellipsis>
              </n-button>
            </template>
          </div>
        </n-popover>
      </n-form-item>
      <n-form-item label="概述" path="description">
        <n-input v-model:value="formData.description" type="textarea" />
      </n-form-item>
      <n-form-item>
        <v-md-editor
          v-model="formData.content"
          :disabled-menus="[]"
          :include-level="[1, 2, 3]"
          height="400px"
          @upload-image="handleUploadImage"></v-md-editor>
      </n-form-item>
      <div flex>
        <div flex-auto></div>
        <n-button m-1 @click="saveArticle">保存</n-button>
        <n-button type="error" m-1 @click="cencel">取消</n-button>
      </div>
    </n-form>
  </n-spin>
</template>

<script setup lang="ts">
import { useDialog, useMessage } from 'naive-ui'
import type { FormInst, UploadFileInfo } from 'naive-ui'
import VMdEditor from '@kangc/v-md-editor'
import '@kangc/v-md-editor/lib/style/base-editor.css'
import githubTheme from '@kangc/v-md-editor/lib/theme/github.js'
import '@kangc/v-md-editor/lib/theme/style/github.css'
import hljs from 'highlight.js'

VMdEditor.use(githubTheme, {
  Hljs: hljs,
})

const props = defineProps<{ articleId?: string }>()
const emit = defineEmits(['closeModal'])
const message = useMessage()
const dialog = useDialog()
const { token } = useAdminStore()
const formRef = ref<FormInst | null>(null)
const formData: articleForm = reactive({
  objectId: '',
  title: '',
  content: '',
})
const fileList = ref<UploadFileInfo[]>()
const tagListData = ref<tagItem[]>([])
const tagName = ref()
const loading = ref(false)
const tagPopover = ref(false)
const uploadAction = import.meta.env.VITE_API_URL + '/api/admin/upload/file'

if (props.articleId) {
  loading.value = true
  articleEdit(props.articleId).then((res) => {
    Object.assign(formData, res.data)
    if (res.data.picUrl) {
      fileList.value = [
        {
          id: res.data.title,
          name: res.data.title,
          status: 'finished',
          url: res.data.picUrl,
        },
      ]
    }
    loading.value = false
  })
}

tagList().then((res) => {
  tagListData.value = res.data
})

const onFinish = ({ event }: { file: UploadFileInfo; event?: ProgressEvent }) => {
  formData.picUrl = import.meta.env.VITE_FILE_URL + JSON.parse((event?.target as XMLHttpRequest).response).data
}

const saveArticle = (event: MouseEvent) => {
  event.preventDefault()
  formRef.value?.validate((errors) => {
    if (errors) {
      message.error('输入错误，请重新验证')
    } else {
      loading.value = true
      if (!formData.objectId) {
        addArticle(formData).then((res) => {
          loading.value = false
          if (res.code == 200) {
            message.success('添加成功')
            emit('closeModal')
          } else {
            message.error(res.msg)
          }
        })
      } else {
        editArticle(formData).then((res) => {
          loading.value = false
          if (res.code == 200) {
            message.success('修改成功')
            emit('closeModal')
          } else {
            message.error(res.msg)
          }
        })
      }
    }
  })
}

const removeTag = (value: string) => {
  formData.tags = (formData.tags as tagItem[]).filter(({ objectId }) => objectId !== value)
}

const putTag = (item: tagItem) => {
  if (formData.tags?.length) {
    for (let rec of formData.tags) {
      if (rec.objectId == item.objectId) {
        message.error('此标签已存在')
        return
      }
    }
    formData.tags?.push(item)
  } else {
    formData.tags = [item]
  }
}

const addNewTag = () => {
  for (let rec of tagListData.value) {
    if (rec.name == tagName.value) {
      message.error('此标签已存在')
      return
    }
  }
  addTag(tagName.value).then((res) => {
    putTag(res.data)
    tagName.value = ''
    tagPopover.value = false
    tagList().then((res) => {
      tagListData.value = res.data
    })
  })
}

const handleUploadImage = (_event: any, insertImage: (arg0: { url: string }) => void, files: File[]) => {
  // 拿到 files 之后上传到文件服务器，然后向编辑框中插入对应的内容
  let formdata = new FormData()
  formdata.append('file', files[0])
  uploadFile(formdata).then((res) => {
    insertImage({ url: import.meta.env.VITE_FILE_URL + res.data })
  })
}

const cencel = () => {
  dialog.warning({
    title: '是否退出',
    positiveText: '确定',
    negativeText: '取消',
    onPositiveClick: () => {
      emit('closeModal')
    },
  })
}
</script>

<style scoped></style>
