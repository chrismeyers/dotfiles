#!/usr/bin/env bash

# Change directory to this script.
cd "$(dirname "$0")"

# Dump installed extensions to file.
cursor --list-extensions > extensions.txt
