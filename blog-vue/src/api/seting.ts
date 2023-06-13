import service from '@/utils/request'

//管理鉴权
/** 获取系统信息 */
export const systemInfo = () => service.get('/admin/seting/info')
/** 获取设置 */
export const getSeting = () => service.get('/admin/seting/get')
/** 设置数据库 */
export const setDBSeting = (data: db) => service.post('/admin/seting/dbSet', data)
/** 设置管理员信息 */
export const setManagerSeting = (data: manager) => service.post('/admin/seting/managerSet', data)
