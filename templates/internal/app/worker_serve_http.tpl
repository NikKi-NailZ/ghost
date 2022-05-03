package app

import (
	"context"
	"errors"
	"net/http"

	mwLogger "git.ooo.ua/vipcoin/lib/http/middleware/logger"
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
			app.logger.Info("🔵 http: server shutdown: %v", err)
		}
	}()

	// starting server
	ip := app.config.Delivery.HTTPServer.ListenAddress
	if err := router.Listen(ip); err != nil {
		if !errors.Is(err, http.ErrServerClosed) {
			app.logger.Fatalf("🔴 failed to start server: %v", err)
		}
	}
}
