{{if .Copyright}}
    {{.Copyright}}
{{end}}
package config

import "time"

// DefaultPath is the default path to look for the config file
const DefaultPath = "./config.yaml"

type (
    // Config is the configuration for the application.
    Config struct {
        DevMode bool `yaml:"dev-mode"`

        Delivery Delivery `yaml:"delivery" valid:"check,deep"`
    }

    // Delivery defines API server configuration.
	Delivery struct {
		HTTPServer HTTPServer `yaml:"http-server" valid:"check,deep"`
	}

    // HTTPServer defines HTTP section of the API server configuration.
	HTTPServer struct {
		LogRequests        bool          `yaml:"log-requests"`
		ListenAddress      string        `yaml:"listen-address" valid:"required"`
		ReadTimeout        time.Duration `yaml:"read-timeout" valid:"required"`
		WriteTimeout       time.Duration `yaml:"write-timeout" valid:"required"`
		BodySizeLimitBytes int           `yaml:"body-size-limit" valid:"required"`
		GracefulTimeout    int           `yaml:"graceful-timeout" valid:"required"`
	}
)

// New loads and validates all configuration data, returns filled Cfg - configuration data model.
func New(appName, cfgFilePath string) (*Config, error) {
	cfg := new(Config)

    // TODO: add constructor implementation
	
    return cfg, nil
}