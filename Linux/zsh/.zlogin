#!/bin/bash

# Enable dark mode
export GTK_THEME=Adwaita:dark
export GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc
export QT_STYLE_OVERRIDE=Adwaita-Dark

if [ "$(tty)" = "/dev/tty1" ]; then
  exec Hyprland
fi
