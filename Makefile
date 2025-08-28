

install: node_modules dist/count.sef.json dist/failures_and_errors.sef.json
	npx ncc build index.js -o dist --minify

node_modules:
	. $$HOME/venvs/npm/bin/activate ; \
	. $$HOME/.nvm/nvm.sh; \
	nvm use 20
	npm install

clean:
	rm -rf node_modules package-lock.json dist


dist/%.sef.json: %.sef.json
	mkdir -p dist
	cp -a $< $@

%.sef.json: %.xslt
	npx xslt3 -xsl:$< -export:$@ -t | true