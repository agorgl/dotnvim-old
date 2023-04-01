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
  local wait = function(interval) vim.wait(interval, function() end) end

  local clj_init = false
  local cljs_attached = false
  local conjure_session_setup_group = api.nvim_create_augroup('conjure_session_setup', { clear = true })
  api.nvim_create_autocmd('BufEnter', {
    group = conjure_session_setup_group,
    pattern = {'*.clj', '*.cljc'},
    callback = function()
      cmd('ConjureClientState clj')
      clj_init = true
    end
  })
  api.nvim_create_autocmd('BufEnter', {
    group = conjure_session_setup_group,
    pattern = '*.cljs',
    callback = function()
      if not clj_init then
        cmd('ConjureClientState clj')
        wait(150) -- wait for connect
        clj_init = true
      end

      cmd('ConjureClientState cljs')
      if not cljs_attached then
        wait(150) -- wait for connect
        cmd('ConjureCljSessionFresh')
        wait(150) -- wait for session clone
        cmd('ConjureShadowSelect app')
        cljs_attached = true
      end
    end
  })

  local conjure_log_group = api.nvim_create_augroup("conjure_log", { clear = true })
  api.nvim_create_autocmd('BufNewFile', {
    group = conjure_log_group,
    pattern = 'conjure-log-*',
    callback = function()
      vim.diagnostic.disable(0)
    end
  })
end

return M
