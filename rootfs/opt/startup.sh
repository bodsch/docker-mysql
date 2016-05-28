#!/bin/sh
#

set -x

MYSQL_DATA_DIR=${MYSQL_DATA_DIR:-${WORK_DIR}/data}
MYSQL_LOG_DIR=${MYSQL_LOG_DIR:-${WORK_DIR}/log}
MYSQL_TMP_DIR=${MYSQL_TMP_DIR:-${WORK_DIR}/tmp}

MYSQL_USER=$(grep user /etc/mysql/my.cnf | cut -d '=' -f 2 | sed 's| ||g')

if [ -d ${MYSQL_DATA_DIR} ]
then
  echo " [i] MySQL directory already present, skipping creation"
else
  echo " [i] MySQL data directory not found, creating initial DBs"

  mysql_user=$(grep user /etc/mysql/my.cnf | cut -d '=' -f 2 | sed 's| ||g')

  mkdir -vp ${MYSQL_DATA_DIR}
  mkdir -vp ${MYSQL_LOG_DIR}
  mkdir -vp ${MYSQL_TMP_DIR}

  chown -Rv ${mysql_user}: ${MYSQL_DATA_DIR}
  chown -Rv ${mysql_user}: ${MYSQL_LOG_DIR}
  chown -Rv ${mysql_user}: ${MYSQL_TMP_DIR}

  mysql_install_db --user=root > /dev/null

  MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-$(pwgen -s 15 1)}

  MYSQL_DATABASE=${MYSQL_DATABASE:-""}
  MYSQL_USER=${MYSQL_USER:-""}
  MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}

#  if [ ! -d "/run/mysqld" ]; then
#    mkdir -p /run/mysqld
#  fi

  tfile="${WORK_DIR}/mysql-bootstrap"

  cat << EOF > ${tfile}
USE mysql;
FLUSH PRIVILEGES;
create user 'root'@'%' IDENTIFIED BY "${MYSQL_ROOT_PASSWORD}";
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
UPDATE user SET password=PASSWORD("") WHERE user='root' AND host='localhost';
FLUSH PRIVILEGES;
EOF

  if [ "${MYSQL_DATABASE}" != "" ]
  then
    echo " [i] Creating database: ${MYSQL_DATABASE}"
    echo "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> ${tfile}

    if [ "${MYSQL_USER}" != "" ]
    then
      echo " [i] Creating user: ${MYSQL_USER} with password ${MYSQL_PASSWORD}"
      echo "GRANT ALL ON \`${MYSQL_DATABASE}\`.* to '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" >> ${tfile}
    fi
  fi

  /usr/bin/mysqld --user=root --bootstrap --verbose=0 < ${tfile}
#  rm -f ${tfile}

  echo -e "\n"
  echo " ==================================================================="
  echo " MySQL user 'root' password set to '${MYSQL_ROOT_PASSWORD}'"
  echo " ==================================================================="
  echo ""

fi

echo -e "\n Starting Supervisor.\n\n"

if [ -f /etc/supervisord.conf ]
then
  /usr/bin/supervisord -c /etc/supervisord.conf >> /dev/null
fi

# EOF
