/** 总设置类型 */
declare type seting = {
  db: db
  manager: manager
}
/** 数据库设置类型 */
declare type db = {
  dbname: string
  dbType: string
  host: string
  password: string
  port: number
  user: string
}
/** 管理员信息设置类型 */
declare type manager = {
  name: string
  password: string
}
