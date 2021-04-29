#!/usr/bin/env bash

# Change directory to this script.
cd "$(dirname "$0")"

# Generate a Brewfile
HOMEBREW_NO_AUTO_UPDATE=1 brew bundle dump --force
