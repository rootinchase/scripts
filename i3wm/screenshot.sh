#!/usr/bin/env bash

if [[ $# -gt 0 ]]
then
  scrot "$1" ~/Pictures/Screenshots/Screenshot-%Y-%m-%d%H:%M:%S.png
else
  scrot ~/Pictures/Screenshots/Screenshot-%Y-%m-%d%H:%M:%S.png
fi

formatted_date=$(date +%Y-%m-%d%H:%M:%S)
notify-send -u low -t 500 "Screenshot captured" "Screenshot Screenshot-$formatted_date.png taken"
