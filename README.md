docker-mysql
============

Docker container with an running MySQL Database.

The Container stores there Data at the Hostsystem in the Directory ```/tmp/docker-data/mysql``` or in a configured Datadirectory.

# Status
[![Build Status](https://travis-ci.org/bodsch/docker-mysql.svg?branch=master)](https://travis-ci.org/bodsch/docker-mysql)

# Build

Your can use the included Makefile.

To build the Container:
    make build

Starts the Container:
    make run

Starts the Container with Login Shell:
    make shell

Entering the Container:
    make exec

Stop (but **not kill**):
    make stop

History
    make history


# Docker Hub

You can find the Container also at  [DockerHub](https://hub.docker.com/r/bodsch/docker-mysql/)


# Versions

 - mariadb 10.1.x


# Supported Environmentvars

 - ```MYSQL_ROOT_PASSWORD``` (default: ```generated with $(pwgen -s 15 1)```)
 - ```MYSQL_SYSTEM_USER```   (default: ```generated with $(grep user /etc/mysql/my.cnf | cut -d '=' -f 2 | sed 's| ||g')```)


# Ports

* 3306
