package app

import "github.com/NikKi-NailZ/ghost/internal/config"

func populateConfig(app *App) {
	cfg, err := config.New(app.meta.configPath)
	if err != nil {
		app.logger.Fatal(err)
	}

	app.config = cfg
}
