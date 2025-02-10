# dotfiles
My personal configuration files.

These files are backed up and can be restored using `backupdots.py` in conjunction with `backupdots.json`.

Make sure to clone this repository with the `--recursive` flag to include all submodules.

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
│   ├── SublimeText/
│   │   └── UserSettings/
│   │       ├── Package Control.sublime-settings
│   │       ├── Preferences.sublime-settings
│   │       └── Python.sublime-settings
│   ├── misc/
│   │   └── .astylerc
│   ├── neovim/
│   │   └── nvim/
│   │       └── init.vim
│   ├── tmux/
│   │   └── .tmux.conf
│   ├── vim/
│   │   ├── .gvimrc
│   │   ├── .ideavimrc
│   │   ├── .vim/
│   │   │   └── pack/
│   │   │       └── plugins/
│   │   │           └── start/
│   │   │               ├── nord-vim/
│   │   │               └── vim-commentary/
│   │   └── .vimrc
│   └── vscode/
│       ├── dump.bat
│       ├── dump.sh*
│       ├── extensions.txt
│       ├── restore.bat
│       ├── restore.sh*
│       └── settings.json
└── macOS/
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
    ├── terminals/
    │   ├── ghostty/
    │   │   └── config
    │   └── iTermProfiles/
    │       └── Default/
    │           ├── com.googlecode.iterm2.plist
    │           └── iterm2_default.itermcolors
    └── zsh/
        └── .zshrc

31 directories, 35 files
```
<!-- END TREE -->
