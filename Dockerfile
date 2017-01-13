
FROM bodsch/docker-alpine-base:1701-02

MAINTAINER Bodo Schulz <bodo@boone-schulz.de>

LABEL version "1.2.3"

EXPOSE 3306

# ---------------------------------------------------------------------------------------

RUN \
  apk --no-cache update && \
  apk --no-cache upgrade && \
  apk --no-cache add \
    mysql \
    mysql-client \
    pwgen && \
  apk del --purge \
    bash \
    nano \
    tree \
    curl && \
  rm -rf \
    /tmp/* \
    /var/cache/apk/*

COPY rootfs/ /

CMD [ "/opt/startup.sh" ]

# ---------------------------------------------------------------------------------------
