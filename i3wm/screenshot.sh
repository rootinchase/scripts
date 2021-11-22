#!/usr/bin/env bash

scrot "$1" ~/Pictures/Screenshots/Screenshot-%Y-%m-%d%H:%M:%S.png

formatted_date=$(date +%Y-%m-%d%H:%M:%S)
notify-send -u low -t 500 "Screenshot captured" "Screenshot Screenshot-$formatted_date.png taken"
