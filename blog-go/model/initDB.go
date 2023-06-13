package model

import (
	"blog-go/conf"
	"fmt"

	"github.com/glebarez/sqlite"
	"gorm.io/driver/mysql"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

//定义全局的db对象，我们执行数据库操作主要通过他实现。
var _db *gorm.DB

//包初始化函数，golang特性，每个包初始化的时候会自动执行init函数，这里用来初始化gorm。
func init() {
	// 声明err变量，下面不能使用:=赋值运算符，否则_db变量会当成局部变量，导致外部无法访问_db变量
	var err error
	switch conf.Conf.DB.DBType {
	case "pgsql":
		{
			dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%d sslmode=disable TimeZone=Asia/Shanghai statement_timeout=500",
				conf.Conf.DB.Host, conf.Conf.DB.User, conf.Conf.DB.Password, conf.Conf.DB.Dbname, conf.Conf.DB.Port)
			//连接MYSQL, 获得DB类型实例，用于后面的数据库读写操作。
			_db, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
			break
		}
	case "mysql":
		{
			dsn := fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?tls=true&charset=utf8mb4&parseTime=True&loc=Local",
				conf.Conf.DB.User, conf.Conf.DB.Password, conf.Conf.DB.Host, conf.Conf.DB.Port, conf.Conf.DB.Dbname)
			_db, err = gorm.Open(mysql.Open(dsn), &gorm.Config{})
			break
		}
	case "sqlite":
		{
			_db, err = gorm.Open(sqlite.Open("gorm.db"), &gorm.Config{})
			break
		}
	default:
		{
			panic("连接数据库失败,未设置数据库类型")
		}
	}
	if err != nil {
		panic("连接数据库失败, error=" + err.Error())
	}

	sqlDB, _ := _db.DB()
	//设置数据库连接池参数
	sqlDB.SetMaxOpenConns(4)  //设置数据库连接池最大连接数
	sqlDB.SetMaxIdleConns(10) //连接池最大允许的空闲连接数，如果没有sql任务需要执行的连接数大于20，超过的连接会被连接池关闭。

	_db.AutoMigrate(&Tag{}, &Article{}, &User{}, &Comment{}, &Reply{})
}

//获取gorm db对象，其他包需要执行数据库查询的时候，只要通过tools.getDB()获取db对象即可。
//不用担心协程并发使用同样的db对象会共用同一个连接，db对象在调用他的方法的时候会从数据库连接池中获取新的连接
func getDB() *gorm.DB {
	return _db
}
