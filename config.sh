#!/usr/bin/env bash

# shellcheck source-path=~/.local/bin
source rootin-common-functions

# # #
# Functions
#
function config_exists() {
  if [ ! -f "$conf" ]
  then
    mkdir -p "$conf"
    rmdir "$conf"
    touch "$conf"
    error "You must create the config first"
    edit "$conf"
  fi
}

function parse_index() {
  echo "$2" | grep -n "$1" | cut -d: -f1
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
  cat=$1
  ((cat--))
  filenames=$(jq -r --argjson cat "$cat" ".categories[$cat].config[].name" "$conf") ||exit

  files=$(echo "$filenames" | wc -l)

  if [[ "$files" -eq 1 ]]
  then
    s=0
  else
    s=$(selection "$filenames")
    echo "raw $s"
    ((s--))

  fi
  if [[ "$DEBUG" == "true" ]]
  then
    echo "$s"
  fi
  final_file=$(eval echo "$(jq -r --argjson cat "$cat" --argjson s "$s" ".categories[$cat].config[$s].file" "$conf")")
  if [[ "$DEBUG" == "true" ]]
  then
    echo "$final_file"
  fi
  edit "$final_file"

}

conf="$XDG_CONFIG_HOME/rootinchase/config_list.json"


config_exists && list_categories
