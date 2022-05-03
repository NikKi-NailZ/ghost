package config

type (
    // Config is the configuration for the application.
    Config struct {}
)

// New loads and validates all configuration data, returns filled Cfg - configuration data model.
func New(appName, cfgFilePath string) (*Config, error) {
	cfg := new(Config)

    // TODO: add constructor implementation
	
    return cfg, nil
}