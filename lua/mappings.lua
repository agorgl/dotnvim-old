local map = vim.api.nvim_set_keymap
local bmap = vim.api.nvim_buf_set_keymap
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
map("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
map("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

function setup_lsp_mappings(bufnr)
  bmap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  bmap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  bmap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  bmap(bufnr, "n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  bmap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  bmap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  bmap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  bmap(bufnr, "n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  bmap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  bmap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  bmap(bufnr, "n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  bmap(bufnr, "n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  bmap(bufnr, "n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
end

-- Tabs
map("n", "<M-n>", "<cmd>tabnext<CR>", opts)
map("n", "<M-p>", "<cmd>tabprev<CR>", opts)
map("t", "<M-n>", "<cmd>tabnext<CR>", opts)
map("t", "<M-p>", "<cmd>tabprev<CR>", opts)

-- ToggleTerm
map("n", "<leader>r", "<cmd>lua require('toggleterm').exec('exec ' .. tasks.run, nil, nil, nil, 'tab')<CR>", opts)
map("n", "<leader>t", "<cmd>ToggleTerm<CR>", opts)
map("t", "<leader>t", "<cmd>ToggleTerm<CR>", opts)
