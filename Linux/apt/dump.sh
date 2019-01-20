#!/usr/bin/env bash

# Change to the directory of this script.
cd "$(dirname "$0")"

if [ ! -d "installed" ]; then
  mkdir installed/
fi

dpkg --get-selections > installed/packages.list
cp /etc/apt/sources.list installed/
rsync -avq --exclude=*.save /etc/apt/sources.list.d installed/
sudo apt-key exportall > installed/repo.keys

