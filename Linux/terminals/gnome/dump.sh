#!/usr/bin/env bash

# Change directory to this script.
cd "$(dirname "$0")"

# Get the config from the dconf DB.
profile_guid="b1dcc9dd-5262-4d8d-a863-c897e6d979b9"
dconf dump /org/gnome/terminal/legacy/profiles:/:${profile_guid}/ > Default.dconf
