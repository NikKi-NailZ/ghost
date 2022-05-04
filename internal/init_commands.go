package app

func initCommands(app *App) {
	app.commands["new"] = generateTree
	app.commands["help"] = help
	app.commands["error"] = toManyArguments
}
