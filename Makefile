
NVM_EXEC = unset npm_config_prefix; . $$HOME/.nvm/nvm.sh && nvm exec 24

help:     ## Show this help.
	@sed -n 's/^##//p' $(MAKEFILE_LIST)
	@grep -E '^[/%a-zA-Z0-9._-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


install: node_modules dist/count.sef.json dist/failures_and_errors.sef.json dist/jacoco.sef.json   ## Install dependencies and build the project
	$(NVM_EXEC) npx ncc build index.js -o dist --minify

node_modules: package.json package-lock.json
	$(NVM_EXEC) npm install

clean:  ## Clean up the project by removing node_modules, package-lock.json, and dist directory
	rm -rf node_modules package-lock.json dist


dist/%.sef.json: %.sef.json
	mkdir -p dist
	cp -a $< $@

%.sef.json: %.xslt
	$(NVM_EXEC) npx xslt3 -xsl:$< -export:$@ -t | true