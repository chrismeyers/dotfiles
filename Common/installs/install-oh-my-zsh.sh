#!/usr/bin/env bash

OH_MY_ZSH_DIR="${ZSH:-$HOME/.oh-my-zsh}"

if [ ! -d "$OH_MY_ZSH_DIR" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi
