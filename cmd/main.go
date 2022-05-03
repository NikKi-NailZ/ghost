package main

import (
	"embed"
	"os"

	app "ghost/internal"
)

//go:embed templates/*
var templates embed.FS

func main() {
	app.New(os.Args[1]).WithTemplates(templates).Run()
}
