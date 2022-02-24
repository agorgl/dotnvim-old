local M = {}

function M.config()
  local ok, plugin = pcall(require, "onedark")
  if not ok then
    return
  end

  plugin.setup {
    style = 'darker',
    toggle_style_key = '<NOP>',
    highlights = {
      NvimTreeNormal = {bg = '$bg0'},
      NvimTreeVertSplit = {bg = '$bg0'},
      NvimTreeEndOfBuffer = {bg = '$bg0'},
    }
  }
  colorscheme_load()
end

return M
