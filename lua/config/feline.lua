local M = {}

function M.config()
  local ok, plugin = pcall(require, "feline")
  if not ok then
    return
  end

  local vi_mode_utils = require('feline.providers.vi_mode')
  local file_utils = require('feline.providers.file')

  local function hl_from_name(name)
    local hl = vim.api.nvim_get_hl_by_name(name, true)
    return {
      bg = hl.background and string.format("#%X", hl.background) or "NONE",
      fg = hl.foreground and string.format("#%X", hl.foreground) or "NONE",
    }
  end

  local function hl_invert(hl)
    if type(hl) == 'function' then
      return function() return hl_invert(hl()) end
    else
      return {
        name = hl.name and hl.name .. '_inverted' or nil,
        fg = hl.bg,
        bg = hl.fg,
      }
    end
  end

  local lighter_hl = function() return hl_from_name("LineNr") end
  local mode_hl = function()
    return {
      fg = vi_mode_utils.get_mode_color(),
      bg = lighter_hl().bg,
    }
  end

  local active = {
    -- Left
    {
      {
        provider = 'vi_mode',
        hl = mode_hl,
        invert = true,
        icon = '',
      },
      {
        provider = 'git_branch_dir',
        hl = mode_hl,
        icon = '',
      },
      {
        provider = 'file_info',
        hl = mode_hl,
        icon = '',
      },
    },
    -- Right
    {
      {
        provider = 'file_type_lower',
        hl = mode_hl,
        icon = '',
      },
      {
        provider = 'file_encoding_lower',
        hl = mode_hl,
        icon = '',
      },
      {
        provider = 'file_format_lower',
        hl = mode_hl,
        icon = '',
      },
      {
        provider = 'line_percentage',
        hl = lighter_hl,
        icon = '',
      },
      {
        provider = 'position',
        hl = lighter_hl,
        icon = '',
      },
      {
        provider = ' ',
        hl = mode_hl,
        invert = true,
        icon = '',
      }
    }
  }

  local inactive = {
    {
      {
        provider = 'file_type',
        hl = mode_hl,
        invert = true,
        icon = '',
      },
      {}
    },
    {}
  }

  -- Surrounds a component with a separator
  local function surround(c, s)
    c.left_sep = c.left_sep or {}
    c.right_sep = c.right_sep or {}
    table.insert(c.left_sep, 1, { str = s, hl = c.hl })
    table.insert(c.right_sep, { str = s, hl = c.hl })
  end

  -- Adds a separator to a component in the given direction
  local function sepadd(c, s, dir, inverted)
    c[dir .. '_sep'] = c[dir .. '_sep'] or {}
    local sep = c[dir .. '_sep']
    local sep_idx = ({left = 1, right = #sep + 1})[dir]
    local sep_hl = not inverted and c.hl or hl_invert(c.hl)
    table.insert(sep, sep_idx, { str = s, hl = sep_hl })
  end

  -- Styles a component by adding padding and separator
  local function style(components, direction)
    local sep = ({
      left = { normal = 'left', inverted = 'left_filled' },
      right = { normal = 'right', inverted = 'right_filled' }
    })[direction]

    for i, component in pairs(components) do
      if component.provider then
        local invert = component.invert
        local mode = invert and 'inverted' or 'normal'
        local sep = sep[mode]

        component.hl = invert and hl_invert(component.hl) or component.hl
        surround(component, ' ')
        sepadd(component, sep, direction, invert)
      end
    end
  end

  for _, group in pairs({active, inactive}) do
    for j, subgroup in pairs(group) do
      local direction = ({'right', 'left'})[j]
      style(subgroup, direction)
    end
  end

  plugin.setup {
    components = { active = active, inactive = inactive },
    custom_providers = {
      git_branch_dir = function()
        return vim.g.gitsigns_head or ''
      end,
      file_type_lower = function(component, opts)
        local v = file_utils.file_type(component, opts):lower()
        return v ~= '' and v or 'no ft'
      end,
      file_encoding_lower = function()
        return file_utils.file_encoding():lower()
      end,
      file_format_lower = function()
        return file_utils.file_format():lower()
      end
    }
  }
end

return M
