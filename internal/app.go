package app

import (
	"embed"

	"go.uber.org/zap"

	"github.com/NikKi-NailZ/ghost/internal/config"
)

type (
	// App is the main application object.
	App struct {
		templates embed.FS

		logger *zap.SugaredLogger

		data Data

		commands map[string]func(*App)
		command  command

		meta meta

		config *config.Config
	}

	meta struct {
		configPath string
	}

	command struct {
		name     string
		argument string
	}

	Data struct {
		AppName   string
		Copyright string
	}
)

func New(arguments []string, configPath string) *App {
	var command command
	switch len(arguments) {
	case 1:
		command.name = "help"
	case 2:
		command.name = arguments[1]
	case 3:
		command.name = arguments[1]
		command.argument = arguments[2]
	default:
		command.name = "error"
	}
	return &App{
		logger:  zap.NewExample().Sugar(),
		command: command,
		meta: meta{
			configPath: configPath,
		},
		commands: make(map[string]func(*App)),
	}
}

func (a *App) WithTemplates(templates embed.FS) *App {
	a.templates = templates
	return a
}

func (a *App) Run() {
	initCommands(a)
	populateConfig(a)
	mergeDataFromConfig(a)

	switch a.command.name {
	case "new":
		a.data.AppName = a.command.argument
	}

	if cmd, exists := a.commands[a.command.name]; exists {
		cmd(a)
	} else {
		a.logger.Errorf("Command %s not found", a.command.name)
	}
}
