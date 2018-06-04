#!/bin/sh

set -x

if [[ -z "${CONSUL}" ]]
then
  return
fi

register()  {

#  data=$(curl \
#    --request PUT \
#    ${CONSUL}:8500/v1/agent/service/register \
#    --data "{
#      \"ID\": \"${HOSTNAME}\",
#      \"Name\":\"${HOSTNAME}\",
#      \"Port\": 3306,
#      \"tags\": [\"database\"]
#    }")
#
#  echo "${data}"

  data=$(curl \
    --request PUT \
    --silent \
    ${CONSUL}:8500/v1/kv/database \
    --data "{
      \"system_user\": \"${MYSQL_SYSTEM_USER}\",
      \"root_password\": \"${MYSQL_ROOT_PASS}\"
    }")

  echo "${data}"

  data=$(curl \
    --silent \
    ${CONSUL}:8500/v1/kv/database)

  echo "---------------------------------"
  echo -e ${data}
  echo "---------------------------------"

  which base64
#  data=$(curl \
#    --silent \
#    ${CONSUL}:8500/v1/kv/database/root_password)
#
#  echo "${data}"

}

register

set +x
