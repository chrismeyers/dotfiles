#!/usr/bin/env bash

# Change directory to this script.
cd "$(dirname "$0")"

# Install each extension
while read p; do
  code --install-extension $p
done <extensions.txt
