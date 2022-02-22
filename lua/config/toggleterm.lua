local M = {}

function M.config()
  local ok, plugin = pcall(require, "toggleterm")
  if not ok then
    return
  end

  plugin.setup {
    shade_terminals = false,
    direction = 'float',
    float_opts = {
      border = 'curved',
    }
  }
end

return M
