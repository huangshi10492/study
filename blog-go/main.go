package main

import (
	"blog-go/model"
	"blog-go/router"

	"github.com/labstack/echo/v4"
)

func main() {
	model.InitNum()
	e := echo.New()
	e = router.CollectRoute(e)
	e.Logger.Fatal(e.Start(":1323"))
}
