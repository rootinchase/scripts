#!/bin/bash

# shellcheck source=/home/rootinchase/Github/scripts/common.sh
source ~/Github/scripts/common.sh

# Kill polybar
polybar-msg cmd quit
sleep 1

if ( grep AuthenticAMD /proc/cpuinfo > /dev/null )
then
    machine="desk"
else
    machine="lap"
fi

# Launch Polybar, using default config location ~/.config/polybar/config
polybar "$machine"_primary 2> /dev/null &

# Get the status of the sometimes disabled HDMI Monitor,
# and only run when needed
if [[ $(polybar -m | wc -l) -eq 2 ]]
then
    polybar "$machine"_secondary 2> /dev/null &
fi

success "Polybar launched..."
