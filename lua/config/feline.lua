local M = {}

function M.config()
  local ok, plugin = pcall(require, "feline")
  if not ok then
    return
  end

  local vi_mode_utils = require('feline.providers.vi_mode')

  local function hl_from_name(name)
    local hl = vim.api.nvim_get_hl_by_name(name, true)
    return {
      bg = string.format("#%X", hl.background),
      fg = string.format("#%X", hl.foreground),
    }
  end

  local mode_hl = function()
    return {
      name = vi_mode_utils.get_mode_highlight_name(),
      fg = vi_mode_utils.get_mode_color(),
      bg = 'NONE',
    }
  end

  local mode_inverted_hl = function()
    return {
      name = vi_mode_utils.get_mode_highlight_name(),
      bg = vi_mode_utils.get_mode_color(),
      fg = 'bg',
      style = 'bold',
    }
  end

  local lighter_hl = hl_from_name("LineNr")

  local lighter_mode_hl = function()
    return {
      fg = vi_mode_utils.get_mode_color(),
      bg = lighter_hl.bg,
    }
  end

  local c = {
    vimode = {
      provider = 'vi_mode',
      hl = mode_inverted_hl,
      left_sep = {
        { str = ' ', hl = mode_inverted_hl, }
      },
      right_sep = {
        { str = ' ', hl = mode_inverted_hl, },
        'right_filled',
      },
      icon = '',
    },
    gitbranch = {
      provider = 'git_branch',
      hl = mode_hl,
      left_sep = {
        { str = ' ', hl = mode_hl, }
      },
      right_sep = {
        { str = ' ', hl = mode_hl, },
        { str = 'right', hl = mode_hl, }
      },
      icon = '',
    },
    fileinfo = {
      provider = 'file_info',
      hl = mode_hl,
      icon = '',
    },
    filetype = {
      provider = 'file_type',
      hl = mode_hl,
      left_sep = {
        { str = ' ', hl = mode_hl, }
      },
      right_sep = {
        { str = ' ', hl = mode_hl, },
      },
      icon = '',
    },
    encoding = {
      provider = 'file_encoding',
      hl = mode_hl,
      left_sep = {
        { str = 'left', hl = mode_hl, },
        { str = ' ', hl = mode_hl, },
      },
      right_sep = {
        { str = ' ', hl = mode_hl, },
      },
      icon = '',
    },
    format = {
      provider = 'file_format',
      hl = mode_hl,
      left_sep = {
        { str = 'left', hl = mode_hl, },
        { str = ' ', hl = mode_hl, },
      },
      right_sep = ' ',
      icon = '',
    },
    lineperc = {
      provider = 'line_percentage',
      hl = lighter_hl,
      left_sep = {
        'left_filled',
        { str = ' ', hl = lighter_hl, },
      },
      right_sep = {
        { str = ' ', hl = lighter_hl },
      },
    },
    position = {
      provider = 'position',
      hl = lighter_hl,
      left_sep = {
        { str = 'left', hl = lighter_hl },
        { str = ' ', hl = lighter_hl },
      },
      right_sep = {
        { str = ' ', hl = lighter_mode_hl },
        { str = 'left_filled', hl = lighter_mode_hl },
      },
    },
  }

  local active = {
    -- Left
    {
      c.vimode,
      c.gitbranch,
      c.fileinfo,
    },
    -- Right
    {
      c.filetype,
      c.encoding,
      c.format,
      c.lineperc,
      c.position,
    }
  }

  local inactive = {
    {
      c.filetype
    },
    -- Empty component to fix the highlight till the end of the statusline
    {}
  }

  plugin.setup {
    components = { active = active, inactive = inactive },
  }
end

return M
