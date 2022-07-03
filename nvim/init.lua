require("impatient").enable_profile()
require("bootstrap")
require("deps")

require("gitsigns").setup()
require("stabilize").setup()
require("gitlinker").setup()
require("nvim-ts-autotag").setup()

vim.g.do_filetype_lua = 1
vim.g.mapleader = ","
vim.g.maplocalleader = "<Space>"

vim.cmd [[
  runtime! lua/modules/options.lua
  runtime! lua/modules/util.lua
  runtime! lua/modules/mappings.lua
  runtime! lua/modules/statusline.lua
]]

-- Make argument objects work with braces (i.e. destructuring)
vim.cmd [[ autocmd User targets#mappings#user call targets#mappings#extend({
  \ 'a': {'argument': [{'o': '[{([]', 'c': '[])}]', 's': ','}]},
\ }) ]]

vim.cmd [[ colorscheme onedark ]]

-- Let emojis complete
vim.cmd [[ set completefunc=emoji#complete ]]
