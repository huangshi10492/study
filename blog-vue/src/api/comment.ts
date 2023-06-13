import service from '@/utils/request'

//用户鉴权
/** 添加评论 */
export const addComment = (data: toComment) => service.userpost('/user/addComment', data)
/** 回复评论 */
export const replyComment = (data: toReply) => service.userpost('/user/replyComment', data)

//管理鉴权
/** 删除评论 */
export const deleteComment = (commentId: string) => service.post('/admin/comment/deleteComment', { commentId })
/** 删除回复 */
export const deleteReply = (commentId: string) => service.post('/admin/comment/deleteReply', { commentId })
