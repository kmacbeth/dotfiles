#!/bin/bash
################################################################################
# Neovim configuration installer
# @file: neovim.sh
# @author: Martin Lafreniere
# @date: 2018-12-28
################################################################################

################################################################################
# @brief Main neovim configuration variables
################################################################################
__NEOVIM_HOME="${HOME}/.config/nvim"
__NEOVIM_ROOT="$(dirname "$(readlink -f "$0")")/neovim"
__NEOVIM_FILES=(init.vim init_plugins.vim ftplugin)

################################################################################
# @brief  Get installation information
# @retval Installation information for menu and return code for installation
#         status.
################################################################################
neovim_get_install_info() {

  local neovim_file=""
  local old_installed=0
  local not_installed=0
  local installed=0

  echo "Neovim Configurations"

  # Check neovim home directory exists, otherwise return not installed
  if [[ ! -d "${__NEOVIM_HOME}" ]]; then
    return 1
  fi

  for neovim_file in "${__NEOVIM_FILES[@]}"; do

    # Get current install files and resolve full link path
    local install_file="${__NEOVIM_HOME}/${neovim_file}"
    local full_install_file

    full_install_file="$(readlink -f "${install_file}")"

    # When no file found at all, signal not installed.
    # When some files found, signal installed but needs update.
    # Otherwise, it is installed
    if [[ -e "${install_file}" ]]; then
      if [[ "${__NEOVIM_ROOT}/${neovim_file}" != "${full_install_file}" ]]; then
        old_installed=1
      else
        installed=1
      fi
    else
      not_installed=1
    fi

  done

  # Check when totally installed or totally not installed, otherwise needs update
  local status=0

  if [[ ${old_installed} == 0 && ${installed} == 1 && ${not_installed} == 0 ]]; then
    status=0
  elif [[ ${old_installed} == 0 && ${installed} == 0 && ${not_installed} == 1 ]]; then
    status=1
  else
    status=2
  fi

  return ${status}
}

################################################################################
# @brief  Install neovim configuration
################################################################################
neovim_install() {

  local neovim_file=""

  echo "Installing $(neovim_get_install_info)"

  # Create the vim home directory if it doesn't exist
  mkdir -p "${__NEOVIM_HOME}"

  for neovim_file in "${__NEOVIM_FILES[@]}"; do

    # Get current install files and resolve full link path
    local install_file="${__NEOVIM_HOME}/${neovim_file}"
    local full_install_file

    full_install_file="$(readlink -f "${install_file}")"

    # If a file already exists but full path does not equal, backup the
    # file and link the new one. Otherwise, just link
    if [[ -e "${install_file}" ]]; then
      if [[ "${__NEOVIM_ROOT}/${neovim_file}" != "${full_install_file}" ]]; then
        # Process backup
        echo ">>> Saving backup ${neovim_file} in ~/.backup"
        cp "${full_install_file}" ~/.backup

        # Link new file
        echo ">> Linking newer ${full_install_file}"
        ln -sf "${__NEOVIM_ROOT}/${neovim_file}" "${full_install_file}"
      fi
    else
      # Link file
      echo ">> Linking ${full_install_file}"
      ln -sf "${__NEOVIM_ROOT}/${neovim_file}" "${full_install_file}"
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

