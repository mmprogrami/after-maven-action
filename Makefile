

install: node_modules count.sef.json


node_modules:
	source ~/venvs/npm/bin/activate
	. $$HOME/.nvm/nvm.sh; nvm use 20
	npm install

clean:
	rm -rf node_modules package-lock.json count.sef.json

count.sef.json: count.xslt
	npx xslt3 -xsl:$< -export:$@ -t