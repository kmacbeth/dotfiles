"""
" File: init.vim
" Author: Martin Lafreniere
" Date: 2018-12-26
"
" Free to use, modify or distribute. No warranties.
"""
scriptencoding utf-8

set cpoptions+=$

" Define which vim directory is in use
if has('win32') || has('win64')
  let g:neovim_home = expand("~/AppData/Local/nvim")
else
  let g:neovim_home = expand("~/.config/nvim")
end

" Buffer/File encoding and formatting
set encoding=utf-8
set fileencoding=utf-8
set fileformats=unix,dos,mac
set fileformat=unix

" Plugins
call plug#begin(g:neovim_home . "/plugged")

Plug 'vim-airline/vim-airline'
Plug 'jlanzarotta/bufexplorer'
Plug 'scrooloose/nerdtree'
Plug 'luochen1990/rainbow'

" Neovim Complete Manager 2
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-syntax' | Plug 'Shougo/neco-syntax'

Plug 'ncm2/ncm2-vim' | Plug 'Shougo/neco-vim'

Plug 'ncm2/ncm2-pyclang'
Plug 'vim-scripts/a.vim'
Plug 'Shougo/neoinclude.vim'
Plug 'octol/vim-cpp-enhanced-highlight', { 'merged': 0 }

Plug 'ncm2/ncm2-jedi'

" Linting & Syntax Checking
Plug 'neomake/neomake'

" Themes
Plug 'morhetz/gruvbox'


call plug#end()

" " Vim colors
set background=dark
colorscheme gruvbox

" Status line, line numbering and command line.
set number
set cmdheight=2
set showcmd
set laststatus=2
set wildmenu

" Completion
set completeopt=noinsert,menuone,noselect

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
if filereadable(g:neovim_home."/init_plugins.vim")
  runtime init_plugins.vim
endif

