
__VIM_HOME="${HOME}/.vim"
__VIM_ROOT="$(dirname "$(readlink -f $0)")/vim"
__VIM_FILES=(vimrc)

vim_get_install_info() {
  local vim_file=""
  local status=1

  echo "Minimal Vim Configuration"

  if [[ ! -d "${__VIM_HOME}" ]]; then
    return ${status}
  fi

  for vim_file in ${__VIM_FILES[@]}; do
    local install_file="${__VIM_HOME}/${vim_file}"
    local full_install_file="$(readlink -f "${install_file}")"
    if [[ -e "${install_file}" ]]; then
      if [[ "${__VIM_ROOT}/${vim_file}" == "${full_install_file}" ]]; then
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

vim_install() {
  echo "Installing $(vim_get_install_info)"

  mkdir -p "${__VIM_HOME}"

  for vim_file in ${__VIM_FILES[@]}; do
    local install_file="${__VIM_HOME}/${vim_file}"
    local full_install_file="$(readlink -f "${install_file}")"
    if [[ -e "${install_file}" ]]; then
      if [[ "${__VIM_ROOT}/${vim_file}" != "${full_install_file}" ]]; then
        echo ">>> Saving backup ${vim_file} in ~/.backup"
        cp ${full_install_file} ~/.backup
        ln -sf "${__VIM_ROOT}/${vim_file}" ${full_install_file}
        echo ">> Linking newer ${full_install_file}"
      fi
    else
      ln -sf "${__VIM_ROOT}/${vim_file}" ${full_install_file}
      echo ">> Linking ${full_install_file}"
    fi
  done
}

if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then
  echo "ERROR: ${BASH_SOURCE[0]} cannot be executed"
  exit 1
fi

