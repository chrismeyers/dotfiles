-- ===========================================================================
-- init.lua - neovim configuration file
-- Author: Chris Meyers
-- NOTE: Some settings taken from https://github.com/nvim-lua/kickstart.nvim
-- ===========================================================================

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Raise a dialog asking to save if a command fails due to unsaved changes
vim.o.confirm = true

-- Enable relative line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Enable spell check by default
vim.o.spell = true

-- Hide buffers instead of closing them
vim.o.hidden = true

-- Ignore case unless a capital letter is used
vim.o.ignorecase = true
vim.o.smartcase = true

-- Open new vertical splits to the right of the current split and new
-- horizontal splits below the current split
vim.o.splitright = true
vim.o.splitbelow = true

-- Use system clipboard
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- Always display the status line
vim.o.laststatus = 2

local stl = '%F '                      -- Full path to the file
stl = stl .. '%y'                      -- Filetype of the file
stl = stl .. '[%{&ff}]'                -- Fileformat [unix]/[dos] etc...
stl = stl .. '%r'                      -- Read-only flag
stl = stl .. '%m'                      -- Modified flag
stl = stl .. '%='                      -- Switch to the right side
stl = stl .. ' Line %l:%c/%L (%P)'     -- Location in file
vim.o.statusline = stl

-- Open file at last cursor position
vim.api.nvim_create_autocmd('BufRead', {
  callback = function(opts)
    vim.api.nvim_create_autocmd('BufWinEnter', {
      once = true,
      buffer = opts.buf,
      callback = function()
        local ft = vim.bo[opts.buf].filetype
        local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
        if
          ft ~= 'gitcommit' and ft ~= 'gitrebase'
          and last_known_line > 1
          and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
        then
          vim.api.nvim_feedkeys([[g`"]], 'nx', false)
        end
      end,
    })
  end,
})

-- Indentation settings
vim.o.smarttab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.breakindent = true

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
vim.o.mouse = 'a'

-- Plugins
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup({
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        transparent = true,
      }
      vim.cmd.colorscheme 'tokyonight-storm'
    end,
  },

  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function() return vim.fn.executable 'make' == 1 end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
    },
    config = function()
      require('telescope').setup {
        pickers = {
          find_files = {
            find_command = { 'rg', '--files', '--color=never', '--hidden', '--glob=!**/.git/*' },
          },
          live_grep = {
            additional_args = { '--hidden', '--glob=!**/.git/*' },
          },
          grep_string = {
            additional_args = { '--hidden', '--glob=!**/.git/*' },
          },
        },
        extensions = {
          ['ui-select'] = { require('telescope.themes').get_dropdown() },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Override default behavior and theme when searching
      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set(
        'n',
        '<leader>s/',
        function()
          builtin.live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end,
        { desc = '[S]earch [/] in Open Files' }
      )

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })
    end,
  },
})
