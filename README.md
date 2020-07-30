# dotfiles
My personal configuration files.

These files are backed up and can be restored using `backupdots.py` in conjunction
with `backupdots.json`.

Make sure to clone this repository with the `--recursive` flag to include all
submodules.

```
usage: backupdots.py [-h] [-p {macOS,Linux,Windows}] [-b] [-r] [-c] [-u]
                     [-t {print,inject}] [--check-platform]
                     [--config-file CONFIG_FILE]

Backup or restore configuration files.

optional arguments:
  -h, --help            show this help message and exit
  -p {macOS,Linux,Windows}, --platform {macOS,Linux,Windows}
                        overrides the current platform to determine which set
                        of files to use. WARNING: This should only be used if
                        the determined platform is wrong!
  -b, --backup          perform a backup based on files in the config file
                        (default: backupdots.json)
  -r, --restore         perform a restore based on files in the config file
                        (default: backupdots.json)
  -c, --cleanup         removes *.orig files
  -u, --unlink          removes all symlinks for the given platform
  -t {print,inject}, --tree {print,inject}
                        generates a directory tree and prints the output to
                        stdout or injects the output into README.md
  --check-platform      checks which platform would be run
  --config-file CONFIG_FILE
                        name of a config file to override backupdots.json
```

<!-- BEGIN TREE -->
```
.
├── Common/
│   ├── misc/
│   │   └── .astylerc
│   ├── neovim/
│   │   └── nvim/
│   │       └── init.vim
│   ├── SublimeText/
│   │   └── UserSettings/
│   │       ├── Package Control.sublime-settings
│   │       ├── Preferences.sublime-settings
│   │       └── Python.sublime-settings
│   ├── tmux/
│   │   └── .tmux.conf
│   ├── vim/
│   │   ├── .gvimrc
│   │   ├── .ideavimrc
│   │   ├── .vim/
│   │   │   └── pack/
│   │   │       └── plugins/
│   │   │           └── start/
│   │   │               ├── ayu-vim/
│   │   │               └── vim-commentary/
│   │   ├── vimfiles -> .vim/
│   │   └── .vimrc
│   └── vscode/
│       ├── dump.bat
│       ├── dump.sh*
│       ├── extensions.txt
│       ├── restore.bat
│       ├── restore.sh*
│       └── settings.json
├── Linux/
│   ├── bash/
│   │   ├── .aliases
│   │   └── .bashrc
│   ├── compton/
│   │   └── compton.conf
│   ├── dunst/
│   │   └── dunstrc
│   ├── fontconfig/
│   │   └── conf.d/
│   │       └── 10-symbols.conf
│   ├── Git/
│   │   ├── .gitconfig
│   │   └── .gitignore_global
│   ├── i3/
│   │   └── config
│   ├── i3lock/
│   │   └── lock.sh*
│   ├── i3status/
│   │   └── config
│   ├── polybar/
│   │   ├── config
│   │   └── launch.sh*
│   ├── rofi/
│   │   ├── config
│   │   ├── material.rasi
│   │   └── sidetab.rasi
│   ├── stalonetray/
│   │   └── .stalonetrayrc
│   ├── SublimeText/
│   │   └── Overrides/
│   │       └── Preferences (Linux).sublime-settings
│   ├── systemd/
│   │   └── i3lock.service
│   ├── terminals/
│   │   ├── alacritty/
│   │   │   └── alacritty.yml
│   │   ├── gnome/
│   │   │   ├── Default.dconf
│   │   │   ├── dump.sh*
│   │   │   └── load.sh*
│   │   └── tilix/
│   │       ├── dump.sh*
│   │       ├── load.sh*
│   │       ├── tilix/
│   │       │   └── schemes/
│   │       │       └── default_colors.json
│   │       └── tilix.dconf
│   ├── Wallpapers/
│   │   ├── moon_mower.jpg
│   │   ├── moon_mower.png
│   │   └── ruby_beach.jpg
│   ├── xfce4/
│   │   └── xfconf/
│   │       └── xfce-perchannel-xml/
│   │           └── xfce4-power-manager.xml
│   └── zsh/
│       └── .zshrc
├── macOS/
│   ├── bash/
│   │   ├── .aliases
│   │   ├── .bash_profile
│   │   └── .bashrc
│   ├── fish/
│   │   ├── aliases.fish
│   │   ├── config.fish
│   │   └── functions/
│   │       └── fish_prompt.fish
│   ├── Git/
│   │   ├── .gitconfig
│   │   └── .gitignore_global
│   ├── Homebrew/
│   │   ├── Brewfile
│   │   ├── dump.sh*
│   │   └── restore.sh*
│   ├── Rectangle/
│   │   └── com.knollsoft.Rectangle.plist
│   ├── SublimeText/
│   │   └── Overrides/
│   │       └── Preferences (OSX).sublime-settings
│   ├── terminals/
│   │   ├── alacritty/
│   │   │   └── alacritty.yml
│   │   └── iTermProfiles/
│   │       └── Default/
│   │           ├── com.googlecode.iterm2.plist
│   │           └── iterm2_default.itermcolors
│   └── zsh/
│       └── .zshrc
└── Windows/
    ├── Git/
    │   └── .gitconfig
    └── SublimeText/
        └── Overrides/
            └── Preferences (Windows).sublime-settings

61 directories, 65 files
```
<!-- END TREE -->
