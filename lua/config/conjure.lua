local M = {}

function M.config()
  local g = vim.g
  g['conjure#completion#omnifunc'] = false
  g['conjure#completion#fallback'] = false
  g['conjure#client#clojure#nrepl#mapping#refresh_changed'] = false
  g['conjure#client#clojure#nrepl#mapping#refresh_all'] = false
  g['conjure#client#clojure#nrepl#mapping#refresh_clear'] = false

  local api = vim.api
  local cmd = vim.cmd
  local shadow_selected = false
  local shadow_select_group = api.nvim_create_augroup('cljs_shadow_select', { clear = true })
  api.nvim_create_autocmd('BufReadPost', {
    group = shadow_select_group,
    pattern = '*.cljs',
    callback = function()
      if not shadow_selected then
        cmd('ConjureShadowSelect app')
        shadow_selected = true
      end
    end
  })
end

return M
