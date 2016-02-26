FROM alpine:latest

MAINTAINER Bodo Schulz <bodo@boone-schulz.de>

LABEL version "1.0.2"

EXPOSE 3306

# ---------------------------------------------------------------------------------------

WORKDIR /app
VOLUME  /app

ADD rootfs /

RUN \
  apk add --update \
  supervisor \
  mysql \
  mysql-client \
  pwgen && \
  rm -f /var/cache/apk/* && \
  chmod u+x /opt/supervisor/*_supervisor

CMD [ "/opt/startup.sh" ]

# ---------------------------------------------------------------------------------------
