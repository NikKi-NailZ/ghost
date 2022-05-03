package app

import (
	"{{.AppName}}/internal/api/delivery/http/status"
)

func (a *App) registerHTTPHandlers() {
	a.statusHTTPHandler = status.NewHandler(
		a.meta.Info.AppName,
		a.meta.Info.Tag,
		a.meta.Info.BuildVersion,
		a.meta.Info.BuildCommit,
		a.meta.Info.BuildDate,
		a.meta.Info.BuildCookie,
	)

}
