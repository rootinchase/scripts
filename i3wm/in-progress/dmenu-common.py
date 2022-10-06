#!/usr/bin/python3

from pydymenu import rofi
import os

config_file = os.environ['XDG_CONFIG_HOME'] + "/rootinchase/dmenu_cmds"
commands = list(())

conf = open(config_file, 'r')

for line in conf:
    commands.append(' '.join(line.splitlines()))
    print(line)

selection = rofi(commands, prompt='Command:')

if selection:
    os.system(selection[0])
