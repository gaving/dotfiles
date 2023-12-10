require("mason").setup {
  ui = {
    icons = {
      package_installed = "✓"
    }
  }
}
require("mason-lspconfig").setup {
  ensure_installed = { "lua_ls" },
}

require 'modules.lsp.init'
