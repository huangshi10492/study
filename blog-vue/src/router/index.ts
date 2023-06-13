import { createRouter, createWebHistory } from 'vue-router'
import { setupLayouts } from 'virtual:generated-layouts'
import generatedRoutes from 'virtual:generated-pages'
import { computed, ref } from 'vue'
import { createDiscreteApi, darkTheme, lightTheme } from 'naive-ui'
import type { ConfigProviderProps } from 'naive-ui'

let adminStore: any = undefined
const themeRef = ref<'light' | 'dark'>('light')
const configProviderPropsRef = computed<ConfigProviderProps>(() => ({
  theme: themeRef.value === 'light' ? lightTheme : darkTheme,
}))
const { loadingBar } = createDiscreteApi(['loadingBar'], {
  configProviderProps: configProviderPropsRef,
})

const routes = setupLayouts(generatedRoutes)
const router = createRouter({
  history: createWebHistory('/'),
  routes,
})
router.beforeEach((to, from, next) => {
  loadingBar.start()
  if (!adminStore) {
    adminStore = useAdminStore()
  }
  if (to.meta.admin) {
    if (!adminStore.isLogin && !adminStore.token) {
      next({ path: '/admin/login' })
      return
    }
  }
  next()
})
router.afterEach(() => {
  loadingBar.finish()
})
router.onError(() => {
  loadingBar.error()
})
export default router
