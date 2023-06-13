import { defineStore } from 'pinia'

const { width } = useWindowSize()

export const useAdminStore = defineStore('admin', {
  state() {
    const token = useStorage('adminToken', '')
    return {
      collapsed: width.value < 700 ? true : false,
      smallWidth: width.value < 300 ? true : false,
      isLogin: false,
      token,
    }
  },
  actions: {
    switchCollapsed() {
      this.collapsed = !this.collapsed
    },
    loginOut() {
      this.token = ''
      this.isLogin = false
    },
    getToken() {
      return this.token
    },
  },
})

export const useUserStore = defineStore('user', {
  state() {
    const token = useStorage('userToken', '')
    return {
      token,
      isLogin: false,
    }
  },
  actions: {
    loginOut() {
      this.token = ''
      this.isLogin = false
    },
    getToken() {
      return this.token
    },
  },
})
export const useWebStore = defineStore('web', {
  state() {
    return {
      isLoading: false,
      info: { runEnv: '', confFile: true },
      name: 'blog-go',
    }
  },
})
