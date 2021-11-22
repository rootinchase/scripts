#!/bin/bash

dir=$(pwd)
command_run=$( dmenu -i < "$dir"/dmenu_cmds )

eval "$command_run"
