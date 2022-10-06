#!/bin/bash

bin_folder="$HOME/.local/bin"

echo "This script installs the scripts that I have created using shortcuts to $bin_folder according to XDG specs"
echo "It will also ensure that they fall within \$PATH"

# shellcheck disable=SC2088
if [[ $(echo "$PATH" | grep -i "$HOME/.local/bin" > /dev/null || echo invalid) ]]
then
    #TODO write to the config file for $SHELL
    echo "You need to add it to path manually"
fi

# make the folder if it's not there already
if [[ -d $bin_folder ]]
then
    mkdir "$bin_folder"
fi

files=$(cat ./files.txt)
pwd=$(pwd)

for file in files
do
    ln -s $pwd/$(echo $file | cut -d: -f1) $bin_folder/$(echo $file | cut -d: -f2)
done
