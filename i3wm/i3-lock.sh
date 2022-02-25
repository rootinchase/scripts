#!/bin/bash

function lock() {
    i3lock -c 000000 -e -k --pass-media-keys --time-color=ffffff --date-color=ffffff
}

function screen_off() {
    xset dpms force off
}

if [ "$1" == "-now" ]
then
    sleep 0.5
    screen_off
fi
lock
