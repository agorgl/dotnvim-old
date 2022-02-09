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
      handler_opts = {
        border = "rounded"
      }
    }, bufnr)
    -- Mappings
    setup_lsp_mappings(bufnr)
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
end

return M
