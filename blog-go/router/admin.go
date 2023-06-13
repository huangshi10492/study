package router

import (
	"blog-go/controller"

	"github.com/labstack/echo/v4"
)

func adminRouter(admin *echo.Group) {
	admin.POST("/login", controller.AdminLogin)
	admin.Use(AdminJwt(), AdminAuth)
	admin.GET("/info", controller.GetAdminInfo)
	admin.POST("/upload/file", controller.UploadFile) // 文件上传
	article := admin.Group("/article")
	article.GET("/all", controller.GetArticleListAll)
	article.GET("/:articleId/edit", controller.GetArticleEdit)
	article.POST("/add", controller.AddArticle)
	article.POST("/edit", controller.EditArticle)
	article.POST("/delete", controller.DeleteArticle)
	article.POST("/change", controller.ChangePublish)
	tag := admin.Group("/tag")
	tag.POST("/add", controller.AddTag)
	tag.POST("/edit", controller.EditTag)
	tag.POST("/delete", controller.DeleteTag)
	comment := admin.Group("/comment")
	comment.POST("/deleteComment", controller.DeleteComment)
	comment.POST("/deleteReply", controller.DeleteReply)
	seting := admin.Group("/seting")
	seting.GET("/info", controller.GetInfo)
	seting.GET("/get", controller.GetSeting)
	seting.POST("/dbSet", controller.SetDBSeting)
	seting.POST("/managerSet", controller.SetManagerSeting)
}
