#!/usr/bin/env bash

# Change directory to this script.
cd "$(dirname "$0")"

# Only trigger an install if there are missing extensions.
installed=()
while IFS= read -r line || [[ -n "$line" ]]; do
  installed+=("$line")
done <<< "$(cursor --list-extensions)"

backedup=()
while IFS= read -r line || [[ -n "$line" ]]; do
  backedup+=("$line")
done <<< "$(cat ./extensions.txt)"

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
  cursor --install-extension $l
done <extensions.txt
