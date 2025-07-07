## Linux configuration files

These configuration files target an Arch Linux installation using Hyprland.

1. Install [Arch Linux](https://wiki.archlinux.org/title/Installation_guide)
1. Install [Hyprland](https://hypr.land)
1. Install [yay](https://github.com/Jguer/yay)
1. Install minimum required packages
    - `sudo pacman -S base-devel brightnessctl dunst firefox ghostty git gnome-keyring gnome-themes-extra grim iwd less libnotify libsecret man-db man-pages neovim openssh openssl otf-font-awesome pipewire pipewire-audio python qt5-wayland qt6-wayland seahorse thunar tk tmux tree unzip vim waybar wireplumber wofi xdg-desktop-portal-hyprland xz zlib zsh`
    - `yay -S adwaita-qt5-git adwaita-qt6-git`
1. Restore dotfiles
1. Configure pacman installed shells:
    - Add shell path(s) to `/etc/shells`
    - Run `chsh -s /path/to/shell`
1. Install [Oh My Zsh](https://ohmyz.sh/)
1. Install [pyenv](https://github.com/pyenv/pyenv)
    - Install pyenv versions defined [here](./zsh/.zshrc)
1. Install [fnm](https://github.com/Schniz/fnm)
