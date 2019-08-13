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
Plug 'Yggdroot/indentLine'

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

" Rust
Plug 'rust-lang/rust.vim'
Plug 'ncm2/ncm2-racer'
"Plug 'racer-rust/vim-racer'

" Tags
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'

" Linting & Syntax Checking
Plug 'neomake/neomake'

" Themes
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'

call plug#end()

" Files and buffers
let g:netrw_banner = 1
let g:netrw_winsize = 20
let g:netrw_liststyle = 3
let g:netrw_localrmdir = 'rm -f'

nnoremap <Leader>fe :Lexplore<CR>

let g:indentLine_color_term = get(g:, 'indentLine_color_term', 239)
let g:indentLine_concealcursor = 'inc'
let g:indentLine_conceallevel = 2
let g:indentLine_fileTypeExclude = ['help', 'man', 'netrw']

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

" Tags
set statusline+=%{gutentags#statusline()}
nnoremap <Leader>tt :TagbarToggle<CR>

" Themes
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_left_sep = '►'
let g:airline_right_sep = '◄'

set background=dark
colorscheme gruvbox
