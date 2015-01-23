" User1 is set for contrasting some information from the statusline
if exists("g:colors_name") && g:colors_name == 'solarized'
  " Solarized colors:
  "
  " 0 /  8 : Light default background  / Dark default background
  " 1 /  9 : Red background  / orange
  " 2 / 10 : Green background / dark gray
  " 3 / 11 : Yellow background / dark gray
  " 4 / 12 : Blue background / gray foreground
  " 5 / 13 : Pink background / dark blue
  " 6 / 14 : Cyan background / gray foreground
  " 7 / 15 : Light gray background / white foreground
  
  hi User1 ctermbg=4 ctermfg=15 cterm=NONE guibg=#268bd2 guifg=#fdf6e3
else
  hi User1 ctermbg=0 ctermfg=8 cterm=NONE guibg=black guifg=white
endif
  
" Reset statusline, than append
set statusline=
set statusline+=%1*\ %{v:servername}\ %0*
set statusline+=\ %f\ %([%R%M]%)
set statusline+=%=%1*\%(\ %{&filetype}\ %)\%0*
set statusline+=\ :\ %(%{(&fileencoding!=''?&fileencoding:&encoding)}%)
set statusline+=\ :\ %{&fileformat}
set statusline+=\ :\ LN\ %L
set statusline+=\ :\ COL\ %-4.c
"set statusline+=\ :

