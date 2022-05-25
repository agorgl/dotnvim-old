local set = vim.opt

set.fileencoding = "utf-8"                      -- File content encoding for the buffer
set.fileformats = { "unix", "dos" }             -- End of line formats for the buffer
set.wrap = false                                -- Disable wrapping of lines longer than the width of window
set.number = true                               -- Show line numbers
set.mouse = "a"                                 -- Enable mouse support
set.clipboard = "unnamedplus"                   -- Connection to the system clipboard
set.swapfile = false                            -- Disable use of swapfile for the buffer
set.backup = false                              -- Disable making a backup file
set.writebackup = false                         -- Disable making a backup before overwriting a file
set.expandtab = true                            -- Enable the use of space in tab
set.smartindent = true                          -- Do auto indenting when starting a new line
set.shiftwidth = 4                              -- Number of space inserted for indentation
set.tabstop = 4                                 -- Number of space in a tab
set.splitbelow = true                           -- Splitting a new window below the current one
set.splitright = true                           -- Splitting a new window at the right of the current one
set.fixendofline = false                        -- Do not restore eol in end of file if missing
set.termguicolors = true                        -- Enable 24-bit RGB color in the TUI
set.pumheight = 12                              -- Height of the pop up menu
set.completeopt = { "menuone", "noselect" }     -- Options for insert mode completion
set.timeoutlen = 1000                           -- Length of time to wait for a mapped sequence
set.updatetime = 300                            -- Length of time to wait before triggering the plugin
set.signcolumn = "auto:1"                       -- When and how to draw the signcolumn
