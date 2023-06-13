import service from '@/utils/request'

//无鉴权
/** 获取文章列表 */
export const articleList = (page: number) => service.get('/article', { page })
/** 获取文章内容 */
export const articleContent = (articleId: string) => service.get('/article/' + articleId)

//管理鉴权
/** 获取所有文章 */
export const articleListAll = () => service.get('/admin/article/all')
/** 获取文章可编辑内容 */
export const articleEdit = (articleId: string) => service.get('/admin/article/' + articleId + '/edit')
/** 添加文章 */
export const addArticle = (data: articleForm) => service.post('/admin/article/add', data)
/** 编辑文章 */
export const editArticle = (data: articleForm) => service.post('/admin/article/edit', data)
/** 删除文章 */
export const deleteArticle = (articleId: string) => service.post('/admin/article/delete', { articleId })
/** 更改发布状态 */
export const changePublish = (articleId: string, isPublish: boolean) =>
  service.post('/admin/article/change', { articleId, isPublish })
