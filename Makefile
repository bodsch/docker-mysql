
CONTAINER  := mysql
IMAGE_NAME := docker-mysql

DATA_DIR   := /tmp/docker-data
MYSQL_ROOT_PASSWORD := $(MYSQL_ROOT_PASSWORD)


build:
	mkdir -vp ${DATA_DIR}
	docker \
		build \
		--rm --tag=$(IMAGE_NAME) .
	@echo Image tag: ${IMAGE_NAME}

run:
	docker \
		run \
		--detach \
		--interactive \
		--tty \
		--env MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
		--volume=${DATA_DIR}:/srv \
		--hostname=${CONTAINER} \
		--name=${CONTAINER} \
		$(IMAGE_NAME)

shell:
	docker \
		run \
		--rm \
		--interactive \
		--tty \
		--env MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
		--volume=${DATA_DIR}:/srv \
		--hostname=${CONTAINER} \
		--name=${CONTAINER} \
		$(IMAGE_NAME) \
		/bin/sh

exec:
	docker \
		exec \
		--interactive \
		--tty \
		${CONTAINER}

stop:
	docker \
		kill ${CONTAINER}

history:
	docker \
		history ${IMAGE_NAME}
