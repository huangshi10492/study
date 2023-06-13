package controller

import (
	"blog-go/model"
	"strconv"

	"github.com/go-playground/validator/v10"
	"github.com/labstack/echo/v4"
)

func GetArticleList(ctx echo.Context) error {
	page, err := strconv.Atoi(ctx.QueryParam("page"))
	if err != nil {
		return ctx.JSON(ErrInput("参数错误"))
	}
	if page > ((model.ArticleCount-1)/10)+1 {
		return ctx.JSON(Fail("没有更多文章了", nil))
	}
	list, err := model.GetArticleList(page)
	if err != nil {
		return ctx.JSON(ErrServer("获取失败"))
	}
	return ctx.JSON(CountSucc("获取成功", list, ((model.ArticleCount-1)/2)+1))
}

func GetArticleListAll(ctx echo.Context) error {
	list, err := model.GetArticleListAll()
	if err != nil {
		return ctx.JSON(ErrServer("获取失败"))
	}
	return ctx.JSON(Succ("获取成功", list))
}

func GetArticleContent(ctx echo.Context) error {
	articleId := ctx.Param("articleId")
	mod, err := model.GetArticleContent(articleId)
	if err != nil {
		return ctx.JSON(ErrServer("获取失败", err.Error()))
	}
	return ctx.JSON(Succ("获取成功", mod))
}

func GetArticleEdit(ctx echo.Context) error {
	articleId := ctx.Param("articleId")
	mod, err := model.GetArticleEdit(articleId)
	if err != nil {
		return ctx.JSON(ErrServer("获取失败"))
	}
	return ctx.JSON(Succ("获取成功", mod))
}

func AddArticle(ctx echo.Context) error {
	requestData := &model.ArticleEdit{}
	err := ctx.Bind(requestData)
	if err != nil {
		return ctx.JSON(ErrServer("添加失败", err.Error()))
	}
	validate := validator.New()
	err = validate.Struct(requestData)
	if err != nil {
		return ctx.JSON(ErrInput("输入参数错误"))
	}
	err = model.AddArticle(requestData)
	if err != nil {
		return ctx.JSON(ErrServer("添加失败", err.Error()))
	}
	model.ArticleCount++
	return ctx.JSON(Succ("添加成功"))
}

func EditArticle(ctx echo.Context) error {
	requestData := &model.ArticleEdit{}
	err := ctx.Bind(requestData)
	if err != nil {
		return ctx.JSON(ErrServer("修改失败", err.Error()))
	}
	validate := validator.New()
	err = validate.Struct(requestData)
	if err != nil || requestData.ID == "" {
		return ctx.JSON(ErrInput("输入参数错误"))
	}
	err = model.EditArticle(requestData)
	if err != nil {
		return ctx.JSON(ErrServer("修改失败", err.Error()))
	}
	return ctx.JSON(Succ("修改成功"))
}

func DeleteArticle(ctx echo.Context) error {
	type DelId struct {
		ArticleId string `json:"articleId"`
	}
	requestData := &DelId{}
	err := ctx.Bind(requestData)
	if err != nil || requestData.ArticleId == "" {
		return ctx.JSON(ErrInput("参数错误"))
	}
	err = model.DeleteArticle(requestData.ArticleId)
	if err != nil {
		return ctx.JSON(ErrServer("删除失败"))
	}
	model.ArticleCount--
	return ctx.JSON(Succ("删除成功"))
}

func ChangePublish(ctx echo.Context) error {
	type Change struct {
		ArticleId string `json:"articleId"`
		IsPublish bool   `json:"isPublish"`
	}
	requestData := &Change{}
	err := ctx.Bind(requestData)
	if err != nil || requestData.ArticleId == "" {
		return ctx.JSON(ErrInput("参数错误"))
	}
	err = model.ChangePublish(requestData.ArticleId, requestData.IsPublish)
	if err != nil {
		return ctx.JSON(ErrServer("切换失败", err))
	}
	return ctx.JSON(Succ("切换成功"))
}
