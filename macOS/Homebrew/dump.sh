#!/usr/bin/env bash

# Change directory to this script.
cd "$(dirname "$0")"

# Generate a Brewfile
brew bundle dump --force
