#!/bin/sh
#

# set -x

WORK_DIR=${WORK_DIR:-/srv}
WORK_DIR=${WORK_DIR}/mysql

MYSQL_DATA_DIR=${WORK_DIR}/data
MYSQL_LOG_DIR=${WORK_DIR}/log
MYSQL_TMP_DIR=${WORK_DIR}/tmp
MYSQL_RUN_DIR=${WORK_DIR}/run

MYSQL_SYSTEM_USER=$(grep user /etc/mysql/my.cnf | cut -d '=' -f 2 | sed 's| ||g')
MYSQL_ROOT_PASS=${MYSQL_ROOT_PASS:-$(pwgen -s 15 1)}

MYSQL_OPTS="--batch --skip-column-names "
MYSQL_BIN=$(which mysql)

bootstrapDatabase() {

  bootstrap="${WORK_DIR}/mysql-bootstrap"

  sed -i \
    -e "s|%WORK_DIR%|${WORK_DIR}|g" /etc/mysql/my.cnf

  [ -d ${MYSQL_DATA_DIR} ] || mkdir -p ${MYSQL_DATA_DIR}
  [ -d ${MYSQL_LOG_DIR} ]  || mkdir -p ${MYSQL_LOG_DIR}
  [ -d ${MYSQL_TMP_DIR} ]  || mkdir -p ${MYSQL_TMP_DIR}
  [ -d ${MYSQL_RUN_DIR} ]  || mkdir -p ${MYSQL_RUN_DIR}

  chown -R ${MYSQL_SYSTEM_USER}: ${WORK_DIR}

  if [ ! -f ${bootstrap} ]
  then

    cat << EOF > /root/.my.cnf
[client]
host     = localhost
user     = root
password = ${MYSQL_RUN_PASSWORD}
socket   = ${MYSQL_RUN_DIR}/mysql.sock

EOF

    cat << EOF > ${bootstrap}
USE mysql;
update user set host = '%' where host != 'localhost' and host != '127.0.0.1' and host != '::1';
UPDATE user SET password = "" WHERE user = 'root' AND host = 'localhost';
UPDATE user SET password = PASSWORD("${MYSQL_ROOT_PASS}") WHERE user = 'root' and host != 'localhost';

GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;

FLUSH PRIVILEGES;
EOF

    mysql_install_db --user=${MYSQL_SYSTEM_USER} > /dev/null

    if [ "${MYSQL_DATABASE}" != "" ]
    then
      echo " [i] Creating database: ${MYSQL_DATABASE}"
      echo "--- Creating database: ${MYSQL_DATABASE}" >> ${bootstrap}
      echo "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> ${bootstrap}

      if [ "${MYSQL_USER}" != "" ]
      then
        echo " [i] Creating user: ${MYSQL_USER} with password ${MYSQL_PASSWORD}"
        echo "--- Creating user: ${MYSQL_USER} with password ${MYSQL_PASSWORD}" >> ${bootstrap}
        echo "GRANT ALL ON \`${MYSQL_DATABASE}\`.* to '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" >> ${bootstrap}
      fi
    fi

    /usr/bin/mysqld --user=${MYSQL_SYSTEM_USER} --bootstrap --verbose=1 < ${bootstrap}

  fi
}

startSupervisor() {

  echo -e "\n Starting Supervisor.\n\n"

  if [ -f /etc/supervisord.conf ]
  then
    /usr/bin/supervisord -c /etc/supervisord.conf >> /dev/null
  fi
}


run() {

  if [ ! -z ${MYSQL_BIN} ]
  then
    bootstrapDatabase
    startSupervisor

    echo -e "\n"
    echo " ==================================================================="
    echo " MySQL user 'root' password set to '${MYSQL_ROOT_PASS}'"
    echo " ==================================================================="
    echo ""
  else
    echo " [E] no MySQL binary found!"
    exit 1
  fi
}


run

# EOF
