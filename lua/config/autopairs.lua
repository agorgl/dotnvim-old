local M = {}

function M.config()
  local ok, plugin = pcall(require, "nvim-autopairs")
  if not ok then
    return
  end

  -- If you want insert `(` after select function or method item
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  local cmp = require('cmp')
  cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

  plugin.setup {
    enable_check_bracket_line = false,
  }
end

return M
