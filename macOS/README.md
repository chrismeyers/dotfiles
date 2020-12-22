## macOS configuration files
1. Install [Homebrew](https://brew.sh/)
1. Restore Homebrew packages and casks ([script](Homebrew/restore.sh))
1. Restore dotfiles
1. Restore VS Code extensions ([script](../Common/vscode/restore.sh))
1. Configure Homebrew installed shells:
    - Add shell path(s) to `/etc/shells`
    - Run `chsh -s /path/to/shell`
1. Install [Oh My Zsh](https://ohmyz.sh/)
1. Install `pyenv` versions defined [here](../Common/misc/.pyenv_versions)
1. Install [Node Version Manager](https://github.com/nvm-sh/nvm#install--update-script)
    - Remove any redundant source lines added to profile files by the install script
