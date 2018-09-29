#!/bin/bash

#--------------------------------------------#
#               Some variables               #
#--------------------------------------------#

# packages to install
babel="@babel/core @babel/cli @babel/preset-env"
react="react react-dom @babel/preset-react"
sass="sass"
pug="pug-cli" # https://github.com/pugjs/babel-plugin-transform-react-pug
http_server="http-server"


# babel config file
babel_config='{
	"presets": [
		"@babel/preset-env",
		"@babel/preset-react"
	]
}'

# basic pug file
pug_file='doctype html
html(lang="en")
	head
		meta(charset="UTF-8")
		meta(name="viewport", content="width=device-width, initial-scale=1.0")
		meta(http-equiv="X-UA-Compatible", content="ie=edge")
		link(rel="stylesheet", href="css/style.css")
		title 
	body
		script(src="https://unpkg.com/react@16/umd/react.production.min.js", crossorigin)
		script(src="https://unpkg.com/react-dom@16/umd/react-dom.production.min.js", crossorigin)
		script(src="js/main.js")'


#--------------------------------------------#
#               Some functions               #
#--------------------------------------------#

build () {
	echo "[Util] Building files..."
	npx babel src/scripts/ -d public/js/
	npx sass src/styles/:public/css/
	npx pug src/ -o public/
}

help () {
	echo "usage stuff"
}

setup () {
	echo "[Util] Performing first-time setup..."
	# initialize npm, install dependencies
	npm init -y
	npm -D i $babel $react $sass $pug $http_server

	# create file structure
	mkdir -p src/{scripts,styles}
	mkdir -p public/{css,js}

	# create basic files
	IFS='`'
	echo $babel_config > .babelrc
	echo $pug_file > ./src/index.pug
	unset IFS

	touch src/scripts/main.jsx
	touch src/styles/style.sass
	
	wget -P public/css/ https://necolas.github.io/normalize.css/8.0.0/normalize.css
}

start () {
	echo "[Util] Starting HTTP server..."
	npx http-server &
}

watch () {
	echo "[Util] Watching files for updates..."
}


#--------------------------------------------#
#          Actually doing stuff now          #
#--------------------------------------------#

if [[ $# -eq 0 ]]; then help
elif [[ $# -eq 1 ]]; then

	if [[ $1 == "build" ]]; then build
	elif [[ $1 == "help" ]]; then help
	elif [[ $1 == "setup" ]]; then setup
	elif [[ $1 == "start" ]]; then start
	elif [[ $1 == "watch" ]]; then watch
	else echo "[Error] Invalid argument"; help
	fi

else echo "[Error] Too many arguments"; help
fi