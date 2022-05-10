local api = vim.api
local cmd = vim.cmd
local fn = vim.fn
local v = vim.v

-- Border match tweak
local function border_set(color)
  cmd(string.format([[call chansend(v:stderr, "\033]11;%s\007")]], color))
  -- api.nvim_chan_send(v.stderr, "\\033]11;" .. color .. "\\007")
end

local function border_reset()
  cmd [[call chansend(v:stderr, "\033]111;\007")]]
  -- api.nvim_chan_send(v.stderr, "\\033]111;\\007")
end

local function match_border_bg()
  local color = api.nvim_get_hl_by_name("Normal", true).background
  if (color) then
    color = string.format("#%X", color)
    border_set(color)
  end
end

local border_color_group = api.nvim_create_augroup('border_color', { clear = true })
api.nvim_create_autocmd('ColorScheme', { group = border_color_group, pattern = '*', callback = match_border_bg })
api.nvim_create_autocmd('VimLeave', { group = border_color_group, pattern = '*', callback = border_reset })

-- Highlight tweaks
local function signs_background_match()
  local bg = fn.synIDattr(fn.synIDtrans(fn.hlID("SignColumn")), "bg#")

  local groups = {
    "LineNr",
    "DiagnosticSignError",
    "DiagnosticSignWarn",
    "DiagnosticSignInfo",
    "DiagnosticSignHint",
    "GitSignsAdd",
    "GitSignsChange",
    "GitSignsDelete",
  }

  for _, group in pairs(groups) do
    local hl = "highlight " .. group .. " guibg=" .. (bg ~= "" and bg or "NONE")
    cmd(hl)
  end
end

if signs_background_match_tweak_enabled then
  local signs_background_group = api.nvim_create_augroup('signs_background', { clear = true })
  api.nvim_create_autocmd('ColorScheme', { group = signs_background_group, pattern = '*', callback = signs_background_match })
end

-- Colorscheme
local colorscheme = "onedark"
function colorscheme_load()
  cmd("silent! colorscheme " .. colorscheme)
  local c = require('onedark.colors')
  colors = {
    bg = c.bg1,
    fg = c.fg,
    black = c.black,
    red = c.red,
    green = c.green,
    blue = c.blue,
    cyan = c.cyan,
    yellow = c.yellow,
    orange = c.orange,
    purple = c.purple,
    grey = c.grey,
    light_grey = c.light_grey,
    dark_cyan = c.dark_cyan,
    dark_purple = c.dark_purple,
    dark_red = c.dark_red,
    dark_yellow = c.dark_yellow,
  }
end
