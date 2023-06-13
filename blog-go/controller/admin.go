package controller

import (
	"blog-go/common"
	"blog-go/conf"
	"blog-go/model"

	"github.com/go-playground/validator/v10"
	"github.com/jinzhu/copier"
	"github.com/labstack/echo/v4"
)

//用户登录
func AdminLogin(ctx echo.Context) error {
	requestData := UserPassword{}
	ctx.Bind(&requestData)
	validate := validator.New()
	err := validate.Struct(requestData)
	if err != nil {
		return ctx.JSON(ErrInput("输入格式错误"))
	}
	name := requestData.Name
	password := requestData.Password
	if name != conf.Conf.Manager.Name || password != conf.Conf.Manager.Password {
		return ctx.JSON(ErrInput("名称或密码错误"))
	}
	token, err := common.ReleaseAdminToken(name)
	if err != nil {
		return ctx.JSON(ErrServer("登录失败"))
	}
	reponseData := model.UserInfo{
		Name:  name,
		Token: token,
	}
	return ctx.JSON(Succ("登录成功", reponseData))
}

func GetAdminInfo(ctx echo.Context) error {
	return ctx.JSON(Succ("获取成功"))
}

func GetSeting(ctx echo.Context) error {
	responseData := conf.Conf
	responseData.Manager = conf.Manager{Name: "", Password: ""}
	return ctx.JSON(Succ("获取成功", responseData))
}

func SetDBSeting(ctx echo.Context) error {
	requestData := conf.DB{}
	ctx.Bind(&requestData)
	validate := validator.New()
	err := validate.Struct(requestData)
	if err != nil {
		return ctx.JSON(ErrInput("输入格式错误"))
	}
	err = copier.Copy(&conf.Conf.DB, &requestData)
	if err != nil {
		return ctx.JSON(ErrServer("设置失败"))
	}
	if conf.SaveConfig() {
		return ctx.JSON(Succ("设置成功"))
	} else {
		return ctx.JSON(ErrServer("设置失败"))
	}
}

func SetManagerSeting(ctx echo.Context) error {
	requestData := conf.Manager{}
	ctx.Bind(&requestData)
	validate := validator.New()
	err := validate.Struct(requestData)
	if err != nil {
		return ctx.JSON(ErrInput("输入格式错误"))
	}
	err = copier.Copy(&conf.Conf.Manager, &requestData)
	if err != nil {
		return ctx.JSON(ErrServer("设置失败"))
	}
	if conf.SaveConfig() {
		return ctx.JSON(Succ("设置成功"))
	} else {
		return ctx.JSON(ErrServer("设置失败"))
	}
}

func GetInfo(ctx echo.Context) error {
	return ctx.JSON(Succ("获取成功", conf.GetInfo()))
}
