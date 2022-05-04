package config

import (
	"os"
	"os/user"
	"strings"

	"gopkg.in/yaml.v3"
)

const DefaultConfig = "~/ghost/config.yaml"

type (
	// Config is the configuration for the application.
	Config struct {
		Copyright string `yang:"copyright"` // Add copyright to your service.
	}
)

func New(path string) (*Config, error) {
	var config Config

	if strings.HasPrefix(path, "~") {
		current, _ := user.Current()
		homeDir := current.HomeDir
		path = strings.Replace(path, "~", homeDir, 1)
	}

	if err := load(path, &config); err != nil {
		return nil, err
	}
	return &config, nil
}

func load(path string, cfg *Config) error {
	data, err := os.ReadFile(path)
	if err != nil {
		return err
	}

	if err := yaml.Unmarshal(data, cfg); err != nil {
		return err
	}

	return nil
}
