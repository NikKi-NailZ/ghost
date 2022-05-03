package app

import (
	"embed"

	"go.uber.org/zap"
)

type (
	// App is the main application object.
	App struct {
		templates embed.FS

		logger *zap.SugaredLogger

		data Data
	}

	Data struct {
		Copyright string // TODO: add custom copyright
		AppName   string
	}
)

func New(appName string) *App {
	return &App{logger: zap.NewExample().Sugar(), data: Data{AppName: appName}}
}

func (a *App) WithTemplates(templates embed.FS) *App {
	a.templates = templates
	return a
}

func (a *App) Run() {
	a.generateTree()
	a.runCommands()
}
