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
  "nvim-lualine/lualine.nvim",
  "nvim-tree/nvim-web-devicons",
  "L3MON4D3/LuaSnip",
  -- "nvim-treesitter/nvim-treesitter"
  "ThePrimeagen/vim-be-good",
  --Dart/Flutter pluggins
  "dart-lang/dart-vim-plugin",
  "thosakwe/vim-flutter",
  "natebosch/vim-lsc",
  "natebosch/vim-lsc-dart",
  "simrat39/rust-tools.nvim"

})

--lua statusline
require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = 'dracula',
    --component_separators = { left = '', right = ''},
    --section_separartors = { left = '', right = ''},
    section_separators = '',
    component_separators = '',
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
--status bar at the top
  winbar = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {{'filename', path = 1}},
    lualine_x = {'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location', {'datetime'}}
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {{'filename', path = 1}},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },

--[[
--status bar at the bottom
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {{'filename', path = 1}},
    lualine_x = {'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location', {'datetime'}}

  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {{'filename', path = 1}},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
]]--
  sections = {},
  inactive_sections = {},
  tabline = {},
  extensions = {}
})

--set the LSP
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "powershell_es",  "terraformls", "tflint", "csharp_ls", "rust_analyzer"}
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

--completion
 --local cmp = require("cmp").setup()
 local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered({"r"}),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'luasnip' }, -- For luasnip users.
      { name = 'nvim_lsp' },
    }, {
      { name = 'buffer' },
    })
  })


  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Set up lspconfig.
--  local capabilities = require('cmp_nvim_lsp').default_capabilities()
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require("lspconfig").powershell_es.setup{}
require("lspconfig").csharp_ls.setup{}
require("lspconfig").rust_analyzer.setup{}
require("lspconfig").tflint.setup({
  capabilities = capabilities
})
require("lspconfig").terraformls.setup{}
vim.api.nvim_create_autocmd({"BufWritePre"}, {
  pattern = {"*.tf", "*.tfvars"},
  callback = function()
    vim.lsp.buf.format()
  end,
})
require("lspconfig").bashls.setup{}


require("telescope").load_extension('harpoon')
require("harpoon").setup({
  save_on_change = true
})

--rust tools
local rt = require("rust-tools")

rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
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

vim.api.nvim_command("highlight Normal guibg=NONE")
vim.api.nvim_command("highlight NonText guibg=NONE")
vim.api.nvim_command("highlight Normal ctermbg=NONE")
vim.api.nvim_command("highlight NonText ctermbg=NONE")
