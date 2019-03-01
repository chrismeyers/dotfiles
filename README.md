# dotfiles
My personal configuration files.

These files are backed up and can be restored using backupdots.py in conjunction
with backupdots.json.

```
usage: backupdots.py [-h] [-p {Mac,Linux,Windows}] [-b] [-r] [-c] [-u]
                     [-t {print,inject}] [--check-platform]

Backup or restore configuration files.

optional arguments:
  -h, --help            show this help message and exit
  -p {Mac,Linux,Windows}, --platform {Mac,Linux,Windows}
                        overrides the current platform to determine which set
                        of files to use. WARNING: This should only be used if
                        the determined platform is wrong!
  -b, --backup          perform a backup based on files in backupdots.json
  -r, --restore         perform a restore based on files in backupdots.json
  -c, --cleanup         removes *.orig files
  -u, --unlink          removes all symlinks for the given platform
  -t {print,inject}, --tree {print,inject}
                        generates a directory tree and prints the output to
                        stdout or injects the output into README.md
  --check-platform      checks which platform would be run
```

<!-- BEGIN TREE -->
```
.
├── Common
│   ├── misc
│   │   └── .astylerc
│   ├── neovim
│   │   └── nvim
│   │       └── init.vim
│   ├── SublimeText
│   │   └── UserSettings
│   │       ├── Package Control.sublime-settings
│   │       └── Python.sublime-settings
│   ├── vim
│   │   ├── .gvimrc
│   │   ├── .vim
│   │   │   └── pack
│   │   │       └── plugins
│   │   │           └── start
│   │   │               ├── gruvbox
│   │   │               └── iceberg
│   │   ├── vimfiles -> .vim
│   │   └── .vimrc
│   └── vscode
│       └── settings.json
├── Linux
│   ├── apt
│   │   ├── dump.sh
│   │   ├── installed
│   │   │   ├── packages.list
│   │   │   ├── repo.keys
│   │   │   ├── sources.list
│   │   │   └── sources.list.d
│   │   │       ├── google-chrome.list
│   │   │       ├── jonathonf-ubuntu-gcc-8_1-bionic.list
│   │   │       ├── papirus-ubuntu-papirus-bionic.list
│   │   │       ├── spotify.list
│   │   │       └── sublime-text.list
│   │   └── restore.sh
│   ├── bash
│   │   ├── .aliases
│   │   └── .bashrc
│   ├── compton
│   │   └── compton.conf
│   ├── dunst
│   │   └── dunstrc
│   ├── fontconfig
│   │   └── conf.d
│   │       └── 10-symbols.conf
│   ├── Git
│   │   ├── .gitconfig
│   │   └── .gitignore_global
│   ├── GNOMETerminal
│   │   ├── Default.dconf
│   │   ├── dump.sh
│   │   └── load.sh
│   ├── i3
│   │   └── config
│   ├── i3lock
│   │   └── lock.sh
│   ├── i3status
│   │   └── config
│   ├── polybar
│   │   ├── config
│   │   └── launch.sh
│   ├── rofi
│   │   ├── config
│   │   ├── material.rasi
│   │   └── sidetab.rasi
│   ├── stalonetray
│   │   └── .stalonetrayrc
│   ├── SublimeText
│   │   └── UserSettings
│   │       └── Preferences.sublime-settings
│   ├── systemd
│   │   └── i3lock.service
│   ├── Wallpapers
│   │   ├── moon_mower.jpg
│   │   ├── moon_mower.png
│   │   └── ruby_beach.jpg
│   └── xfce4
│       └── xfconf
│           └── xfce-perchannel-xml
│               └── xfce4-power-manager.xml
├── Mac
│   ├── bash
│   │   ├── .aliases
│   │   ├── .bash_profile
│   │   ├── .bashrc
│   │   └── MCG
│   │       ├── .aliases
│   │       └── .bashrc
│   ├── Git
│   │   ├── .gitconfig
│   │   ├── .gitignore_global
│   │   └── MCG
│   │       └── .gitconfig
│   ├── Homebrew
│   │   ├── Brewfile
│   │   ├── dump.sh
│   │   └── restore.sh
│   ├── iTermProfiles
│   │   └── Default
│   │       ├── com.googlecode.iterm2.plist
│   │       └── iterm2_default.itermcolors
│   ├── LAMP
│   │   ├── Homebrew
│   │   │   └── httpd.conf
│   │   └── MAMP
│   │       ├── httpd-vhosts.conf
│   │       └── templates
│   │           ├── httpd_MAMP_PRO_TEMPLATE.conf
│   │           ├── main_MAMP_PRO_TEMPLATE.cf
│   │           ├── my56_MAMP_PRO_TEMPLATE.cnf
│   │           ├── nginx_MAMP_PRO_TEMPLATE.conf
│   │           └── php7.1.8_MAMP_PRO_TEMPLATE.ini
│   └── SublimeText
│       └── UserSettings
│           ├── Preferences.sublime-settings
│           └── Python3.sublime-build
└── Windows
    ├── Git
    │   └── .gitconfig
    └── SublimeText
        └── UserSettings
            └── Preferences.sublime-settings

57 directories, 66 files
```
<!-- END TREE -->
