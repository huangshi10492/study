<template>
  <n-layout has-sider>
    <n-layout-sider
      :width="220"
      bordered
      collapse-mode="width"
      :collapsed-width="width > 500 ? 64 : 0"
      :collapsed="adminStore.collapsed">
      <AdminMenu />
    </n-layout-sider>
    <n-layout>
      <div min-h-screen flex flex-col>
        <n-layout-header border-b bc-eee>
          <AdminHeader />
        </n-layout-header>
        <n-layout-content content-style="padding: 24px;">
          <router-view v-slot="{ Component, route }">
            <Transition name="fade-slide" mode="out-in" appear>
              <div :key="route.fullPath">
                <component :is="Component" />
              </div>
            </Transition>
          </router-view>
        </n-layout-content>
      </div>
    </n-layout>
  </n-layout>
  <n-back-top :right="40" />
</template>
<script setup lang="ts">
const adminStore = useAdminStore()
const { width } = useWindowSize()
</script>
