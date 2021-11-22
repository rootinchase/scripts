#!/bin/bash

# Get cores from /proc/cpuinfo, find the core numbers, and keep only them
cpu_cores=$(grep processor /proc/cpuinfo | cut -d: -f 2)

# For each core in the list, echo the first argument of the script to the right
# place to set
for core in $cpu_cores
do
  echo "$1" > /sys/devices/system/cpu/cpu"$core"/cpufreq/scaling_govorner
done


#TODO Verify that $1 is a valid governor