FROM alpine:latest

MAINTAINER Bodo Schulz <bodo@boone-schulz.de>

LABEL version "1.0.0"

EXPOSE 3306

# ---------------------------------------------------------------------------------------

WORKDIR /app
VOLUME  /app

ADD rootfs /

# COPY startup.sh /startup.sh

RUN apk add --update supervisor mysql mysql-client && rm -f /var/cache/apk/*

# COPY my.cnf /etc/mysql/my.cnf

RUN chmod u+x /opt/supervisor/*_supervisor

CMD [ "/opt/startup.sh" ]

# ---------------------------------------------------------------------------------------
