"""
" File: init_plugins.vim
" Author: Martin Lafreniere
" Date: 2019-05-22
"
" Initialize neovim plugins
"
" Free to use, modify or distribute. No warranties.
"""
" Plugins
call plug#begin(g:neovim_home . "/plugged")

" Files and buffers
Plug 'jlanzarotta/bufexplorer'

" General Completion
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-syntax' | Plug 'Shougo/neco-syntax'

" VIM script
Plug 'ncm2/ncm2-vim' | Plug 'Shougo/neco-vim'

" C/C++
Plug 'ncm2/ncm2-pyclang'
Plug 'Shougo/neoinclude.vim'
Plug 'octol/vim-cpp-enhanced-highlight', { 'merged': 0 }

" Python
Plug 'ncm2/ncm2-jedi'

" Linting & Syntax Checking
Plug 'neomake/neomake'

" Themes
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
"Plug 'luochen1990/rainbow'


call plug#end()

" Files and buffers
let g:netrw_banner = 1
let g:netrw_winsize = 20
let g:netrw_liststyle = 3
let g:netrw_localrmdir = 'rm -f'

nnoremap <Leader>fe :Lexplore<CR>


" Completion engine setup
augroup vimrc
autocmd BufEnter * call ncm2#enable_for_buffer()
augroup END

inoremap <expr> <CR> (pumvisible() ? "\<c-y>" : "\<CR>")
inoremap <expr> <tab> (pumvisible() ? "\<c-n>" : "\<tab>")
inoremap <expr> <s-tab> (pumvisible() ? "\<C-p>" : "\<s-tab>")

" C/C++
let g:ncm2_pyclang#library_path = '/usr/lib/x86_64-linux-gnu/libclang-8.so.1'

" Linting and syntax checking
call neomake#configure#automake('nrwi', 500)
let g:neomake_python_exe = '/usr/bin/python3'

" Thmes
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_left_sep = '►'
let g:airline_right_sep = '◄'

" let g:rainbow_active = 1
" let g:rainbow_conf = {}
" let g:rainbow_conf['guifgs']      = ['#b58900', '#268bd2', '#cb4b16', '#d33682']
" let g:rainbow_conf['ctermfgs']    = ['3', '4', '9', '5']
" let g:rainbow_conf['operators']   = '_,_'
" let g:rainbow_conf['parentheses'] = ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold']
" let g:rainbow_conf['separately']  = { 'cmake': 0, 'xml': 0 }

set background=dark
colorscheme gruvbox
