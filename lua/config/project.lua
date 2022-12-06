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
  clojure = {
    patterns = {
      "deps.edn",
    },
    tasks = {
      run = "clj -M:env/dev:repl/headless",
    },
    autorun = 'run',
  },
  clojurescript = {
    patterns = {
      "shadow-cljs.edn",
    },
    tasks = {
      run = "npx shadow-cljs watch app",
    },
  },
  maven = {
    patterns = {
      "pom.xml",
    },
    skip_patterns = {
      "deps.edn",
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
    skip_patterns = {
      "shadow-cljs.edn",
    },
    tasks = {
      run = "npm run dev",
      build = "npm run build",
      clean = "npm ci",
    },
  },
  expo = {
    patterns = {
      "app.json",
    },
    tasks = {
      run = "expo start",
      build = "expo export --dev",
      clean = "npm ci",
    },
  },
  flutter = {
    patterns = {
      "pubspec.yaml",
    },
    tasks = {
      run = "flutter run",
      build = "flutter build",
      clean = "flutter clean",
    },
    postrun = function(term)
      local api = vim.api
      local hot_reload_group = api.nvim_create_augroup('hot_reload', { clear = true })
      api.nvim_create_autocmd('BufWritePost', {
        group = hot_reload_group,
        pattern = '*.dart',
        callback = function ()
          term:send('r', true)
        end,
      })
    end,
  },
}

local function project_type(root)
  local fn = vim.fn

  local should_skip = function(p)
    for _, spat in pairs(p.skip_patterns) do
      if fn.empty(fn.glob(spat)) == 0 then
        return true
      end
    end
    return false
  end

  for t, p in pairs(types) do
    for _, pat in pairs(p.patterns) do
      if fn.empty(fn.glob(pat)) == 0 then
        if not (p.skip_patterns and should_skip(p)) then
          return t
        end
      end
    end
  end
  return nil
end

function M.exec(task, background)
  local toggleterm_terminal = require('toggleterm.terminal')
  local terminal = toggleterm_terminal.Terminal

  local terms = toggleterm_terminal.get_all(true)
  if next(terms) then
    local term = terms[1]
    term:toggle()
    return
  end

  local term = terminal:new({
    cmd = tasks[task or 'run'],
    direction = 'horizontal',
    close_on_exit = false,
    on_open = function(term)
      vim.cmd("startinsert!")
    end,
  })

  if not background then
    term:toggle()
  else
    term:spawn()
  end

  if postrun then
    postrun(term)
  end
end

function M.exec_background(task)
  M.exec(task, true)
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
      autorun = types[type].autorun
      postrun = types[type].postrun
      if autorun then
        print(string.format("Launching '%s' in background", tasks[autorun]))
        M.exec_background(autorun)
      end
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
