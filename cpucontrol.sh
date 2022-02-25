#!/bin/bash

DEBUG="false"
source "$HOME"/.local/bin/rootin-common-functions

STATE=offline
CPUCORES=$(grep processor /proc/cpuinfo | cut -d: -f 2)

LOWERCORE=1
HIGHERCORE=$(($(grep -c processor /proc/cpuinfo)-1))

# PHYSICALCORES=(false)

function parse_args() {
  # This parses all arguments
  for i in "$@"
  do
    case $i in
      --help)
      help
      ;;
      -l=*|--lowest=*)
      LOWERCORE="${i#*=}"
      if [[ "$DEBUG" = "true" ]]
      then
        echo Lowest core = "$LOWERCORE"
      fi
      ;;
      -h=*|--highest=*)
      HIGHERCORE="${i#*=}"
      if [[ "$DEBUG" = "true" ]]
      then
        echo Highest core = "$HIGHERCORE"
      fi
      ;;
      # -p|--physical)
      # PHYSICALCORES=$(true)
      # if [[ "$DEBUG" = "true" ]]
      # then
      #   echo "PHYSICALCORES=true"
      # fi
      # ;;
      --on)
      STATE=1
      if [[ "$DEBUG" = "true" ]]
      then
        echo "STATE=online"
      fi
      ;;
      --off)
      STATE=0
      if [[ "$DEBUG" = "true" ]]
      then
        echo "STATE=offline"
      fi
      ;;
    esac
  done
  verify_cores
}

function verify_cores() {
  # This will verify that the cores used exist...
  # Make sure that you don't go higher that that which exists, and that lower is
  # lower than the HIGHERCORE

  if ( [[ ! -e /sys/devices/system/cpu/cpu"$HIGHERCORE"/online ]] && [[ ! -e /sys/devices/system/cpu/cpu"$HIGHERCORE"/online ]] )
  then
    error "Invalid cores"
    exit 1
  fi

  if [[ "$HIGHERCORE" -lt "$LOWERCORE" ]]
  then
    error "The lower core is higher then the higher one"
    exit 1
  fi
}

function coretoggle() {
  echo "$STATE" > /sys/devices/system/cpu/cpu"$1"/online
  echo /sys/devices/system/cpu/cpu"$1"/online
}

function coreid() {
  cat /sys/devices/system/cpu/cpu"$1"/topology/core_id
}

function help() {
  printf "
cpucontrol.sh
This script powers on and off cpu cores

cpucontrol.sh [options]

--on : Turns on the specified cores
--off : Turns off the specified cores

-h|--highest=corenum : Specifies the highest core to use
-l|--lowest=corenum : Specifies lowest core to use

\n"
}

function main() {
  parse_args "$@"

  for core in $CPUCORES
  do
    # if $PHYSICALCORES
    # then
    #   core=$(coreid "$core")
    # fi
    if [ "$core" -ge "$LOWERCORE" ] && [ "$core" -le "$HIGHERCORE" ]
    then
      coretoggle "$core"
    fi
  done
}

main "$@"
