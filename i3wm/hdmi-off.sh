#!/bin/bash
# vim: ft=bash
# Detect DP Monitor# (My GPU has 5 DP inputs)
MON="$(xrandr --properties | awk '/DisplayPort-/ &&  !/disconnected/ {print $1}')"

xrandr --output HDMI-A-0 --off \
    --output "$MON" --primary --mode 1920x1080 --pos 0x0 --rotate normal

~/Github/scripts/i3wm/bar-launch.sh "$MON"
