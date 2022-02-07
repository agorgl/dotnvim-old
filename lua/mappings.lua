local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
local g = vim.g

-- Leader Key
g.mapleader = ","
g.maplocalleader = ","

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", opts)
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", opts)

-- NVim Tree
map("n", "<F2>", "<cmd>NvimTreeToggle<CR>", opts)
