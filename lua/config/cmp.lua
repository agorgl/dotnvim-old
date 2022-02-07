local M = {}

function M.config()
  local ok, plugin = pcall(require, "cmp")
  if not ok then
    return
  end

  plugin.setup {
    sources = {
      { name = "nvim_lsp" },
      { name = "buffer" },
      { name = "path" },
    },
  }
end

return M
