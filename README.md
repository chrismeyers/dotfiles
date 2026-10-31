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
│   │   ├── install-claude-code.sh*
│   │   ├── install-homebrew.sh*
│   │   └── install-oh-my-zsh.sh*
│   ├── mise/
│   │   ├── .default-npm-packages
│   │   ├── .default-python-packages
│   │   └── config.toml
│   ├── neovim/
│   │   └── nvim/
│   │       ├── init.lua
│   │       └── nvim-pack-lock.json
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
└── macOS/
    ├── bash/
    │   └── .aliases
    ├── git/
    │   ├── .gitconfig
    │   └── .gitignore_global
    ├── homebrew/
    │   ├── Brewfile
    │   ├── dump.sh*
    │   └── restore.sh*
    ├── installs/
    │   └── set-macos-defaults.sh*
    ├── rectangle/
    │   └── RectangleConfig.json
    ├── terminals/
    │   ├── alacritty/
    │   │   └── alacritty.yml
    │   ├── ghostty/
    │   │   └── config
    │   └── iterm2/
    │       └── default/
    │           ├── com.googlecode.iterm2.plist
    │           └── iterm2_default.itermcolors
    └── zsh/
        └── .zshrc

22 directories, 32 files
```
<!-- END TREE -->
