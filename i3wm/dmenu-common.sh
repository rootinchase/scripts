#!/bin/bash

command_run=$( dmenu -i < "$XDG_CONFIG_HOME"/rootinchase/dmenu_cmds )

eval "$command_run"
