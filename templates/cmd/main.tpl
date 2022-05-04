{{if .Copyright}}
    {{.Copyright}}
{{end}}
package main

import (
	"context"
	"embed"
	"flag"
	"os"
	"os/signal"
	"syscall"


    "{{.AppName}}/internal/app"
    "{{.AppName}}/internal/config"

    // TODO: make things good with database
)

var (
	appName       = "{{.AppName}}"
	version       string
	commit        string
	tag           string
	date          string
	fortuneCookie string
)

//go:embed dbschema/migrations
var dbMigrationFS embed.FS

func main() {
	cfgPath := flag.String("c", config.DefaultPath, "configuration file")
	flag.Parse()

	app.New(
		app.Meta{
			Info: app.Info{
				AppName:      appName,
				Tag:          tag,
				BuildVersion: version,
				BuildCommit:  commit,
				BuildDate:    date,
				BuildCookie:  fortuneCookie,
			},
			ConfigPath: *cfgPath,
		},
	).WithMigrationFS(dbMigrationFS).Run(registerGracefulHandle())
}

func registerGracefulHandle() context.Context {
	ctx, cancel := context.WithCancel(context.Background())

	c := make(chan os.Signal, 1)
	signal.Notify(c, syscall.SIGHUP, os.Interrupt, syscall.SIGTERM)

	go func() {
		<-c
		cancel()
	}()

	return ctx
}
