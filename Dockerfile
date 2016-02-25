FROM alpine:latest

MAINTAINER Bodo Schulz <bodo@boone-schulz.de>

WORKDIR /app
VOLUME /app

ADD rootfs /

COPY startup.sh /startup.sh

RUN apk add --update supervisor mysql mysql-client && rm -f /var/cache/apk/*

COPY my.cnf /etc/mysql/my.cnf

EXPOSE 3306

RUN chmod u+x /opt/supervisor/*_supervisor

CMD ["/startup.sh"]
