#!/usr/bin/env bash

# Standardize variable
XDG_CONFIG_HOME="${HOME}/.config"
XDG_DATA_HOME="${HOME}/.local"

# Installers
INSTALLERS=(installers/*.sh)
INSTALLERS_SIZE=${#INSTALLERS[@]}
INSTALLERS_NAME=()

INSTALL_STATUS=()
INSTALL_STATUS+=("\e[32m\342\234\223\e[39m")
INSTALL_STATUS+=("\e[31m\342\234\227\e[39m")
INSTALL_STATUS+=("\e[33m\342\234\223\e[39m")

remove_shell_extension() {
  local filename="$1"
  echo "${filename%*.sh}"
}

extract_file_basename() {
  local filename="$1"
  echo "${filename##*/}"
}

source_installers() {
  local installer=""

  for installer in ${INSTALLERS[@]}; do
    source ${installer}
    INSTALLERS_NAME+=("$(remove_shell_extension "$(extract_file_basename "${installer}")")")
  done
}

select_installer() {
  local installer_name=""
  local installer_info=""
  local installer_status=""

  for installer_index in ${!INSTALLERS[@]}; do
    installer_name="${INSTALLERS_NAME[${installer_index}]}"
    installer_info="$(${installer_name}_get_install_info)"
    installer_status="$?"
    printf "%2u) Install %-30s [%b]\n" \
  	  "$((${installer_index} + 1))" "${installer_info}" "${INSTALL_STATUS[${installer_status}]}"
  done

  echo -n "Select> "
  read user_input

  if [[ "${user_input}" =~ ^[1-9][0-9]*$ ]]; then
    # Reduce to index installer name array
    (( user_input-- ))
    if (( user_input < INSTALLERS_SIZE )); then
      installer_name="${INSTALLERS_NAME[${user_input}]}"
      ${installer_name}_install
    fi
  fi
}

main() {

  mkdir -p ~/.backup

  source_installers
  select_installer

}

main "$@"

