package main

import (
	"embed"
	"flag"
	"os"

	app "github.com/NikKi-NailZ/ghost/internal"
	"github.com/NikKi-NailZ/ghost/internal/config"
)

//go:embed templates/*
var templates embed.FS

func main() {
	configPath := flag.String("c", config.DefaultConfig, "path to config file")
	flag.Parse()

	app.New(os.Args, *configPath).WithTemplates(templates).Run()
}
