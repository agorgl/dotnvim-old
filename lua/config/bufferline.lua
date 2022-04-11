local M = {}

function M.config()
  local ok, plugin = pcall(require, "bufferline")
  if not ok then
    return
  end

  plugin.setup {
    options = {
      mode = "tabs",
      show_buffer_close_icons = false,
      always_show_bufferline = false,
    }
  }
end

return M
