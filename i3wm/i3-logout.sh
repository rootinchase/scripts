#!/bin/bash

prompt=$(printf "No\nYes" | dmenu -i -p "Do you want to log out?")

if [ "$prompt" == "Yes" ]
then
    i3-msg exit
fi