{{if .Copyright}}
    {{.Copyright}}
{{end}}
package app

import (
	"github.com/gofiber/fiber/v2"
)

func (a *App) registerHTTPRoutes(app *fiber.App) {
	router := app.Group("/v4/star-exchanger")
	router.Get("/status", a.statusHTTPHandler.CheckStatus)
}
