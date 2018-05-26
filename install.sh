#!/usr/bin/env bash
#--------------------------------------------------------------------------------
# Install my dotfiles
#
# @note: Make sure that if behind a proxy to define HTTP_PROXY or HTTPS_PROXY.
#--------------------------------------------------------------------------------
BASE_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
TARGET_DIR="${TARGET_DIR:-${HOME}}"

not_exists()
{
  command -v "$1" > /dev/null
  return $?
}

source ${BASE_DIR}/scripts/editor.sh

shell_setup()
{
  rm -f "${BASE_DIR}/.inputrc" "${BASE_DIR}/.bashrc" "${BASE_DIR}/.bash_profile"

  ln -sf "${BASE_DIR}/inputrc"      "${TARGET_DIR}/.inputrc"
  ln -sf "${BASE_DIR}/bashrc"       "${TARGET_DIR}/.bashrc"
  ln -sf "${BASE_DIR}/bash_profile" "${TARGET_DIR}/.bash_profile"

  touch "${TARGET_DIR}/.bashrc.extras"

  not_exists "curl" || sudo apt-get -y install curl
}


main()
{
  echo "TARGET: ${TARGET_DIR}"
  echo "SOURCE: ${BASE_DIR}"

  if [[ ! -d "${TARGET_DIR}" ]]; then
    mkdir "${TARGET_DIR}"
  fi

  shell_setup
  editors_setup
}


main "$@"

