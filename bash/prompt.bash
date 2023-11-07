
#-- Colors --
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
            eval "$("$BASE16_SHELL/profile_helper.sh")"

TERM_BLACK='\[\e[0;30m\]'
TERM_RED='\[\e[0;31m\]'
TERM_GREEN='\[\e[0;32m\]'
TERM_YELLOW='\[\e[0;33m\]'
TERM_BLUE='\[\e[0;34m\]'
TERM_MAGENTA='\[\e[0;35m\]'
TERM_CYAN='\[\e[0;36m\]'
TERM_WHITE='\[\e[0;37m\]'
TERM_RESET='\[\e[0m\]'

PS1_START="${TERM_GREEN}\u${TERM_YELLOW}@${TERM_CYAN}\h${TERM_YELLOW}:${TERM_MAGENTA}\w "
export PS2="> "
export PS3="#? "
export PS4="+"

ruby_version()
{
  local rv=$(ruby -e 'puts RUBY_VERSION')
  echo $rv
}

gem_home_top()
{
  local rh=
  if test -n "${GEM_HOME}"
  then
    if [ "${GEM_HOME}" == "${GEM_ROOT}" ]
    then
      rh="system"
    else
      local parent=$(echo ${GEM_HOME} | sed s/\.gem.*$//)
      if test -n "${parent}"
      then 
        rh=$(basename ${parent})
      else
        rh="unknown"
      fi
    fi
  else
    rh="unset"
  fi
  echo $rh
}

promptFunc()
{
  PREV_RET_VAL=$?

  PS1_RUBY=$(ruby_version)
  PS1_GEM=$(gem_home_top)
  PS1_RUBY="${TERM_RED}${PS1_RUBY}@${PS1_GEM} "

  PS1_GIT=$(__git_ps1 "%s ")
  PS1_GIT="${TERM_YELLOW}${PS1_GIT:-}"

  if test $PREV_RET_VAL -eq 0
  then
    PS1="${PS1_START}${PS1_RUBY}${PS1_GIT}${TERM_WHITE}%${TERM_RESET} "
  else
    PS1="${PS1_START}${PS1_RUBY}${PS1_GIT}${TERM_RED}%${TERM_RESET} "
  fi
  export PS1
}

PROMPT_COMMAND=promptFunc

