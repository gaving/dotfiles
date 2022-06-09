require("impatient").enable_profile()
require("bootstrap")
require("deps")

-- enable filetype.lua
vim.g.do_filetype_lua = 1

-- map leader key to comma
vim.g.mapleader = ","
vim.g.maplocalleader = "<Space>"

-- order matters
vim.cmd [[
runtime! lua/modules/options.lua
runtime! lua/modules/util.lua
runtime! lua/modules/mappings.lua
runtime! lua/modules/statusline.lua
]]

vim.cmd [[ colorscheme yellow-moon ]]
