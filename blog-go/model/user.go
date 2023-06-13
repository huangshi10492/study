package model

import (
	"time"

	"gorm.io/gorm"
)

//用户数据结构
type User struct {
	CreatedAt time.Time      `json:"-"`
	UpdatedAt time.Time      `json:"-"`
	DeletedAt gorm.DeletedAt `json:"-" gorm:"index"`
	ID        string         `json:"objectId,omitempty" gorm:"primaryKey;"`
	Name      string         `json:"name"`
	Password  string         `json:"-"`
}

//用户信息数据结构
type UserInfo struct {
	ID    string `json:"objectId"`
	Name  string `json:"name"`
	Token string `json:"token,omitempty"`
}

//添加用户
func AddUser(name string, password string) error {
	db := getDB()
	mod := &User{
		ID:       getId(),
		Name:     name,
		Password: password,
	}
	err := db.Create(mod).Error
	return err
}

//检查姓名是否存在
func CheckName(name string) string {
	db := getDB()
	mod := &User{
		Name: name,
	}
	db.Where("name=?", name).First(mod)
	return mod.ID
}

//验证密码是否正确
func CheckPassword(name string, password string) bool {
	db := getDB()
	mod := &User{
		Name: name,
	}
	db.Where("name=?", name).First(mod)
	return password == mod.Password
}

//验证用户id是否存在
func CheckUserID(ID string) error {
	db := getDB()
	mod := &User{
		ID: ID,
	}
	err := db.First(mod, "id=?", ID).Error
	return err
}
