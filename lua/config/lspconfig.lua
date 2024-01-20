local M = {}

function M.config()
  local ok, plugin = pcall(require, "lspconfig")
  if not ok then
    return
  end
  local lsp_util = require("lspconfig.util")

  -- Setup cmp integration
  local cmp_nvim_lsp = require("cmp_nvim_lsp")

  -- Use an on_init function to disable the lsp semantic highlight
  local on_init = function(client, initialization_result)
    if client.server_capabilities then
      client.server_capabilities.semanticTokensProvider = false
    end
  end

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
    ccls = {},
    rust_analyzer = {},
    gopls = {},
    jdtls = {},
    tsserver = {},
    pyright = {},
    clojure_lsp = {},
    dartls = {},
    tailwindcss = {
      settings = {
        tailwindCSS = {
          experimental = {
            classRegex = {
              ":class\\s+\"([^\"]*)\"",
              ":[\\w-.#>]+\\.([\\w-]*)"
            },
          },
          includeLanguages = {
            clojure = "html"
          },
        },
      },
      root_dir = function(fname)
        local tailwindcss_config = lsp_util.root_pattern('tailwind.config.js', 'tailwind.config.cjs', 'tailwind.config.mjs', 'tailwind.config.ts')(fname)
        local postcss_config = lsp_util.root_pattern('postcss.config.js', 'postcss.config.cjs', 'postcss.config.mjs', 'postcss.config.ts')(fname)
        local node_config = lsp_util.find_package_json_ancestor(fname) or lsp_util.find_node_modules_ancestor(fname)
        return tailwindcss_config or postcss_config or node_config
      end
    },
  }

  for lsp, opts in pairs(servers) do
    local capabilities = cmp_nvim_lsp.default_capabilities()
    local config = {
      capabilities = capabilities,
      on_init = on_init,
      on_attach = on_attach,
      flags = {
        -- This will be the default in neovim 0.7+
        debounce_text_changes = 150,
      }
    }
    for k,v in pairs(opts) do config[k] = v end
    plugin[lsp].setup(config)
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
