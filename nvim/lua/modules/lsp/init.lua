local lspconfig = require "lspconfig"
local Util = require "modules.util"

-- override handlers
require "modules.lsp.handlers"

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = {
  tsserver = {
    init_options = vim.tbl_deep_extend(
      "force",
      require("nvim-lsp-ts-utils").init_options,
      {
      preferences = {
        importModuleSpecifierEnding = "auto",
        importModuleSpecifierPreference = "shortest",
      },
      documentFormatting = false,
    }
    ),
    settings = {
      completions = {
        completeFunctionCalls = true,
      },
    },
  },
  jsonls = require("modules.lsp.json").config,
  html = {
    cmd = { "vscode-html-language-server", "--stdio" },
  },
  cssls = {
    cmd = { "vscode-css-language-server", "--stdio" },
  },
  pyright = {},
  eslint = {},
  dockerls = {},
  -- grammarly = {},
  -- remark_ls = {},
}

for name, opts in pairs(servers) do
  if type(opts) == "function" then
    opts()
  else
    local client = lspconfig[name]

    client.setup(vim.tbl_extend("force", {
      flags = { debounce_text_changes = 150 },
      on_attach = Util.lsp_on_attach,
      on_init = Util.lsp_on_init,
      capabilities = capabilities,
    }, opts))
  end
end
