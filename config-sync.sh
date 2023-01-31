#!/bin/bash -
#===============================================================================
#
#          FILE: config-sync.sh
#
#         USAGE: ./config-sync.sh [DIRECTORY]
#
#   DESCRIPTION: This will sync a specified folder in $XDG_CONFIG_HOME for the user to root
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Ryan Chase (), 
#  ORGANIZATION: 
#       CREATED: 12/07/22 06:07:13
#      REVISION:  ---
#===============================================================================

set -o nounset                                  # Treat unset variables as an error

if [ $UID -eq 0 ]
then
    echo "Please run as user, this cannot be run as the user yet"
fi

if [ -d "$XDG_CONFIG_HOME"/"$1" ]
then
    ROOT_CONFIG_DIR=$(sudo env | grep XDG_CONFIG_HOME | \cut -d= -f2 )

    sudo cp -r "$XDG_CONFIG_HOME"/"$1" "$ROOT_CONFIG_DIR"
fi
