local M = {}

function M.config()
  local ok, plugin = pcall(require, "telescope")
  if not ok then
    return
  end

  plugin.setup {}
  plugin.load_extension('fzf')
end

return M
