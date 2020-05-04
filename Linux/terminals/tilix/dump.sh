#!/usr/bin/env bash

# Change directory to this script.
cd "$(dirname "$0")"

# Dump the settings
dconf dump /com/gexperts/Tilix/ > tilix.dconf

