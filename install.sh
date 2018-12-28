#!/usr/bin/env bash
################################################################################
# Dotfiles installer
# @file: installer.sh
# @author: Martin Lafreniere
# @date: 2018-12-28
################################################################################

# Standardize environment variables
XDG_CONFIG_HOME="${HOME}/.config"
XDG_DATA_HOME="${HOME}/.local"

################################################################################
# @brief Installers
# @description Get a list of installers script from the installers directory
################################################################################
INSTALLERS=(installers/*.sh)
INSTALLERS_SIZE=${#INSTALLERS[@]}
INSTALLERS_NAME=()

################################################################################
# @brief Install status
# @description An array containing a symbol with escaped color to represent
#    the current installation status.
#    [0] Green checkmark  (installed)
#    [1] Red crossmark    (not installed)
#    [2] Yellow checkmark (installed but needs update)
################################################################################
INSTALL_STATUS=()
INSTALL_STATUS+=("\e[32m\342\234\223\e[39m")
INSTALL_STATUS+=("\e[31m\342\234\227\e[39m")
INSTALL_STATUS+=("\e[33m\342\234\223\e[39m")


################################################################################
# @brief Helper functions
################################################################################
remove_shell_extension() {

  local filename="$1"

  echo "${filename%*.sh}"
}

extract_file_basename() {

  local filename="$1"

  echo "${filename##*/}"
}

################################################################################
# @brief  Get installer name
# @param  $1 Installer filename with full path
# @retval Installer name
################################################################################
get_installer_name() {

    local installer="$1"
    local installer_basename="$(extract_file_basename "${installer}")"
    local installer_name="$(remove_shell_extension ${installer_basename})"

    echo "${installer_name}"
}


################################################################################
# @brief  Source all installers script
# @retval Fills the $INSTALLERS_NAME global array
################################################################################
source_installers() {

  local installer=""

  for installer in ${INSTALLERS[@]}; do
    source ${installer}
    INSTALLERS_NAME+=($(get_installer_name "${installer}"))
  done
}

################################################################################
# @brief  Present available installer and select one
# @description Buid a menu of available installer and prompt for selection
#    using a number. Any other key is treated as the exit key. Once a valid
#    key is select, it calles the appropriate installer install function.
################################################################################
select_installer() {

  local installer_name=""
  local installer_info=""
  local installer_status=""

  for installer_index in ${!INSTALLERS[@]}; do

    installer_name="${INSTALLERS_NAME[${installer_index}]}"

    # Get install information to display in menu. Return value is the current
    # installation status (installed, not installed, installed by needs update
    installer_info="$(${installer_name}_get_install_info)"
    installer_status="$?"

    printf "%2u) Install %-30s [%b]\n" \
        "$((${installer_index} + 1))" "${installer_info}" "${INSTALL_STATUS[${installer_status}]}"
  done

  # Get user input selection and check it is a valid number for selection.
  # If it does, call the appropriate install function.
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

################################################################################
# @brief Main install script function
################################################################################
main() {

  # Ensure the backup directory exists for copying old installed files
  mkdir -p ~/.backup

  source_installers
  select_installer

}

main "$@"

