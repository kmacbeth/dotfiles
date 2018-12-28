
__NEOVIM_HOME="${XDG_CONFIG_HOME}/nvim"
__NEOVIM_ROOT="$(dirname "$(readlink -f $0)")/neovim"
__NEOVIM_FILES=(init.vim init_plugins.vim)

neovim_get_install_info() {
  local neovim_file=""
  local status=1

  echo "Neovim Configurations"

  if [[ ! -d "${__NEOVIM_HOME}" ]]; then
    return ${status}
  fi

  for neovim_file in ${__NEOVIM_FILES[@]}; do
    local install_file="${__NEOVIM_HOME}/${neovim_file}"
    local full_install_file="$(readlink -f "${install_file}")"
    if [[ -e "${install_file}" ]]; then
      if [[ "${__NEOVIM_ROOT}/${neovim_file}" == "${full_install_file}" ]]; then
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

neovim_install() {
  echo "Installing $(neovim_get_install_info)"

  mkdir -p "${__NEOVIM_HOME}"

  for neovim_file in ${__NEOVIM_FILES[@]}; do
    local install_file="${__NEOVIM_HOME}/${neovim_file}"
    local full_install_file="$(readlink -f "${install_file}")"
    if [[ -e "${install_file}" ]]; then
      if [[ "${__NEOVIM_ROOT}/${neovim_file}" != "${full_install_file}" ]]; then
        echo ">>> Saving backup ${neovim_file} in ~/.backup"
        cp ${full_install_file} ~/.backup
        ln -sf "${__NEOVIM_ROOT}/${neovim_file}" ${full_install_file}
        echo ">> Linking newer ${full_install_file}"
      fi
    else
      ln -sf "${__NEOVIM_ROOT}/${neovim_file}" ${full_install_file}
      echo ">> Linking ${full_install_file}"
    fi
  done

  # Install plugins
  mkdir -p "${__NEOVIM_HOME}/autoload"
  mkdir -p "${__NEOVIM_HOME}/plugged"

  curl -Ls https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
       -o "${__NEOVIM_HOME}/autoload/plug.vim"

  nvim +PlugInstall +qall
}


if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then
  echo "ERROR: ${BASH_SOURCE[0]} cannot be executed"
  exit 1
fi

