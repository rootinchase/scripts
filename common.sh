#!/bin/bash

# Colors!
# Reset
export NC='\033[0m'       # Text Reset
# Regular Colors
export BLACK='\033[0;30m'        # Black
export RED='\033[0;31m'          # Red
export GREEN='\033[0;32m'        # Green
export YELLOW='\033[0;33m'       # Yellow
export BLUE='\033[0;34m'         # Blue
export PURPLE='\033[0;35m'       # Purple
export CYAN='\033[0;36m'         # Cyan
export WWHITE='\033[0;37m'        # White

# Bold
export BBLACK='\033[1;30m'       # Black
export BRED='\033[1;31m'         # Red
export BGREEN='\033[1;32m'       # Green
export BYELLOW='\033[1;33m'      # Yellow
export BBLUE='\033[1;34m'        # Blue
export BPURPLE='\033[1;35m'      # Purple
export BCYAN='\033[1;36m'        # Cyan
export BWWHITE='\033[1;37m'       # White

# Underline
export UBLACK='\033[4;30m'       # Black
export URED='\033[4;31m'         # Red
export UGREEN='\033[4;32m'       # Green
export UYELLOW='\033[4;33m'      # Yellow
export UBLUE='\033[4;34m'        # Blue
export UPURPLE='\033[4;35m'      # Purple
export UCYAN='\033[4;36m'        # Cyan
export UWHITE='\033[4;37m'       # White

# Background
export ON_BLACK='\033[40m'       # Black
export ON_RED='\033[41m'         # Red
export ON_GREEN='\033[42m'       # Green
export ON_YELLOW='\033[43m'      # Yellow
export ON_BLUE='\033[44m'        # Blue
export ON_PURPLE='\033[45m'      # Purple
export ON_CYAN='\033[46m'        # Cyan
export ON_WHITE='\033[47m'       # White

# High Intensity
export IBLACK='\033[0;90m'       # Black
export IRED='\033[0;91m'         # Red
export IGREEN='\033[0;92m'       # Green
export IYELLOW='\033[0;93m'      # Yellow
export IBLUE='\033[0;94m'        # Blue
export IPURPLE='\033[0;95m'      # Purple
export ICYAN='\033[0;96m'        # Cyan
export IWHITE='\033[0;97m'       # White

# Bold High Intensity
export BIBLACK='\033[1;90m'      # Black
export BIRED='\033[1;91m'        # Red
export BIGREEN='\033[1;92m'      # Green
export BIYELLOW='\033[1;93m'     # Yellow
export BIBLUE='\033[1;94m'       # Blue
export BIPURPLE='\033[1;95m'     # Purple
export BICYAN='\033[1;96m'       # Cyan
export BIWHITE='\033[1;97m'      # White

# High Intensity backgrounds
export ON_IBLACK='\033[0;100m'   # Black
export ON_IRED='\033[0;101m'     # Red
export ON_IGREEN='\033[0;102m'   # Green
export ON_IYELLOW='\033[0;103m'  # Yellow
export ON_IBLUE='\033[0;104m'    # Blue
export ON_IPURPLE='\033[0;105m'  # Purple
export ON_ICYAN='\033[0;106m'    # Cyan
export ON_IWHITE='\033[0;107m'   # White

function error() {
    printf "(%bERROR%b) %s\n" "$RED" "$NC" "$@"
}

function debug_msg() {
    printf "(%bDEBUG%b) %s\n" "$YELLOW" "$NC" "$@"
}

function success() {
    printf "(%bSuccess%b) %s\n" "$GREEN" "$NC" "$@"
}

function edit() {
  if is_dmenu
  then
    run_in_terminal "$EDITOR" "$1"
  else
    file="$1"
    "$EDITOR" "$file"
  fi
}

function cd_fail() {
  if [[ -d "$1" ]]
  then
    # Is it read/writeable
    if [[ -w "$1" ]]
    then
      error "Unknown failure accessing $1"
    else
      error "Directory $1, does not have write permissions"
    fi

  else
    mkdir -p "$1" || cd_fail "$1"

  fi
}

function is_dmenu() {
  [[ -z "${TERM+set}" ]]
}

function is_ssh() {
  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]
  then
    SESSION_TYPE=remote/ssh
  # many other tests omitted
  else
    case $(\ps -o comm= -p $PPID) in
      sshd|*/sshd) SESSION_TYPE=remote/ssh;;
    esac
  fi
  [[ -n "${SESSION_TYPE+set}" ]]
}

function is_root() {
    [ "$USER" == "root" ]
}

function is_xorg() {
  if [ -n "$DISPLAY" ]; then
    echo "set"
    return 0
  else
    echo "unset"
    return 1
  fi
}

function run_in_terminal() {
  kitty "$@"
}

function search() {
  if is_dmenu
  then
    echo "$1" | dmenu -i
  else
    echo "$1" | fzf
  fi

}
