const webStore = useWebStore()
export const title = (name: string) => {
  useHead({
    title: computed(() => name + ' | ' + webStore.name),
  })
}
