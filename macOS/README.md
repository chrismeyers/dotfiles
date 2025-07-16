## macOS configuration files

1. Install [Homebrew](https://brew.sh/)
1. Restore Homebrew packages and casks ([script](Homebrew/restore.sh))
    - Homebrew now supports backing up and restoring VS Code extensions by default. VS Code extensions can also be restored using this [script](../Common/vscode/restore.sh).
1. Restore dotfiles
1. Configure Homebrew installed shells:
    - Add shell path(s) to `/etc/shells`
    - Run `chsh -s /path/to/shell`
1. Install [Oh My Zsh](https://ohmyz.sh/)
1. Install Python, Node.js, and Ruby versions using [Mise](https://mise.jdx.dev/)
