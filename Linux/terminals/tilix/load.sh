#!/usr/bin/env bash

# Change directory to this script.
cd "$(dirname "$0")"

# Load the settings
dconf load /com/gexperts/Tilix/ < tilix.dconf

