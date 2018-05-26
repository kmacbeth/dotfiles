
VIM_HOME="${TARGET_DIR}/.vim"
NEOVIM_HOME="${TARGET_DIR}/.config/nvim"

editors_setup()
{
  rm -rf "${BASE_DIR}/vim/autoload" "${BASE_DIR}/vim/plugged"
  
  mkdir -p "${TARGET_DIR}/.backup"
  mkdir -p "${BASE_DIR}/vim/autoload"
  mkdir -p "${BASE_DIR}/vim/plugged"

  # Install neovim directory
  not_exists "nvim" || sudo apt-get -y install neovim neovim-qt
  ln -snf "${BASE_DIR}/vim" "${NEOVIM_HOME}"
  
  # Install vim
  not_exists "vim" || sudo apt-get -y install vim vim-gtk3
  ln -snf "${BASE_DIR}/vim" "${VIM_HOME}"

  # Install plugins
  curl -L -o "${BASE_DIR}/vim/autoload/plug.vim" \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 2> /dev/null
       
  vim +PlugInstall +qall
  nvim +PlugInstall +qall
}
