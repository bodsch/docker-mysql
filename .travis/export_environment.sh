#!/bin/bash

wget http://dl-cdn.alpinelinux.org/alpine/latest-stable/main/x86_64/APKINDEX.tar.gz
tar -xzf APKINDEX.tar.gz
version=$(grep -A1 "P:mariadb-common" APKINDEX | tail -n1 | cut -d ':' -f2 | cut -d '-' -f1)

echo "${version}" > ${TRAVIS_BUILD_DIR}/.deployment-env
