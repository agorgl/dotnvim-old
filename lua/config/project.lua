local M = {}

local types = {
  cargo = {
    patterns = {
      "Cargo.toml",
    },
    tasks = {
      run = "cargo run",
      build = "cargo build",
      clean = "cargo clean",
    },
  },
  maven = {
    patterns = {
      "pom.xml",
    },
    tasks = {
      run = "mvn spring-boot:run",
      build = "mvn build",
      clean = "mvn clean",
    },
  },
  npm = {
    patterns = {
      "package.json",
    },
    tasks = {
      run = "npm run dev",
      build = "npm run build",
      clean = "npm ci",
    },
  },
}

local function project_type(root)
  local fn = vim.fn
  for t, p in pairs(types) do
    for _, pat in pairs(p.patterns) do
      if fn.empty(fn.glob(pat)) == 0 then
        return t
      end
    end
  end
  return nil
end

function M.exec(task)
  local terminal = require('toggleterm.terminal').Terminal
  local term = terminal:new({
    cmd = tasks[task or 'run'],
    direction = 'tab',
    close_on_exit = false,
    on_open = function(term)
      vim.cmd("startinsert!")
    end,
  })
  term:toggle()
end

function M.config()
  local ok, plugin = pcall(require, "project_nvim")
  if not ok then
    return
  end

  local api = vim.api

  plugin.setup {
    manual_mode = true,
  }

  local project = require("project_nvim.project")
  local project_tasks_setup = function()
    local root = project.get_project_root()
    local type = project_type(root)
    if type then
      tasks = types[type].tasks
    end
  end

  local tasks_setup_group = api.nvim_create_augroup('tasks_setup', { clear = true })
  api.nvim_create_autocmd('VimEnter', {
    group = tasks_setup_group,
    pattern = '*',
    callback = project_tasks_setup,
  })
end

return M
