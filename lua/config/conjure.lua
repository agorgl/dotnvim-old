local M = {}

function M.config()
  local g = vim.g
  local api = vim.api
  local cmd = vim.cmd

  g['conjure#client_on_load'] = false
  g['conjure#completion#omnifunc'] = false
  g['conjure#completion#fallback'] = false
  g['conjure#client#clojure#nrepl#mapping#refresh_changed'] = false
  g['conjure#client#clojure#nrepl#mapping#refresh_all'] = false
  g['conjure#client#clojure#nrepl#mapping#refresh_clear'] = false

  local log = require('conjure.log')
  local client = require('conjure.client')
  local server = require('conjure.client.clojure.nrepl.server')
  local action = require('conjure.client.clojure.nrepl.action')

  local client_state = function(key)
    if key == nil or key == '' then
      return client['state-key']()
    else
      return client['set-state-key!'](key)
    end
  end

  local connect = function(cb)
    if not server['connected?']() then
      return action['connect-port-file']({["silent?"] = true, ["cb"] = cb})
    else
      cb()
    end
  end

  local is_log_buf = function(path) return log['log-buf?'](path) end
  local clone_fresh_session = function() action['clone-fresh-session']() end
  local shadow_select = function(build) action['shadow-select'](build) end

  local clj_initialized = false
  local cljs_initialized = false
  local conjure_session_setup_group = api.nvim_create_augroup('conjure_session_setup', { clear = true })
  api.nvim_create_autocmd('BufEnter', {
    group = conjure_session_setup_group,
    pattern = {'*.clj', '*.cljc'},
    callback = function()
      local path = vim.fn.expand("%:p")
      if is_log_buf(path) then
        return
      end

      client_state("clj")
      if not clj_initialized then
        connect(function()
          clj_initialized = true
        end)
      end
    end
  })
  api.nvim_create_autocmd('BufEnter', {
    group = conjure_session_setup_group,
    pattern = '*.cljs',
    callback = function()
      local cljs_setup = function()
        client_state("cljs")
        if not cljs_initialized then
          connect(function()
            vim.schedule(function()
              clone_fresh_session()
              vim.defer_fn(function()
                shadow_select("app")
                cljs_initialized = true
              end, 150)
            end)
          end)
        end
      end
      if not clj_initialized then
        client_state("clj")
        connect(function()
          clj_initialized = true
          vim.defer_fn(function()
            cljs_setup()
          end, 150)
        end)
      else
        cljs_setup()
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
