
FROM alpine:latest

MAINTAINER Bodo Schulz <bodo@boone-schulz.de>

LABEL version="1705-01"

ENV \
  ALPINE_MIRROR="dl-cdn.alpinelinux.org" \
  ALPINE_VERSION="edge" \
  TERM=xterm \
  BUILD_DATE="2017-05-01" \
  VERSION="10.1.22-r1"

EXPOSE 3306

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="MariaDB Docker Image" \
      org.label-schema.description="Inofficial MariaDB Docker Image" \
      org.label-schema.url="https://www.mariadb.com" \
      org.label-schema.vcs-url="https://github.com/bodsch/docker-mysql" \
      org.label-schema.vendor="Bodo Schulz" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0" \
      com.microscaling.docker.dockerfile="/Dockerfile" \
      com.microscaling.license="unlicense"

# ---------------------------------------------------------------------------------------

RUN \
  echo "http://${ALPINE_MIRROR}/alpine/${ALPINE_VERSION}/main"       > /etc/apk/repositories && \
  echo "http://${ALPINE_MIRROR}/alpine/${ALPINE_VERSION}/community" >> /etc/apk/repositories && \
  apk --no-cache update && \
  apk --no-cache upgrade && \
  apk --no-cache add \
    mariadb \
    mariadb-client \
    pwgen && \
  rm -rf \
    /tmp/* \
    /var/cache/apk/*

COPY rootfs/ /

CMD [ "/init/run.sh" ]

# ---------------------------------------------------------------------------------------
