# dotfiles

My personal configuration files.

These files are backed up and can be restored using `backupdots.py` in conjunction with `backupdots.json`.

```
usage: backupdots.py [-h] [-p {Linux,macOS,Windows}] [-b] [-r] [-c] [-u]
                     [-t {print,inject}] [--check-platform]
                     [--config-file CONFIG_FILE] [--skip-hooks]

Backup or restore configuration files

options:
  -h, --help            show this help message and exit
  -p, --platform {Linux,macOS,Windows}
                        overrides the current platform to determine which set of
                        files to use. WARNING: This should only be used if the
                        determined platform is wrong!
  -b, --backup          perform a backup based on files in the config file
                        (default: backupdots.json)
  -r, --restore         perform a restore based on files in the config file
                        (default: backupdots.json)
  -c, --cleanup         removes *.orig files
  -u, --unlink          removes all symlinks for the given platform
  -t, --tree {print,inject}
                        generates a directory tree and prints the output to
                        stdout or injects the output into README.md
  --check-platform      checks which platform would be run
  --config-file CONFIG_FILE
                        name of a config file to override backupdots.json
  --skip-hooks          skips running backup and restore hooks
```

<!-- BEGIN TREE -->
```
./
├── Common/
│   ├── installs/
│   │   ├── install-homebrew.sh*
│   │   └── install-oh-my-zsh.sh*
│   ├── misc/
│   │   └── .astylerc
│   ├── mise/
│   │   ├── .default-gems
│   │   ├── .default-npm-packages
│   │   └── .default-python-packages
│   ├── neovim/
│   │   └── nvim/
│   │       ├── init.lua
│   │       └── nvim-pack-lock.json
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
│   │   └── .vimrc
│   ├── vscode/
│   │   ├── dump.bat
│   │   ├── dump.sh*
│   │   ├── extensions.txt
│   │   ├── restore.bat
│   │   ├── restore.sh*
│   │   └── settings.json
│   └── zed/
│       └── settings.json
├── Linux/
│   ├── bash/
│   │   └── .aliases
│   ├── dunst/
│   │   └── dunstrc
│   ├── Git/
│   │   ├── .gitconfig
│   │   └── .gitignore_global
│   ├── hypr/
│   │   └── hyprland.conf
│   ├── SublimeText/
│   │   └── Overrides/
│   │       └── Preferences (Linux).sublime-settings
│   ├── terminals/
│   │   └── ghostty/
│   │       └── config
│   ├── waybar/
│   │   ├── config.jsonc
│   │   ├── power_menu.xml
│   │   └── style.css
│   └── zsh/
│       ├── .zlogin
│       └── .zshrc
├── macOS/
│   ├── bash/
│   │   └── .aliases
│   ├── Git/
│   │   ├── .gitconfig
│   │   └── .gitignore_global
│   ├── Homebrew/
│   │   ├── Brewfile
│   │   ├── dump.sh*
│   │   └── restore.sh*
│   ├── Rectangle/
│   │   └── RectangleConfig.json
│   ├── SublimeText/
│   │   └── Overrides/
│   │       └── Preferences (OSX).sublime-settings
│   ├── terminals/
│   │   ├── alacritty/
│   │   │   └── alacritty.yml
│   │   ├── ghostty/
│   │   │   └── config
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

41 directories, 49 files
```
<!-- END TREE -->
