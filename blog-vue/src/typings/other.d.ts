/** 菜单项类型 */
declare type menuItem = {
  label: string
  path?: string
  key?: string
  icon?: string
  children?: Array<menuItem>
}
/** 登录表单类型 */
declare type loginForm = {
  name: string
  password: string
  passwordAgain?: string
}
