{{if .Copyright}}
    {{.Copyright}}
{{end}}
package app

import (
	"context"
	"log"
)

// InitWorkers ...
func (a *App) initWorkers() []worker {
	workers := []worker{
		serveHTTP,
	}

	if a.config.DevMode {
		workers = append(
			workers,
			func(ctx context.Context, a *App) {
				log.Println("Welcome into DevMode Environment") // TODO: change on app logger
			},
		)
	}

	return workers
}
