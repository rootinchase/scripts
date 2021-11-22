#!/bin/bash
# vim: ft=bash                                                                                  
# Detect DP Monitor# (My GPU has 5 DP inputs)
DP_MONITOR=$(xrandr --properties | awk '/DP-/ &&  !/disconnected/ {print $1}')

xrandr --output HDMI-0 --off \
    --output "$DP_MONITOR" --primary --mode 1920x1080 --pos 0x0 --rotate normal

~/.config/polybar/launch.sh "$DP_MONITOR"
