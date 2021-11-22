#!/bin/bash
# vim:filetype=bash

# Detect DP Monitor# (My GPU has 5 DP inputs)
MON="$(xrandr --properties | awk '/DP-/ &&  !/disconnected/ {print $1}')"

xrandr  --output "$MON" --primary --mode 1920x1080 --pos 0x0 --rotate normal\
        --output HDMI-0 --mode 1920x1080 --pos 1920x0 --rotate normal --left-of "$MON"


~/.config/polybar/launch.sh "$DP_MONITOR" > /dev/null 2>&1
