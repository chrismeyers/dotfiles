# dotfiles

My personal configuration files.

These files are backed up and can be restored using `backupdots.py` in conjunction with `backupdots.json`.

```
usage: backupdots.py [-h] [-p {macOS,Linux,Windows}] [-b] [-r] [-c] [-u]
                     [-t {print,inject}] [--check-platform]
                     [--config-file CONFIG_FILE]

Backup or restore configuration files

options:
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
./
├── Common/
│   ├── misc/
│   │   └── .astylerc
│   ├── neovim/
│   │   └── nvim/
│   │       ├── init.lua
│   │       └── lazy-lock.json
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
│   └── vscode/
│       ├── dump.bat
│       ├── dump.sh*
│       ├── extensions.txt
│       ├── restore.bat
│       ├── restore.sh*
│       └── settings.json
└── macOS/
    ├── bash/
    │   ├── .aliases
    │   ├── .bash_profile
    │   ├── .bashrc
    │   └── scripts/
    │       ├── madoffice.sh*
    │       └── remote.sh*
    ├── fish/
    │   ├── aliases.fish
    │   ├── config.fish
    │   └── functions/
    │       ├── fish_prompt.fish
    │       └── remote.fish
    ├── Git/
    │   ├── .gitconfig
    │   └── .gitignore_global
    ├── Homebrew/
    │   ├── Brewfile
    │   ├── dump.sh*
    │   └── restore.sh*
    ├── Rectangle/
    │   └── RectangleConfig.json
    ├── SublimeText/
    │   └── Overrides/
    │       └── Preferences (OSX).sublime-settings
    ├── terminals/
    │   ├── ghostty/
    │   │   └── config
    │   └── iTermProfiles/
    │       └── Default/
    │           ├── com.googlecode.iterm2.plist
    │           └── iterm2_default.itermcolors
    └── zsh/
        └── .zshrc

25 directories, 36 files
```
<!-- END TREE -->
