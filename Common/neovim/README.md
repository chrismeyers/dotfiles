# Neovim

## Plugin Manager

This Neovim config uses the built-in `vim.pack` plugin manager (Neovim 0.12+).

Plugins are declared in `nvim/init.lua` with `vim.pack.add(...)`.

The lockfile is `nvim-pack-lock.json` in the same config directory.
Track this file in Git for reproducible plugin revisions across machines.

### First Run

1. Start Neovim.
1. `vim.pack` installs missing plugins automatically.
1. Review/create `nvim-pack-lock.json` and commit it.

### List Plugins

1. Open Neovim.
1. Run `:PackList` to view installed plugins, active state, and short commit revision.
1. Optionally review `nvim/init.lua` to see declared plugins in `vim.pack.add(...)`.

### Update Plugins

1. Open Neovim.
1. Run `:PackUpdate <plugin-name>` (or multiple names) to update installed plugins.
If no plugin names are passed then all plugins will be updated.
1. Review the update buffer.
1. Confirm with `:write` or cancel with `:quit`.
1. Commit the updated `nvim-pack-lock.json`.

### Delete Plugins

1. Open Neovim.
1. Remove plugin entries from `nvim/init.lua` (`vim.pack.add(...)`) and restart Neovim.
1. Run `:PackDelete <plugin-name>` (or multiple names) to remove installed plugins.
1. Commit any changes to `nvim/init.lua` and `nvim-pack-lock.json`.

### Optional telescope-fzf-native Build

`nvim-telescope/telescope-fzf-native.nvim` is optional.

If `make` exists, build runs automatically on `PackChanged` install/update events.
If build fails or `make` is unavailable, Telescope still works without this extension.

### Installing on Windows

Update versions below as necessary.

1. Download and run Build Tools for Visual Studio 2026 (https://aka.ms/vs/stable/vs_BuildTools.exe)
1. Install the following Individual Components:
    1. C++/CLI support (Latest MSVC)
    1. MSVC Build Tools for x64/x86 (Latest)
    1. Windows 11 SDK (10.0.26100.7705)
1. Launch `Developer PowerShell for VS` and run `nvim` to install and build plugins

Running `nvim` from `Developer PowerShell for VS` is only needed when installing or updating plugins that trigger a build.
Regular usage of `nvim` can be done in a normal terminal.
