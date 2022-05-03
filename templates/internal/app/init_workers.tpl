package app

import "context"

// InitWorkers ...
func (a *App) initWorkers() []worker {
	workers := []worker{
		serveHTTP,
	}

	if a.config.DevMode {
		workers = append(
			workers,
			func(ctx context.Context, a *App) {
				a.logger.Info("Welcome into DevMode Environment")
			},
		)
	}

	return workers
}
