#!/bin/sh

if [[ -z "${CONSUL}" ]] || [[ -z "${CONFIG_BACKEND}"  ]]
then
  return
fi

log_info "use '${CONFIG_BACKEND}' as configuration backend"

wait_for_consul() {

  RETRY=50
  local http_response_code=0

  until [[ 200 -ne $http_response_code ]] && [[ ${RETRY} -le 0 ]]
  do
    http_response_code=$(curl \
      -w %{response_code} \
      --silent \
      --output /dev/null \
      ${CONSUL}:8500/v1/health/service/consul)

    [[ 200 -eq $http_response_code ]] && break

    sleep 5s

    RETRY=$(expr ${RETRY} - 1)
  done

  if [[ ${RETRY} -le 0 ]]
  then
    log_error "could not connect to the consul master instance '${CONSUL}'"
    exit 1
  fi
}

register_node()  {

  local address=$(hostname -i)

  data=$(curl \
    --silent \
    --request PUT \
    ${CONSUL}:8500/v1/agent/service/register \
    --data '{
      "ID": "'${HOSTNAME}'",
      "Name": "'${HOSTNAME}'",
      "Port": 3306,
      "Address": "'${address}'",
      "tags": ["database"]
    }')

  echo "${data}"
}

set_consul_var() {

  local consul_key=${1}
  local consul_var=${2}

  data=$(curl \
    --request PUT \
    --silent \
    ${CONSUL}:8500/v1/kv/${consul_key} \
    --data ${consul_var})
#  curl \
#    --silent \
#    ${CONSUL}:8500/v1/kv/${consul_key}
}

get_consult_var() {

  local consul_key=${1}

  data=$(curl \
    --silent \
    ${CONSUL}:8500/v1/kv/${consul_key})

  if [[ ! -z "${data}" ]]
  then
    value=$(echo -e ${data} | jq --raw-output .[].Value 2> /dev/null)

    if [[ ! -z "${value}" ]]
    then
      echo ${value} | base64 -d
    else
      echo ""
      #echo "${decoded}"
    fi
  fi
}

if [[ "${CONFIG_BACKEND}" = "consul" ]]
then
  wait_for_consul
  register_node
  set_consul_var  'database/root/user' ${MYSQL_SYSTEM_USER}
  set_consul_var  'database/root/password' ${MYSQL_ROOT_PASS}
  set_consul_var  'database/url' ${HOSTNAME}
fi
