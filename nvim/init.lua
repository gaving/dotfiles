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

require("deps")
require("bootstrap")
require("impatient").enable_profile()

-- Plugins
require("alpha").setup(require'alpha.themes.startify'.config)
require("gitlinker").setup()
require("gitsigns").setup()
require("gitlinker").setup({
  callbacks = {
    ["git.spnet.local"] = require"gitlinker.hosts".get_gitlab_type_url
  },
})
require("nvim-ts-autotag").setup()
require("stabilize").setup()
require("typescript").setup({})
require("nvim-tmux-navigation").setup({
  keybindings = {
    left = "<C-h>",
    down = "<C-j>",
    up = "<C-k>",
    right = "<C-l>",
    last_active = "<C-\\>",
    next = "<C-Space>",
  }
})
require("lualine").setup()

vim.g.do_filetype_lua = 1
vim.g.mapleader = ","
vim.g.maplocalleader = "<Space>"

vim.cmd [[
  runtime! lua/modules/options.lua
  runtime! lua/modules/util.lua
  runtime! lua/modules/mappings.lua
  runtime! lua/modules/statusline.lua
]]

vim.cmd [[
  set completefunc=emoji#complete
]]

-- Make argument objects work with braces (i.e. destructuring)
vim.cmd [[
  autocmd User targets#mappings#user call targets#mappings#extend({
    \ 'a': {'argument': [{'o': '[{([]', 'c': '[])}]', 's': ','}]},
  \ })
]]
