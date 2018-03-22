[[ -z "${PS1}" ]] && return 0

PATH="${HOME}/bin:${PATH}"

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

  if [[ "${retformat}" == 'basic' ]]; then
    echo "${code}"
  elif [[ "${retformat}" == 'prompt' ]]; then
    echo "\[\033[${code}m\]"
  else
    echo "\033[${code}m"
  fi
}

###############################
###         EDITORS         ###
###############################
export EDITOR="vim"
export VISUAL="${EDITOR}"
_tovim()
{
  local servername="$1"; shift
  gvim --servername "${servername}" --remote-silent "$@"
}
vimdev() { _tovim 'DEV'   "$@"; }

###############################
###       PERMISSIONS       ###
###############################
alias ux='chmod u+x'
alias nx='chmod -x+X'
alias 755='chmod 755'
alias 644='chmod 644'

###############################
###        SEARCHING        ###
###############################
alias grep='grep --color=auto --extended-regexp'
export GREP_COLORS="$(colorize 'bright_green' 'basic')"

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
_set_prompt()
{
  local retcode="$?" prompt

  # Show current directory and previous
  PS1="[\h] $(sed -r 's#.*/(.*/.*)#\1#' <<< "${PWD}")"

  if [[ "${retcode}" -eq 0 ]]; then
    prompt="${prompt}$(colorize 'bright_green' 'prompt')\342\234\223"
  else
    prompt="${prompt}$(colorize 'bright_red' 'prompt')\342\234\227"
  fi
  prompt="${prompt}$(colorize 'default' 'prompt')"

  PS1="${PS1} ${prompt} \$ "
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

