import service from '@/utils/request'

//无鉴权
/** 获取标签列表 */
export const tagList = () => service.get('/tag/get')
/** 获取标签信息 */
export const tagInfo = (tagId: string) => service.get('/tag/info', { tagId })

//管理鉴权
/** 添加标签 */
export const addTag = (name: string) => service.post('/admin/tag/add', { name })
/** 编辑标签 */
export const editTag = (data: tagForm) => service.post('/admin/tag/edit', data)
/** 删除标签 */
export const deleteTag = (tagId: string) => service.post('/admin/tag/delete', { tagId })
