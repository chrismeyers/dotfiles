#!/usr/bin/env bash

# Change to the directory of this script.
cd "$(dirname "$0")"

# NOTE: This script hasn't been tested! It may be better to only use the files
# in the installed/ directory as a reference, and manually install the programs
# that are needed.
sudo apt-key add installed/repo.keys
sudo cp -r installed/sources.list* /etc/apt
sudo apt update
sudo dpkg --clear-selections
sudo dpkg --set-selections < installed/packages.list

