__SHELL_HOME="${HOME}"
__SHELL_ROOT="$(dirname "$(readlink -f $0)")/shell"
__SHELL_FILES=(bashrc bash_profile inputrc)

shell_get_install_info() {
  local shell_file=""
  local status=1

  echo "Bash Configuration"

  for shell_file in ${__SHELL_FILES[@]}; do
    local install_file="${__SHELL_HOME}/.${shell_file}"
    local full_install_file="$(readlink -f "${install_file}")"
    if [[ -e "${install_file}" ]]; then
      if [[ "${__SHELL_ROOT}/${shell_file}" == "${full_install_file}" ]]; then
        status=0
      else
        status=2
      fi
    else
      status=2
    fi
    if [[ ${status} == 2 ]]; then
      break
    fi
  done

  return ${status}
}

shell_install() {
  echo "Installing $(shell_get_install_info)"

  for shell_file in ${__SHELL_FILES[@]}; do
    local install_file="${__SHELL_HOME}/.${shell_file}"
    local full_install_file="$(readlink -f "${install_file}")"
    if [[ -e "${install_file}" ]]; then
      if [[ "${__SHELL_ROOT}/${shell_file}" != "${full_install_file}" ]]; then
        echo ">>> Saving backup .${shell_file} in ~/.backup"
        cp ${full_install_file} ~/.backup
        ln -sf "${__SHELL_ROOT}/${shell_file}" ${full_install_file}
        echo ">> Linking newer ${full_install_file}"
      fi
    else
      ln -sf "${__SHELL_ROOT}/${shell_file}" ${full_install_file}
      echo ">> Linking ${full_install_file}"
    fi
  done
}

if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then
  echo "ERROR: ${BASH_SOURCE[0]} cannot be executed"
  exit 1
fi

