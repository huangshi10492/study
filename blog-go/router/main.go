package router

import (
	"blog-go/controller"

	"github.com/labstack/echo/v4"
)

func CollectRoute(echo *echo.Echo) *echo.Echo {
	echo.Use(CORS(), Log())
	echo.Static("/static", "static") // 静态目录
	api := echo.Group("/api")
	api.POST("/register", controller.UserRegister)
	api.POST("/login", controller.UserLogin)
	user := api.Group("/user")
	user.Use(UserJwt(), UserAuth)
	user.POST("/info", controller.UserInfo)
	user.POST("/addComment", controller.AddComment)
	user.POST("/replyComment", controller.ReplyComment)

	article := api.Group("/article")
	article.GET("", controller.GetArticleList)
	article.GET("/:articleId", controller.GetArticleContent)

	tag := api.Group("/tag")
	tag.GET("/get", controller.GetTags)
	tag.GET("/info", controller.GetTagInfo)

	admin := api.Group("/admin")
	adminRouter(admin)

	return echo
}
