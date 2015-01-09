#!/usr/bin/env bash

# Install my dotfiles

function setup_vim
{
  local vim_ver major minor
  
  vim_ver="$(vim --version | head | grep -o -E '[0-9]+\.[0-9]+')"
  major="$(grep -o -E '^[0-9]+' <<< "${vim_ver}")"
  minor="$(grep -o -E '[0-9]+$' <<< "${vim_ver}")"

  if [[ ${major} -lt 7 ]] || [[ ${major} -eq 7 && ${minor} -lt 4 ]]; then 
    ln -sf "${PWD}/vim/vimrc"  ~/.vimrc
    ln -sf "${PWD}/vim/gvimrc" ~/.gvimrc
  fi
}

function setup_links
{
  for file in "${PWD}"/*; do
    if [[ "${file##*/}" != "install.sh" ]]; then
      ln -sf "${file}" "${HOME}/.${file##*/}"
    fi
  done
  setup_vim
}

setup_links

