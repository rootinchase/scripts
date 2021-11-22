#!/bin/bash

prompt=$(printf "No \n Yes" | dmenu -i -p "Do you want to log out?")

if [ "$prompt" == "Yes" ]
then
    i3_msg exit
fi