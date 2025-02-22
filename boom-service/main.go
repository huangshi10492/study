package main

import (
	"boom-service/internal/config"
	"boom-service/internal/services"
	"encoding/json"
	"fmt"
	"github.com/gofiber/contrib/websocket"
	"github.com/gofiber/fiber/v2"
)

func main() {
	app := fiber.New()
	webSocketService := services.NewWebSocketService()
	conf := config.NewConfig("./config.yaml")

	_, err := services.NewTurnService(conf.Turn)
	if err != nil {
		panic(err)
	}
	app.Use("/register", func(c *fiber.Ctx) error {
		if websocket.IsWebSocketUpgrade(c) {
			return c.Next()
		}
		return fiber.ErrUpgradeRequired
	})
	app.Get("/register", websocket.New(func(c *websocket.Conn) {
		webSocketService.NewClient(c, c.Query("id"))
	}))
	app.Get("/info", func(ctx *fiber.Ctx) error {
		resp, err := json.Marshal(map[string]string{
			"type": "云端服务",
			"ip":   conf.Turn.PublicIP,
			"port": fmt.Sprintf("%d", conf.Web.Port),
		})
		if err != nil {
			return fiber.ErrServiceUnavailable
		}
		return ctx.Send(resp)
	})
	app.Static("/", "./web")

	err = app.Listen(fmt.Sprintf(":%d", conf.Web.Port))
	if err != nil {
		panic(err)
		return
	}
}
