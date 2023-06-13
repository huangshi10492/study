/** 标签项类型 */
declare type tagItem = {
  objectId: string
  name: string
}
/** 标签表单类型 */
declare type tagForm = {
  objectId: string
  name: string
  articles?: articleListItem[]
}
