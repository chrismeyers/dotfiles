-- ===========================================================================
-- init.lua - neovim configuration file
-- Author: Chris Meyers
-- NOTE: Some settings taken from https://github.com/nvim-lua/kickstart.nvim
-- ===========================================================================

-- Raise a dialog asking to save if a command fails due to unsaved changes
vim.opt.confirm = true

-- Enable line numbers
vim.opt.number = true

-- Enable spell check by default
vim.opt.spell = true

-- Hide buffers instead of closing them
vim.opt.hidden = true

-- Ignore case unless a capital letter is used
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Open new vertical splits to the right of the current split and new
-- horizontal splits below the current split
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Always display the status line
vim.opt.laststatus = 2

local stl = '%F '                      -- Full path to the file
stl = stl .. '%y'                      -- Filetype of the file
stl = stl .. '[%{&ff}]'                -- Fileformat [unix]/[dos] etc...
stl = stl .. '%r'                      -- Read-only flag
stl = stl .. '%m'                      -- Modified flag
stl = stl .. '%='                      -- Switch to the right side
stl = stl .. ' Line %l:%c of %L (%P)'  -- Location in file
vim.opt.statusline = stl

-- Open file at last cursor position
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function(args)
    local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line('$')
    local not_commit = vim.b[args.buf].filetype ~= 'commit'

    if valid_line and not_commit then
      vim.cmd([[normal! g`"]])
    end
  end,
})

-- Indentation settings
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true

vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  command = 'set expandtab shiftwidth=2 softtabstop=2'
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'make',
  command = 'set noexpandtab shiftwidth=8 tabstop=8'
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  command = 'set noexpandtab shiftwidth=4 tabstop=4'
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  command = 'set expandtab shiftwidth=4 softtabstop=4'
})

-- Enable the mouse everywhere
vim.opt.mouse = 'a'

-- Providers
vim.g.python3_host_prog = vim.fn.expand('~/.pyenv/shims/python3')

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  'tpope/vim-commentary',

  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-storm'
    end,
  },
})
