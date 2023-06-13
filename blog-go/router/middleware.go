package router

import (
	"blog-go/common"
	"blog-go/conf"
	"blog-go/controller"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func UserJwt() echo.MiddlewareFunc {
	config := middleware.JWTConfig{
		Claims:     &common.UserClaims{},
		SigningKey: common.UserJwtKey,
		ContextKey: "user",
	}
	return middleware.JWTWithConfig(config)
}

func UserAuth(next echo.HandlerFunc) echo.HandlerFunc {
	return func(ctx echo.Context) error {
		ID, name := common.GetUserTokenInfo(ctx)
		ctx.Set("ID", ID)
		ctx.Set("name", name)
		return next(ctx)
	}
}

func AdminJwt() echo.MiddlewareFunc {
	config := middleware.JWTConfig{
		Claims:     &common.AdminClaims{},
		SigningKey: common.AdminJwtKey,
		ContextKey: "admin",
	}
	return middleware.JWTWithConfig(config)
}

func AdminAuth(next echo.HandlerFunc) echo.HandlerFunc {
	return func(ctx echo.Context) error {
		name := common.GetAdminTokenInfo(ctx)
		if name != conf.Conf.Manager.Name {
			return ctx.JSON(controller.ErrToken("token不存在"))
		}
		return next(ctx)
	}
}

func CORS() echo.MiddlewareFunc {
	return middleware.CORS()
}

func Log() echo.MiddlewareFunc {
	return middleware.LoggerWithConfig(middleware.LoggerConfig{
		Format: "method=${method}, uri=${uri}, status=${status}\n",
	})
}
