package app

const helpMSG = "Usage: ghost [command] [argument]\n\n" // TODO: add beauty help
const errorToManyArguments = "Error: too many arguments\n" + helpMSG
const needToInit = "config not found need to init run ghost init"

func help(app *App) {
	app.logger.Info(helpMSG)
}

func toManyArguments(app *App) {
	app.logger.Info(errorToManyArguments)
}

func needInit(app *App) {
	app.logger.Info(needToInit)
}
