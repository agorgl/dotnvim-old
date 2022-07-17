local map = vim.keymap.set
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

-- LSP
map("n", "<space>e", vim.diagnostic.open_float, opts)
map("n", "[d", vim.diagnostic.goto_prev, opts)
map("n", "]d", vim.diagnostic.goto_next, opts)
map("n", "<space>q", vim.diagnostic.setloclist, opts)

function setup_lsp_mappings(bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  map("n", "gd", vim.lsp.buf.definition, opts)
  map("n", "gD", vim.lsp.buf.declaration, opts)
  map("n", "gi", vim.lsp.buf.implementation, opts)
  map("n", "gt", vim.lsp.buf.type_definition, opts)
  map("n", "gr", vim.lsp.buf.references, opts)
  map("n", "K", vim.lsp.buf.hover, opts)
  map("n", "<C-k>", vim.lsp.buf.signature_help, opts)
  map("n", "<leader>f", vim.lsp.buf.formatting, opts)
  map("n", "<leader>rn", vim.lsp.buf.rename, opts)
  map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
  map("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
end

-- Tabs
map({"n","t"}, "<M-n>", "<cmd>tabnext<CR>", opts)
map({"n","t"}, "<M-p>", "<cmd>tabprev<CR>", opts)

-- Fugitive
map("n", "<leader>gg", "<cmd>tab G<CR>", opts)

-- ToggleTerm
map({"n","t"}, "<leader>rr", require('config.project').exec, opts)
map({"n","t"}, "<leader>rb", require('config.project').exec_background, opts)
map({"n","t"}, "<leader>t", "<cmd>ToggleTerm<CR>", opts)
