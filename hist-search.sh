#!/bin/bash

case $SHELL in
    /usr/bin/zsh|/bin/zsh|/usr/bin/bash|/bin/bash)
        hist_file=$(set | grep HISTFILE | awk -F= '{print $2}');;
    *)
        echo "unsupported shell"
        exit 1;;
esac

# These one's break this, so I can't use them
# shellcheck disable=2046,2116
command_run=$( tac $(echo "$hist_file") | fzf )

eval "$command_run"
