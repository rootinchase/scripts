#!/bin/bash

function lock() {
    i3lock -c 000000 -e -k --pass-media-keys --time-color=ffffff --date-color=ffffff
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
