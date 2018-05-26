"""
" init.vim
" Author: Martin Lafreniere
"
" Free to use, modify or distribute. No warranties.
"""
scriptencoding utf-8

set cpoptions+=$

" Define which vim directory is in use
if has('win32') || has('win64')
  let g:vim_home = expand("~/AppData/Local/nvim")
else
  let g:vim_home = expand("~/.config/nvim")
end

" Buffer/File encoding and formatting
set encoding=utf-8
set fileencoding=utf-8
set fileformats=unix,dos,mac
set fileformat=unix

" Plugins
call plug#begin(g:vim_home . "/plugged")

Plug 'JulioJu/neovim-qt-colors-solarized-truecolor-only'
Plug 'vim-airline/vim-airline'
Plug 'jlanzarotta/bufexplorer'
Plug 'scrooloose/nerdtree'
Plug 'luochen1990/rainbow'
Plug 'godlygeek/tabular'

call plug#end()

" " Vim colors
set background=dark
colorscheme peachpuff

" Status line, line numbering and command line.
set number
set cmdheight=2
set showcmd
set wildmenu
set laststatus=2

" Set default whitespacings rules
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set list
set listchars=tab:>-,trail:$

" Set default search options
set incsearch
set hlsearch
set ignorecase
set smartcase

" Buffer options
set hidden
set backspace=1

" Text line options
"set textwidth=160
set nowrap
set formatoptions+=cqrn
set formatoptions-=o

" Working Directory
set directory=~/.config/backup
set autochdir

" Error handling
set visualbell t_vb=

" Terminal mouse
set mouse=a

" Map leader
nnoremap <space> <nop>
let mapleader = " "

" Vim settings based on workstation
if filereadable(g:vim_home."/vimrc.local")
  runtime vimrc.local
endif

" Neovim QT GuiFont command
command! -nargs=? GuiFont call rpcnotify(0, 'Gui', 'SetFont', "<args>") | let g:GuiFont = "<args>"
GuiFont Consolas:h11:cANSI
