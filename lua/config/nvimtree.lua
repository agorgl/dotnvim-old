local M = {}
local g = vim.g

function M.config()
  local ok, plugin = pcall(require, "nvim-tree")
  if not ok then
    return
  end

  local folder_closed, folder_open = '▸', '▾'
  plugin.setup {
    view = {
      signcolumn = "no"
    },
    renderer = {
      add_trailing = false,
      icons = {
        show = {
          file = true,
          folder = true,
          folder_arrow = false,
          git = false,
        },
        glyphs = {
          default = ' ',
          symlink = ' ',
          folder = {
            arrow_closed = '',
            arrow_open = '',
            default = folder_closed,
            open = folder_open,
            empty = folder_closed,
            empty_open = folder_open,
            symlink = folder_closed,
            symlink_open = folder_open,
          },
        },
      },
    },
  }
end

return M
