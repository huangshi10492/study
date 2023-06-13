package controller

import (
	"blog-go/model"

	"github.com/go-playground/validator/v10"
	"github.com/labstack/echo/v4"
)

func AddTag(ctx echo.Context) error {
	type TagName struct {
		Name string `json:"name" validate:"required,max=10"`
	}
	requestData := &TagName{}
	ctx.Bind(&requestData)
	validate := validator.New()
	err := validate.Struct(requestData)
	if err != nil {
		return ctx.JSON(ErrInput("输入参数错误"))
	}
	mod, err := model.AddTag(requestData.Name)
	if err != nil {
		return ctx.JSON(ErrServer("添加失败", err.Error()))
	}
	return ctx.JSON(Succ("添加成功", mod))
}
func GetTags(ctx echo.Context) error {
	mods, err := model.GetTags()
	if err != nil {
		return ctx.JSON(ErrServer("获取失败"))
	}
	return ctx.JSON(Succ("获取成功", mods))
}
func GetTagInfo(ctx echo.Context) error {
	tagId := ctx.QueryParam("tagId")
	if tagId == "" {
		return ctx.JSON(ErrInput("参数错误"))
	}
	mods, err := model.GetTagInfo(tagId)
	if err != nil {
		return ctx.JSON(ErrServer("获取失败"))
	}
	return ctx.JSON(Succ("获取成功", mods))
}

func EditTag(ctx echo.Context) error {
	requestData := &model.Tag{}
	ctx.Bind(&requestData)
	validate := validator.New()
	err := validate.Struct(requestData)
	if err != nil {
		return ctx.JSON(ErrInput("输入参数错误"))
	}
	err = model.EditTag(requestData)
	if err != nil {
		return ctx.JSON(ErrServer("修改失败"))
	}
	return ctx.JSON(Succ("修改成功"))
}

func DeleteTag(ctx echo.Context) error {
	type Tag struct {
		TagId string `json:"tagId"`
	}
	requestData := &Tag{}
	ctx.Bind(&requestData)
	if requestData.TagId == "" {
		return ctx.JSON(ErrInput("参数错误"))
	}
	err := model.DeleteTag(requestData.TagId)
	if err != nil {
		return ctx.JSON(ErrServer("删除失败"))
	}
	return ctx.JSON(Succ("删除成功"))
}
