SERVICE=python-django-docker
COMMIT_SHA=$(shell git rev-parse HEAD)
REGISTRY=gokusenz/dockergk
TAG=python-django
PWD:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# Dev commands

default:
	make docker
	make push

build:
	docker-compose build

test:
	docker-compose exec web python3 manage.py test

test-perfapi:
	docker-compose exec web coverage run --source='.' manage.py test perfapi -v 2

dev:
	docker-compose up

update:
	docker-compose exec web python3 -m pip install -r requirements.txt

docker:
	docker build -f Dockerfile.prod -t $(REGISTRY)/$(SERVICE) .

push:
	docker push $(REGISTRY)/$(SERVICE):$(TAG)

exec:
	docker-compose exec web bash

builder:
	docker build -f Dockerfile.builder -t $(REGISTRY)/$(SERVICE):builder .
	docker push $(REGISTRY)/$(SERVICE):builder
