#!/usr/bin/env bash

# Change directory to this script.
cd "$(dirname "$0")"

# Install everything in the Brewfile.
brew bundle
