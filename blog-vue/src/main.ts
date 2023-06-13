import { createApp } from 'vue'
import router from './router'
import { createPinia } from 'pinia'
import App from './App.vue'
import 'uno.css'
import { createHead } from '@vueuse/head'

const app = createApp(App)
const pinia = createPinia()
const head = createHead()

app.use(pinia).use(router).use(head).mount('#app')
