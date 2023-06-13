package controller

import (
	"blog-go/model"

	"github.com/go-playground/validator/v10"
	"github.com/labstack/echo/v4"
)

func AddComment(ctx echo.Context) error {
	requestData := &model.Comment{}
	err := ctx.Bind(requestData)
	if err != nil {
		return ctx.JSON(ErrServer("添加失败", err))
	}
	requestData.Owner = ctx.Get("name").(string)
	validate := validator.New()
	err = validate.Struct(requestData)
	if err != nil {
		return ctx.JSON(ErrInput("输入参数错误"))
	}
	err = model.AddComment(requestData)
	if err != nil {
		return ctx.JSON(ErrServer("添加失败", err.Error()))
	}
	return ctx.JSON(Succ("添加成功"))
}

func ReplyComment(ctx echo.Context) error {
	requestData := &model.Reply{}
	err := ctx.Bind(requestData)
	if err != nil {
		return ctx.JSON(ErrServer("添加失败", err.Error()))
	}
	requestData.Owner = ctx.Get("name").(string)
	validate := validator.New()
	err = validate.Struct(requestData)
	if err != nil {
		return ctx.JSON(ErrInput("输入参数错误"))
	}
	err = model.ReplyComment(requestData)
	if err != nil {
		return ctx.JSON(ErrServer("回复失败", err.Error()))
	}
	return ctx.JSON(Succ("回复成功"))
}

func DeleteComment(ctx echo.Context) error {
	type DelId struct {
		ID string `json:"commentId"`
	}
	requestData := &DelId{}
	err := ctx.Bind(requestData)
	if err != nil || requestData.ID == "" {
		return ctx.JSON(ErrInput("参数错误"))
	}
	err = model.DeleteComment(requestData.ID)
	if err != nil {
		return ctx.JSON(ErrServer("删除失败"))
	}
	model.ArticleCount--
	return ctx.JSON(Succ("删除成功"))
}

func DeleteReply(ctx echo.Context) error {
	type DelId struct {
		ID string `json:"commentId"`
	}
	requestData := &DelId{}
	err := ctx.Bind(requestData)
	if err != nil || requestData.ID == "" {
		return ctx.JSON(ErrInput("参数错误"))
	}
	err = model.DeleteReply(requestData.ID)
	if err != nil {
		return ctx.JSON(ErrServer("删除失败"))
	}
	model.ArticleCount--
	return ctx.JSON(Succ("删除成功"))
}
