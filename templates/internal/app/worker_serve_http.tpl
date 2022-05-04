{{if .Copyright}}
    {{.Copyright}}
{{end}}
package app

import (
	"context"
	"errors"
	"log"
	"net/http"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/recover"
	"github.com/gofiber/fiber/v2/middleware/requestid"
)

func serveHTTP(ctx context.Context, app *App) {
	router := fiber.New(fiber.Config{
		Prefork:      false,
		ReadTimeout:  app.config.Delivery.HTTPServer.ReadTimeout,
		WriteTimeout: app.config.Delivery.HTTPServer.WriteTimeout,
		Network:      fiber.NetworkTCP4,
		BodyLimit:    app.config.Delivery.HTTPServer.BodySizeLimitBytes,
		AppName:      app.meta.Info.AppName,
		// TODO: add ErrorHandler
	})

	router.Use(requestid.New())
	router.Use(recover.New())

	// TODO: add middleware for logging

	app.registerHTTPRoutes(router)

	// graceful shutdown listener.
	go func() {
		<-ctx.Done()

		if err := router.Shutdown(); err != nil {
			log.Println("🔵 http: server shutdown: %v", err) // TODO: add app logger``
		}
	}()

	// starting server
	ip := app.config.Delivery.HTTPServer.ListenAddress
	if err := router.Listen(ip); err != nil {
		if !errors.Is(err, http.ErrServerClosed) {
			log.Fatal("🔴 failed to start server: %v", err) // TODO: add app logger``
		}
	}
}
