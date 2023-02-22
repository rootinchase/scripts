#!/bin/bash

if [[ $UID != 0 ]]
then
    echo "Please run as root"
    exit 1
fi

arch=$(eselect profile show | awk -F "/" ' /linux/ {print "~"$3}')

echo "$1" "$arch" >> /etc/portage/package.accept_keywords/new

sort -u -o /etc/portage/package.accept_keywords/new /etc/portage/package.accept_keywords/new

