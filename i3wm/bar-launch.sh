#!/bin/bash


# Terminate already running bar instances
pkill polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null
do
    sleep 1
done

# Launch Polybar, using default config location ~/.config/polybar/config
polybar primary 2> /dev/null &

# Get the status of the sometimes disabled HDMI Monitor,
# and only run when needed
hdmi_status=$( xrandr --properties | awk '/HDMI-0/ {print $2}' )
if [[ $hdmi_status != "disconnected" ]]
then
    polybar secondary 2> /dev/null &
fi


echo "Polybar launched..."
