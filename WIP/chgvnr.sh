#!/bin/bash

# Get cores from /proc/cpuinfo, find the core numbers, and keep only them
cpu_cores=$(grep processor /proc/cpuinfo | cut -d: -f 2)
GOV="$1"

function set_gov() {
    # For each core in the list, echo the first argument of the script to the right
    # place to set
    for core in $cpu_cores; do
        echo "$GOV" >/sys/devices/system/cpu/cpu"$core"/cpufreq/scaling_govorner
    done
}

function is_valid_governor() {
    available=$(cat cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors)
    for test in $available; do
        if [ "$test" == "$GOV" ]; then
            valid=$(true)
            break
        fi
    done
    return "$valid"
}

if is_valid_governor
then
    set_gov
else
    error "Invalid Governor selected"
fi
