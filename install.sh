#!/usr/bin/env bash
#--------------------------------------------------------------------------------
# Install my dotfiles
#
# @note: Make sure that if behind a proxy to define HTTP_PROXY or HTTPS_PROXY.
#--------------------------------------------------------------------------------
VIM_HOME="~/.vim"
NEOVIM_HOME="~/.config/nvim"


#--------------------------------------------------------------------------------
# Link dotfiles
#
# @param $1 name: The file/directory name.
#--------------------------------------------------------------------------------
link_dotfile()
{
  local name="$1"

  ln -sf "${PWD}/${name}" "${HOME}/.${name}"
}


#--------------------------------------------------------------------------------
# Download Plugin Manager for [neo]vim
#
# @param $1 destination: Destination directory.
#--------------------------------------------------------------------------------
download_plugin_manager()
{
  local destination="$1"

  curl -L -o "${destination}/plug.vim" \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}


#--------------------------------------------------------------------------------
# Setup Vimrc Files
#
# @note: For vim 7.3 and lower, [g]vimrc must be in ${HOME}/.[g]vimrc
#--------------------------------------------------------------------------------
setup_vimrc_files()
{
  local vim_ver major minor

  vim_ver="$(vim --version | head | grep -o -E '[0-9]+\.[0-9]+')"
  major="$(grep -o -E '^[0-9]+' <<< "${vim_ver}")"
  minor="$(grep -o -E '[0-9]+$' <<< "${vim_ver}")"

  if [[ ${major} -lt 7 ]] || [[ ${major} -eq 7 && ${minor} -lt 4 ]]; then 
    ln -sf "${VIM_HOME}/vimrc"  "${HOME}/.vimrc"
    ln -sf "${VIM_HOME}/gvimrc" "${HOME}/.gvimrc"
  fi
}

#--------------------------------------------------------------------------------
# Setup Editor
#
# @param $1 editor: Editor name
#--------------------------------------------------------------------------------
setup_editor()
{
  local editor="$1"
  local editor_home editor_cmd

  if [[ "${editor}" == "vim" ]]; then
    editor_home="${VIM_HOME}"
    editor_cmd="vim"
  else
    editor_home="${NEOVIM_HOME}"
    editor_cmd="nvim"
  fi

  # Create and link directories
  ln -sf "${PWD}/vim" "${editor_home}"

  mkdir -p "${HOME}/.backup"
  mkdir -p "${PWD}/vim/autoload"
  mkdir -p "${PWD}/vim/plugged"

  if [[ "${editor}" == "vim" ]]; then
    setup_vimrc_files
  fi

  # Install plugins
  download_plugin_manager "${PWD}/vim/autoload"

  ${editor_cmd} +PlugInstall +qall
}


#--------------------------------------------------------------------------------
# Setup Shell
#--------------------------------------------------------------------------------
setup_shell()
{
  link_dotfile "inputrc"
  link_dotfile "bashrc"
  link_dotfile "bash_profile"
}


#--------------------------------------------------------------------------------
# Install dotfiles.
#
# @param $1 editor: Editor name.
#--------------------------------------------------------------------------------
main()
{
  local editor="$1"

  # Setup Bash
  setup_shell

  # Setup either vim or neovim
  if [[ -n "${editor}" ]]; then
    if [[ "${editor}" == "vim" || "${editor}" == "neovim" ]]; then
      setup_editor "${editor}"
    else
      echo 1>&2 "Error: editor ${editor} not supported for install."
      exit 1
    fi
  fi
}


main "$@"

