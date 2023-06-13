import axios, { AxiosError } from 'axios'
import type { AxiosInstance, AxiosRequestConfig, AxiosResponse } from 'axios'
import { createDiscreteApi } from 'naive-ui'
import type { ConfigProviderProps } from 'naive-ui'
import router from '@/router'
const configProviderPropsRef = computed<ConfigProviderProps>(() => ({}))
const { message } = createDiscreteApi(['message'], {
  configProviderProps: configProviderPropsRef,
})

const { getToken, loginOut } = useAdminStore()
const webStore = useWebStore()
// 创建实例
const axiosInstance: AxiosInstance = axios.create({
  // 前缀
  baseURL: import.meta.env.VITE_API_URL + '/api',
  // 超时
  timeout: 1000 * 5,
  // 请求头
  headers: {
    'Content-Type': 'application/json',
  },
})

// 请求拦截器
axiosInstance.interceptors.request.use(
  (config: AxiosRequestConfig) => {
    // TODO 在这里可以加上想要在请求发送前处理的逻辑
    // TODO 比如 loading 等
    //webStore.isLoading = true
    return config
  },
  (error: AxiosError) => {
    return Promise.reject(error)
  }
)

// 响应拦截器
axiosInstance.interceptors.response.use(
  (response: AxiosResponse) => {
    webStore.isLoading = false
    if (response.status === 200) {
      return response.data
    }
    //ElMessage.info(JSON.stringify(response.status))
    return response
  },
  (error: AxiosError) => {
    webStore.isLoading = false
    const { response } = error
    if (error.code === 'ERR_NETWORK') {
      message.error('网络连接异常,请稍后再试!')
      return Promise.reject(error)
    }
    if (response) {
      if (response.status == 400) {
        message.error('登录过期或未登录')
        loginOut()
        router.push('/admin/login')
        return Promise.reject(response.data)
      }
      //message.error((response.data as any).message)
      return Promise.reject(response.data)
    }
    return Promise.reject(error)
  }
)
const service = {
  get(url: string, data?: object): Promise<any> {
    return axiosInstance.get(url, {
      params: data,
      headers: {
        Authorization: 'Bearer ' + getToken(),
      },
    })
  },

  post(url: string, data?: object): Promise<any> {
    return axiosInstance.post(url, data, {
      headers: {
        Authorization: 'Bearer ' + getToken(),
      },
    })
  },
  userpost(url: string, data?: object): Promise<any> {
    return axiosInstance.post(url, data, {
      headers: {
        Authorization: 'Bearer ' + useUserStore().token,
      },
    })
  },

  upload: (url: string, file: FormData) =>
    axiosInstance.post(url, file, {
      headers: {
        Authorization: 'Bearer ' + getToken(),
      },
    }),
}

export default service
