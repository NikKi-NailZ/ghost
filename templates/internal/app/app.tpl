{{if .Copyright}}
    {{.Copyright}}
{{end}}
package app

import (
	"context"
	"embed"

	"{{.AppName}}/internal/config"
	"{{.AppName}}/internal/api/delivery"
)

type (
   	// Meta defines meta for application.
	Meta struct {
		Info       Info
		ConfigPath string
	}

	// Info defines metadata of application.
	Info struct {
		AppName      string
		Tag          string
		BuildVersion string
		BuildCommit  string
		BuildDate    string
		BuildCookie  string
	}

	// App defines main application struct.
	App struct {
		// meta information about application.
		meta Meta

		// tech dependencies
		config *config.Config

		dbMigrationsFS embed.FS

		// Repository dependencies.

		// services

		// Delivery dependencies.
		statusHTTPHandler delivery.StatusHTTP

		// Scheduler dependencies.
	}

	worker func(ctx context.Context, a *App)
)

// New - app constructor without init for components.
func New(meta Meta) *App {
	return &App{
		meta: meta,
	}
}

// WithMigrationFS is a setup for database migration filesystem
func (a *App) WithMigrationFS(f embed.FS) *App {
	a.dbMigrationsFS = f
	return a
}

// Run – registers graceful shutdown.
// populate configuration and application dependencies,
// run workers.
func (a *App) Run(ctx context.Context) {
	// Domain registration
	a.registerRepositories()
	a.registerServices()

	// Register Handlers
	a.registerHTTPHandlers()

	// Run Workers
	a.runWorkers(ctx)
}
