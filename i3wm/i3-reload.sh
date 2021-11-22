#!/bin/bash
# vim: ft=bash

# This compiles my i3 config into one file as required by it being a POS
# (Yes, I'm mad at it)
cd "$XDG_CONFIG_HOME"/i3

# Remove current config by deleting and creating a new file
cp ./config ./config.bak
touch ./config

cat ./config.colors ./config.keybinds.* ./config.mode.* ./config.workspaces ./config.workspaces.assign > ./config

# Have i3 reload config
i3-msg reload

