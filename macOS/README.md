## macOS configuration files

1. Restore dotfiles
    1. Grant Full Disk Access to Terminal.app
    1. Run `./backupdots.py -r --skip-hooks`
    1. Restart the terminal
    1. Run `./backupdots.py -r`
1. Configure Homebrew installed shells:
    - Add shell path(s) to `/etc/shells`
    - Run `chsh -s /path/to/shell`
1. Install Python, Node.js, and Ruby versions using [Mise](https://mise.jdx.dev/)
