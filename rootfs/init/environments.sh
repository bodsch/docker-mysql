

HOSTNAME=$(hostname -f)

WORK_DIR=/srv/mysql

MYSQL_DATA_DIR=${WORK_DIR}/data
MYSQL_LOG_DIR=${WORK_DIR}/log
MYSQL_TMP_DIR=${WORK_DIR}/tmp
MYSQL_RUN_DIR=${WORK_DIR}/run
MYSQL_INNODB_DIR=${WORK_DIR}/innodb

MYSQL_SYSTEM_USER=${MYSQL_SYSTEM_USER:-$(grep user /etc/mysql/my.cnf | cut -d '=' -f 2 | sed 's| ||g')}
MYSQL_ROOT_PASS=${MYSQL_ROOT_PASS:-$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)}

MYSQL_OPTS="--batch --skip-column-names "
MYSQL_BIN=$(which mysql)

# wait_for_consul

# PASSWORD=$(get_consul_var "${HOSTNAME}/root/password")

#log_info "generated password  :  '${MYSQL_ROOT_PASS}'"
#log_info "restored from consul:  '${PASSWORD}'"

# [[ -z "${PASSWORD}" ]] || MYSQL_ROOT_PASS=${PASSWORD}

#log_info "set MYSQL_ROOT_PASS to '${MYSQL_ROOT_PASS}'"
