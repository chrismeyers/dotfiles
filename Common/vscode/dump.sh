#!/usr/bin/env bash

# Change directory to this script.
cd "$(dirname "$0")"

# Dump installed extensions to file
code --list-extensions > extensions.txt
