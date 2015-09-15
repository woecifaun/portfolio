.SILENT:
.PHONY: help

## Colors
COLOR_RESET   = \033[0m
COLOR_INFO    = \033[32m
COLOR_COMMENT = \033[33m

## Help
help:
	printf "${COLOR_COMMENT}Usage:${COLOR_RESET}\n"
	printf " make [target]\n\n"
	printf "${COLOR_COMMENT}Available targets:${COLOR_RESET}\n"
	awk '/^[a-zA-Z\-\_0-9\.]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf " ${COLOR_INFO}%-16s${COLOR_RESET} %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

## Setup environment & Install application
setup:
	ansible-galaxy install -r ansible/roles.yml -p ansible/roles -f --ignore-errors
	vagrant up --provision
	vagrant ssh -c 'cd /srv/app && make install'

## Install
install: prepare-vendor build

## Setup environment & Install application
prepare-vendor:
	composer install
	npm install

## Build static files
build:
	gulp

## Build dev
build-dev:
	gulp dev

## Launch dev server
dev:
	sudo supervisorctl start all

## Launch dev server
stop-dev:
	sudo supervisorctl stop all

## Publish
publish:
	rm -rf dist
	vagrant ssh -c 'cd /srv/app && make build && bin/console portfolio:build -e=prod thomas.jarrand.fr'
	chmod -R 755 dist
	rsync -arzv --delete dist/* dédié:/home/tom32i/sites/portfolio
