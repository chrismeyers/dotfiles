-- ===========================================================================
-- init.lua - neovim configuration file
-- Author: Chris Meyers
-- NOTE: Some settings taken from https://github.com/nvim-lua/kickstart.nvim
-- ===========================================================================

-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Raise a dialog asking to save if a command fails due to unsaved changes
vim.o.confirm = true

-- Enable relative line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Always show sign column
vim.o.signcolumn = "yes:2"

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
vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)

-- Open file at last cursor position
vim.api.nvim_create_autocmd("BufRead", {
  callback = function(opts)
    vim.api.nvim_create_autocmd("BufWinEnter", {
      once = true,
      buffer = opts.buf,
      callback = function()
        local ft = vim.bo[opts.buf].filetype
        local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
        if
          ft ~= "gitcommit"
          and ft ~= "gitrebase"
          and last_known_line > 1
          and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
        then
          vim.api.nvim_feedkeys([[g`"]], "nx", false)
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

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  command = "set expandtab shiftwidth=2 softtabstop=2",
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "make",
  command = "set noexpandtab shiftwidth=8 tabstop=8",
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  command = "set noexpandtab shiftwidth=4 tabstop=4",
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  command = "set expandtab shiftwidth=4 softtabstop=4",
})

-- Enable the mouse everywhere
vim.o.mouse = "a"

-- Diagnostics
vim.diagnostic.config({
  float = {
    source = "always",
  },
})

-- Plugins
vim.api.nvim_create_user_command("PackList", function()
  local formatted = "Installed plugins:\n"
  vim.iter(vim.pack.get()):each(function(plugin)
    formatted = formatted
      .. (plugin.active and "  [✓]" or "  [✗]")
      .. " "
      .. plugin.spec.name
      .. " ("
      .. plugin.rev:sub(1, 7)
      .. ")\n"
  end)
  vim.notify(vim.trim(formatted))
end, { desc = "List plugins installed with vim.pack" })

vim.api.nvim_create_user_command("PackUpdate", function(opts)
  if vim.tbl_isempty(opts.fargs) then
    vim.pack.update()
  else
    vim.pack.update(opts.fargs)
  end
end, {
  desc = "Update plugins installed with vim.pack",
  nargs = "*",
  complete = function(arg_lead)
    return vim
      .iter(vim.pack.get())
      :filter(function(plugin)
        return plugin.spec.name:find(arg_lead, 1, true) == 1
      end)
      :map(function(plugin)
        return plugin.spec.name
      end)
      :totable()
  end,
})

vim.api.nvim_create_user_command("PackSync", function()
  vim.pack.update(nil, { target = "lockfile" })
end, {
  desc = "Sync plugins installed with vim.pack to nvim-pack-lock.json",
})

vim.api.nvim_create_user_command("PackDelete", function(opts)
  vim.pack.del(opts.fargs)
end, {
  desc = "Delete plugins installed with vim.pack",
  nargs = "+",
  complete = function(arg_lead)
    return vim
      .iter(vim.pack.get())
      :filter(function(plugin)
        return plugin.spec.name:find(arg_lead, 1, true) == 1
      end)
      :map(function(plugin)
        return plugin.spec.name
      end)
      :totable()
  end,
})

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, path, kind = ev.data.spec.name, ev.data.path, ev.data.kind

    if name == "telescope-fzf-native.nvim" and (kind == "install" or kind == "update") then
      if vim.fn.executable("make") ~= 1 then
        return
      end

      vim.system({ "make" }, { cwd = path }, function(obj)
        if obj.code ~= 0 then
          vim.schedule(function()
            vim.notify("telescope-fzf-native.nvim build failed:\n" .. (obj.stderr or ""), vim.log.levels.WARN)
          end)
        end
      end)
    end

    if name == "nvim-treesitter" and kind == "update" then
      local ok = pcall(vim.cmd, "TSUpdate")
      if not ok then
        vim.notify(":TSUpdate failed!", vim.log.levels.WARN)
      end
    end
  end,
})

--- tokyonight.nvim
vim.pack.add({ "https://github.com/folke/tokyonight.nvim" })
require("tokyonight").setup({
  transparent = true,
})
vim.cmd.colorscheme("tokyonight-storm")

--- which-key.nvim
vim.pack.add({ "https://github.com/folke/which-key.nvim" })
require("which-key").setup({
  delay = 0,
  spec = {
    { "<leader>s", group = "[S]earch", mode = { "n", "v" } },
    { "<leader>t", group = "[T]oggle" },
    { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
    { "gr", group = "LSP Actions", mode = { "n" } },
  },
})

--- telescope.nvim
vim.pack.add({
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-telescope/telescope-ui-select.nvim",
  "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
})
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    require("telescope").setup({
      pickers = {
        find_files = {
          find_command = { "rg", "--files", "--color=never", "--hidden", "--glob=!**/.git/*" },
        },
        live_grep = {
          additional_args = { "--hidden", "--glob=!**/.git/*" },
        },
        grep_string = {
          additional_args = { "--hidden", "--glob=!**/.git/*" },
        },
      },
      extensions = {
        ["ui-select"] = { require("telescope.themes").get_dropdown() },
      },
    })

    -- Keep fzf-native optional.
    if vim.fn.executable("make") == 1 then
      pcall(require("telescope").load_extension, "fzf")
    end
    pcall(require("telescope").load_extension, "ui-select")

    -- See `:help telescope.builtin`
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
    vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
    vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
    vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
    vim.keymap.set({ "n", "v" }, "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
    vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
    vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
    vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
    vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

    -- Override default behavior and theme when searching
    vim.keymap.set("n", "<leader>/", function()
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = "[/] Fuzzily search in current buffer" })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set("n", "<leader>s/", function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      })
    end, { desc = "[S]earch [/] in Open Files" })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set("n", "<leader>sn", function()
      builtin.find_files({
        cwd = vim.fn.stdpath("config"),
      })
    end, { desc = "[S]earch [N]eovim files" })
  end,
})

--- gitsigns.nvim
vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })
require("gitsigns").setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
  sign_priority = 20,
  on_attach = function(bufnr)
    local gitsigns = require("gitsigns")

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end, { desc = "Next Git Hunk" })

    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end, { desc = "Previous Git Hunk" })

    -- Actions
    map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage Hunk" })
    map("v", "<leader>hs", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Stage Hunk" })
    map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage Buffer" })

    map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset Hunk" })
    map("v", "<leader>hr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Reset Hunk" })
    map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset Buffer" })

    map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview Hunk" })
    map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Preview Hunk Inline" })

    map("n", "<leader>hb", function()
      gitsigns.blame_line({ full = true })
    end, { desc = "Blame Line" })

    map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff Index" })
    map("n", "<leader>hD", function()
      gitsigns.diffthis("~")
    end, { desc = "Diff HEAD~" })

    -- Toggles
    map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle current line blame" })
    map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Toggle word diff" })

    -- Text object
    map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Select Git Hunk" })
  end,
})

--- nvim-treesitter
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })
require("nvim-treesitter").setup({
  -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
  install_dir = vim.fn.stdpath("data") .. "/site",
})

require("nvim-treesitter").install({
  "astro",
  "bash",
  "cpp",
  "css",
  "go",
  "html",
  "javascript",
  "json",
  "python",
  "typescript",
})

--- LSP
vim.pack.add({
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  "https://github.com/neovim/nvim-lspconfig",
})
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "astro", -- Astro
    "gopls", -- Go
    "lua_ls", -- Lua
    "ty", -- Python
    "vtsls", -- TypeScript/JavaScript
  },
  automatic_enable = true,
})
require("mason-tool-installer").setup({
  ensure_installed = {
    "goimports", -- Go formatter
    "luacheck", -- Lua linter
    "prettier", -- TypeScript/JavaScript formatter
    "ruff", -- Python formatter + linter
    "stylua", -- Lua formatter
  },
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

vim.lsp.log.set_level("off")

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open Diagnostic Float" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open Diagnostic List" })
vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })

--- blink.cmp
vim.pack.add({ { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") } })
require("blink.cmp").setup({
  keymap = {
    preset = "enter",
    ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
  },
  signature = {
    enabled = true,
  },
  completion = {
    accept = {
      auto_brackets = {
        enabled = false,
      },
    },
  },
})

--- conform.nvim
vim.pack.add({ "https://github.com/stevearc/conform.nvim" })
require("conform").setup({
  formatters_by_ft = {
    astro = { "prettier" },
    go = { "goimports" },
    javascript = { "prettier" },
    lua = { "stylua" },
    python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },
    typescript = { "prettier" },
  },
  formatters = {
    prettier = {
      prepend_args = { "--single-quote", "--trailing-comma", "es5", "--config-precedence", "prefer-file" },
    },
    stylua = {
      prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
    },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})

--- nvim-lint
vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })
require("lint").linters_by_ft = {
  astro = { "eslint" },
  javascript = { "eslint" },
  lua = { "luacheck" },
  typescript = { "eslint" },
}

vim.api.nvim_create_autocmd({ "BufWinEnter", "BufWritePost", "BufReadPost", "InsertLeave" }, {
  callback = function()
    require("lint").try_lint(nil, { ignore_errors = true })
  end,
})
