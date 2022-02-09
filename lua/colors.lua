local cmd = vim.cmd
local api = vim.api
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

border_color_match = match_border_bg
border_color_reset = border_reset

cmd [[
  augroup border_color
    autocmd!
    autocmd ColorScheme * lua border_color_match()
    autocmd VimLeave * lua border_color_reset()
  augroup end
]]

-- Colorscheme
local colorscheme = "molokai"
cmd("silent! colorscheme " .. colorscheme)
