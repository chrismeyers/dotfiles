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

### Sync Plugins

1. Open Neovim.
1. Run `:PackSync` to sync installed plugins with `nvim-pack-lock.json`.

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
