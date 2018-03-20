export NODE_VERSION := 8.10.0
export YARN_VERSION := 1.5.1
export AUTHOR := sourcec0de
export CLAIR_DB_VERSION := 2018-03-17
export CLAIR_SCAN_VERSION := v2.0.1
export CLAIR_SCAN_PORT = 6060
export COMPOSE_PROJECT_NAME = $(AUTHOR)node
IMAGE_TAG=$(AUTHOR)/node:$(NODE_VERSION)

# we have to export here instead of following
# the export IMAGE_TAG since we're using a colon in the string
# Make doesn't like it.
export IMAGE_TAG

.PHONY: build

build:
	docker build . -t latest \
								 -t $(IMAGE_TAG)

push: build
	docker push $(IMAGE_TAG)

clair-start:
	docker-compose up

clair-start-d:
	docker-compose up -d

clair-stop:
	docker-compose stop

clair-down:
	docker-compose down

clair-logs:
	docker-compose logs -f

scan: push
	docker-compose up -d
	clair-scanner $(IMAGE_TAG)
	- docker-compose down
