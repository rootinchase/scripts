#!/bin/bash
# vim:filetype=bash

# Detect DP Monitor# (My GPU has 5 DP inputs)
MON="$(xrandr --properties | awk '/DisplayPort-/ &&  !/disconnected/ {print $1}')"

xrandr  --output "$MON" --primary --mode 1920x1080 --pos 0x0 --rotate normal\
        --output HDMI-A-0 --mode 1920x1080 --pos 1920x0 --rotate normal --right-of "$MON"


~/Github/scripts/i3wm/bar-launch.sh "$MON" > /dev/null 2>&1
