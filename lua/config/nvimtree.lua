local M = {}

function M.config()
  local ok, plugin = pcall(require, "nvim-tree")
  if not ok then
    return
  end

  plugin.setup {}
end

return M
