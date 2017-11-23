# README #

This is my dotfiles.

### Better syntax highlighting in vim for reStructuredText ###

Comment out in syntax/rst.vim:

```vim
syn region  rstLiteralBlock         matchgroup=rstDelimiter
      \ start='::\_s*\n\ze\z(\s\+\)' skip='^$' end='^\z1\@!'
      \ contains=@NoSpell
```

Replace by:

```vim
syn region  rstLiteralBlock         matchgroup=rstDelimiter
      \ start='::\_s*\n\ze' skip='^$' end='^\ze\_S'
      \ contains=@NoSpell
```

### Ubuntu Install ###

```sh
apt-get install build-essential git

```