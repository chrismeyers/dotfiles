# Neovim

## Plugin Manager

This Neovim config uses the built-in `vim.pack` plugin manager (Neovim 0.12+).

Plugins are declared in `nvim/init.lua` with `vim.pack.add(...)`.

The lockfile is `nvim-pack-lock.json` in the same config directory.
Track this file in Git for reproducible plugin revisions across machines.

### First Run

1. Start Neovim.
2. `vim.pack` installs missing plugins automatically.
3. Review/create `nvim-pack-lock.json` and commit it.

### List Plugins

1. Open Neovim.
2. Run `:PackList` to view installed plugins, active state, and short commit revision.
3. Optionally review `nvim/init.lua` to see declared plugins in `vim.pack.add(...)`.

### Update Plugins

1. Open Neovim.
2. Run `:PackUpdate <plugin-name>` (or multiple names) to update installed plugins.
If no plugin names are passed then all plugins will be updated.
3. Review the update buffer.
4. Confirm with `:write` or cancel with `:quit`.
5. Commit the updated `nvim-pack-lock.json`.

### Delete Plugins

1. Open Neovim.
2. Remove plugin entries from `nvim/init.lua` (`vim.pack.add(...)`) and restart Neovim.
3. Run `:PackDelete <plugin-name>` (or multiple names) to remove installed plugins.
4. Commit any changes to `nvim/init.lua` and `nvim-pack-lock.json`.

### Optional telescope-fzf-native Build

`nvim-telescope/telescope-fzf-native.nvim` is optional.

If `make` exists, build runs automatically on `PackChanged` install/update events.
If build fails or `make` is unavailable, Telescope still works without this extension.
