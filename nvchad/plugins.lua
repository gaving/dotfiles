local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {
  {
    "alexghergh/nvim-tmux-navigation",
    event = "VeryLazy",
    config = function()
      require('nvim-tmux-navigation').setup {
        disable_when_zoomed = true, -- defaults to false
        keybindings = {
          left = "<C-h>",
          down = "<C-j>",
          up = "<C-k>",
          right = "<C-l>",
          last_active = "<C-\\>",
          next = "<C-Space>",
        }
      }
    end,
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    event = "VeryLazy",
    config = function()
      require("various-textobjs").setup({ useDefaultKeymaps = true })
    end,
  },
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup()
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  {
    "mhinz/vim-sayonara",
    event = "VeryLazy",
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = "VeryLazy",
    config = function ()
      require'alpha'.setup(require'alpha.themes.startify'.config)
    end
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },
  {
    "tummetott/unimpaired.nvim",
    event = "VeryLazy",
    config = function()
      require("unimpaired").setup()
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = overrides.mason
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = overrides.mason
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        "<leader>F",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { { "biomejs" } },
      },
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
    }
  }
}

return plugins
