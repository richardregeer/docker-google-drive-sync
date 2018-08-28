.DEFAULT_GOAL := help

RED=\033[31m
CYAN=\033[36m
YELLOW=\033[33m
GREEN=\033[32m
DEFAULT=\033[0m

ENV := development
DOCKER := true
DOCKER_NETWORK := bridge
OS := $(shell uname)
PROJECT_ROOT := $(shell pwd)
PROJECT_CONTAINER_ROOT := /usr/local/bin/google-sync
DOCKER_IMAGE := richardregeer/google-drive-sync
NODE_MODULES := ./node_modules/.bin

ifeq ($(DOCKER),true)
START_COMMAND := docker run --rm -it --init --net=${DOCKER_NETWORK} \
		-v ${PROJECT_ROOT}:${PROJECT_CONTAINER_ROOT} \
		-v ${PROJECT_ROOT}/etc/config.dev.json:${PROJECT_CONTAINER_ROOT}/etc/config.json \
		-v ${PROJECT_ROOT}/etc/rclone.dev.conf:/root/.config/rclone/rclone.conf \
		-v ${PROJECT_ROOT}/sync-root:/var/target \
		-w ${PROJECT_CONTAINER_ROOT} \
		${DOCKER_IMAGE}:${ENV}
else
START_COMMAND :=
endif

.PHONY: help
help:
	@echo -e 'To run a task: ${GREEN}make [task_name]${DEFAULT}'
	@echo "\tExample: make build ENV='production'"
	@echo ''
	@echo 'By default the task will run in development environment mode using docker on a bridge network.'
	@echo -e 'The environment can be changed by passing ${YELLOW}ENV=[development|production|ci]${DEFAULT}.'
	@echo -e 'To run a command on the host without docker use argument ${YELLOW}DOCKER=false${DEFAULT}.'
	@echo -e 'By default docker runs in bridge network mode to change use argument ${YELLOW}DOCKER_NETWORK=[host|bridge]${DEFAULT}.'
	@echo "\tExample: make start ENV=production DOCKER=false DOCKER_NETWORK=host"
	@echo ''
	@echo -e 'Please add a valid token in ${GREEN}/etc/rclone.dev.conf${DEFAULT} before running ${YELLOW}make start${DEFAULT}. The files will be synced to the ${GREEN}sync-root${DEFAULT} folder in the project.\nSync configuration can be changed in ${GREEN}etc/config.dev.json${DEFAULT}'
	@echo ''
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%s%-30s%s %s\n", "${CYAN}", $$1, "${DEFAULT}",$$2}'

.PHONY: start
start: ## Start docker google drive sync on development.Possible environments ENV=development|production
ifeq ($(ENV),development)
	${START_COMMAND} pm2-dev etc/pm2.dev.config.json
else
	${START_COMMAND}
endif

.PHONY: install
install: ## Install the docker google drive sync development environment. Possible environments ENV=development
ifeq ($(ENV),development)
	@echo -e '${CYAN}Install the docker google drive sync development environment${DEFAULT}'
	make build
	${START_COMMAND} npm install
endif
ifeq ($(ENV),ci)
	@echo -e '${CYAN}Install the docker google drive sync ci environment${DEFAULT}'
	npm install
endif

.PHONY: build
build: ## Build the google drive sync image.
	docker build -t ${DOCKER_IMAGE}:${ENV} .
ifeq ($(ENV),ci)
	docker build -t ${DOCKER_IMAGE}:latest .
endif

.PHONY: publish
publish: ## Pubish docker image to docker hub only available on ci environment.
ifneq ($(ENV),ci)
	$(error Required ENV='ci')
endif
	docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}
	docker push ${DOCKER_IMAGE}:latest

.PHONY: lint
lint: ## Check the codestyle of the complete project.
	${START_COMMAND} ${NODE_MODULES}/eslint .
