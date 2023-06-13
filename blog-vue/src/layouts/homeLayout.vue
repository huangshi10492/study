<template>
  <n-layout>
    <div min-h-screen flex flex-col>
      <n-layout-header><HomeHeader /></n-layout-header>
      <n-layout-content embedded content-style="padding: 12px;" border-b bc-eee>
        <router-view />
      </n-layout-content>
      <n-layout-footer mt-auto><HomeFooter /></n-layout-footer>
    </div>
  </n-layout>
  <n-back-top :right="40" />
</template>
<script setup lang="ts"></script>
