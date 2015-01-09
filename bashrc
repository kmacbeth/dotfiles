[[ -z "${PS1}" ]] && return 0

###############################
###        HISTORY          ###
###############################
HISTCONTROL=ignoreboth
HISTSIZE=5000
HISTFILESIZE=10000
shopt -s histappend
alias h='history'
alias hgrep='history | grep'

###############################
###        TERMINAL         ###
###############################
shopt -s checkwinsize

###############################
###          JOBS           ###
###############################
set -o notify

###############################
###      DIRECTORIES        ###
###############################
shopt -s cdable_vars
shopt -s cdspell
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias ls='ls --color=auto'
alias ll='ls -l'

###############################
###        COMMANDS         ###
###############################
shopt -s no_empty_cmd_completion
if [[ "$(uname -s)" = CYGWIN_NT* ]]; then
  shopt -s completion_strip_exe
fi

###############################
###         COLORS          ###
###############################
function colorize
{
  local colorname="$1" retformat="$2" code="0"

  case "${colorname}" in
    clear)          code="0"    ;;
    black)          code="0;30" ;;
    red)            code="0;31" ;;
    green)          code="0;32" ;;
    yellow)         code="0;33" ;;
    blue)           code="0;34" ;;
    magenta)        code="0;35" ;;
    cyan)           code="0;36" ;;
    bright_white)   code="0;37" ;;
    bright_black)   code="1;30" ;;
    bright_red)     code="1;31" ;;
    bright_green)   code="1;32" ;;
    bright_yellow)  code="1;33" ;;
    bright_blue)    code="1;34" ;;
    bright_magenta) code="1;35" ;;
    bright_cyan)    code="1;36" ;;
    bright_white)   code="1;37" ;;
    *)              code="0;39" ;;
  esac

  if [[ -n "${retformat}" ]]; then
    echo "${code}"
  else
    echo "\033[${code}m"
  fi
}

###############################
###         EDITORS         ###
###############################
export EDITOR="vim"
export VISUAL="${EDITOR}"
function _tovim
{
  local servername="$1"; shift

  if gvim --serverlist | grep "${servername}" > /dev/null; then
    gvim --servername "${servername}" --remote "$@"
  else
    gvim --servername "${servername}" "$@"
  fi
}
function vimdev { _tovim 'DEV'   "$@"; }
function pyvim  { _tovim 'PYVIM' "$@"; }

###############################
###       PERMISSIONS       ###
###############################
alias ux='chmod u+x'
alias nx='chmod -x+X'
alias 755='chmod 755'

###############################
###        SEARCHING        ###
###############################
export GREP_OPTIONS='--extended-regexp --color=auto'
export GREP_COLORS="$(colorize 'bright_green')"
function search
{
  local arg
  for arg; do
    echo "====== Result: ${arg} ======"
    find -type f -exec grep -H "${arg}" {} \;
  done
}

###############################
###           CVS           ###
###############################
function cst
{
  cvs status 2> /dev/null \
    | grep 'File:' \
    | awk '{ printf("%-30s %s %s\n", $2":", $4, $5) }'
}
function cco
{
  cvs co -d "$1" "${PROJECT_NAME}/$2"
}

###############################
###        UTILITIES        ###
###############################
alias k='cat'
alias kat='cat --show-all'
function extract
{
  case "$1" in
    *.tar.bz2)
      tar xvjf "$1"   ;;
    *.tar.gz) 
      tar xvzf "$1"   ;;
    *.bz2)    
      bunzip2 "$1"    ;;
    *.rar)    
      unrar x "$1"    ;;
    *.gz)     
      gunzip "$1"     ;;
    *.tar)    
      tar xvf "$1"    ;;
    *.tbz2)   
      tar xvjf "$1"   ;;
    *.tgz)    
      tar xvzf "$1"   ;;
    *.zip)    
      unzip "$1"      ;;
    *.Z)      
      uncompress "$1" ;;
    *)        
      echo "Error: cannot extract '$1' via extract" >&2 ;;
  esac
}

###############################
###      PROMPT THEME       ###
###############################
function _set_prompt
{
  local retcode="$?" prompt

  PS1="[\h] $(sed -r 's#.*/(.*/.*)#\1#' <<< "${PWD}")"
  
  if [[ "${retcode}" -eq 0 ]]; then
    prompt="${prompt}$(colorize 'bright_white')"
  else
    prompt="${prompt}$(colorize 'bright_red')"
  fi
  prompt="${prompt}\$$(colorize 'default')"

  PS1="${PS1} ${prompt} "
}
PROMPT_COMMAND=_set_prompt

###############################
###         SOURCE          ###
###############################

# Make use of bash completion, they are very handy
if [[ -f /etc/bash_completion ]]; then
  source /etc/bash_completion
fi

# Allow some level of customization
if [[ -f ~/.bashrc.extras ]]; then
  source ~/.bashrc.extras
fi

