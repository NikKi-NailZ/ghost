package main

import (
	"embed"

	app "ghost/internal"
)

//go:embed templates/*
var templates embed.FS

func main() {
	app.New("test_workspace/test_app").WithTemplates(templates).Run()
}
