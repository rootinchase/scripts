#!/bin/bash

hist_file=$(grep -i HISTFILE "$ZDOTDIR/.zshrc" | awk -F= '{print $2}')

new_hist=$(eval echo "$hist_file")

command_run=$( tac "$new_hist" | fzf )

echo "$command_run"

eval "$command_run"
