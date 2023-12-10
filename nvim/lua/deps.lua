require("lazy").setup({
  "alexghergh/nvim-tmux-navigation",
  "AndrewRadev/splitjoin.vim",
  "AndrewRadev/switch.vim",
  "cljoly/telescope-repo.nvim",
  {
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons'
  },
  "andymass/vim-matchup",
  "chaoren/vim-wordmotion",
  "christianchiarulli/nvcode-color-schemes.vim",
  "edkolev/tmuxline.vim",
  "folke/trouble.nvim",
  "folke/zen-mode.nvim",
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    -- config = function()
      -- vim.cmd([[colorscheme tokyonight]])
    -- end,
  },
  "goolord/alpha-nvim",
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
    },
  },
  "iamcco/markdown-preview.nvim",
  "jose-elias-alvarez/null-ls.nvim",
  "jose-elias-alvarez/nvim-lsp-ts-utils",
  "jose-elias-alvarez/typescript.nvim",
  "jparise/vim-graphql",
  "junegunn/vim-easy-align",
  "kachyz/vim-gitmoji",
  {
    "kana/vim-textobj-indent",
    dependencies = {
      "kana/vim-textobj-user",
    },
  },
  {
    "kana/vim-textobj-line",
    dependencies = {
      "kana/vim-textobj-user",
    },
  },
  "kdheepak/lazygit.nvim",
  "lewis6991/gitsigns.nvim",
  "lewis6991/impatient.nvim",
  "lukas-reineke/indent-blankline.nvim",
  "luukvbaal/stabilize.nvim",
  "machakann/vim-sandwich",
  "memgraph/cypher.vim",
  "mhinz/vim-sayonara",
  "neovim/nvim-lspconfig",
  "norcalli/nvim-colorizer.lua",
  "ntpeters/vim-better-whitespace",
  "nvim-lua/plenary.nvim",
  "nvim-lua/popup.nvim",
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  "nvim-telescope/telescope-ui-select.nvim",
  "nvim-telescope/telescope.nvim",
  "nvim-treesitter/nvim-treesitter",
  "nvim-treesitter/nvim-treesitter-textobjects",
  "nvim-treesitter/playground",
  "ruifm/gitlinker.nvim",
  "shortcuts/no-neck-pain.nvim",
  "tami5/sqlite.lua",
  "tmux-plugins/vim-tmux-focus-events",
  "tpope/vim-abolish",
  "tpope/vim-commentary",
  "tpope/vim-dadbod",
  "tpope/vim-dispatch",
  "tpope/vim-eunuch",
  "tpope/vim-fugitive",
  "tpope/vim-projectionist",
  "tpope/vim-repeat",
  "tpope/vim-rhubarb",
  "tpope/vim-rsi",
  "tpope/vim-sensible",
  "tpope/vim-sleuth",
  "tpope/vim-surround",
  "tpope/vim-unimpaired",
  "wellle/targets.vim",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "windwp/nvim-ts-autotag",
  {
    "xolox/vim-colorscheme-switcher",
    dependencies = {
      "xolox/vim-misc",
    },
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
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
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async"
    }
  }
})
