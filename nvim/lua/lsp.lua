local lspconfig = require("lspconfig")

local util = lspconfig.util
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.handlers["textDocument/formatting"] = function(err, _, result, _, bufnr)
    if err ~= nil or result == nil then
        return
    end
    if not vim.api.nvim_buf_get_option(bufnr, "modified") then
        local view = vim.fn.winsaveview()
        vim.lsp.util.apply_text_edits(result, bufnr)
        vim.fn.winrestview(view)
        if bufnr == vim.api.nvim_get_current_buf() then
            vim.api.nvim_command("noautocmd :update")
        end
    end
end

local on_attach = function(_, bufnr)
    require("completion").on_attach()
    local function bufnoremap(type, input, output)
        vim.api.nvim_buf_set_keymap(bufnr, type, input, output, {noremap = true, silent = true})
    end
    bufnoremap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>")
    bufnoremap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>")
    bufnoremap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")
    bufnoremap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
    bufnoremap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>")
    bufnoremap("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>")
    bufnoremap("n", "<Space>a", "<cmd>lua vim.lsp.buf.code_action()<cr>")
    -- bufnoremap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>")
    -- bufnoremap("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<cr>")
    bufnoremap("n", "L", "<cmd>lua vim.lsp.buf.hover()<cr>")
    bufnoremap("n", "<Space>rn", "<cmd>lua vim.lsp.buf.rename()<cr>")
    bufnoremap("n", "<Space>f", "<cmd>lua vim.lsp.buf.formatting()<cr>")
    vim.api.nvim_command [[augroup Format]]
    vim.api.nvim_command [[autocmd! * <buffer>]]
    vim.api.nvim_command [[autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()]]
    vim.api.nvim_command [[augroup END]]
end

lspconfig.jdtls.setup {
    on_attach = on_attach
}

lspconfig.pyright.setup {
    on_attach = on_attach
}

lspconfig.rust_analyzer.setup {
    on_attach = on_attach
}

lspconfig.clangd.setup {
    on_attach = on_attach
}

lspconfig.sumneko_lua.setup {
    settings = {Lua = {diagnostics = {globals = {"vim", "use"}}}},
    on_attach = on_attach,
    capabilities = capabilities
}

-- lspconfig.tsserver.setup {
--     on_attach = on_attach,
--     root_dir = util.root_pattern("package.json", "tsconfig.json", ".git") or vim.loop.cwd(),
--     capabilities = capabilities
-- }

lspconfig.html.setup {
    on_attach = on_attach,
    root_dir = util.root_pattern("package.json", "tsconfig.json", ".git") or vim.loop.cwd(),
    capabilities = capabilities
}

lspconfig.cssls.setup {
    on_attach = on_attach,
    root_dir = util.root_pattern("package.json", "tsconfig.json", ".git") or vim.loop.cwd(),
    capabilities = capabilities
}

local shellcheck = {
    lintCommand = "shellcheck -f gcc -x -",
    lintStdin = true,
    lintFormats = {"%f=%l:%c: %trror: %m", "%f=%l:%c: %tarning: %m", "%f=%l:%c: %tote: %m"}
}

local black = {
    formatCommand = "black -",
    formatStdin = true
}

local isort = {
    formatCommand = "isort --stdout --profile black -",
    formatStdin = true
}

local flake8 = {
    lintCommand = "flake8 --max-line-length 160 --stdin-display-name ${INPUT} -",
    lintStdin = true,
    lintIgnoreExitCode = true,
    lintFormats = {"%f=%l:%c: %m"}
}

local mypy = {
    lintCommand = "mypy --show-column-numbers --ignore-missing-imports",
    lintFormats = {"%f=%l:%c: %trror: %m", "%f=%l:%c: %tarning: %m", "%f=%l:%c: %tote: %m"}
}

local prettier = {
    formatCommand = ([[
  ./node_modules/.bin/prettier
  ]]):gsub("\n", "")
}

-- run prettier and eslint --fix
local prettierEslint = {
    formatCommand = ([[
  ./node_modules/.bin/prettier-eslint --prettier-last
  ]]):gsub("\n", "")
}

local eslint = {
    -- lintCommand = "./node_modules/.bin/eslint -f unix --stdin",
    -- eslint_d = faster eslint
    lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
    lintIgnoreExitCode = true,
    lintStdin = true
}

local luafmt = {
    formatCommand = "luafmt --stdin",
    formatStdin = true
}

lspconfig.efm.setup {
    on_attach = on_attach,
    init_options = {documentFormatting = true},
    settings = {
        rootMarkers = {".git/"},
        languages = {
            lua = {luafmt},
            python = {flake8, black, isort, mypy},
            typescript = {prettier, eslint},
            javascript = {prettier, eslint},
            typescriptreact = {prettier, eslint},
            javascriptreact = {prettier, eslint},
            yaml = {prettier},
            json = {prettier},
            html = {prettier},
            scss = {prettier},
            css = {prettier},
            markdown = {prettier},
            sh = {shellcheck}
        }
    }
}
