local M = {}

function M.config()
  local ok, plugin = pcall(require, "nvim-treesitter.configs")
  if not ok then
    return
  end

  plugin.setup {
    ensure_installed = "all",
    highlight = {
      enable = true,
      disable = { "c", "rust" },
    }
  }
end

return M
