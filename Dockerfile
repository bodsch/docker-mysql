
FROM alpine:3.8

ENV \
  TERM=xterm \
  BUILD_DATE="2018-07-30" \
  VERSION="10.2.15"

EXPOSE 3306

LABEL \
  version="1807" \
  maintainer="Bodo Schulz <bodo@boone-schulz.de>" \
  org.label-schema.build-date=${BUILD_DATE} \
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
  apk update --quiet --no-cache && \
  apk upgrade --quiet --no-cache && \
  apk add --quiet --no-cache \
    curl \
    jq \
    util-linux \
    mariadb \
    mariadb-client \
    pwgen && \
  mkdir /etc/mysql/conf.d && \
  rm -rf \
    /tmp/* \
    /var/cache/apk/*

COPY rootfs/ /

HEALTHCHECK \
  --interval=5s \
  --timeout=2s \
  --retries=12 \
  CMD /init/health_check.sh

VOLUME [ "/etc/mysql/conf.d" ]

CMD [ "/init/run.sh" ]

# ---------------------------------------------------------------------------------------
