import { NIcon } from 'naive-ui'
import type { MenuOption } from 'naive-ui'
import { RouterLink } from 'vue-router'
import { Icon } from '@iconify/vue'

const renderIcon = (icon: string | undefined) => {
  return () => h(NIcon, null, { default: () => h(Icon, { icon }) })
}
const renderMenu = (menuItems: Array<menuItem> | undefined) => {
  const menuOptions: MenuOption[] = []
  if (menuItems != undefined) {
    menuItems.forEach((item: menuItem) => {
      let labelView
      if (item.path) {
        labelView = () =>
          h(
            RouterLink,
            {
              to: {
                path: item.path as string,
              },
            },
            () => item.label
          )
      } else {
        labelView = item.label
      }
      menuOptions.push({
        label: labelView,
        key: item.path || item.key,
        icon: renderIcon(item.icon),
        children: renderMenu(item.children),
      })
    })
    return menuOptions
  }
}
export default renderMenu
