local M = {}
local g = vim.g

function M.config()
  g.nvim_tree_show_icons = {
    git = 0,
    folders = 1,
    files = 1,
    folder_arrows = 0,
  }

  local folder_closed, folder_open = '▸', '▾'
  g.nvim_tree_icons = {
    default = ' ',
    symlink = ' ',
    folder = {
      arrow_open = '',
      arrow_closed = '',
      default = folder_closed,
      open = folder_open,
      empty = folder_closed,
      empty_open = folder_open,
      symlink = folder_closed,
      symlink_open = folder_open,
    }
  }

  g.nvim_tree_add_trailing = 1

  local ok, plugin = pcall(require, "nvim-tree")
  if not ok then
    return
  end

  plugin.setup {
    view = {
      signcolumn = "no"
    },
  }
end

return M
