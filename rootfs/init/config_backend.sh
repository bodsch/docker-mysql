

if [[ ! -z "${CONFIG_BACKEND_SERVER}" ]]
then
  if [[ -z "${CONFIG_BACKEND}" ]]
  then
    log_warn "no 'CONFIG_BACKEND' defined"
    return
  fi

  log_info "use '${CONFIG_BACKEND}' as configuration backend"

  if [[ "${CONFIG_BACKEND}" = "consul" ]]
  then
    . config_backend/consul.sh
  elif [[ "${CONFIG_BACKEND}" = "etcd" ]]
  then
    . config_backend/etc.sh
  fi
fi

save_config() {

  local backend=

  if [[ "${CONFIG_BACKEND}" = "consul" ]]
  then
    # wait_for_consul
    register_node
    set_consul_var  "${HOSTNAME}/root/user" ${MYSQL_SYSTEM_USER}
    set_consul_var  "${HOSTNAME}/root/password" ${MYSQL_ROOT_PASS}
    set_consul_var  "${HOSTNAME}/url" ${HOSTNAME}
  elif [[ "${CONFIG_BACKEND}" = "etcd" ]]
  then
    set_etc_var "" ""


  fi

}
