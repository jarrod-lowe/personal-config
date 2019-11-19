#!/bin/bash
# run with source
# set -eu causes bash to die under some circumstances I can't see (because
# the shell disappears)
alarm_time=5

function timer_start {
  timer="${timer:-$SECONDS}"
}

function timer_stop {
  time_taken="$(( SECONDS - $timer ))"
  if [ "${time_taken}" -ge "${alarm_time}" ] ; then
    #timer_show='ALERT\a'${RANDOM}
    echo -ne '\a'
    timer_show=''
  else
    timer_show=''
  fi
  unset time_taken
  unset timer
}

trap 'timer_start' DEBUG

function get_git_branch {
    local TITLE=""
    if git branch >/dev/null 2>/dev/null ; then
      GIT_BRANCH="$(git branch | awk '$1=="*"{print $2;}')"
      # if [ "${TERM}" = "screen" ] || [ "${TERM}" = "xterm-256color" ] ; then
      #   # Screen or tmux
      #   echo -ne "\033k${GIT_BRANCH}\033\\"
      # fi
      # if [ "${TERM}" = "xterm" ] ; then
      #   # How do we emit a title in xterm?
      #   :
      # fi
      if [ ! -z "${TMUX}" ] ; then
        TITLE="${GIT_BRANCH}"
      fi
    else
      GIT_BRANCH=""
    fi

    if [ ! -z "${TMUX_TITLE}" ] ; then
      TITLE="${TMUX_TITLE}"
    fi
    if [ ! -z "${TITLE}" ] ; then
      echo -ne "\033k${TITLE}\033\\"
    fi
}

PROMPT_COMMAND="get_git_branch ; timer_stop"

# Colour prompts
  PS1='$(
    rc=$?
    echo -ne "${timer_show}"
    timer_show=''
    echo -n "\[\033[01;33m\]$(date +%H:%M:%S) "
    if [ "$rc" -ne "0" ] ; then
      echo -n "\[\033[01;31m\]${rc} "
    else
      echo -n "\[\033[01;00m\]${rc} "
    fi
    if [ "$EUID" -ne "0" ] ; then
      echo -n "\[\033[01;32m\]\u@"
    else
      echo -n "\[\033[01;31m\]\u@"
    fi
    if [ "${FVX-}" != "No FVX" -a "${FVX-}" != "" ] ; then
      if [ "$OWNER" == "$USER" ] ; then
        echo -n "\[\033[01;32m\]"
      else
        echo -n "\[\033[01;31m\]"
      fi
      echo -n "[$FVX]"
      echo -n "\[\033[00m\]"
    else
      hostname="${HOSTNAME}"
      if [ "${#hostname}" -gt 10 ] ; then
        hostname="${hostname:0:9}…"
      fi
      echo -n "${hostname}"
      echo -n "\[\033[00m\]"
    fi
    if [ ! -z "${GIT_BRANCH}" ] ; then
        echo -n "\[\033[01;36m\]"
        echo -n "[${GIT_BRANCH}]"
        echo -n "\[\033[00m\]"
    fi
    #if [ -n "${VIRTUAL_ENV}" ] ; then
    #  echo -n "\[\033[01;33m\][$(basename "${VIRTUAL_ENV}")]"
    #fi
    if [ ! -z "${OS_PROJECT_NAME}" ] ; then
        echo -n "\[\033[01;95m\]"
        echo -n "{${OS_PROJECT_NAME}}"
        echo -n "\[\033[00m\]"
    fi
    echo -n ":"
    if [ ! -z "${GIT_BRANCH}" ] && [ ! -z "${OS_PROJECT_NAME}" ] ; then
      echo "\n\r" # newline
    fi
    )\[\033[01;36m\]\w \$\[\033[00m\] '

