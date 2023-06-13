/** 文章列表项类型 */
declare type articleListItem = {
  objectId: string
  createdAt: string
  title: string
  picUrl?: string
  tags?: tagItem[]
  description?: string
  isPublish?: boolean
}
/** 文章编辑表单类型 */
declare type articleForm = {
  objectId: string
  title: string
  picUrl?: string
  tags?: tagItem[]
  tagIds?: number[]
  description?: string
  content: string
}
/** 文章目录项类型 */
declare type articleHeader = {
  type?: number
  id?: string
  left?: number
}

declare type articleContent = {
  objectId: string
  title: string
  content: string
  createdAt: string
  updatedAt: string
  tags?: tagItem[]
}
