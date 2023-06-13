import service from '@/utils/request'

//无鉴权
/** 管理员登录 */
export const adminLogin = (data: loginForm) => service.post('/admin/login', data)
/** 用户登录 */
export const userLogin = (data: loginForm) => service.userpost('/login', data)
/** 用户注册 */
export const userRegister = (data: loginForm) => service.userpost('/register', data)

//用户鉴权
/** 获取用户信息 */
export const userInfo = () => service.userpost('/user/info')

//管理鉴权
/** 获取管理员信息 */
export const adminInfo = () => service.get('/admin/info')
/** 上传文件 */
export const uploadFile = (formData: FormData) => service.upload('/admin/upload/file', formData)
