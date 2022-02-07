local M = {}

function M.config()
  local ok, plugin = pcall(require, "lspconfig")
  if not ok then
    return
  end
end

return M
