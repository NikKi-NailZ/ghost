{{if .Copyright}}
    {{.Copyright}}
{{end}}
package services

//go:generate mockgen -source services.go -destination ./services_mock.go -package services
type ()