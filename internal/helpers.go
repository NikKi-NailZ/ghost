package app

func mergeDataFromConfig(app *App) {
	app.data.Copyright = app.config.Copyright
}