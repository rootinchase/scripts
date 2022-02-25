#!/usr/bin/env bash

source /home/rootinchase/.local/bin/rootin-common-functions

# # #
# Functions
#
function config_exists() {
  if [ ! -f "$conf" ]
  then
    touch "$conf"
    error "You must create the config first"
    edit "$conf"
  fi
}

function parse_index() {
  index=$(echo "$2" | grep -n "$1" | cut -d : -f 1)
  echo "$index"
}

function selection() {
  selection=$(search "$1")
  index=$(parse_index "$selection" "$1")
  echo "$index"
}

function list_categories() {
  categories=$(jq -r ".categories[].name" "$conf")
  cats=$( echo "$categories" | wc -l )
  if [[ "$cats" -eq 1 ]]
  then
    list_files 0
  else
    selected=$( selection "$categories" )
    list_files "$selected"
  fi
}

function list_files() {
  # $1 will be the index needed
  cat=$(($1-1))
  filenames=$(jq -r --argjson cat $cat ".categories[$cat].config[].name" "$conf")

  files=$(echo "$filenames" | wc -l)

  if [[ "$files" -eq 1 ]]
  then
    sel=0

  else
    sel=$(( $( selection "$filenames" )-1))

  fi
  file=$(jq -r --argjson cat $cat --argjson sel $sel ".categories[$cat].config[$sel].file" "$conf")
  final_file=$(eval echo "$file")
  edit "$final_file"
}

conf="$XDG_CONFIG_HOME/config_list.json"


config_exists && list_categories
