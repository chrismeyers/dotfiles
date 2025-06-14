#!/usr/bin/env bash

# Change directory to this script.
cd "$(dirname "$0")"

# Check if program argument is provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 [vscode|cursor]"
  exit 1
fi

PROGRAM=$1
OUTPUT_FILE="extensions.${PROGRAM}.txt"

case $PROGRAM in
  "vscode")
    code --list-extensions > "$OUTPUT_FILE"
    ;;
  "cursor")
    cursor --list-extensions > "$OUTPUT_FILE"
    ;;
  *)
    echo "Invalid program. Use 'vscode' or 'cursor'"
    exit 1
    ;;
esac
