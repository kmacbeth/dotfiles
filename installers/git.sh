#!/bin/bash
################################################################################
# Git configuration installer
# @file: git.sh
# @author: Martin Lafreniere
# @date: 2019-05-31
################################################################################

################################################################################
# @brief Main vim configuration variables
################################################################################
__GIT_HOME="${HOME}"
__GIT_ROOT="$(dirname "$(readlink -f "$0")")/git"
__GIT_FILES=(gitconfig)

################################################################################
# @brief  Get installation information
# @retval Installation information for menu and return code for installation
#         status.
################################################################################
git_get_install_info() {

  local git_file=""
  local old_installed=0
  local not_installed=0
  local installed=0

  echo "Git Configuration"

  for git_file in "${__GIT_FILES[@]}"; do

    # Get current install files and resolve full link path
    local install_file="${__GIT_HOME}/.${git_file}"
    local full_install_file

    full_install_file="$(readlink -f "${install_file}")"

    # When no file found at all, signal not installed.
    # When some files found, signal installed but needs update.
    # Otherwise, it is installed
    if [[ -e "${install_file}" ]]; then
      if [[ "${__GIT_ROOT}/${git_file}" != "${full_install_file}" ]]; then
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
# @brief  Install git configuration
################################################################################
git_install() {

  local git_file=""

  echo "Installing $(git_get_install_info)"

  for git_file in "${__GIT_FILES[@]}"; do

    # Get current install files and resolve full link path
    local install_file="${__GIT_HOME}/.${git_file}"
    local full_install_file

    full_install_file="$(readlink -f "${install_file}")"

    echo "${full_install_file}"

    # If a file already exists but full path does not equal, backup the
    # file and link the new one. Otherwise, just link
    if [[ -e "${install_file}" ]]; then
      if [[ "${__GIT_ROOT}/${git_file}" != "${full_install_file}" ]]; then
        # Process backup
        echo ">>> Saving backup .${git_file} in ~/.backup"
        cp "${full_install_file}" ~/.backup

        # Link new file
        echo ">> Linking newer ${full_install_file}"
        ln -sf "${__GIT_ROOT}/${git_file}" "${full_install_file}"
      fi
    else
      # Link file
      echo ">> Linking ${full_install_file}"
      ln -sf "${__GIT_ROOT}/${git_file}" "${full_install_file}"
    fi
  done
}

if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then
  echo "ERROR: ${BASH_SOURCE[0]} cannot be executed"
  exit 1
fi

