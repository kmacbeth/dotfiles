"""
" File: init_plugins.vim
" Author: Martin Lafreniere
" Date: 2018-12-26
"
" Initialize neovim plugins
"
" Free to use, modify or distribute. No warranties.
"""

" Configure AIRLINE
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_left_sep = '►'
let g:airline_right_sep = '◄'


" Configure RAINBOW PARENS
let g:rainbow_active = 1
let g:rainbow_conf = {}
let g:rainbow_conf['guifgs']      = ['#b58900', '#268bd2', '#cb4b16', '#d33682']
let g:rainbow_conf['ctermfgs']    = ['3', '4', '9', '5']
let g:rainbow_conf['operators']   = '_,_'
let g:rainbow_conf['parentheses'] = ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold']
let g:rainbow_conf['separately']  = { 'cmake': 0 }

" YouCompleteMe
let g:ycm_autoclose_preview_window_after_completion = 1

