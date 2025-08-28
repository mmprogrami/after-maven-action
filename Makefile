

install: node_modules count.sef.json failures_and_errors.sef.json
	npx ncc build index.js -o dist


node_modules:
	source ~/venvs/npm/bin/activate
	. $$HOME/.nvm/nvm.sh; nvm use 20
	npm install

clean:
	rm -rf node_modules package-lock.json rm *.sef.json

%.sef.json: %.xslt
	npx xslt3 -xsl:$< -export:$@ -t | true