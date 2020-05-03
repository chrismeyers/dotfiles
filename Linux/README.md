## Linux configuration files
These configuration files were originally created when using Ubuntu 18.04.1. Many of these configuration files should work on other Linux distributions, but some may have to be tweaked.
  + GTK appearance:
    + i3 configured with LXAppearance:
      * Widgets: [Arc-Dark](https://github.com/horst3180/arc-theme)
      * Cursor: DMZ-White
      + Icons: [Papirus-Dark](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)
        * Folders: [Papirus Folders](https://github.com/PapirusDevelopmentTeam/papirus-folders) - bluegrey
    + GNOME configured with gnome-tweak-tool (`gnome-tweaks`):
      * Widgets: Adwaita-dark
      * Cursor: DMZ-White
      * Icons: LoginIcons
  + Notifications are handled in i3 using [`dunst`](https://dunst-project.org/)
  + Power management is handled in i3 using `xfce4-power-manager` and `xbacklight`
    * Polybar uses xbacklight to display screen brightness
  + If xbacklight doesn't work after installing, modify `/usr/share/X11/xorg.conf.d/20-intel.conf` (create file if needed) to contain:
    ```
    Section "Device"
    	Identifier "0x42" # determined by running: xrandr --verbose
    	Driver "intel"
    	Option "Backlight" "intel_backlight" # 2nd argument determined by running: ls -1 /sys/class/backlight
    EndSection
    ```
  + To enter deep sleep on suspend, modify `/etc/default/grub` to have:
    * `GRUB_CMDLINE_LINUX_DEFAULT="quiet splash mem_sleep_default=deep"`
    * To apply changes, run: `sudo update-grub`
  + Programs built from source:
    + i3-gaps
      * [Repository](https://github.com/Airblader/i3)
      * [Installation Guide](https://github.com/Airblader/i3/wiki/Compiling-&-Installing)
    + Vim
      * [Repository](https://github.com/vim/vim)
      * [Installation Guide](https://github.com/Valloric/YouCompleteMe/wiki/Building-Vim-from-source)
    + Neovim
      * [Repository](https://github.com/neovim/neovim)
      * [Installation Guide](https://github.com/neovim/neovim/wiki/Building-Neovim)
    + Polybar
      * [Repository](https://github.com/jaagr/polybar)
      * [Installation Guide](https://github.com/jaagr/polybar/wiki/Compiling)
    + Python
      * [Repository](https://github.com/python/cpython)
      * [Installation Guide](https://github.com/chrismeyers/trumppet/blob/master/README.md#additional-information)
