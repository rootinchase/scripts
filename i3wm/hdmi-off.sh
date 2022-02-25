#!/bin/bash
# vim: ft=bash
# Detect DP Monitor# (My GPU has 5 DP inputs)
MON="$(xrandr --properties | awk '/DisplayPort-/ &&  !/disconnected/ {print $1}')"

xrandr --output HDMI-A-0 --off \
    --output "$MON" --primary --mode 1920x1080 --pos 0x0 --rotate normal

~/.config/polybar/launch.sh "$DP_MONITOR"
