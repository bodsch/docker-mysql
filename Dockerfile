
FROM alpine:latest

ARG BUILD_DATE
ARG BUILD_VERSION

EXPOSE 3306

# ---------------------------------------------------------------------------------------

RUN \
  apk update --quiet --no-cache && \
  apk upgrade --quiet --no-cache && \
  apk add --quiet --no-cache \
    mariadb \
    mariadb-client \
    pwgen && \
  VERSION=$(apk info -s mariadb 2>/dev/null | grep mariadb | cut -d ' ' -f1 | cut -d '-' -f2) && \
  echo -e "\nmariadb version ${VERSION} installed\n" && \
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

LABEL \
  version="${BUILD_VERSION}" \
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
