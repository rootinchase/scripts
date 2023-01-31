#!/bin/bash
# vim:filetype=bash

# Argument parsing time...
for arg in $@
do
    case $arg in
        --clone|-c)
            CLONE=true
            break

    esac
done

SECONDARY=$(xrandr | grep -A1 DisplayPort |grep -v disconnected | grep -B1 -e"\b3840x2160\b" | cut -d' ' -f1 | head -n1)

# My primary monitor is only 1440p, not 4k, so find the one that isn't 4k
PRIMARY=$(xrandr | grep -i -e "["Displayport","HDMI","VGA","DVI","DP"]-" | grep -v disconnected | grep "${SECONDARY}"|  cut -d' ' -f1 | head -n1)

echo "$PRIMARY" "$SECONDARY"

if [[ CLONE != "true"]]
then
    xrandr  --output "$PRIMARY" --primary --mode 2560x1440 --rotate normal --output "$SECONDARY" --mode 2560x1440 --rotate normal --right-of "$PRIMARY"
else
    xrandr  --output "$PRIMARY" --primary --mode 2560x1440 --rotate normal --output "$SECONDARY" --same-as "$PRIMARY"
fi

# The glories of installing into $PATH
bar-launch
