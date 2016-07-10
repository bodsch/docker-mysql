TYPE := mysql
IMAGE_NAME := ${USER}-docker-${TYPE}
DATA_DIR := ${HOME}/docker-data
MYSQL_ROOT_PASSWORD := $(MYSQL_ROOT_PASSWORD)


build:
	mkdir -vp ${DATA_DIR}
	docker build --rm --tag=$(IMAGE_NAME) .

run:
	docker run \
		--detach \
		--interactive \
		--tty \
		--env MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
		--volume=${DATA_DIR}:/srv \
		--hostname=${USER}-mysql \
		--name=${USER}-${TYPE} \
		$(IMAGE_NAME)

shell:
	docker run \
		--rm \
		--interactive \
		--tty \
		--env MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
		--volume=${DATA_DIR}:/srv \
		--hostname=${USER}-mysql \
		--name=${USER}-${TYPE} \
		$(IMAGE_NAME)

exec:
	docker exec \
		--interactive \
		--tty \
		${USER}-${TYPE} \
		/bin/sh

stop:
	docker kill \
		${USER}-${TYPE}
