local M = {}

function M.config()
  local ok, plugin = pcall(require, "lspconfig")
  if not ok then
    return
  end

  -- Setup cmp integration
  local cmp_nvim_lsp = require("cmp_nvim_lsp")
  local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    -- Enable signature plugin
    local lsp_signature = require "lsp_signature"
    lsp_signature.on_attach({
      bind = true,
      hint_enable = false,
      handler_opts = {
        border = "rounded"
      }
    }, bufnr)
    -- Mappings
    setup_lsp_mappings(bufnr)
  end

  local fn = vim.fn
  local api = vim.api
  local cmd = vim.cmd
  local lsp = vim.lsp
  local diagnostic = vim.diagnostic

  lsp.handlers["textDocument/hover"] = lsp.with(
    lsp.handlers.hover, {
      border = "rounded"
    }
  )

  lsp.handlers["textDocument/signatureHelp"] = lsp.with(
    lsp.handlers.signature_help, {
      border = "rounded"
    }
  )

  diagnostic.config({
    underline = false,
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    float = {
      border = "rounded"
    }
  })

  local diagnostic_open_group = api.nvim_create_augroup('diagnostic_open', { clear = true })
  api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
    group = diagnostic_open_group,
    pattern = '*',
    callback = function()
      vim.diagnostic.open_float(nil, { focus = false })
    end
  })

  -- Diagnostic signs
  local diagnostic_signs = {
    { name = "DiagnosticSignError", text = "✘✘" },
    { name = "DiagnosticSignWarn", text = "!!" },
    { name = "DiagnosticSignInfo", text = "--" },
    { name = "DiagnosticSignHint", text = "**" },
  }
  for _, sign in ipairs(diagnostic_signs) do
    fn.sign_define(sign.name, { text = sign.text, texthl = sign.name })
  end

  local servers = {
    "ccls",
    "rust_analyzer",
    "gopls",
    "jdtls",
    "tsserver",
    "pyright"
  }
  for _, lsp in pairs(servers) do
    plugin[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
        -- This will be the default in neovim 0.7+
        debounce_text_changes = 150,
      }
    }
  end

  local null_ls = require "null-ls"
  local nlb = null_ls.builtins

  local sources = {
    -- Formatting
    nlb.formatting.prettierd,

    -- Diagnostics
    nlb.diagnostics.eslint,
    nlb.diagnostics.flake8,

    -- Actions
    nlb.code_actions.gitsigns,
  }

  null_ls.setup {
    sources = sources,
    on_attach = on_attach,
  }
end

return M
