vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = true,
  },
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  "nvim-telescope/telescope.nvim",

  {
    "dracula/vim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd [[ colorscheme dracula ]]
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
    },
    config = function()
    end,
  },
  "nvim-lua/plenary.nvim",
  "ThePrimeagen/harpoon",
})

--completion
require("cmp").setup()

--set the LSP
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "powershell_es",  "terraformls", "tflint"}
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
require("lspconfig").lua_ls.setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
	globals = {"vim"}
      }
    }
  }
}

require("lspconfig").powershell_es.setup {
  capabilities = capabilities,
}

require("lspconfig").terraformls.setup{}
require("lspconfig").tflint.setup{}
require("telescope").load_extension('harpoon')
require("harpoon").setup({
  save_on_change = true
})

--set the gutter numbering
vim.wo.relativenumber = true
vim.wo.number = true
vim.wo.numberwidth = 6

vim.o.shiftwidth = 2

--set the colour scheme
vim.o.termguicolors = true

--telescope config
local builtin = require("telescope.builtin")
vim.keymap.set('n','<leader>ff', builtin.find_files, {})
vim.keymap.set('n','<leader>fg', builtin.live_grep, {})
vim.keymap.set('n','<leader>fb', builtin.buffers, {})
vim.keymap.set('n','<leader>fh', builtin.help_tags, {})

--harpoon config
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

vim.keymap.set("n", "1", function() ui.nav_file(1) end)
vim.keymap.set("n", "2", function() ui.nav_file(2) end)
vim.keymap.set("n", "3", function() ui.nav_file(3) end)
vim.keymap.set("n", "4", function() ui.nav_file(4) end)
