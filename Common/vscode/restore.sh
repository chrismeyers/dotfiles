#!/usr/bin/env bash

# Change directory to this script.
cd "$(dirname "$0")"

# Check if program argument is provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 [vscode|cursor]"
  exit 1
fi

PROGRAM=$1
INPUT_FILE="extensions.${PROGRAM}.txt"

if [ ! -f "$INPUT_FILE" ]; then
  echo "Error: $INPUT_FILE not found"
  exit 1
fi

# Install each extension
while read -r l; do
  case $PROGRAM in
    "vscode")
      code --install-extension "$l"
      ;;
    "cursor")
      cursor --install-extension "$l"
      ;;
  esac
done < "$INPUT_FILE"
