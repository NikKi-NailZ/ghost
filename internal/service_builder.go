package app

import (
	"errors"
	"os"
	"os/exec"
	"strings"
	"text/template"
)

const (
	cmdFolder                 = "cmd"
	internalFolder            = "internal"
	internalAPIFolder         = "internal/api"
	internalAPPFolder         = "internal/app"
	internalConfigFolder      = "internal/config"
	internalAPIDeliveryFolder = "internal/api/delivery"
	internalAPIDOmainFolder   = "internal/api/domain"
	internalAPIServicesFolder = "internal/api/services"
)

var folders = []string{
	cmdFolder,
	internalFolder,
	internalAPIFolder,
	internalAPPFolder,
	internalConfigFolder,
	internalAPIDeliveryFolder,
	internalAPIDOmainFolder,
	internalAPIServicesFolder,
}

const pathSeparator = "/"

func (a App) modifyPath(path string) string {
	return strings.Replace(path, "templates", a.data.AppName, 1)
}

func (a App) readTemplates(path string) {
	entries, err := a.templates.ReadDir(path)
	if err != nil {
		a.logger.Fatal(err)
	}

	for _, entry := range entries {
		switch entry.IsDir() {
		case true:
			a.logger.Infof("Try to create folder %s", path+pathSeparator+entry.Name())

			if err := os.Mkdir(a.modifyPath(path+pathSeparator+entry.Name()), 0755); err != nil {
				if !errors.Is(err, os.ErrExist) {
					a.logger.Errorf("Error creating folder %s", err)
					return
				}
			}

			a.readTemplates(path + pathSeparator + entry.Name())
		case false:
			var parseable bool

			fileName := path + pathSeparator + entry.Name()
		
			fileName = a.modifyPath(fileName)
			if strings.Contains(fileName, "tpl") {
				fileName = strings.Replace(fileName, "tpl", "go", 1)
				parseable = true
			}
		
			a.logger.Infof("Try to create file %s", fileName)

			file, err := os.Create(fileName)
			if err != nil {
				if errors.Is(err, os.ErrExist) {
					a.logger.Debugf("File %s already exists", fileName)
					continue
				}
				a.logger.Errorf("Error creating file %s", err)
				return
			}


			if !parseable {
				parseable = a.checkForParse(fileName,
					"Makefile",
					"README.md",
					"Dockerfile",
					"Dockerfile.local",
					"docker-compose.yml",
					".gitignore",
				)
			}

			if parseable {
				tmpl, err := template.ParseFS(a.templates, path+pathSeparator+entry.Name())
				if err != nil {
					a.logger.Errorf("Error parsing template %s", err)
					return
				}

				if err := tmpl.Execute(file, a.data); err != nil {
					a.logger.Errorf("Error executing template %s", err)
					return
				}

				continue
			}

			fileData, err := a.templates.ReadFile(path + pathSeparator + entry.Name())
			if err != nil {
				a.logger.Errorf("Error reading template %s", err)
				return
			}

			file.Write(fileData)
		}
	}
}

func (a *App) parseCopyright() {} // TODO implement

func generateTree(app *App) {
	app.logger.Infof("Try to create app folder %s", app.data.AppName)

	if err := os.Mkdir(app.data.AppName, 0755); err != nil {
		if !errors.Is(err, os.ErrExist) {
			app.logger.Errorf("Error creating folder %s", err)

			return
		}

		app.logger.Debugf("Folder %s already exists", app.data.AppName)
	}

	app.readTemplates("templates")

	app.runCommands()
}

func (a *App) checkForParse(fileName string, allowedFowParse ...string) bool {
	for _, allowed := range allowedFowParse {
		if strings.Contains(fileName, allowed) {
			return true
		}
	}

	a.logger.Info("Regular file %s", fileName)

	return false
}

func (a App) runCommands() {
	modCMD := exec.Command("go", "mod", "init", a.data.AppName)
	modCMD.Dir = a.data.AppName
	modCMD.Run()

	modCMD = exec.Command("go", "mod", "tidy")
	modCMD.Dir = a.data.AppName
	modCMD.Run()
}
