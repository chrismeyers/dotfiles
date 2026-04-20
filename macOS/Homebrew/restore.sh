#!/usr/bin/env bash

# Change directory to this script.
cd "$(dirname "$0")"

# Only trigger an install if there are missing packages.
installed=()
while IFS= read -r line || [[ -n "$line" ]]; do
  installed+=("$line")
done <<< "$(./dump.sh --file=-)"

backedup=()
while IFS= read -r line || [[ -n "$line" ]]; do
  backedup+=("$line")
done <<< "$(cat ./Brewfile)"

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
