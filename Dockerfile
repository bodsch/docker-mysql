
FROM docker-alpine-base:latest

MAINTAINER Bodo Schulz <bodo@boone-schulz.de>

LABEL version "1.3.2"

EXPOSE 3306

ENV WORK_DIR=/app
ENV MYSQL_DATA_DIR=${WORK_DIR}/data
ENV MYSQL_LOG_DIR=${WORK_DIR}/log
ENV MYSQL_TMP_DIR=${WORK_DIR}/tmp

# ---------------------------------------------------------------------------------------

WORKDIR ${WORK_DIR}
VOLUME  ${WORK_DIR}

RUN \
  mkdir -p /run/mysqld

RUN \
  apk update --quiet

RUN \
  apk add --quiet \
    collectd \
    collectd-mysql \
    mysql \
    mysql-client \
    pwgen

RUN \
  rm -rf /tmp/* /var/cache/apk/*

RUN \
  mv /etc/collectd/collectd.conf /etc/collectd/collectd.conf.DIST

ADD rootfs/ /

CMD [ "/opt/startup.sh" ]

# ---------------------------------------------------------------------------------------
