local cmd = vim.cmd
local fn = vim.fn

local function packer_setup()
  local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    print "Cloning packer..."
    fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }
    vim.cmd [[packadd packer.nvim]]
  end
  local _, packer = pcall(require, "packer")
  return packer
end

local function plugins(use)
  -- Plugin manager
  use 'wbthomason/packer.nvim'
  -- Fuzzy finder
  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/plenary.nvim'}}
  }
  -- File explorer
  use {
    'kyazdani42/nvim-tree.lua',
    config = function() require 'config.nvimtree'.config() end
  }
  -- Statusline
  use {
    'feline-nvim/feline.nvim',
    config = function() require 'config.feline'.config() end
  }
  -- Syntax highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  -- Completion engine
  use {
    "hrsh7th/nvim-cmp",
    config = function() require("config.cmp").config() end
  }
  -- Buffer completion source
  use {
    "hrsh7th/cmp-buffer",
  }
  -- Path completion source
  use {
    "hrsh7th/cmp-path",
  }
  -- LSP completion source
  use {
    "hrsh7th/cmp-nvim-lsp",
  }
  -- LSP configurations
  use {
    'neovim/nvim-lspconfig',
    config = function() require 'config.lspconfig'.config() end
  }
  -- LSP signature hints
  use {
    "ray-x/lsp_signature.nvim",
  }
  -- Git integration
  use {
    'lewis6991/gitsigns.nvim',
    requires = {{'nvim-lua/plenary.nvim'}},
    config = function() require 'config.gitsigns'.config() end
  }
  -- Surround editing
  use 'tpope/vim-surround'
  -- Colorscheme
  use 'tomasr/molokai'
end

local luapath = fn.resolve(fn.stdpath("config")) .. "/lua"
cmd(string.format([[
augroup packer_user_config
  autocmd!
  autocmd BufWritePost %s/plugins.lua,%s/config/*.lua source <afile> | PackerCompile
augroup end
]], luapath, luapath))

local ok, packer = pcall(require, "packer")
if not ok then
  packer = packer_setup()
end

packer.startup(plugins)
if not ok then
  packer.sync()
end
