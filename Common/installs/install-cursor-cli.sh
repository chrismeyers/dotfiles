#!/usr/bin/env bash

if ! command -v agent >/dev/null 2>&1; then
  curl https://cursor.com/install -fsS | bash
fi
