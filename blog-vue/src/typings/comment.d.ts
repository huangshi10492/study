/** 评论类型 */
declare type comment = {
  createdAt: string
  objectId: string
  content: string
  owner: string
  replies?: reply[]
}
/** 评论api类型 */
declare type toComment = {
  content: string
  toArticleId: string
}
/** 回复类型 */
declare type reply = {
  createdAt: string
  objectId: string
  content: string
  owner: string
  replyer: string
}
/** 回复api类型 */
declare type toReply = {
  content: string
  toCommentId: string
  replyer: string
}
