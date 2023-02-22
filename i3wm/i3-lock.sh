#!/bin/bash

function lock() {
    i3lock -c 000000 -e -k -f --radius 120 --pass-media-keys --pass-screen-keys --pass-power-keys --pass-volume-keys --date-str="%A, %b %d %Y" --time-color=AA0000 --date-color=ffffff
}

function screen_off() {
    xset dpms force off
}

lock

if [ "$1" == "--now" ]
then
    sleep 0.5
    screen_off
fi
if [ "$1" == "--help" ]
then
    echo "i3-lock
usage: i3-lock [--now]

options:
--now: turn of the screen right away"
fi
