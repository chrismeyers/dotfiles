#!/usr/bin/env bash

# Change directory to this script.
cd "$(dirname "$0")"

# Only trigger an install if there are missing extensions.
mapfile -t installed <<< "$(code --list-extensions)"
mapfile -t backedup <<< "$(cat ./extensions.txt)"

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

# Install each extension.
while read l; do
  code --install-extension $l
done <extensions.txt
