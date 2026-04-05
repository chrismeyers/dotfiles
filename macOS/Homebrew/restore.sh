#!/usr/bin/env bash

# Change directory to this script.
cd "$(dirname "$0")"

# Only trigger an install if there are missing packages.
mapfile -t installed <<< "$(./dump.sh --file=-)"
mapfile -t backedup <<< "$(cat ./Brewfile)"

missing=false
for item in "${backedup[@]}"; do
  if [[ ! " ${installed[*]} " =~ " ${item} " ]]; then
    missing=true
    break
  fi
done

if [ "$missing" = false ]; then
  exit 0
fi

# Install everything in the Brewfile.
brew bundle
