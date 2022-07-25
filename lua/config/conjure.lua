local M = {}

function M.config()
  local g = vim.g
  g['conjure#completion#omnifunc'] = false
  g['conjure#completion#fallback'] = false
  g['conjure#client#clojure#nrepl#mapping#refresh_changed'] = false
  g['conjure#client#clojure#nrepl#mapping#refresh_all'] = false
  g['conjure#client#clojure#nrepl#mapping#refresh_clear'] = false
end

return M
