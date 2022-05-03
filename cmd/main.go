package main

import (
	"embed"
	"os"

	app "github.com/NikKi-NailZ/ghost/internal"
)

//go:embed templates/*
var templates embed.FS

func main() {
	app.New(os.Args[1]).WithTemplates(templates).Run()
}
