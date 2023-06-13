package controller

import (
	"blog-go/common"
	"blog-go/model"

	"github.com/go-playground/validator/v10"
	"github.com/labstack/echo/v4"
)

type UserPassword struct {
	Name     string `json:"name" validate:"required,max=10,min=3"`
	Password string `json:"password" validate:"required,max=24,min=6"`
}

//用户注册
func UserRegister(ctx echo.Context) error {
	requestData := UserPassword{}
	ctx.Bind(&requestData)
	validate := validator.New()
	err := validate.Struct(requestData)
	if err != nil {
		return ctx.JSON(ErrInput("输入参数错误"))
	}
	name := requestData.Name
	password := requestData.Password
	err = model.AddUser(name, password)
	if err != nil {
		return ctx.JSON(ErrServer("注册失败", err.Error()))
	}
	return ctx.JSON(Succ("注册成功"))
}

//用户登录
func UserLogin(ctx echo.Context) error {
	requestData := UserPassword{}
	ctx.Bind(&requestData)
	validate := validator.New()
	err := validate.Struct(requestData)
	if err != nil {
		return ctx.JSON(ErrInput("输入参数错误"))
	}
	name := requestData.Name
	password := requestData.Password
	ID := model.CheckName(name)
	if ID == "" {
		return ctx.JSON(Fail("用户不存在"))
	}
	if !model.CheckPassword(name, password) {
		return ctx.JSON(ErrInput("名称或密码错误"))
	}
	token, err := common.ReleaseUserToken(ID, name)
	if err != nil {
		return ctx.JSON(ErrServer("登录失败"))
	}
	mod := &model.UserInfo{
		ID:    ID,
		Name:  name,
		Token: token,
	}
	return ctx.JSON(Succ("登录成功", mod))
}

//获取用户信息
func UserInfo(ctx echo.Context) error {
	ID := ctx.Get("ID").(string)
	name := ctx.Get("name").(string)
	mod := &model.UserInfo{
		ID:   ID,
		Name: name,
	}
	return ctx.JSON(Succ("获取成功", mod))
}
