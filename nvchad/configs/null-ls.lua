local null_ls = require "null-ls"

local b = null_ls.builtins

local sources = {
  b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } },
  b.formatting.biome.with { filetypes = { "js", "jsx", "json" } },
  b.formatting.stylua,
}

null_ls.setup {
  debug = true,
  sources = sources,
}
