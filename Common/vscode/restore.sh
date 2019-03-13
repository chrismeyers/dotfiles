#!/usr/bin/env bash

# Change directory to this script.
cd "$(dirname "$0")"

# Install each extension
while read l; do
  code --install-extension $l
done <extensions.txt
